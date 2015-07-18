/*
 * FB driver for VGATONIC LCD controller
 * for generic 640x480x8bpp VGA monitor driving.
 * (Basically, anything with a VGA port should support this mode)
 *
 *
 * (Notes Retained from Kamal Mostafa)
 #  Layout is based on skeletonfb.c by James Simmons and Geert Uytterhoeven.
 *  
 *
 * Copyright (C) 2015, PK
 * Inspired by Matt Porter, Neil Greatorex, Kamal Mostafa, and notro, along with the broadsheetfb driver by Jaya Kumar
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

// See the header file for all of the definitions and lengthy explanations

#include "vgatonic.h"

static struct fb_fix_screeninfo vgatonicfb_fix = {
	.id 			= "VGATONIC_V2", 
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
	.grayscale      = 0,
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
		.speed_hz   = speed_hz,
	};
	

	spi_message_init(&m);
	spi_message_add_tail(&t, &m);
	return spi_sync(spi, &m);
}

static int vgatonic_write_data_buf(struct vgatonicfb_par *par, u8 *txbuf, int size)
{
	/* Chip Select low to warn VGATonic something is coming */
	gpio_set_value(par->cs, 0);

	int bytesLeft = size;
	int retval = 0;
	while (bytesLeft > 0) {

	  if (bytesLeft > par->maxSPIBytes) {
	
	    /* Full Speed SPI */
	    struct spi_message	m;
	    struct spi_transfer	t = {
	      .tx_buf		= txbuf+(size-bytesLeft),
	      .len		= par->maxSPIBytes,
	      .speed_hz         = par->spiSpeed,
	    };
	    spi_message_init(&m);
	    spi_message_add_tail(&t, &m);
	    int retval = spi_sync(par->spi, &m);
	    bytesLeft -= par->maxSPIBytes;
	  } else {
	    	    /* Full Speed SPI */
	    struct spi_message	m;
	    struct spi_transfer	t = {
	      .tx_buf		= txbuf+(size-bytesLeft),
	      .len		= bytesLeft,
	      .speed_hz         = par->spiSpeed,
	    };
	    spi_message_init(&m);
	    spi_message_add_tail(&t, &m);
	    int retval = spi_sync(par->spi, &m);
	    bytesLeft = 0;
	  }
	  
	  
	}
	
	/* Chip Select high to warn VGATonic something is done */
	gpio_set_value(par->cs, 1);


	return retval;
}

/* 	The deferred io informs us where the framebuffer is dirty.  Tell VGATonic to skip to the nearest
	Hardware Accelerated Line then return the line number to the requester.
 */
static int vgatonicfb_hardware_move(struct vgatonicfb_par *par, int dirty_line)
{
	int width = vgatonicfb_resolution_table[par->resIndex].width;
	int height = vgatonicfb_resolution_table[par->resIndex].height;
	int start_line = 0;
	u8 HARDWARE_MOVE = 0b00000000;
	
	// Not implemented yet - but don't worry, it's in hardware.  I've got microcontrollers successfully using it,
	// so this should be revisited.

	// if (start_line != 0) {

	// 	// Send SPI Command
	// 	/* Chip Select low to warn VGATonic something is coming; in this case a mode change */
	// 	gpio_set_value(par->cs, 0);
	// 		struct spi_message	m;
	// 		struct spi_transfer	t = {
	// 		.tx_buf		= &HARDWARE_MOVE,
	// 		.len		= 1,
	// 		//.speed_hz 	= par->modeChangeSpeed,
	// 	};

	// 	spi_message_init(&m);
	// 	spi_message_add_tail(&t, &m);

	// 	int retval = spi_sync(par->spi, &m);

	// 	// Done changing mode
	// 	gpio_set_value(par->cs, 1);

	// 	if (retval)
	// 		return -1;

	// }

	return start_line;
}

