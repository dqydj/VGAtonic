/* Definitions File for Tiny 2313a Firmware on VGATonic Board */

#ifndef TINYDEFS_H
#define TINYDEFS_H

// EEPROM Locations - Don't change it unless you also update the EEPROM!  Beware: only 128 bytes available.
#define OSCALSPEED   0
#define LTCSPEED     1
#define HELLOMSG     2  // Welcome string
#define FONTSTORAGE  21 // Where the MSBs of our font reside.  We write 95 bytes from here.

// Serial Constants - Wishlist: change speed.
//#define USART_BAUDRATE 38400
#define BAUD_PRESCALE(prescale) (((F_CPU / (prescale * 16UL))) - 1)

// Macros to flip IOs
#define CPLD_LOW     PORTB  &= ~(1 << PB0)
#define CPLD_HIGH    PORTB  |=  (1 << PB0)
#define CLK_LOW      PORTB  &= ~(1 << PB4)
#define CLK_HIGH     PORTB  |=  (1 << PB4)
#define CPLD_GIVE    PORTB  &= ~(1 << PB1)
#define CPLD_TAKE    PORTB  |=  (1 << PB1)
#define SCK_LOW      PORTB  &= ~(1 << PB7)
#define SCK_HIGH     PORTB  |=  (1 << PB7)
#define DI_LOW       PORTB  &= ~(1 << PB5)
#define DI_HIGH      PORTB  |=  (1 << PB5)

// SPI Definitions
#define SCK_LOW  PORTB  &= ~(1 << PB7)
#define SCK_HIGH  PORTB  |= (1 << PB7)
#define DI_LOW  PORTB  &= ~(1 << PB5)
#define DI_HIGH  PORTB  |= (1 << PB5)

//UART Definitions
#define BUFFER_SIZE 4
#define TERMINAL_LINE_MAX 40
#define NO_DATA 0x0100

#endif

