## VGATonic vt52 Compatible Escape Codes ##

Here is a list of vt52 compatible escape codes supported by VGATonic.  Due to the very small RAM (128 Bytes), there isn't enough room to implement any of the multi-line commands.  However, this covers the major commands for most applications.

Hit escape, then hit the following character to execute the commands:

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
----------------------------------

Hit escape, then hit the following character to execute the commands:

    % - Administrator Mode
    W - 'W'rite framebuffer mode (pass through pixels from UART, 255 at a time)
    Z - Send control character to VGATonic.  (Position or Resolution or Bit Depth change)
    m - Become 'm'aster of CPLD (Disable external SPI writes and put Microcontroller in control)
    r - 'r'elease CPLD (Allow external SPI writes)
    s - 's'elect CPLD (Warn CPLD a new frame write is coming)
    u - 'u'nselect CPLD (Inform CPLD current frame write is done)
  
  **Special VGATonic Only Administrator Escape Codes ( Esc-%-(code) )**
  
    < - 9600  Baud Serial Terminal (Default)
    > - 38400 Baud Serial Terminal
    + - Add one to LTC6903 PLL Scaler
    - - Subtract one from LTC6903 PLL Scaler
    & - VGATonic default PLL Scaler, 0B01011110
    | - Burn current PLL Scaler to EEPROM
  
  **When done with VGATonic escape modes, to get back to the serial terminal, here's what I do:**
  
    Escape - m     (master)
    Escape - s     (select CPLD)
    Escape - Z r ( 160x120 @ 8bpp screen)
    Escape - E     (Clear the screen)

**When calibrating a new VGATonic:**

    Escape - % - to decrease the pixel clock (That's a single minus)
    Escape - % + to increase the pixel clock
    Escape - % | to burn scaler to EEPROM (will retain between 
    powerups)
    
**If your monitor won't sync to the VGATonic clock:**

  Escape - % & to reset the LTC Calibration bit to factory
  Escape - % | to burn the factory bit to EEPROM


> Written with [StackEdit](https://stackedit.io/).