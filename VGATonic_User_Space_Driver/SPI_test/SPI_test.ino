#include <SPI.h>

int led = 13;
int CS = 9;
byte counter = B00000001;
byte positionByte = B11111111;

#include "SomeUtilities.h"
#include "SomeTests.h"

void setup (void)
{
  pinMode(CS,OUTPUT);
  //Reset pulses...
  digitalWrite(CS, HIGH);  // ensure SS stays high for now
  digitalWrite(CS, LOW);  // ensure SS stays high for now
  digitalWrite(CS, HIGH);  // ensure SS stays high for now
  digitalWrite(CS, LOW);  // ensure SS stays high for now
  digitalWrite(CS, HIGH);  // ensure SS stays high for now
  
  SPI.setDataMode(SPI_MODE3);
  // Put SCK, MOSI, SS pins into output mode
  // also put SCK, MOSI into LOW state, and SS into HIGH state.
  // Then put SPI hardware into Master mode and turn SPI on
  SPI.begin ();
  pinMode(led, OUTPUT);  

  // Slow down the master a bit
  SPI.setClockDivider(SPI_CLOCK_DIV8);
  Serial.begin(9600);
  
  changeMode(640, 480, 8);
}  // end of setup

void printBits(byte myByte){
  for(byte mask = 0x80; mask; mask >>= 1){
    if(mask  & myByte)
        Serial.print('1');
    else
        Serial.print('0');
  }
}

void loop (void)
{
  
    changeMode(640, 480, 8);
    movePosition(positionByte--);
    writeColor(counter++, 640, 36, 8);
    if (positionByte == B10000000) {
      positionByte = B11111111;
    }
    
//    testPositionAcceleration(640, 480, 8);
//    testPositionAcceleration(320, 240, 8);
//    testPositionAcceleration(160, 120, 8);
//    testPositionAcceleration( 80,  60, 8);
//    
//    testPositionAcceleration(640, 480, 4);
//    testPositionAcceleration(320, 240, 4);
//    testPositionAcceleration(160, 120, 4);
//    testPositionAcceleration( 80,  60, 4);
//    
//    testPositionAcceleration(640, 480, 2);
//    testPositionAcceleration(320, 240, 2);
//    testPositionAcceleration(160, 120, 2);
//    testPositionAcceleration( 80,  60, 2);
//    
//    testPositionAcceleration(640, 480, 1);
//    testPositionAcceleration(320, 240, 1);
//    testPositionAcceleration(160, 120, 1);
//    testPositionAcceleration( 80,  60, 1);
    //testSomeSolidColors();
  
    //testFullScreenWrites();
  
}  // end of loop