/* Change the mode of VGATonic */
static int vgatonicfb_update_mode(struct vgatonicfb_par *par)
{
	gpio_set_value(par->cs, 1);

	// Base value 640x480x8bpp
	u8 MODECHANGE = 0b00000000;

	// Resolution & Bit depth change
	MODECHANGE |= vgatonicfb_resolution_table[par->resIndex].modeOrByte;
	MODECHANGE |=   vgatonicfb_bitdepth_table[par->bppIndex].modeOrByte;

	/* Chip Select low to warn VGATonic something is coming; in this case a mode change */
	gpio_set_value(par->cs, 0);

	struct spi_message	m;
	struct spi_transfer	t = {
		.tx_buf		= &MODECHANGE,
		.len		= 1,
	};

	spi_message_init(&m);
	spi_message_add_tail(&t, &m);

	int retval = spi_sync(par->spi, &m);

	// Increase or decrease frames per second
	int newFPS = par->spiFPS;
	newFPS << vgatonicfb_bitdepth_table[par->bppIndex].modeOrByte;

	switch (vgatonicfb_resolution_table[par->resIndex].modeOrByte) {
		case 1:
			newFPS *= 4;
			break;
		case 2:
			newFPS *= 16;
			break ;
		case 3:
			newFPS *= 64;
			break ;
	}
	if (newFPS > 60) newFPS = 60;

	// Change our update speed
	par->info->fbdefio->delay	= HZ/newFPS;


	// Done changing mode
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


	/* Current settings of monitor */
	int height = vgatonicfb_resolution_table[par->resIndex].height;
	int width  =  vgatonicfb_resolution_table[par->resIndex].width;
	int bpp    =      vgatonicfb_bitdepth_table[par->bppIndex].bpp;


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


	/* Adjusted for screen size */
	dh = (dh / (480/height));
	dw = (dw / (640/width));
	/* Adjusted width again for bit depth */
	int bitScaler = 8/bpp;
	dw /= bitScaler;

	/* Load spi_writing_buffer with image data from the dirty_rect subwindow */

	// We have no way of skipping pixels yet, but we can optimize by not writing beyond
	// where we actually have changed pixels.  No need to write the bottom right when the menubar changes.

	vmem_start = (WIDTH*dy + dx)*BPP/8; // No need to change this code since we are setting it to 0,0 in the rect.


	/* 8 bit part, 16 bit pixels */

	vmem16 = (u16 *)((u8 *)vmem + vmem_start);
	smem   = par->spi_writing_buffer;

	for (i=0; i<dh; i++) {
		int x;
		#ifdef __LITTLE_ENDIAN
		for (x=0; x<dw; x++) {
			if (bpp == 8) {
		    	smem[x] =  RGB565toRGB332( vmem16[x] ) ;
			} else if (bpp == 4) {
		    	u8 pixel = 0b00000000;
				pixel |= RGB565toRGBI( vmem16[(x*bitScaler)] )   << 4;
				pixel |= RGB565toRGBI( vmem16[(x*bitScaler)+1] ) << 0;
				smem[x] = pixel;
			} else if (bpp == 2) {
		    	u8 pixel = 0b00000000;
				pixel |=   RGB565to4G( vmem16[(x*bitScaler)] )   << 6;
				pixel |=   RGB565to4G( vmem16[(x*bitScaler)+1] ) << 4;
				pixel |=   RGB565to4G( vmem16[(x*bitScaler)+2] ) << 2;
				pixel |=   RGB565to4G( vmem16[(x*bitScaler)+3] ) << 0;
				smem[x] = pixel;
			} else {
				u8 pixel = 0b00000000;
				pixel |=   RGB565toBW( vmem16[(x*bitScaler)] )   << 7;
				pixel |=   RGB565toBW( vmem16[(x*bitScaler)+1] ) << 6;
				pixel |=   RGB565toBW( vmem16[(x*bitScaler)+2] ) << 5;
				pixel |=   RGB565toBW( vmem16[(x*bitScaler)+3] ) << 4;
				pixel |=   RGB565toBW( vmem16[(x*bitScaler)+4] ) << 3;
				pixel |=   RGB565toBW( vmem16[(x*bitScaler)+5] ) << 2;
				pixel |=   RGB565toBW( vmem16[(x*bitScaler)+6] ) << 1;
				pixel |=   RGB565toBW( vmem16[(x*bitScaler)+7] ) << 0;
				smem[x] = pixel;
			}
		}
		#else
			// Haven't checked.
		#endif
		// Increase the counters by one spot.  16 bit vs 8 bit variable, remember
		smem += dw*BPPVGATONIC/8;
		vmem16 += WIDTH*BPP/16;
	}


	/* 	Send spi_writing_buffer to VGATONIC's local VRAM over SPI 
		Dirty height (starting from zero) * Dirty width (always 640)
	*/
	
	write_nbytes = dw*dh*BPPVGATONIC/8;
	ret = vgatonic_write_data_buf(par, par->spi_writing_buffer, write_nbytes);


	// This should never get hit because we use blocking SPI calls with spi_sync.
	if (ret < 0)
		pr_err("%s: spi_write failed to update display buffer\n",
			par->info->fix.id);

}

