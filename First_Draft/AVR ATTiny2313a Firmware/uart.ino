/*****************************************

            UART Transfers
  
******************************************/

/*
 * Receive a character from UART
 */
unsigned char inline uart_receive (void)
{
    while( (UCSRA) & (1<<RXC) == 0 );                  
    return UDR;                                   
}

/*
 * Send a character over UART
 */
void inline uart_transmit (unsigned char data)
{
    while ( ( UCSRA & (1<<UDRE)) == 0 );                // wait while register is free
    UDR = data;                                   // load data in the register
}

/*
 * Send a string over UART
 */
void uart_puts(const char *s )
{
    while (*s) 
      uart_transmit (*s++);

}


/*****************************************

            UART Setup
  
******************************************/

/* Turn on the Hardware UART Credit abcminiuser @ http://www.avrfreaks.net/forum/tut-soft-using-usart-interrupt-driven-serial-comms */
void setup_uart() 
{
  UBRRH = (uint8_t)(BAUD_PRESCALE >> 8); 
  UBRRL = (uint8_t)(BAUD_PRESCALE);
  UCSRB = (1 << RXEN) | (1 << TXEN) | (1 << RXCIE);
  UCSRC = (1 << USBS) | (3 << UCSZ0);
  sei();
}

/*****************************************

            Interrupt Handlers
  
******************************************/

/*
 * For speed reasons, only write into our ring buffer and get out.  Deal with it elsewhere.
 */
ISR(USART_RX_vect) 
{
  uint8_t tmp = UDR;
  if (rxn==BUFFER_SIZE)
    rxn=0;
  RX_BUFF[rxn++] = tmp;  
  rx_flag=1;
}
