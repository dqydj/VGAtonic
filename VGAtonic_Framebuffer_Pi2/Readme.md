This implementation of the VGAtonic framebuffer is for the *Raspberry Pi 2 B*.  Odds are it will be similar for whatever device you are using; this should get you started.

------ To run (No build) ------

- Build a VGAtonic board and clone the repository (or copy the ko files)
	- Enable SPI on your computer.  I did it on mine using ‘raspi-config’
- Change the SPI Buffer Size to 307200.
	- On my board, I edited /boot/cmdline.txt and added 'spidev.bufsiz=307200'
	- Reboot to change (or edit /sys/module/spidev/parameters/bufsiz)
	- 'cat /sys/module/spidev/parameters/bufsiz' to check it took hold
- In the directory where you have the ko files:

	sudo modprobe sysfillrect
	sudo modprobe syscopyarea
	sudo modprobe sysimgblt
	sudo modprobe fb_sys_fops
	sudo insmod vgatonic.ko
	sudo insmod rpi_vgatonic_spi.ko

- 'dmesg'
	- Check for messages from VGAtonic at the bottom
- If all went well, you can now use it like a normal framebuffer.  I suggest notro's options here: https://github.com/notro/fbtft/wiki/Framebuffer-use



------ To build (if you want to change things) ------

- Acquire/borrow/build VGAtonic board and clone the repository
- Do all of this to get linux-headers for the most recent kernel:

	Get set up for kernel module compilation.  The best guide is notro’s post in this thread on the raspberry pi forums: https://www.raspberrypi.org/forums/viewtopic.php?f=29&t=76504

	Make sure you read Notro’s fbtft wiki before running rip-source, because you’re going to need gcc 4.8.3+:
	https://github.com/notro/rpi-source/wiki

	I used these instructions:
	https://somewideopenspace.wordpress.com/2014/02/28/gcc-4-8-on-raspberry-pi-wheezy/
	Then I removed all the Jessy references once I knew the right gcc was installed.

	Now you can run ‘rpi-update’ and ‘rpi-source’.

- cd into the VGAtonic Framebuffer directory.
- Make your edits
- To build:

	sudo make clean
	sudo make
	sudo make install
- If it compiles, now go to the run section and run it!
