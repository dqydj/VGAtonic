/*
 * FB driver for VGATONIC LCD controller
 * for generic 640x480x8bpp VGA monitor driving.
 * (Basically, anything with a VGA port should support this mode)
 *
 *
 * (Notes Retained from Kamal Mostafa)
 #  Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
 *
 * Copyright (C) 2015, PK
 * Inspired by Matt Porter, Neil Greatorex, Kamal Mostafa, and notro
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License. See the file COPYING in the main directory of this archive for
 * more details.
 */

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/errno.h>
#include <linux/string.h>
#include <linux/mm.h>
#include <linux/vmalloc.h>
#include <linux/slab.h>
#include <linux/init.h>
#include <linux/fb.h>
#include <linux/gpio.h>
#include <linux/spi/spi.h>
#include <linux/delay.h>
#include <linux/uaccess.h>
#include "vgatonic.h"

static struct fb_fix_screeninfo vgatonicfb_fix = {
	.id 			= "VGATONIC_V1", 
	.type 			= FB_TYPE_PACKED_PIXELS,
	.visual 		= FB_VISUAL_TRUECOLOR,
	.xpanstep 		= 0,
	.ypanstep 		= 0,
	.ywrapstep 		= 0, 
	.line_length 	= WIDTH*BPP/8,
	.accel 			= FB_ACCEL_NONE,
};

static struct fb_var_screeninfo vgatonicfb_var = {
	.xres 			= WIDTH,
	.yres 			= HEIGHT,
	.xres_virtual 	= WIDTH,
	.yres_virtual 	= HEIGHT,
	.bits_per_pixel = BPP,
	.nonstd			= 1,
};

/*
 * SPI blocking write with given SPI clock speed
 */
static inline int spi_write_at_speed(struct spi_device *spi, u32 speed_hz, const void *buf, size_t len)
{
	struct spi_message	m;
	struct spi_transfer	t = {
		.tx_buf		= buf,
		.len		= len,
		.speed_hz	= speed_hz,
	};
	

	spi_message_init(&m);
	spi_message_add_tail(&t, &m);
	return spi_sync(spi, &m);
}

static int vgatonic_write_data_buf(struct vgatonicfb_par *par, u8 *txbuf, int size)
{
	/* Chip Select low to warn VGATonic something is coming */
	gpio_set_value(par->cs, 0);

	
	struct spi_message	m;
	struct spi_transfer	t = {
		.tx_buf		= txbuf,
		.len		= size,
	};

	spi_message_init(&m);
	spi_message_add_tail(&t, &m);
	int retval = spi_sync(par->spi, &m);

	/* Chip Select high to warn VGATonic something is coming */
	gpio_set_value(par->cs, 1);

	return retval;
}

/* Reset VGATonic  */
static void vgatonic_reset(struct vgatonicfb_par *par)
{
	// Toggle the chip select pin a couple times to ensure we are at pixel 0,0.
	gpio_set_value(par->cs, 0);
	udelay(10);
	gpio_set_value(par->cs, 1);
	udelay(10);
	gpio_set_value(par->cs, 0);
	udelay(10);
	gpio_set_value(par->cs, 1);
	mdelay(120);

}
/* vgatonicfb_update_display

		we have a map of 'dirty' pixels (in 'dirty_rect') which need updates.  This gets hit every time deferred IO 
		comes back and asks for an update.  We put everything that needs updating into a buffer then pass it to SPI.

*/

static void vgatonicfb_update_display(struct vgatonicfb_par *par, const struct fb_fillrect *dirty_rect)
{
	int ret = 0;


	// Remember, VGATonic has 8 bit output.  Most likely we are dealing with 16 bit color input.  We need to convert!
	u8 *vmem = par->info->screen_base;
	int i;
	u16 *vmem16;
	u8  *smem;
	int dx, dy, dw, dh;
	unsigned int vmem_start;
	unsigned int write_nbytes;

	if (dirty_rect) {
	    dx = dirty_rect->dx;
	    dy = dirty_rect->dy;
	    dw = dirty_rect->width;
	    dh = dirty_rect->height;
	} else {
	    dx = dy = 0;
	    dw = WIDTH;
	    dh = HEIGHT;
	}

	/* Load spi_writing_buffer with image data from the dirty_rect subwindow */

	// We have no way of skipping pixels yet, but we can optimize by not writing beyond
	// where we actually have changed pixels.  AKA, no need to write the bottom right.

	vmem_start = (WIDTH*dy + dx)*BPP/8; // No need to change this code since we are setting it to 0,0 in the rect.


	// Here is where the complication comes into play: we're a 8 bit part, and there are 16 bit pixels.
	// Make sure you convert in the following code!!!

	vmem16 = (u16 *)((u8 *)vmem + vmem_start);
	smem   = par->spi_writing_buffer;


	for (i=0; i<dh; i++) {
		int x;


	// This didn't matter on my Pi (in fact I had inverted colors when I tried to adjust), but leaving the ifdefs anyway.

#ifdef __LITTLE_ENDIAN

		for (x=0; x<dw; x++) {
		    smem[x] =  RGB565toRGB332( vmem16[x] ) ;
		}
#else
		// Someone test a big Endian system for me?
		for (x=0; x<dw; x++) {
		    smem[x] = RGB565toRGB332( vmem16[x] );
		}

#endif
		// Increase the counters by one spot.  16 bit vs 8 bit variable, remember
		smem += dw*BPPVGATONIC/8;
		vmem16 += WIDTH*BPP/16;
	}

	/* Send spi_writing_buffer to VGATONIC's local VRAM over SPI */
	
	write_nbytes = dw*dh*BPPVGATONIC/8;
	ret = vgatonic_write_data_buf(par, par->spi_writing_buffer, write_nbytes);


	// This should never get hit because we use blocking SPI calls with spi_sync.
	if (ret < 0)
		pr_err("%s: spi_write failed to update display buffer\n",
			par->info->fix.id);

}

