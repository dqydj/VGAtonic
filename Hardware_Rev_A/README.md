In this directory you'll find the design documentation for VGAtonic's first reference design, which we're naming v0.01 or "Rev A"

We've added three systems to the board to make it easier to develop the firmware.  An LTC6903 (http://www.linear.com/product/LTC6903 , up to 68 MHz) will handle the clocking duty for VGAtonic.  It is controlled by an ATTiny2313.  (I've routed a few additional lines between the CPLD and the ATTiny for user expansion.)

We've also added a Gadget Factory Papilio (http://papilio.cc/) compatible (other than the 2.5v pin) header at the bottom, with two slots.  16 CPLD GPIOs are routed there.  Another 3 are routed to the switch near the VGA connector.

All in all, about 3"x3", and $30 for 10 shipped from http://www.elecrow.com/ (DHL option when I purchased mine)

License: MIT (see root directory)
