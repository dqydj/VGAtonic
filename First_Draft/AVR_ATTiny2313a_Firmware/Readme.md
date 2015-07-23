## Burning Firmware ##

This is a two step process.

The very first time you run, you should uncomment the line in AVR_ATTiny2313a_Firmware.ino which says:

    //#define EEPROM_UPDATE 1 // Uncomment when you want to write EEPROM, otherwise leave this alone.

The function updateEEPROM() in utilities.ino controls what happens during the EEPROM write.  You should change the:

    eeprom_update_byte (( uint8_t *) OSCALSPEED, 'K' );

line (or at least the 'K') to something.  I am making one board at a time, so I just send ‘u’ over serial at 9600 baud until I have a value which is 1/9600 seconds long.  See Jason Pepas’s example 
here: https://github.com/pepaslabs/CalibrateATtiny85OSCCAL 

The *second* run, comment that line out - you’re ready to program again.  Connect at 9600 baud and do this:

    Escape - m (Master mode)
    Escape - s (Select CPLD)

Now send it a bunch of random characters - congratulations, you are talking to a serial terminal emulator… in only 128 Bytes of RAM!!!

It is based on vt52 escape codes, but… 128 bytes of RAM, so we can’t do multi-line functions, wraps, and inserts.  We handle most of the codes, however.  See terminalCodes.md for all of the codes.

> Written with [StackEdit](https://stackedit.io/).