/* vgatonicfb_deferred_io

		This will get hit 1/FPS times per second, and it will give this driver the updates framebuffer.

		We 

*/

static void vgatonicfb_deferred_io(struct fb_info *info, struct list_head *pagelist)
{
	struct page *page;
	int npages = info->fix.smem_len / PAGE_SIZE;
	int page_low = npages;
	int page_high = -1;
	struct fb_fillrect rect;
	int i;

	for ( i=0; i<npages; i++ ) {
		struct vgatonicfb_par *par = info->par;
		if (test_and_clear_bit(i, &par->deferred_pages_mask)) {
			if ( page_high == -1 )
				page_low = i;
			page_high = i;
		}
	}

	list_for_each_entry(page, pagelist, lru) {
		if ( page_low > page->index )
		    page_low = page->index;
		if ( page_high < page->index )
		    page_high = page->index;
	}

	if (page_high == -1) {
		pr_debug("VGATONICFB - deferred_io no pages? full update.\n");
		page_low = 0;
		page_high = npages - 1;
	}

	// VGATonic doesn't have a way to change the row yet.  This is a useful fix though, maybe a future version?  
	// Will allow us to push the limits of the FPS and max out the SPI on VGATonic.

	page_low = 0;

	// The rest of the math still applies - we don't have to write the whole screen; we can stop whenever the dirty pixels stop.
	// That means if something in the menubar changes, we might 'only' be writing 50 lines:
	// 640*480*8 = 2,457,600 bits/frame, 640*50*8 = 256,000 bits/frame, or 89.6% less congestion on SPI.
	//
	// At 58 MHz and serial, it makes a difference.

	rect.dx = 0;
	rect.width = WIDTH;

	rect.dy = page_low * PAGE_SIZE / (WIDTH*BPP/8);
	rect.height = (page_high - page_low + 1) * PAGE_SIZE / (WIDTH*BPP/8);

	vgatonicfb_update_display(info->par, &rect);
}


/* 
	Mark page-size areas as dirty by setting corresponding bit(s) in the deferred_pages_mask bitmap, then (re-)schedule the 
   	deferred_io workqueue task. 
*/

static void vgatonicfb_deferred_io_touch(struct fb_info *info, const struct fb_fillrect *rect)
{
	struct fb_deferred_io *fbdefio = info->fbdefio;

	if (!fbdefio)
		return;

	if (rect) {
		struct vgatonicfb_par *par = info->par;
		unsigned long offset;
		int index_lo, index_hi, i;

		offset = rect->dy * info->fix.line_length;
		index_lo = offset >> PAGE_SHIFT;
		offset = (rect->dy + rect->height - 1) * info->fix.line_length;
		index_hi = offset >> PAGE_SHIFT;

		for ( i=index_lo; i<=index_hi; i++ )
			set_bit(i, &par->deferred_pages_mask);
	}

	schedule_delayed_work(&info->deferred_work, fbdefio->delay);
}


static int vgatonicfb_blank(int blank_mode, struct fb_info *info)
{
	struct vgatonicfb_par *par = info->par;

	if (blank_mode == FB_BLANK_UNBLANK) {
		/* do nothing */
	} else {
		/* paint the screen black */
		memset(par->info->screen_base, 0, info->fix.smem_len);
		vgatonicfb_update_display(par, NULL);
	}
	return 0;
}


