In the spirit of “doing what comes easiest” (My day job isn’t embedded programming, folks…) and knowing that the first version only has to program our oscillator, I burned an Arduino compatible bootloader on the 2313a.  I used the package here:

https://code.google.com/p/arduino-tiny/

Please follow their instructions for burning the bootloader (you will need a way to program it using the ICSP header; I used one of these: .)  Then you can upload compiled code just like you do to the Arduinos in your parts bin.

As for the code: I’m going to play with the oscillator’s clock a bit later; it seems to be running almost a tenth of a megahertz fast on the two boards I’m testing - just enough to cause some slightly weird artifacts on the screen.

But this is a demo… so I’ll release this as is.  Here’s the math from the Linear Technologies LTC6903 data sheet: (We change OCT and DAC)

f = 2^OCT  * ( (2078)  /  (2 - (DAC/1024) )

Picking OCT = 15 and DAC = 663:

f = 2^15 * ( (2078) / (2-(663/1024)) ) = 50.344 MHz

I’m getting closer to 50.5 MHz on the test boards; I’ll try to debug this later (it still will show a picture on all my monitors).