/*
 * SPI testing utility (using spidev driver)
 *
 * Based on code:
 * Copyright (c) 2007  MontaVista Software, Inc.
 * Copyright (c) 2007  Anton Vorontsov 
 *
 * PK, 2015, http://dqydj.net
 */

#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <linux/spi/spidev.h>


#define IN  0
#define OUT 1
 
#define LOW  0
#define HIGH 1
 
#define CEPIN 25  /* Chip enable - I put VGATonic on pin 25 */

#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))


#include "gpio.h"
#include "raspi_user_spi_test.h"


static void pabort(const char *s)
{
	perror(s);
	abort();
}

// Assuming spidev0.0 exists, should be pretty portable between hosts.
static const char *device = "/dev/spidev0.0";

// Mode 3 is important!
static uint8_t mode = 3;
static uint8_t bits = 8;

// Raspberry Pi can handle quite a bit - but our part is limited to 59 and change.  Use 58.
// On other devices, set this to something sane.
static uint32_t speed = 58000000;
static uint16_t delay;

static void transfer(int fd, uint8_t * message, size_t message_size)
{
	int ret;
	sleep(.5);
	GPIOWrite(CEPIN, 0);
	sleep(.5);

	uint8_t rx[message_size];
	printf("Array size %i \n", message_size);
	struct spi_ioc_transfer tr = {
		.tx_buf = (unsigned long)message,
		.rx_buf = (unsigned long)rx,
		.len = message_size,
		.delay_usecs = delay,
		.speed_hz = speed,
		.bits_per_word = bits,
	};

	ret = ioctl(fd, SPI_IOC_MESSAGE(1), &tr);

	sleep(3);
	GPIOWrite(CEPIN, 1);
	sleep(.5);

}

int main(int argc, char *argv[])
{

	/*
	 * Enable GPIO pins
	 */
	if (-1 == GPIOExport(CEPIN))
		return(1);
 
	/*
	 * Set GPIO directions
	 */
	if (-1 == GPIODirection(CEPIN, OUT))
		return(2);

	// Reset VGATonic to ensure we are at pixel 0,0
	sleep(.5);
	GPIOWrite(CEPIN, 1);
	sleep(.5);
	GPIOWrite(CEPIN, 0);
	sleep(.5);
	GPIOWrite(CEPIN, 1);
	sleep(.5);
	GPIOWrite(CEPIN, 0);
	sleep(.5);
	GPIOWrite(CEPIN, 1);
	sleep(.5);

	int ret = 0;
	int fd;
	
	fd = open(device, O_RDWR);
	if (fd < 0)
		pabort("can't open device");

	/*
	 * spi mode
	 */
	ret = ioctl(fd, SPI_IOC_WR_MODE, &mode);
	if (ret == -1)
		pabort("can't set spi mode");

	ret = ioctl(fd, SPI_IOC_RD_MODE, &mode);
	if (ret == -1)
		pabort("can't get spi mode");

	/*
	 * bits per word
	 */
	ret = ioctl(fd, SPI_IOC_WR_BITS_PER_WORD, &bits);
	if (ret == -1)
		pabort("can't set bits per word");

	ret = ioctl(fd, SPI_IOC_RD_BITS_PER_WORD, &bits);
	if (ret == -1)
		pabort("can't get bits per word");

	/*
	 * max speed hz
	 */
	ret = ioctl(fd, SPI_IOC_WR_MAX_SPEED_HZ, &speed);
	if (ret == -1)
		pabort("can't set max speed hz");

	ret = ioctl(fd, SPI_IOC_RD_MAX_SPEED_HZ, &speed);
	if (ret == -1)
		pabort("can't get max speed hz");

	printf("spi mode: %d\n", mode);
	printf("bits per word: %d\n", bits);
	printf("max speed: %d Hz (%d KHz)\n", speed, speed/1000);

	while (1) {
		
		transfer(fd, doge, 307200);
		transfer(fd, guitars, 307200);
	
	}

	close(fd);


	return ret;
}