static int vgatonicfb_init_display(struct vgatonicfb_par *par)
{
	/* Hit the CS pin a few times to reset the pixel to 0,0 on VGATonic */

	vgatonic_reset(par);

	/* Fill display mem with a gradient pattern */

	if ( 1 ) { 
		u16 *vmem16 = (u16 *)par->info->screen_base;
		int x, y;
		for ( y=0; y<HEIGHT; y++ )
			for ( x=0; x<WIDTH; x++ ) {
				u16 pixel;
				pixel = ((WIDTH-x)>>2) << 11 | (x>>2) << 5 | (y>>3) << 0;
				*vmem16++ = pixel;
			}
	}

	/* Update the display with the display mem contents, then turn it on */

	vgatonicfb_update_display(par, NULL);
	
	mdelay(100);

	return 0;
}


/* No hardware acceleration for rects, use system */
void vgatonicfb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
{
	sys_fillrect(info, rect);
	vgatonicfb_deferred_io_touch(info, rect);
}

/* No hardware acceleration for copying, use system */
void vgatonicfb_copyarea(struct fb_info *info, const struct fb_copyarea *area) 
{
	const struct fb_fillrect *rect = (const struct fb_fillrect *)area;
	sys_copyarea(info, area);
	vgatonicfb_deferred_io_touch(info, rect);
}

/* No hardware acceleration for image blitting, use system */
void vgatonicfb_imageblit(struct fb_info *info, const struct fb_image *image) 
{
	const struct fb_fillrect *rect = (const struct fb_fillrect *)image;
	sys_imageblit(info, image);
	vgatonicfb_deferred_io_touch(info, rect);
}


static ssize_t vgatonicfb_write(struct fb_info *info, const char __user *buf, size_t count, loff_t *ppos)
{
	unsigned long p = *ppos;
	void *dst;
	int err = 0;
	unsigned long total_size;

	if (info->state != FBINFO_STATE_RUNNING)
		return -EPERM;

	total_size = info->fix.smem_len;

	if (p > total_size)
		return -EFBIG;

	if (count > total_size) {
		err = -EFBIG;
		count = total_size;
	}

	if (count + p > total_size) {
		if (!err)
			err = -ENOSPC;

		count = total_size - p;
	}

	dst = (void __force *) (info->screen_base + p);

	if (copy_from_user(dst, buf, count))
		err = -EFAULT;

	if  (!err)
		*ppos += count;

	vgatonicfb_deferred_io_touch(info, NULL); /* TODO: pass dirty rect */

	return (err) ? err : count;
}


/* Get those RGB565 values, even though we know we'll be converting them to RGB332 later. */
static int vgatonicfb_setcolreg(unsigned regno, unsigned red, unsigned green, unsigned blue, unsigned transp, struct fb_info *info)
{
	struct vgatonicfb_par *par = info->par;

	if (regno >= ARRAY_SIZE(par->pseudo_palette))
		return -EINVAL;

	par->pseudo_palette[regno] =
		((red   & 0xf800)) |
		((green & 0xfc00) >>  5) |
		((blue  & 0xf800) >> 11);

	return 0;
}

/* Register a bunch of stuff with the OS so it will know how to reach the framebuffer when we are needed */


// First, all the functions you might need (FB 'op'erations)
static struct fb_ops vgatonicfb_ops = {
	.owner			= THIS_MODULE,
	.fb_read		= fb_sys_read,
	.fb_write		= vgatonicfb_write,
	.fb_blank		= vgatonicfb_blank,
	.fb_fillrect	= vgatonicfb_fillrect,
	.fb_copyarea	= vgatonicfb_copyarea,
	.fb_imageblit	= vgatonicfb_imageblit,
	.fb_setcolreg	= vgatonicfb_setcolreg,
};

// Tell deferred IO how quickly to wake us up on each sleep.  In the header file the FPS value is set.
static struct fb_deferred_io vgatonicfb_defio = {
	.delay			= HZ/SPI_FRAMES_PER_SECOND,
	.deferred_io	= vgatonicfb_deferred_io,
};

