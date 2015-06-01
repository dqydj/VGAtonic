To use:

Edit the code, since we're assuming a 58 MHz SPI device (which isn't common!)

(If you need to build)

gcc raspi_user_spi_test.c -o spitest

(To run: You need a "spidev0.0" device!)

sudo ./spitest

Control-c to exit - but really, insert your code in the loop if you just want to write to the framebuffer!