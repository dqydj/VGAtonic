**Raspberry Pi:**

Install all of the normal build tools and a recent gcc/g++. You may need an updated kernel - I'm using some 3.18 flavor (no device tree); you can match me like so:

> sudo rpi-update 07179c0ab486d8362af38c6fc99643ded953b99d  
> rpi-source  
> cd into Driver directory  
> sudo make clean  
> sudo make  


Once you've built, here is how you load VGATonic each time (you can automate this, of course!):

> sudo modprobe sysfillrect 
> sudo modprobe syscopyarea 
> sudo modprobe sysimgblt
> sudo modprobe fb_sys_fops
> sudo insmod vgatonic.ko
> sudo insmod rpi_vgatonic_spi.ko

(You should see activity. Or just do a 'cat /dev/urandom > /dev/fbX' to see writes!)


**Odroid C1:**

I'm on this kernel: Linux odroid 3.10.80-94 for all of these instructions.  Here is how I build on the Odroid:

> sudo -i  
> cd into VGATonic  
> make clean  
> make  

Once it is built, this is how you load it:

> sudo modprobe spicc  
> sudo modprobe spidev  
> sudo modprobe sysfillrect  
> sudo modprobe syscopyarea  
> sudo modprobe sysimgblt  
> sudo modprobe fb_sys_fops  
> sudo insmod vgatonic.ko  
> sudo insmod odroid_vgatonic_spi.ko  

**Beaglebone Black**

For the BeagleBone, you need to load a device tree overlay before anything else to turn on the SPI device.  Since SPI1 interferes with HDMI, I used SPI0.  Here is a tutorial: http://elinux.org/BeagleBone_Black_Enable_SPIDEV .  I do not use a device tree overlay for VGATonic in the driver (yet) for our control pin - so in theory, you should control other things writing to the pin you choose.  Still, this works for me in the 3.8.* kernel:

> cd VGATonic directory  
> make clean; make  

Beaglebone has a lot of stuff loaded for us already, so it's easier to load.

> echo BB-SPI0-01 > /sys/devices/bone_capemgr.*/slots #(assuming you followed the SPI tutorial above and used the default name)  
> sudo insmod vgatonic.ko  

**How Do I Know it Worked?**

There is a test pattern printed when you first load the driver for your platform.  You should see a pachwork of some sort - it is different than the green screen you get when giving VGATonic power for the first time.

The easiest way to know it worked, however, is to get it to react from your platform.  You'll have a new entry in /dev/fb*, so do this:

> cat /dev/urandom > /dev/fbX # X is the new framebuffer number  

You should see random pixels everywhere.  As for how to use your screen, check out the excellent resources Notro has compiled for fbtft.  I have generally tested these platforms by starting the x server then using a browser for a bit just to see how responsive it is.

> Written with [StackEdit](https://stackedit.io/).