// Modprode/etc.  This registers us with the system.
static int vgatonicfb_probe (struct spi_device *spi)
{
	int chip 								= spi_get_device_id(spi)->driver_data;
	struct vgatonicfb_platform_data *pdata 	= spi->dev.platform_data;
	int vmem_size 							= WIDTH*HEIGHT*BPP/8;
	u8 *vmem 								= NULL;
	u8 *spi_writing_buffer 					= NULL;
	struct fb_info *info;
	struct vgatonicfb_par *par;
	int retval = -EINVAL;

	pr_debug("VGATONICFB - loading\n");

	if (chip != VGATONIC_SPI_VIDEO_CARD) {
		pr_err("%s: only the %s device is supported\n", DRVNAME,
			to_spi_driver(spi->dev.driver)->id_table->name);
		return -EINVAL;
	}

	if (!pdata) {
		pr_err("%s: platform data required for Chip Select information!\n",
			DRVNAME);
		return -EINVAL;
	}

	retval = gpio_request_one(pdata->cs_gpio, GPIOF_OUT_INIT_LOW,
			"VGATONIC Chip Select Pin");
	if (retval) {
		gpio_free(pdata->cs_gpio);
		pr_err("%s: could not acquire cs_gpio %d\n",
			DRVNAME, pdata->cs_gpio);
		return retval;
	}

	retval = -ENOMEM;
	vmem = vzalloc(vmem_size);
	if (!vmem)
		goto alloc_fail;

	/* Allocate spi write buffer */
	spi_writing_buffer = vzalloc(vmem_size);
	if (!spi_writing_buffer)
		goto alloc_fail;

	info = framebuffer_alloc(sizeof(struct vgatonicfb_par), &spi->dev);
	if (!info)
		goto alloc_fail;

	info->screen_base 		= (u8 __force __iomem *)vmem;
	info->fbops 			= &vgatonicfb_ops;
	info->fix 				= vgatonicfb_fix;
	info->fix.smem_len 		= vmem_size;
	info->var = vgatonicfb_var;
	/* RGB565 -see notes elsewhere for why. */
	info->var.red.offset 	= 11;
	info->var.red.length 	= 5;
	info->var.green.offset 	= 5;
	info->var.green.length 	= 6;
	info->var.blue.offset	= 0;
	info->var.blue.length 	= 5;
	info->var.transp.offset = 0;
	info->var.transp.length = 0;
	info->flags             = FBINFO_FLAG_DEFAULT | FBINFO_VIRTFB;
	info->fbdefio           = &vgatonicfb_defio;

	fb_deferred_io_init(info);

	par = info->par;
	par->info = info;
	par->spi = spi;
	par->cs = pdata->cs_gpio;
	par->spi_writing_buffer = spi_writing_buffer;
	info->pseudo_palette = par->pseudo_palette;

	spi_set_drvdata(spi, info);

	retval = vgatonicfb_init_display(par);

	if (retval < 0)
		goto fbreg_fail;

	/* register framebuffer *after* initializing device! */
	retval = register_framebuffer(info);
	if (retval < 0)
		goto fbreg_fail;

	pr_info("fb%d: %s frame buffer device,\n\tusing %d KiB of video memory\n", info->node, info->fix.id, vmem_size);

	return 0;

	/* TODO: release gpios on fail */
fbreg_fail:
	spi_set_drvdata(spi, NULL);
	framebuffer_release(info);

alloc_fail:
	if (spi_writing_buffer)
		vfree(spi_writing_buffer);
	if (vmem)
		vfree(vmem);

	gpio_free(pdata->cs_gpio);

	return retval;
}

// VGATonic was turned off.
static int vgatonicfb_remove(struct spi_device *spi)
{
	struct fb_info *info = spi_get_drvdata(spi);

	if (info) {
		struct vgatonicfb_par *par = info->par;
		unregister_framebuffer(info);
		fb_deferred_io_cleanup(info);
		vfree(info->screen_base);	
		framebuffer_release(info);
		vfree(par->spi_writing_buffer);
		gpio_free(par->cs);
	}

	spi_set_drvdata(spi, NULL);

	return 0;
}

// VGATonic is an SPI device as well as a framebuffer; set that up.
static const struct spi_device_id vgatonicfb_ids[] = {
	{ "vgatonic_card_on_spi", VGATONIC_SPI_VIDEO_CARD },
	{ },
};
MODULE_DEVICE_TABLE(spi, vgatonicfb_ids);


// Let the VGATonic SPI driver know about the framebuffer driver.
static struct spi_driver vgatonicfb_driver = {
	.driver = {
		.name   	= "vgatonicfb",
		.owner  	= THIS_MODULE,
	},
	.id_table 		= vgatonicfb_ids,
	.probe  		= vgatonicfb_probe,
	.remove 		= vgatonicfb_remove,
};

// What to do on entrance
static int __init vgatonicfb_init(void)
{
	return spi_register_driver(&vgatonicfb_driver);
}

// What to do on exit
static void __exit vgatonicfb_exit(void)
{
	pr_debug("VGATONICFB - exit\n");
	spi_unregister_driver(&vgatonicfb_driver);
}

/* ------------------------------------------------------------------------- */

module_init(vgatonicfb_init);
module_exit(vgatonicfb_exit);

MODULE_DESCRIPTION("FB driver for VGATONIC display controller");
MODULE_AUTHOR("Matt Porter");
MODULE_AUTHOR("Neil Greatorex");
MODULE_AUTHOR("Kamal Mostafa <kamal@whence.com>");
MODULE_AUTHOR("farter");
MODULE_AUTHOR("notro");
MODULE_AUTHOR("PK");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.1");