/* vgatonicfb_deferred_io

		This will get hit 1/FPS times per second, and it will give this driver the updated framebuffer.

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
		pr_debug("VGATonic - deferred_io no pages? full update.\n");
		page_low = 0;
		page_high = npages - 1;
	}
	
	// For now, blast out the whole page.
	page_low = 0;

	// Eventually we should check 'dirty' pixels...
	//
	// The rest of the math still applies - we really don't *have* to write the whole screen; we can stop whenever the dirty pixels stop.
	// That means if something in the menubar changes, we might 'only' be writing 50 lines:
	// 640*480*8 = 2,457,600 bits/frame, 640*50*8 = 256,000 bits/frame, or 89.6% less congestion on SPI.

	rect.dx = 0;
	rect.width = WIDTH;

	rect.dy = page_low * PAGE_SIZE / (WIDTH*BPP/8);

	/* If we check dirty pixels, we can theoretically cut down writes here by using
		the VGATonic feature to move to a line */

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

/*
	When there is a query about the capabilities of VGATonic, this is where we check
	if we can support it with our hardware.
*/
static int vgatonicfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
{

	int err = 0;
	struct vgatonicfb_par *par = info->par;
	int bpp = var->bits_per_pixel >> 3;
	unsigned long line_size = var->xres_virtual * bpp;

	// Tell them we don't support anything greater than 16 bits
	// Remember, 16 bits is the minimum expected by many pieces of software, so we present the
	// fake 16 bit option and just cut it down to 8 ourselves.
	if (var->bits_per_pixel > 16)
        return -EINVAL;

    // We aren't increasing our virtual memory... we can only do 640x480x8bpp anyway.
   	if ((line_size * var->yres_virtual) > info->fix.smem_len)
        return -ENOMEM; 

    // Let's also keep the virtual resolution below our highest defined amount
    
    int foundResIndex = par->resLength;
    int i = foundResIndex -1;
    while (i >= 0) {
    	if ( var->xres <= vgatonicfb_resolution_table[i].width && var->yres <= vgatonicfb_resolution_table[i].height ) {
    		foundResIndex = i;
    	}
    	--i;
    }
    if (foundResIndex == par->resLength)
    	return -EINVAL;
    par->resIndex = foundResIndex;

    switch (var->bits_per_pixel) {

      	// B&W
        	case 1:
        // Four greys
        	case 2:
        // 4 bit depth, RGBI 16 Color
        	case 4:
        // 8 Bit Depth, RRRGGGBB 256 Color
         	case 8:
         	        var->red.offset 	= 0;
                	var->green.offset 	= 0;
                 	var->blue.offset 	= 0;
                	var->red.length 	= 8;
                	var->green.length 	= 8;
                	var->blue.length 	= 8;
                	var->transp.length 	= 0;
                	var->transp.offset 	= 0;
                	break;
        // RGB 565 (Fake, but it's small enough to just write everything.  600 KB!  40KB less than all you'll ever need! )
            case 16:
            		var->red.offset 	= 11;
					var->red.length 	= 5;
					var->green.offset 	= 5;
					var->green.length 	= 6;
					var->blue.offset	= 0;
					var->blue.length 	= 5;
					var->transp.offset 	= 0;
					var->transp.length 	= 0;
					break;
			default:
                 err = -EINVAL;
    }

    var->red.msb_right 		= 0;
    var->green.msb_right 	= 0;
    var->blue.msb_right 	= 0;
    var->transp.msb_right 	= 0;

    int foundBppIndex = par->bppLength-1;
    i = foundBppIndex;
    while (i >= 0) {
    	if ( var->bits_per_pixel <= vgatonicfb_bitdepth_table[i].bpp ) {
    		foundBppIndex = i;
    	}

    	--i;
    }
    par->bppIndex = foundBppIndex;
    var->xres 				= vgatonicfb_resolution_table[par->resIndex].width;
    var->yres 				= vgatonicfb_resolution_table[par->resIndex].height;
	var->xres_virtual 		= vgatonicfb_resolution_table[par->resIndex].width;
	var->yres_virtual 		= vgatonicfb_resolution_table[par->resIndex].height;


    return 0;

}


