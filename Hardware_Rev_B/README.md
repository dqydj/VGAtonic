**NOTE:  This is the current version that should be built.  It has the NTSC pins and almost the same number of GPIOs broken out as Rev A on the optional unpopulated header on the back.**

**For VGA, there is no contest - build Rev B.  You will get more serial speeds, better ground isolation, shielding on the SPI signals, and... LEDs!**

By default, you should try the REGULAR firmware, not the WIDESCREEN firmware.  640x480 at 60Hz is industry standard, so that's the fallback (and it allows 320x240, 160x120 and 80x60 resolutions too for your slower parts or when you want to drive VGATonic over serial).  Once your board is working, the WIDESCREEN firmware is *much* nicer, but it only offers 848x480 and 424x240 resolutions.  It is only tested on rev B, but it likely works on rev A - just be careful.  Note, too, that the TERMINAL EMULATOR only works with the REGULAR firmware, it isn't yet updated for WIDESCREEN.

In this directory you'll find the design documentation for VGAtonic's second design, which we're naming v1.25 or "Rev B".  It is 39% smaller than the first version and contains 54 components (counting the headers and a single component each).

Returning are the Xilinx XC95144 CPLD, the ISSI IS61LV5128AL Memory, and the Linear LTC6903.

We've switched the Atmel 2313a up with the Atmel ATTiny 4313 (it's pin compatible), and clocked it with a 7.3728 MHz crystal which gives us magic frequencies to support lots of new serial speeds.  An external clock also saves us the optional calibration step in programming, which could be a bit of a hassle - now we'll have just two steps for the microcontroller, burning EEPROM then programming the rest.

Oh, we also added LEDs!  That, of course, is the best new feature.

License: MIT (see root directory)