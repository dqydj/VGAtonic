In this directory you'll find the design documentation for VGAtonic's first reference design, which we're naming v0.01.

We've added three systems to the board to make it easier to develop the firmware (for me).  An LTC6903 (http://www.linear.com/product/LTC6903 , up to 68 MHz) will handle the clocking duty for this draft of VGAtonic.  It will be controlled by an ATTiny2313.  I've routed a few additional lines between the CPLD and the ATTiny for whatever feature creep we can come up with.

I didn't put a ton of time into the power supply design - I've got a fairly typical setup with a PTC rated at around 3/4 an Amp, then a '117 and some support caps.  5V before the regulator only goes to the header, and all of our 4 chips are run on 3.3v. Since we're getting power from USB, I routed the data line out to headers in case we want to play with those.

The main communication will remain SPI, and is legal between 2.5 and 5v - but we'll break out RX/TX in the 2313 (partially chosen because of the UART) for whatever we feel like developing.

We've also added a Gadget Factory Papilio (http://papilio.cc/) compatible (other than the 2.5v pin) header at the bottom, with two slots.  16 CPLD GPIOs are routed there.  Another 3 are routed to the switch near the VGA connector.

All in all, about 3"x3", and $30 for 10 shipped from http://www.elecrow.com/ (DHL option, thanks folks!)
