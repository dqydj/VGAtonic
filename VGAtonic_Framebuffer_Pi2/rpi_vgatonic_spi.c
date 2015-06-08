/*

	I only tested this on a Raspberry Pi 2.  This will likely be different on whatever hardware you have.

	Luckily, it will be short for most boards - but you're on your own.

*/

#include <linux/module.h>
#include <linux/spi/spi.h>
#include "vgatonic.h"

#define SPI_BUS 	    		0
#define SPI_BUS_CS1 			0

const char this_driver_name[] = "vgatonic_card_on_spi";

// On my board, I used pin 25 since it is right next to the 0.0 SPI device.
static struct vgatonicfb_platform_data vgatonicfb_data = {
       .cs_gpio       = 25,
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
		printk(KERN_ALERT "Missing modprobe omap2_mcspi?\n");
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
		printk(KERN_ALERT "Driver [%s] already registered for %s!!!\nRemoving it from the bus for VGATonic to occupy it.", pdev->driver->name, buff);
		spi_unregister_device( pdev );
	} 


	/* All the rules we're set to print - use mode 3!  Don't push the speed too high! */
	spi_device->dev.platform_data 	= &vgatonicfb_data;
	spi_device->max_speed_hz		= SPI_BUS_SPEED;
	spi_device->mode 				= SPI_MODE_3;
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

MODULE_DESCRIPTION("SPI driver for VGATonic SPI VGA display controller on Raspberry Pi 2");
MODULE_AUTHOR("PK");
MODULE_LICENSE("GPL");