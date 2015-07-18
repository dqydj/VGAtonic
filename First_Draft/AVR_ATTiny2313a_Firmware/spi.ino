/*****************************************

            SPI Transfers
  
******************************************/

/*
 * Bitbang for the LTC6903 - 2 at a time, it's 16 bits long
 */
void bitbang_byte_out(unsigned char byte)
{
  
    for (int i = 0; i < 8; i++)
    {
      if ((byte & 0B10000000) == 0B10000000) {
          SCK_LOW;
          DI_HIGH;
          SCK_HIGH;
          DI_LOW;
      }
      else {
        SCK_LOW;
        DI_LOW;
        SCK_HIGH;
      }
      byte = byte << 1;
    }
  
}

void bitbang_bytes_out()
{
    // Software SPI (Confused DI and D0 on this version for clock, so we have to bitbang the clock's SPI signal before using the USI)
  DDRB  |= _BV(PB1);   // as output (D10, CPLD Master)
  DDRB  |= _BV(PB0);   // as output (D9,  CPLD Select)
  DDRB  |= _BV(PB4);   // as output (D13, CLK  Select)
  DDRB  |= _BV(PB7);   // as output (USISCK)
  DDRB  |= _BV(PB5);   // as output  (DI, temp for clock)

  CLK_HIGH;
  CLK_LOW;
  // Define LTC speed by sending 2 bytes over SPI.
  // Works out to roughly 50.344 MHz, almost exactly 2x the 640x480 VGA clock 
  // (that was the goal; it's close enough for most monitors).
  //  unsigned char LTCBytes[2];
  //  LTCBytes[0] = 0b11111010;
  //  LTCBytes[1] = eeprom_read_byte ((uint8_t*)LTCSPEED);
  bitbang_byte_out(0b11111010);
  bitbang_byte_out(LTCCAL);

  CLK_HIGH;

  // Turn on regular SPI now, once the LTC is ready.
  DDRB  |= _BV(PB6);   // as output (DO)
  DDRB  &= ~_BV(PB5);  // as input  (DI)
  PORTB |= _BV(PB5);   // pullup on (DI)
}

/*
 * 
 * SPI Mode 0 using the USI hardware on the ATTiny
 * 
 */

uint8_t inline spi_transfer(uint8_t data) {
  USIDR = data;
  USISR = _BV(USIOIF); // clear flag

  while ( (USISR & _BV(USIOIF)) == 0 ) {
     USICR = (1<<USIWM0)|(1<<USICS1)|(1<<USICLK)|(1<<USITC);
  }
  return USIDR;
}

