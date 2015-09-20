#include <linux/module.h>
#include <linux/spi/spi.h>
#include "vgatonic.h"

// Change these to something appropriate for your board.  Roughly SPEED/(640*480*8) (subtract one or two) is the max FPS.
#define SPI_BUS_SPEED 						48000000
#define SPI_BUS_SPEED_WS					48000000

// Based on x/640/480/8
#define SPI_FRAMES_PER_SECOND 				19
// Based on x/848/480/8
#define SPI_FRAMES_PER_SECOND_WS 			14.25

/* For many boards, only the next few lines need to be changed */

#define SPI_BUS 	    		1
#define SPI_BUS_CS1 			0

/* Define the pseudo chip select.  We need this so we can hold it low for up to 307200 times in a row for a full screen write in 640*480*8 without the hardware SPI
   Device interfering.  Also, for widescreen, it might be low for as long as 407040 times! */
#define FAKE_CS					48
// Define the maximum number of SPI writes your hardware can support.  For many, it's unlimited, so use 307200.  (For widescreen changes we have increased it to 407040)
#define MAX_SPI_WRITES			407040

// Do we want to use widescreen?  This macro sets it up in the kernel.
// When you insmod or modprobe, use "insmod <thismodule>.ko widescreen=1" and widescreen mode will turn on
static int widescreen = 0;             /* default to no, use 4:3 */
module_param(widescreen, bool, 0644);  /* a Boolean type */


const char this_driver_name[] = "vgatonic_card_on_spi";

static struct vgatonicfb_platform_data vgatonicfb_data = {
       .cs_gpio       			= FAKE_CS,
       .spi_speed 				= SPI_BUS_SPEED,
       .spi_frames_per_second 	= SPI_FRAMES_PER_SECOND,
       .spi_speed_ws 			= SPI_BUS_SPEED_WS,
       .spi_frames_per_second_ws= SPI_FRAMES_PER_SECOND_WS,
       .max_spi_writes		 	= MAX_SPI_WRITES,
};

static int __init add_vgatonicfb_device_to_bus(void)
{
	struct spi_master *spi_master;
	struct spi_device *spi_device;
	struct device *pdev;
	char   buff[64];
	int    status = 0;

	spi_master = spi_busnum_to_master(SPI_BUS);
	if (!spi_master) {
		printk(KERN_ALERT "spi_busnum_to_master(%d) returned NULL\n",
			SPI_BUS);
		printk(KERN_ALERT "Missing modprobe spi device?\n");
		return -1;
	}

	spi_device = spi_alloc_device(spi_master);
	if (!spi_device) {
		put_device(&spi_master->dev);
		printk(KERN_ALERT "spi_alloc_device() failed\n");
		return -1;
	}

	/* specify a chip select line */
	spi_device->chip_select = SPI_BUS_CS1;

	/* Check whether this SPI bus.cs is already claimed */
	snprintf(buff, sizeof(buff), "%s.%u", 
			dev_name(&spi_device->master->dev),
			spi_device->chip_select);

	pdev = bus_find_device_by_name(spi_device->dev.bus, NULL, buff);


	/* If the bus is claimed, that is expected.  Unregister whatever is there.
	If we weren't doing this driver so quickly, we'd give it the bus back when you're done.  */
	if ( pdev && pdev->driver && pdev->driver->name && strcmp(this_driver_name, pdev->driver->name) ) {
		printk(KERN_ALERT "Driver [%s] already registered for %s.\nRemoving it from the bus for VGATonic to occupy it.", pdev->driver->name, buff);
		spi_unregister_device( pdev );
	} 


	/* All the rules we're set to print - use mode 3!  Don't push the speed too high! */
	spi_device->dev.platform_data 	= &vgatonicfb_data;
	struct vgatonicfb_platform_data *pdata 	= spi_device->dev.platform_data;
	if (widescreen) {
		pdata->useWidescreen = true;
		spi_device->max_speed_hz		= SPI_BUS_SPEED_WS;
	} else {
		pdata->useWidescreen = false;
		spi_device->max_speed_hz		= SPI_BUS_SPEED;
	}

	spi_device->mode 				= SPI_MODE_0;
	spi_device->bits_per_word 		= 8;
	spi_device->irq 				= -1;
	spi_device->controller_state 	= NULL;
	spi_device->controller_data 	= NULL;
	strlcpy(spi_device->modalias, this_driver_name, SPI_NAME_SIZE);


	/* Adding the VGATonic SPI Device */
	status 							= spi_add_device(spi_device);
	
	if (status < 0) {	
		spi_dev_put(spi_device);
		printk(KERN_ALERT "spi_add_device() failed: %d\n", status);		
	}				
	

	put_device(&spi_master->dev);

	return status;
}
module_init(add_vgatonicfb_device_to_bus);

static void __exit rpi_vgatonicfb_exit(void)
{
}
module_exit(rpi_vgatonicfb_exit);

MODULE_DESCRIPTION("SPI driver for VGATonic SPI VGA display controller");
MODULE_AUTHOR("PK");
MODULE_LICENSE("GPL");
