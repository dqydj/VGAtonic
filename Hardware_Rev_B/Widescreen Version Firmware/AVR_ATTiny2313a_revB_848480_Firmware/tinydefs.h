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
#define F_CPU 7372800UL
#define BAUD_PRESCALE(baudrate)     (((F_CPU / (baudrate * 16UL))) - 1)
#define BAUD_PRESCALE_U2X(baudrate) (((F_CPU / (baudrate * 8UL))) - 1)

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
#define SCK_LOW      PORTB  &= ~(1 << PB7)
#define SCK_HIGH     PORTB  |= (1 << PB7)
#define DI_LOW       PORTB  &= ~(1 << PB5)
#define DI_HIGH      PORTB  |= (1 << PB5)

//UART Definitions
#define BUFFER_SIZE  128
#define TERMINAL_LINE_MAX 40
#define NO_DATA      0x0100
#define OFF_U2X      UCSRA &= ~(1 << U2X);
#define USE_U2X      UCSRA |= (1 << U2X);

// LED Definitions

#define LED1_ON      PORTD  &= ~(1 << PD4);
#define LED1_OFF     PORTD  |=  (1 << PD4)
#define LED2_ON      PORTD  &= ~(1 << PD5);
#define LED2_OFF     PORTD  |=  (1 << PD5)

#endif

