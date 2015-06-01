/*
 * FB Driver for VGATonic - the Header and some definitions
 *
 * Copyright (C) 2015 PK
 * Inspired by Matt Porter, Neil Greatorex, Kamal Mostafa, farter and notro
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License. See the file COPYING in the main directory of this archive for
 * more details.
 */

#define DRVNAME					"vgatonicfb"
#define WIDTH					640
#define HEIGHT					480
#define SPI_BUS 	    		0
#define SPI_BUS_CS1 			0

 // 640*480*8 = 2,457,600 bits.  Max is 23.6 FPS at 58,000,000 Hz.  Scale it back a bit for gpio delays and conservatism.
 // Of course, SPI speed is conservative.  See my calculation here: 
 // https://hackaday.io/project/1943-vgatonic/log/5738-spi-clock-domain-crossing-finally-something-useful

 // If you're not on a Raspberry Pi 2 B, change this to something more appropriate!
#define SPI_BUS_SPEED 			58000000
#define SPI_FRAMES_PER_SECOND 	22

/* 

We present the next line to the outside world - there is no linux support for RGB332 anymore, and most programs that
write directly to the framebuffer will puke when they can't figure out the conversion.

Spark provided by farter at http://fartersoft.com/blog/2011/06/22/hacking-up-an-rgb-framebuffer-driver-for-wii-linux/
we will present a 16 bit RGB565 framebuffer to the outside world (which has forgotten about those RGB332 days of the 
80s to early 90s!), then only do our conversion internally.

*/

#define BPP			16

/*

As far as we have planned, VGATonic will only have 8 bit color depth, so leave this as 8.

*/

#define BPPVGATONIC 8

/*

Conversion from RGB565 space to RGB332 (RRRGGGBB); I first saw this macro in Notro's fbtft code and it was easier than
using the programming calculator since it was already working.

Also known as RGB 8-8-4, No translation needed                          = 256 Colors
R: 0-7
G: 0-7
B: 0-3

*/

#define RGB565toRGB332(c) ( ((c&0xE000)>>8) | ((c&0x0700)>>6) | ((c&0x0018)>>3) )


// Maybe add some more color spaces?  6-8-5 is supposed to be the ideal scheme for 256 (so I've heard).

/*

Todo: RGB 6-7-6: 6 shades of red and blue, 7 shades of green            = 252 colors + LUT
Translation: (42×R)+(6×G)+B

R: 0-5
G: 0-6
B: 0-5

*/

/*

Todo: RGB 6-8-5: 5 shades of red, 4 shades of blue, 8 shades of green   = 240 colors + LUT
Translation: (40×R)+(5×G)+B

R: 0-5
G: 0-7
B: 0-4

*/

/* Display Module */

#define VGATONIC_SPI_VIDEO_CARD	0	/* It's a graphics card.  It supports standard VGA.... */


struct vgatonic_function {
	u16 cmd;
	u16 data;
};

struct vgatonicfb_par {
	struct spi_device *spi;
	struct fb_info *info;
	u8     *spi_writing_buffer;
	u32    pseudo_palette[16];
	int    cs;
	volatile long unsigned int deferred_pages_mask;
};

struct vgatonicfb_platform_data {
	int cs_gpio;
};



