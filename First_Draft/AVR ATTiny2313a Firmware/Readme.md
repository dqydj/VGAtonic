INSTALLING

The very first time you run, you should uncomment the line which says:

//#define EEPROM_UPDATE 1 // Uncomment when you want to write EEPROM, otherwise leave this alone.

The function updateEEPROM() in utilities.ino controls what happens during the EEPROM write.  You should change the:

eeprom_update_byte (( uint8_t *) OSCALSPEED, 'K' );

line to something.  I am making one board at a time, so I just send ‘u’ over serial at 9600 baud until I have a value
which is 1/9600 seconds long (scaling will require a crystal or a better calibration step).  See Jason Pepas’s example 
here: https://github.com/pepaslabs/CalibrateATtiny85OSCCAL 

The *second* run, comment that line out - you’re ready to run.  Connect at 38400 baud and do this:

Escape - m (Master mode)

Now send it a bunch of characters - congratulations, you are talking to a serial terminal… in only 128 Bytes of RAM!!!

It is based on vt52 escape codes, but… 128 bytes of RAM, so we can’t do multi-line functions, wraps, and inserts.  You’ve got
15 lines and 40 columns to play with:

vt52 ESCAPE CHARACTERS

    Escape character interpretation.  Missing a few due to lack of multi-line memory.  First type an escape character - you should see a ‘>’ response in the terminal.  Then:

    A - Move the cursor to beginning of line above.
    B - Move the cursor to beginning of line below.
    C - Move the cursor right by one.
    D - Move the cursor left by one.
    E - Clear the screen and place the cursor in the upper left corner.
    H - Move the cursor to the upper left corner.
    I - Move the cursor to beginning of line above.
    J - Erase all lines after our current line
    K - Clear the current line from the current cursor position.
    M - Delete the current line.
    Y - 'Goto' Coordinate mode - first will change line number, then cursor position (both ASCII - 32)
    b - Byte after 'b' sets new foreground color.
    c - Byte after 'c' sets new background color.
    d - Erase all lines above current line.
    e - Enable the cursor.
    f - Disable the cursor.
    l - Erase current line line and place the cursor at the beginning of the row.
    o - Erase the current line from the beginning to the current cursor.
    p - Invert background and foreground color.
    q - Invert background and foreground color.

    Special VGATonic Only Escape Codes

    W - 'W'rite framebuffer mode (pass through pixels from UART)
    Z - Send control character to VGATonic.  (Position or Resolution change)
    m - Become 'm'aster of CPLD (Disable external SPI writes and put Microcontroller in control)
    r - 'r'elease CPLD (Allow external SPI writes)
    s - 's'elect CPLD (Warn CPLD a new frame write is coming)
    u - 'u'nselect CPLD (Inform CPLD current frame write is done)

I’ll publish an example of how to use the VGATonic only escape codes later.
