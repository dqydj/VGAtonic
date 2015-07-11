/*****************************************

            SPI Transfers
  
******************************************/

/*
 * Bitbang for the LTC6903
 */
void bitbang_byte_out(unsigned char byte)
{
  byte = reverseByte(byte);
  int i;
  for (i = 0; i < 8; i++)
  {
    if ((byte & 1) == 1) {
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
    byte = byte >> 1;
  }
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

