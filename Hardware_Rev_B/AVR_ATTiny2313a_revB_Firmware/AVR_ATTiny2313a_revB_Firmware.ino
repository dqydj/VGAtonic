/* Firmware for the ATTiny 2313a on the VGAtonic board. */
//#define EEPROM_UPDATE 1 // Uncomment when you want to write EEPROM, otherwise leave this alone.
#include <avr/pgmspace.h>
#include <avr/eeprom.h>
#include "tinydefs.h"
#include "font.h"


/******************************************************************
 * 
 * VGATonic Control Signals
 * 
 *  VGATONIC_MODE             - Current State of VGATonic:
 *    0: Terminal Emulator Mode
 *    1: Terminal Emulator Mode Escape Character Interpreter
 *    2: Background Color Change Mode
 *    3: Foreground Color Change Mode
 *    4: Framebuffer Passthrough Mode (See Manual for Protocol)
 *    5: Control Character Passthrough Mode (See Manual for Details)
 *    6: Goto Line Number (ASCII Code minus 32)
 *    7: Goto Cursor Position (ASCII Code minus 32)
 *  CURRENT_LINE              - Current Line number.  Divide by 8 to find text line.
 *  CURRENT CURSOR            - Cursor position - 40 MAX Per Row.
 *  CURRENT_BACKGROUND_COLOR  - Active background color for terminal
 *  CURRENT_FOREGROUND_COLOR  - Active foreground color for terminal
 *  CURRENT_BUFFER            - Current characters in the active line
 *  SHOW_CURSOR               - Boolean; True if we are rendering the cursor
 *  RX_BUFF                   - Ring buffer of received characters over serial
 *    rxn:      pointer to active buffer element
 *    rx_flag:  raised when we receive a new byte.
 *  LTCCAL                    - Calibration byte for the LTC6903
 *  
 */
uint8_t VGATONIC_MODE = 0;
uint8_t CURRENT_LINE = 0;
uint8_t CURRENT_CURSOR = 0;
uint8_t CURRENT_BACKGROUND_COLOR = 0B00001100;
uint8_t CURRENT_FOREGROUND_COLOR = 0B00000000;
char    CURRENT_BUFFER[TERMINAL_LINE_MAX + 1] = "";
boolean SHOW_CURSOR = false;

// Volatile - Interrupts will edit these!
volatile char RX_BUFF[BUFFER_SIZE] = "";
volatile uint8_t rxn = 0; // buffer 'element' counter.
volatile uint8_t rx_flag = 0;

/*
 * These belong to the framebuffer
 */
uint8_t current_pixel_count = 0;
uint8_t LTCCAL; 


void setup() 
{
#ifdef EEPROM_UPDATE

  /* 
   *  Function should only run once, control it with the #define of EEPROM_UPDATE.
   *  It is defined in the utilities.ino file.
   * 
   */
  updateEEPROM();
  
#endif EEPROM_UPDATE

  //OSCCAL = eeprom_read_byte ((uint8_t*)OSCALSPEED);
  LTCCAL = eeprom_read_byte ((uint8_t*)LTCSPEED);
  
  
  // Set up LEDs
  DDRD  |= _BV(PD4);   // as output (LED 1)
  LED1_OFF;
  DDRD  |= _BV(PD5);   // as output (LED 2)
  LED2_OFF;
  

  bitbang_bytes_out();
  // Welcome message stored in EEPROM
  CPLD_TAKE;
  sendControlSignalToVGATonic(0B00000010); // 160x120, 256 colors
  CPLD_LOW;
  printLinesToScreen(0,120);
  uint8_t myCounter = 0;

  // Give control to external SPI (to write from computers, microcontrollers, etc.
  CPLD_HIGH;
  CPLD_GIVE;
  
  // Almost ready, turn on UART
  setup_uart();
}

/*
 * 
 * The microcontroller is a large state machine.  It starts in mode 0, but depending on key choices, here are all the modes:
 * 
 *  0   - vt52 Terminal Mode
 *  1   - vt52 Escape Character Interpretation (see terminal.ino file)
 *  2   - vt52 Change Background Color (Use the whole bit - the original only allowed 16 colors, we allow 256)
 *  3   - vt52 Change Foreground Color (Ditto)
 *  4   - VGATonic Framebuffer mode - allows passthrough UART -> SPI for VGATonic.
 *  5   - VGATonic control character - allow changing cursor position or resolution or color depth (all hardware functions)
 *  6&7 - vt52 'Y' Escape code - (6) allows us to set a y location, line 0 - 14.  (7) is for x location, 0 - 39.
 */