/* Send a command to change the mode */
static int vgatonicfb_set_par(struct fb_info *info)
{
        struct vgatonicfb_par *par = info->par;
        vgatonicfb_update_mode(par);

        /* Sorry, we don't know if it actually succeeded. */
        return 0;
}


static int vgatonicfb_blank(int blank_mode, struct fb_info *info)
{
	struct vgatonicfb_par *par = info->par;

	if (blank_mode == FB_BLANK_UNBLANK) {
		/* do nothing */
	} else {
		/* I see a dirty screen and I want it painted black */
		memset(par->info->screen_base, 0, info->fix.smem_len);
		vgatonicfb_update_display(par, NULL);
	}
	return 0;
}

/* Hit the CS pin a few times to reset the pixel to 0,0 on VGATonic 
   then paint a pleasing tst pattern so you know it is working. */
static int vgatonicfb_init_display(struct vgatonicfb_par *par)
{
	

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


/* Get those RGB565 values. */
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
	.fb_check_var   = vgatonicfb_check_var,
	.fb_set_par 	= vgatonicfb_set_par,
};

// Tell deferred IO how quickly to wake us up on each sleep.  In the header file the FPS value is set.
static struct fb_deferred_io vgatonicfb_defio = {
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

	pr_debug("VGATONIC Framebuffer - loading\n");

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
	info->var 				= vgatonicfb_var;
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

	info->fbdefio->delay	= HZ/pdata->spi_frames_per_second,

	fb_deferred_io_init(info);

	par = info->par;
	/* See notes in header - setting a bunch of defaults. */
	par->bppIndex 			= 3;
	par->resIndex 			= 3;
	par->bppLength 			= 4;
	par->resLength 			= 4;
	par->spiSpeed         	= pdata->spi_speed;
	par->spiFPS         	= pdata->spi_frames_per_second;
	par->maxSPIBytes        = pdata->max_spi_writes;

	par->info = info;
	par->spi = spi;
	par->cs = pdata->cs_gpio;
	par->spi_writing_buffer = spi_writing_buffer;
	info->pseudo_palette = par->pseudo_palette;

	spi_set_drvdata(spi, info);


	vgatonicfb_update_mode(par);
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
MODULE_AUTHOR("Kamal Mostafa");
MODULE_AUTHOR("farter");
MODULE_AUTHOR("notro");
MODULE_AUTHOR("PK");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.1");
