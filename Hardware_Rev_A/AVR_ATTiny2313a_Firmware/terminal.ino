/*************************************************************************************

  Escape character interpretation.  (Missing a few due to lack of multi-line memory.)

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

  % - Administrator Mode
  W - 'W'rite framebuffer mode (pass through pixels from UART)
  Z - Send control character to VGATonic.  (Position or Resolution or Bit Depth change)
  m - Become 'm'aster of CPLD (Disable external SPI writes and put Microcontroller in control)
  r - 'r'elease CPLD (Allow external SPI writes)
  s - 's'elect CPLD (Warn CPLD a new frame write is coming)
  u - 'u'nselect CPLD (Inform CPLD current frame write is done)
  
  Special VGATonic Only Administrator Escape Codes ( Esc-%-(code) )
  
  < - 9600  Baud Serial Terminal (Default)
  > - 38400 Baud Serial Terminal
  + - Add one to LTC6903 PLL Scaler
  - - Subtract one from LTC6903 PLL Scaler
  & - VGATonic default PLL Scaler, 0B01011110
  | - Burn current PLL Scaler to EEPROM
  

  When done with VGATonic escape modes, to get back to the serial terminal, here's what I do:
  Escape - m     (master)
  Escape - s     (select CPLD)
  Escape - Z - r ( 160x120 @ 8bpp screen)
  Escape - E     (Clear the screen)

  When calibrating a new VGATonic:
  Escape % - to decrease the pixel clock
  Escape % + to increase the pixel clock
  Escape % | to burn scaler to EEPROM (will retain between powerups)

  If your monitor won't sync to the VGATonic clock:
  Escape % & to reset the LTC Calibration bit to factory
  Escape % | to burn the factory bit to EEPROM


**************************************************************************************/

void interpretVT52EscapeSequence (const char currentChar)
{
  // Mode 8 - Administrator mode.  You hit a '|'
  if (VGATONIC_MODE == 8) {
    if (currentChar == '<')
    {
      uart_speed_9600();
    }
    else if (currentChar == '>')
    {
      uart_speed_38400();
    }
    else if (currentChar == '+')
    {
      LTCCAL += 4;
      bitbang_bytes_out();
    }
    else if (currentChar == '-')
    {
      LTCCAL -= 4;
      bitbang_bytes_out();
    }
    else if (currentChar == '&')
    {
      LTCCAL = 0B01011110;
      bitbang_bytes_out();
    }
    else if (currentChar == '|')
    {
      eeprom_update_byte ( ( uint8_t *) LTCSPEED, LTCCAL );
    }
  }


  VGATONIC_MODE = 0;
  if  ( (currentChar == 'A' || currentChar == 'I') && CURRENT_LINE != 0) {
    printLineToScreen(CURRENT_BUFFER, false);
    CURRENT_LINE -= 8;
    CURRENT_BUFFER[0] = '\0';
    CURRENT_CURSOR = 0;
  }
  else if  (currentChar == 'B' && CURRENT_LINE != 112) {
    printLineToScreen(CURRENT_BUFFER, false);
    CURRENT_LINE += 8;
    CURRENT_BUFFER[0] = '\0';
    CURRENT_CURSOR = 0;
  }
  else if  (currentChar == 'C' && CURRENT_CURSOR != 39)
  {
    if (CURRENT_BUFFER[CURRENT_CURSOR] == '\0') {
      insChar(' ', CURRENT_CURSOR);
    }
    ++CURRENT_CURSOR;
  }
  else if  (currentChar == 'D' && CURRENT_CURSOR != 0)
  {
    --CURRENT_CURSOR;
  }
  else if (currentChar == 'E' || currentChar == 'H')
  {
    if (currentChar == 'E') printLinesToScreen(0, 120);
    CURRENT_LINE = 0;
    CURRENT_BUFFER[0] = '\0';
    CURRENT_CURSOR = 0;
  }
  else if  (currentChar == 'J' && CURRENT_LINE != 112)
  {
    printLinesToScreen(CURRENT_LINE + 8, 120);
  }
  else if  (currentChar == 'K' && CURRENT_CURSOR != 39)
  {
    insChar('\0', CURRENT_CURSOR);
  }
  else if  (currentChar == 'M' || currentChar == 'l')
  {
    CURRENT_BUFFER[0] = '\0';
    CURRENT_CURSOR = 0;
  }
  else if  (currentChar == 'Y')
  {
    VGATONIC_MODE = 6;
  }
  else if  (currentChar == 'b')
  {
    VGATONIC_MODE = 3;
  }
  else if  (currentChar == 'c')
  {
    VGATONIC_MODE = 2;
  }
  else if  (currentChar == 'd' && CURRENT_LINE != 0)
  {
    printLinesToScreen(0, CURRENT_LINE);
  }
  else if (currentChar == 'e')
  {
    SHOW_CURSOR = true;
  }
  else if (currentChar == 'f')
  {
    SHOW_CURSOR = false;
  }
  else if (currentChar == 'o')
  {
    insCharRange(' ', 0, CURRENT_CURSOR);
  }
  else if (currentChar == 'p' || currentChar == 'q')
  {
    // Compiles to less than an XOR swap, strangely.  Atmel, care to comment?
    uint8_t temp = CURRENT_FOREGROUND_COLOR;
    CURRENT_FOREGROUND_COLOR = CURRENT_BACKGROUND_COLOR;
    CURRENT_BACKGROUND_COLOR = temp;
  }
  /*****************************************************************
   *  VGATonic Special Escape Characters.  Don't try on your working
   *  vt52 that you use need for daily work.
   *****************************************************************/
  else if (currentChar == 'W')
  {
    current_pixel_count = 0;
    VGATONIC_MODE       = 4;
    uart_transmit(0x06);
    return;
  }
  else if (currentChar == 'Z')
  {
    VGATONIC_MODE       = 5;
    uart_transmit(0x06);
    return;
  }
  else if (currentChar == 'm') {
    CPLD_TAKE; uart_transmit(0x06); return;
  }
  else if (currentChar == '%') {
    VGATONIC_MODE = 8; uart_transmit('|'); return;
  }
  else if (currentChar == 'r') {
    CPLD_GIVE; uart_transmit(0x06); return;
  }

  else if (currentChar == 's') {
    CPLD_LOW; uart_transmit(0x06); return;
  }

  else if (currentChar == 'u') {
    CPLD_HIGH; uart_transmit(0x06); return;
  }


  printLineToScreen(CURRENT_BUFFER);

}