void loop()
{
#ifndef EEPROM_UPDATE

  if (rx_flag == 1) { // New UART Data
    rx_flag = 0;
    for (int i = 0; i < rxn; i++) { // For each new character received
      char currentChar = RX_BUFF[i];
      if        (VGATONIC_MODE == 7) { // 'Y' Set Position Cursor
        currentChar-= 32;
        if ( currentChar < 39) {
          CURRENT_CURSOR = currentChar;
          insCharRange(' ', 0, 38);
          uart_transmit(0x06);
        }
        VGATONIC_MODE = 0;
      } else if (VGATONIC_MODE == 6) { // 'Y' Set Position Line
        //CURRENT_LINE = (uint8_t)112;
        currentChar -= 32;
        if ( currentChar < 14) {
          CURRENT_LINE = (currentChar)*8;
          uart_transmit(0x06);
        }
        VGATONIC_MODE = 7;
      } else if (VGATONIC_MODE == 5) { // Send Control Character to VGATonic
        sendControlSignalToVGATonic(currentChar); VGATONIC_MODE = 0;
      } else if (VGATONIC_MODE == 4) { // UART Driven Framebuffer Mode
        handleFramebufferMode(currentChar);
      } else if (VGATONIC_MODE == 3) { // FG Color Change
        CURRENT_FOREGROUND_COLOR = currentChar; VGATONIC_MODE = 0;
      } else if (VGATONIC_MODE == 2) { // BG Color Change
        CURRENT_BACKGROUND_COLOR = currentChar; VGATONIC_MODE = 0;
      } else if (VGATONIC_MODE == 1 || VGATONIC_MODE == 8) { // Escape sequence
        interpretVT52EscapeSequence(currentChar);
      } else {
        handleTerminalMode(currentChar);
      }
      
      
      RX_BUFF[0] = 0x00;
      rxn = 0;
    }
  }

  
#endif EEPROM_UPDATE
}


/*
 * 'Framebuffer' mode - not fast over serial, but useful to show static images or slow animations on the lower resolutions.
 * 
 * 
 * All credit to Ward Christensen's 1977 XMODEM Protocol.  We send 150 bytes at a time though, not 128.
 * Also, we skip the CRC check since a bad pixel won't hurt us (or, at least, not much...)
 * 
 */
void handleFramebufferMode(const char currentChar) 
{
    spi_transfer(currentChar);
    ++current_pixel_count;
  // 150 is the highest number under 256 which divides evenly into all resolutions.
  if (150 == current_pixel_count) {
    VGATONIC_MODE = 0;
    uart_transmit(0x17);
  }
}


/*
 * Font retrieval function - 5 active lines plus a descender bit.
 * I wrote about the font here: https://hackaday.io/project/6309-vga-graphics-card-vgatonic/log/20759-a-tiny-4x6-pixel-font-that-will-fit-on-almost-any-microcontroller-license-mit
 */
unsigned char getFontLine(unsigned char data, int line_num) 
{
  //const uint8_t index = (data-32);
  data -= 33;
  if (data > 96) {
    return 0;
  }
  else {
    unsigned char pixel = 0;

    /*
     * The 'upper half' of characters is in the EEPROM, the 'lower half' in PROGMEM. 
     */
    uint8_t byte1 = eeprom_read_byte ( (uint8_t*)(FONTSTORAGE + data) );
    uint8_t byte2 = pgm_read_byte(&font4x6[data]);

    // Descender bit - if set, drop by one line
    if (byte2 & 1 == 1) line_num -= 1;

    // Font retrieval lines
    if (line_num == 0) {
      pixel = byte1 >> 4;
    } else if (line_num == 1) {
      pixel = byte1 >> 1;
    } else if (line_num == 2) {
      // This one is split over 2 bytes.  I put it at the 'end' of both.
      return ( (byte1 & 0x03) << 2) | (byte2 & 0x02) ;
    } else if (line_num == 3) {
      pixel = byte2 >> 4;
    } else if (line_num == 4) {
      pixel = byte2 >> 1;
    }
    return pixel & 0xE;
  }
}
