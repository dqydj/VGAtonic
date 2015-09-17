**This Firmware should ONLY be used with the Rev A version of the board, unless you populate the header on the back of rev B and build a DAC for the NTSC signals.  (That is left as an exercise for the rev B reader)**

*Also, this is a proof of concept - **you should use the VGA output**.  There are nonstandard frequencies everywhere, and it's luck of the draw how close the LTC6903 on your board will get to NTSC's colorburst frequency.  VGA is much more tolerant of small errors, while even being 15000 off NTSC's 3.57 MHz (that's just a .4% error!) burst will create a rainbow from a single color.*

To use this with a rev A Board:

 1. In the Microcontroller firmware, edit the LTC6903 programming lines until you have an acceptable color burst frequency.  Datasheet is here http://www.linear.com/product/LTC6903
 2. 	 bitbang_byte_out(0b11100001); bitbang_byte_out(0B10100110);
	 3. (In theory, DAC should be 100, but I needed to use 105.  I also got .07% error instead of .00%)
 3. Program the microcontroller
 4. Program the CPLD

The released firmwares should work if you set the speeds below 21.9 MHz SPI, and note that color depth is 4 bits while resolution is 320x240.  This might require recompilation.

As for the TTL Serial support?  It works, but only in framebuffer mode.  Send only 320x240@4bpp or you'll get weirdness on the screen.

After that?  Use it just like you would a regular VGA VGATonic - I've tested it on all three NTSC accepting screens here, and while the colors are all slightly different ('Never The Same Color' is a joke for a reason), they all attempt to produce a picture even with my non-standard colorburst frequency.
