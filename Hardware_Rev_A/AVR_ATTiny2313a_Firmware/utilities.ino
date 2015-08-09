/*****************************************

          Utility Functions
  
******************************************/
#ifdef EEPROM_UPDATE
/*  
 *  Code here should only be executed when you are writing to EEPROM the >first< time.
 *  Here we calibrate OSCCAL, write the welcome string, and add fonts to EEPROM.
 *  The welcome string may be up to 18 real characters and an '\0'
 *  
 */
void updateEEPROM() 
{

  uint8_t hello[14] = "VGATonic v1.0";
  eeprom_update_byte (( uint8_t *) OSCALSPEED, 'K' );
  eeprom_update_byte (( uint8_t *) LTCSPEED, 0B01011110 );
  eeprom_update_block ( (const void*)&hello , (void *)HELLOMSG , 14);
  //int k = 0;
  for (int x = 0; x < 95; ++x) {
    //for (int y = 0; y < 2; y++) {
      eeprom_update_byte (( uint8_t *) FONTSTORAGE+x, pgm_read_byte(&font4x6[x][0]) );
      //++k;
    //}
  }

}
#endif


/*  
 *  Overloaded functions here to print lines to screen using various default values or 
 *  with variables passed in.  Should be reasonably self-explanatory
 */
void inline printColorLine() 
{
  for (uint8_t x = 0; x < 160; ++x) {
        spi_transfer(CURRENT_BACKGROUND_COLOR);
  }
}

void inline printLinesToScreen(uint8_t pos, uint8_t posLast) 
{
  if (pos == 0) { CPLD_HIGH; CPLD_LOW; printColorLine(); }
  while (pos < posLast) {
    printLineToScreen("", pos, false);
    pos += 8;
  }
}

void inline printLineToScreen(const char * c, boolean showCursor) 
{
  printLineToScreen(c, CURRENT_LINE, showCursor);
}

void inline printLineToScreen(const char * c) 
{
  printLineToScreen(c, CURRENT_LINE, SHOW_CURSOR);
}

/* 
 * Because our font is a fixed 4x6, this code is able to spit it out in an 8 pixel high line. 
 * Also includes code to render the cursor when it is turned on (ESC-e or ESC-f control it)
*/
void printLineToScreen(const char * c, uint8_t pos, boolean showCursor) 
{  

  // Move command
  //if (pos != 0)
  sendControlSignalToVGATonic(0B10000000 | pos);
  CPLD_LOW;
  
  uint8_t line_count = 0;
  uint8_t tempColor = CURRENT_BACKGROUND_COLOR;
  const char * start = c;
  while (line_count < 8) {
    uint8_t pixels_printed = 0;
    while (*c && line_count < 7) {
      uint8_t pixel = getFontLine(*c++, line_count-1);
      for (uint8_t j = 0; j < 4; ++j) {
        
        // AND the pixel with 0b00000011 and subtract that from 3 so we count from 3->0 and loop.  It's due to the pixel decoding in the CPLD
        (pixel >> ( 0x03 - (pixels_printed&0x03)) ) & 0x01 == 1 ? spi_transfer(CURRENT_FOREGROUND_COLOR) : spi_transfer(CURRENT_BACKGROUND_COLOR);
        pixels_printed++;
      }
    }
    while (pixels_printed < 160) {
      
      //tempColor = CURRENT_BACKGROUND_COLOR;
      
      /* This hack saves ~ 40 bytes from writing out the whole >= and <=.  Thanks, int division for letting this be true 4 times in a row. */
      if (showCursor == true && line_count == 7) {  
        if (CURRENT_CURSOR == (int)(pixels_printed/4)) tempColor = CURRENT_FOREGROUND_COLOR;
      } else {
        spi_transfer(CURRENT_BACKGROUND_COLOR);
      }
        
      
      ++pixels_printed;
      
      
    }
    ++line_count;
    c = start;
  }

}

/*
 * Insert characters in a range - probably stop at index 38 otherwise it'll think the line is full (length = 40).
 */
void inline insCharRange(const char insertChar, uint8_t posStart, uint8_t posEnd)
{
  for (; posStart <= posEnd; ++posStart) insChar(insertChar,posStart);
}

/*
 * Insert characters at a position
 */
void inline insChar(const char insertChar, uint8_t pos) 
{
  if ( strlen(CURRENT_BUFFER) <= pos ) strncat (CURRENT_BUFFER, &insertChar, 1); 
  else if ( strlen(CURRENT_BUFFER) > pos ) CURRENT_BUFFER[pos] = insertChar;
}
  

/* Not used, saved for reference */
void changeMode(int width, int height, int depth) 
{
    byte mByte     = B00000011; // 80x60
    byte depthByte = B00001100; // B&W
    
    if (width == 640) {
      mByte = B00000000;
    } else if (width == 320) {
      mByte = B00000001;
    } else if (width == 160) {
      mByte = B00000010;
    }
    
    if (depth == 8) {
      depthByte = B00000000;
    } else if (depth == 4) {
      depthByte = B00000100;
    } else if (depth == 2) {
      depthByte = B00001000;
    }
    
    mByte |= depthByte;
    uart_transmit(mByte);
    
    sendControlSignalToVGATonic(mByte);
}
/*
 * A single pixel write is how VGATonic knows how to switch hardware modes.
 */
void sendControlSignalToVGATonic(uint8_t mByte) 
{
    CPLD_HIGH;
    CPLD_LOW;
    //delay(.01);
    spi_transfer ( (mByte) );
    //delay(.01);
    CPLD_HIGH;
}

/*
 * Flip a byte.
 */
//uint8_t reverseByte( uint8_t x ) 
//{ 
//   x = ((x >> 1) & 0x55) | ((x << 1) & 0xaa); 
//   x = ((x >> 2) & 0x33) | ((x << 2) & 0xcc); 
//   x = ((x >> 4) & 0x0f) | ((x << 4) & 0xf0); 
//   return x;    
//}

/*****************************************

          Setup Functions
  
******************************************/

// Bitbang SPI for LTC603
// DAC = 663, OCT = 15.  Can't change it yet.
//void inline setup_ltc(uint8_t inputByte) 
//{
//
//  DDRB  |= _BV(PB1);   // as output (D10, CPLD Master)
//  DDRB  |= _BV(PB0);   // as output (D9,  CPLD Select)  
//  DDRB  |= _BV(PB4);   // as output (D13, CLK  Select)
//  DDRB  |= _BV(PB7);   // as output (USISCK)
//  DDRB  |= _BV(PB5);   // as output  (DI, temp for clock)
//  
//  CLK_HIGH; 
//  CLK_LOW;
//
//  bitbang_byte_out(0b11111010);
//  bitbang_byte_out(inputByte);
//  
//  CLK_HIGH;   
//
//  // Turn on regular SPI
//  DDRB  |= _BV(PB6);   // as output (DO)
//  DDRB  &= ~_BV(PB5);  // as input  (DI)
//  PORTB |= _BV(PB5);   // pullup on (DI)  
// 
//}