/*
 * Emulate a vt52 Terminal as best we can.
 *
 * Handle normal terminal characters:
 *  - If it is in our alphabet, print it to the current cursor location.  Send it back over UART.
 *  - If it is an enter key or we hit the max per line, write the line and move to the next (not enough RAM to cache multiple lines)
 *  - If it is an escape character, listen for vt52 escape codes (see above function)
 *  - Anything else?  Bells, etc?  Ignore it...
 *
 */

void handleTerminalMode(const char currentChar)
{

  if (currentChar == 0x0D or strlen(CURRENT_BUFFER) == TERMINAL_LINE_MAX) { // Return/Enter
    //printLineToScreen(CURRENT_BUFFER, CURRENT_LINE, false);
    printLineToScreen(CURRENT_BUFFER, false);
    if (CURRENT_LINE == 112) CURRENT_LINE = 0;
    else CURRENT_LINE += 8;
    uint8_t i = 0;
    if (currentChar != 0x0D) {
      CURRENT_BUFFER[0] = currentChar;
      i = 1;
    }
    CURRENT_BUFFER[i] = '\0'; // Null first byte is as good as deleting the string.
    CURRENT_CURSOR = i;
    printLineToScreen(CURRENT_BUFFER);
  } else if (currentChar == 0x1B) { // Escape key
    // Escape from terminal
    VGATONIC_MODE = 1;
    uart_transmit('>');
    return;
  } else {
    // Any other key
    if (currentChar == 127) { // Delete key
      // If length isn't zero, remove a character from the buffer.
      if (CURRENT_BUFFER[0] != '\0') {
        CURRENT_BUFFER[strlen(CURRENT_BUFFER) - 1] = '\0';
        --CURRENT_CURSOR;
      }
    } else {

      insChar(currentChar, CURRENT_CURSOR);
      CURRENT_CURSOR++;
    }
    printLineToScreen(CURRENT_BUFFER);
    uart_transmit(currentChar);
    //uart_transmit('~');
  }

}
