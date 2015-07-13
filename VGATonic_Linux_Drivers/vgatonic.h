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


/* Don't worry if your board can't drive this in an acceptable way, you can use fbset to reduce resolution or color
   depth to get something workable once it is initialized. */

#define DRVNAME					"vgatonicfb"
#define WIDTH					640
#define HEIGHT					480

/* 

We present the next line to the outside world - there is (basically) no linux support for RGB332 anymore, and most programs that
write directly to the framebuffer will puke when they can't figure out the conversion.

Spark provided by farter at http://fartersoft.com/blog/2011/06/22/hacking-up-an-rgb-framebuffer-driver-for-wii-linux/
we will present a 16 bit RGB565 framebuffer to the outside world (which has forgotten about those RGB332 days of the 
80s to early 90s!), then only do our conversion internally.

*/

#define BPP			16

/*

VGATonic's base color depth.

*/

#define BPPVGATONIC 8

/*

Conversion from RGB565 space to RGB332 (RRRGGGBB); I first saw this macro in Notro's fbtft code.

Also known as RGB 8-8-4, No translation needed                          = 256 Colors
R: 0-7
G: 0-7
B: 0-3

Returns byte

*/

#define RGB565toRGB332(c) ( ((c&0xE000)>>8) | ((c&0x0700)>>6) | ((c&0x0018)>>3) )

/*

Conversion from RGB565 space to RGBI;

The MSB of red, green and blue plus any of the next highest bits for RGB in our intensity field.

*/

#define     RGB565toRGBI(c) ( ((c&0x8000)>>12) | ((c&0x4000)>>14) | ((c&0x0400)>>8) | ((c&0x0200)>>9) | ((c&0x0018)>>3) )

/*

Conversion from RGB565 space to 4 "Grays" (B GH GL W);

11 = white, 10 = Gray High 01 = Gray Low 00 = black = 4 colors
Any of the top two bits; we're decompositioning using the highest value.

Returns bit

*/

#define     RGB565to4G(c) ( ((c&0xC000)>>14) | ((c&0x0600)>>9) | ((c&0x0018)>>3) )

/*

Conversion from RGB565 space to BW;

1 = white, 0 = black = 2 colors
If any color has a MSB set we will mark it white.

Returns 2 bits

*/

#define     RGB565toBW(c) ( ((c&0x8000)>>15) | ((c&0x0400)>>10) | ((c&0x0010)>>4) )


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

struct vgatonicfb_platform_data {
	int cs_gpio;
	int spi_speed;
	int spi_frames_per_second;
	int max_spi_writes;
};

struct vgatonic_function {
	u16 cmd;
	u16 data;
};

struct vgatonicfb_par {
	struct 	spi_device *spi;
	struct 	fb_info *info;
	u8     	*spi_writing_buffer;
	u32    	pseudo_palette[16];
	int 	resIndex;
	int 	bppIndex;
	int     resLength;
	int     bppLength;
	int    	cs;
	int 	spiSpeed;
	int 	spiFPS;
	volatile long unsigned int deferred_pages_mask;
};


/*  VGATonic Hardware acceleration tables - at low resolutions, speeding up frame refreshes by demanding less
 	SPI writes than standard "high requirement" 640x480x8bpp VGA.  */

/*  The first 4 bytes are reserved, then:
	Byte 5&6 = Bit Depth:
				'xxxx00xx' - 8 bpp
				'xxxx01xx' - 4 bpp
				'xxxx10xx' - 2 bpp (Gray)
				'xxxx11xx' - 1 bpp (B&W)

	This controls the number of pixels sent per SPI send - 1, 2, 4, and 8.

	Byte 7&8 = User Resolution:
				'xxxxxx00' - 640x480
				'xxxxxx01' - 320x240
				'xxxxxx10' - 160x120
				'xxxxxx11' - 80x60

	This controls the total number of transations; each tick down the resolution chart will divide the number
	of writes needed per frame by 4.

	So, for a complete frame refresh, we can accept as low as 80*60*1 = 4800 Bits, or just 600 Bytes, 
	or as high as 640*480*8 = 2457600 Bits, or 307,200 Bytes.

	resIndex and bppIndex will map to these.

				*/

struct hardware_resolution_info {
	char id[16];      /* Just a name */
    int  width;       
    int  height;
    u8   modeOrByte;
};

struct hardware_bitdepth_info {
	char id[16];      /* Just a name */
    int  bpp;         /* Our bitdepth */
    u8   modeOrByte;  /* Byte to OR with our master byte to change/set mode */
};


/* Hardware supported (read: accelerated) on VGATonic.  Lesser resolutions require less SPI writes. */
/* Keep these in ascending order for later comparisons to pick the proper one for a virtual frame size. */

static struct hardware_resolution_info vgatonicfb_resolution_table[] = {
	{  /* Our most modest recepticle, 80x60 */
		.id 		= "80x60",
		.width 		= 80,
		.height 	= 60,
		.modeOrByte	= 0b00000011,
	},
	{  /* Second smallest resolution, 160x120 */
		.id 		= "160x120",
		.width 		= 160,
		.height 	= 120,
		.modeOrByte	= 0b00000010,
	},
	{  /* Second biggest resolution, 320x240 */
		.id 	= "320x240",
		.width 	= 320,
		.height = 240,
		.modeOrByte	= 0b00000001,
	},
	{  /* Base default (and highest resolution) 640x480 */
		.id 	= "640x480",
		.width 	= 640,
		.height = 480,
		.modeOrByte	= 0b00000000,
	}
};

/* Hardware supported (read: accelerated) bit depths on VGATonic.  The lower depths literally require less writes */
static struct hardware_bitdepth_info vgatonicfb_bitdepth_table[] = {
	{  /* 1 bit per pixel, B&W */
		.id 	= "1bpp",
		.bpp    = 1,
		.modeOrByte	= 0b00001100,
	},
	{  /* 2 bits per pixel, 4 color (greyscale) */
		.id 	= "2bpp",
		.bpp    = 2,
		.modeOrByte	= 0b00001000,
	},
	{  /* 4 bits per pixel, 16 color */
		.id 	= "4bpp",
		.bpp    = 4,
		.modeOrByte	= 0b00000100,
	},
	{  /* 8 Bits per pixel, 256 color */
		.id 	= "8bpp",
		.bpp    = 8,
		.modeOrByte	= 0b00000000,
	}

};


