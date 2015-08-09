#include <SPI.h>

#include "Guitars.h"
#include "Doge3.h"

void setup (void)
{

  digitalWrite(SS, HIGH);  // ensure SS stays high for now

  // Put SCK, MOSI, SS pins into output mode
  // also put SCK, MOSI into LOW state, and SS into HIGH state.
  // Then put SPI hardware into Master mode and turn SPI on
  SPI.begin ();

  // Slow down the master a bit
  SPI.setClockDivider(SPI_CLOCK_DIV8);
}  // end of setup



void loop (void)
{
    
    showPicture(doge3);
    delay(10000);
    showPicture(guitars);
    delay(10000);
    
  
}  // end of loop

void showPicture (const uint8_t * arrayRef) {
   // send test string
    delay(1);
    digitalWrite(SS, LOW);    // SS is pin 10
    for (int row = 0; row <= 480; row++) {
      byte myBytes[640];
      int rowMultiplier = 640*row;
      for (int column = 0; column <= 640; column++) {
      
        myBytes[column] = arrayRef[rowMultiplier+column];
      
      }
      SPI.transferBuffer(myBytes, NULL, 640);
      
    }
    digitalWrite(SS, HIGH);
    // disable Slave Select

}




