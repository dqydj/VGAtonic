**NOTE: For most purposes, you should build REVISION B.  Please exit this directory and go to Rev B.  It is smaller, it doesn't require extra code to work around an error in the schematic, it supports more serial speeds, and it has better ground planes and shielding for SPI signals.  It also has LEDs!**

**The only reason you should build this version is for easy access to RCA and the GPIOs.  Revision B has all the same pins broken out on a .4mm pitch header, which is harder to access, but is superior in all other ways!8**

In this directory you'll find the design documentation for VGAtonic's first reference design, which we're naming v0.01 or "Rev A"

We've added three systems to the board to make it easier to develop the firmware.  An LTC6903 (http://www.linear.com/product/LTC6903 , up to 68 MHz) will handle the clocking duty for VGAtonic.  It is controlled by an ATTiny2313.  (I've routed a few additional lines between the CPLD and the ATTiny for user expansion.)

We've also added a Gadget Factory Papilio (http://papilio.cc/) compatible (other than the 2.5v pin) header at the bottom, with two slots.  16 CPLD GPIOs are routed there.  Another 3 are routed to the switch near the VGA connector.

All in all, about 3"x3", and $30 for 10 shipped from http://www.elecrow.com/ (DHL option when I purchased mine)

License: MIT (see root directory)
