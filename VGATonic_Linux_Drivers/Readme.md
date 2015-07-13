Raspberry Pi:

Install all of the normal build tools and a recent gcc/g++. You may need an updated kernel - I'm using some 3.18 flavor (no device tree); you can match me like so:

sudo rpi-update 07179c0ab486d8362af38c6fc99643ded953b99d
rpi-source

cd into Driver directory

sudo make clean ; sudo make

sudo modprobe sysfillrect; sudo modprobe syscopyarea; sudo modprobe sysimgblt; sudo modprobe fb_sys_fops; sudo insmod vgatonic.ko; sudo insmod rpi_vgatonic_spi.ko

(You should see activity. Or just do a 'cat /dev/urandom > /dev/fbX' to see writes!)
Odroid C1:

I'm on this kernel: Linux odroid 3.10.80-94

sudo -i

Install all of the normal build tools. cd into VGATonic directory.

make clean ; make

sudo modprobe spicc; sudo modprobe spidev; sudo modprobe sysfillrect; sudo modprobe syscopyarea; sudo modprobe sysimgblt; sudo modprobe fb_sys_fops; sudo insmod vgatonic.ko; sudo insmod odroid_vgatonic_spi.ko

(You should see activity. Or just do a 'cat /dev/urandom > /dev/fbX' to see writes, just ike our Raspberry Pi bretheren!)
