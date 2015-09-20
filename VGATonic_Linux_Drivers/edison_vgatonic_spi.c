#include <linux/module.h>
#include <linux/spi/spi.h>
#include <linux/spi/intel_mid_ssp_spi.h>
#include <asm/intel-mid.h>
#include <linux/lnw_gpio.h>
#include <linux/gpio.h>
#include "vgatonic.h"

// Change these to something appropriate for your board.
#define SPI_BUS_SPEED 				25000000
#define SPI_BUS_SPEED_WS 			25000000

// Based on x/640/480/8
#define SPI_FRAMES_PER_SECOND 	        10
// Based on x/848/480/8
#define SPI_FRAMES_PER_SECOND_WS 	    7.5

/* For many boards, only the next few lines need to be changed */

#define SPI_BUS 	    		5
#define SPI_BUS_CS1 			1

/* Define the pseudo chip select.  We need this so we can hold it low for up to 307200 times in a row for a full screen write in 640*480*8 without the hardware SPI
   Device interfering */
#define FAKE_CS					49

// Define the maximum number of SPI writes your hardware can support. For Edison, the hardware supports 8192 words or 16384 bytes, so limit your writes to that size.
// Even though widescreen is even larger, we still have to break up our writes.
#define MAX_SPI_WRITES			16384

// Do we want to use widescreen?  This macro sets it up in the kernel.
// When you insmod or modprobe, use "insmod <thismodule>.ko widescreen=1" and widescreen mode will turn on
static int widescreen = 0;             /* default to no, use 4:3 */
module_param(widescreen, bool, 0644);  /* a Boolean type */


const char this_driver_name[] = "vgatonic_card_on_spi";

static struct vgatonicfb_platform_data vgatonicfb_data = {
       .cs_gpio       			= FAKE_CS,
       .spi_speed 		       	= SPI_BUS_SPEED,
       .spi_frames_per_second 	= SPI_FRAMES_PER_SECOND,
       .spi_speed_ws 			= SPI_BUS_SPEED_WS,
       .spi_frames_per_second_ws= SPI_FRAMES_PER_SECOND_WS,
       .max_spi_writes		 	= MAX_SPI_WRITES,
};

static void tng_ssp_spi_cs_control(u32 command);
static void tng_ssp_spi_platform_pinmux(void);

static int tng_ssp_spi2_FS_gpio = 111;

static struct intel_mid_ssp_spi_chip chip = {
	.burst_size = DFLT_FIFO_BURST_SIZE,
	.timeout = DFLT_TIMEOUT_VAL,
	.dma_enabled = true,
	.cs_control = tng_ssp_spi_cs_control,
	.platform_pinmux = tng_ssp_spi_platform_pinmux,
};

static void tng_ssp_spi_cs_control(u32 command)
{
	gpio_set_value(tng_ssp_spi2_FS_gpio, (command == CS_ASSERT) ? 0 : 1);
}

static void tng_ssp_spi_platform_pinmux(void)
{
	int err;
	int saved_muxing;
	err = gpio_request_one(tng_ssp_spi2_FS_gpio,
			GPIOF_DIR_OUT|GPIOF_INIT_HIGH, "Arduino Shield SS");
	if (err) {
		pr_err("%s: unable to get Chip Select GPIO,\
				fallback to legacy CS mode \n", __func__);
		lnw_gpio_set_alt(tng_ssp_spi2_FS_gpio, saved_muxing);
		chip.cs_control = NULL;
		chip.platform_pinmux = NULL;
	}
}

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


	/* All the rules we're set to print - use mode 0!  It's the same as mode 3, but clock normally low.  
	Don't push the speed too high! */

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
	spi_device->controller_data 	= &chip;
	strlcpy(spi_device->modalias, this_driver_name, SPI_NAME_SIZE);

	printk(KERN_ALERT "Chip is in, about to go to setup\n");

	/* Adding the VGATonic SPI Device */
	status 							= spi_add_device(spi_device);

	printk(KERN_ALERT "Chip is out, left setup\n");

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

MODULE_DESCRIPTION("SPI driver for VGATonic SPI VGA display controller on Intel Edison");
MODULE_AUTHOR("PK");
MODULE_LICENSE("GPL");
