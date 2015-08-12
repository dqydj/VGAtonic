VGAtonic
========

4 MBit Video Card supporting up to 640x480 resolution and 8 bit color depth over SPI.  Outputs to any standard VGA Monitor.

**What it is:**

VGAtonic is a video card for adding graphics output to computers, microcontrollers, and devices with SPI output.  It can generally support 5v, 3.3v and 2.5v SPI without level conversion, and can accept SPI of up to 60 MHz (or higher), giving 24.4 FPS as a worst case top speed for it's highest resolution and color depth.  It is also an entry to the [2015](https://hackaday.io/project/6309-vga-graphics-card-vgatonic) and [2014](https://hackaday.io/project/1943-vgatonic) Hackaday Prize competitions.

It additionally has hardware supported accelerations for various things, meaning that slower SPI links can still have useful display output:

 - 640x480 resolution  
 - 320x240 resolution
 - 160x120 resolution
 - 80x60 resolution
 - 8 bit color (256 colors)
 - 4 bit color (16 colors)
 - 2 bit color (4 colors)
 - 1 bit color (black & white)

Last, it also *accelerates screen positioning*, so the entire framebuffer need not be updated for a single refresh (allowing, for example, a menubar at the bottom of the screen to be updated at the full 60 Hz possible in the 640x480 resolution mode).

Importantly, all of these accelerations stack, so if you have a 4 MHz link, you can choose to target, say, 160x120x4 bits for 52 FPS worst case.

**How it's made:**

See the entire parts list in [this Hackaday Prize post](https://hackaday.io/project/1943-vgatonic/log/7136-breaking-down-the-bom-costs-per-board).  As part of the project, to keep it *interesting* I used modestly spec'd parts - a 144 Macrocell Xilinx XC95144XL CPLD instead of a large FPGA, and an 8 bit 128-Bytes of RAM Atmel ATTiny 2313a Microcontroller instead of one of the larger Atmel parts or something 32-bit (it's not even the largest part in its footprint).  Additionally, the pixel clock is provided by Linear Technology's LTC6903, allowing it to be changed on the fly (and, undoubtedly, tuned for specific monitors) by the microcontroller.  

You can [find the schematics here](https://github.com/dqydj/VGAtonic/tree/master/First_Draft).

As for the software:


 - KiCad for the layout and Schematic
 - VHDL on Xilinx's ISE Webpack for the CPLD
 - C/C++ for any Microcontroller and Computer glue
 - C for the kernel code for the VGATonic Linux framebuffer drivers
 - Python where necessary

**How it's licensed:**

MIT (Hardware, Firmware, Python Examples, Arduino Code)
GPL (Linux Framebuffer Drivers, Linux Userspace Code)