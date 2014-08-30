/*
  Firmware for the ATTiny 2313a on the VGAtonic board.
 */
 
// Pin 13 has an LED connected on most Arduino boards.
// give it a name:
int led = 4;

int spiSCK = 16;
int spiMOSI = 14;
int clockSelectLow = 13;



  // the setup routine runs once when you press reset:
  void setup() {                
  // initialize the digital pin as an output.
  pinMode(led, OUTPUT);
  

  pinMode(spiSCK, OUTPUT);
  pinMode(spiMOSI, OUTPUT);
  pinMode(clockSelectLow, OUTPUT);
  
  // Set the clock to 50.35MHz (Well, off by .0124%...)
  // Bitbang SPI for LTC603
  // DAC = 663, OCT = 15
  digitalWrite(clockSelectLow, LOW);    // turn the LED off by making the voltage LOW
  
  delay(2); 
  // First 4 are OCT
  digitalWrite(spiSCK, LOW);  
  
  digitalWrite(spiMOSI, HIGH);
  delay(2);   
  
  digitalWrite(spiSCK, HIGH); // Latch it in!
  delay(2); 
  
  digitalWrite(spiSCK, LOW);
  digitalWrite(spiMOSI, HIGH);
  delay(2);   
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);    
  digitalWrite(spiMOSI, HIGH);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);
  digitalWrite(spiMOSI, HIGH);  
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  //Next 10 are DAC
  // 663 = 1010010111
  digitalWrite(spiSCK, LOW);    
  digitalWrite(spiMOSI, HIGH); 
  delay(2);   
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);
  digitalWrite(spiMOSI, LOW);
  delay(2);   
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);    
  digitalWrite(spiMOSI, HIGH);  
  delay(2);  
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);
  digitalWrite(spiMOSI, LOW);  
  delay(2);  
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);
  digitalWrite(spiMOSI, LOW);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);    
  digitalWrite(spiMOSI, HIGH);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!

  delay(2); 

  digitalWrite(spiSCK, LOW);
  digitalWrite(spiMOSI, LOW);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);    
  digitalWrite(spiMOSI, HIGH);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);    
  digitalWrite(spiMOSI, HIGH);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  
  digitalWrite(spiSCK, LOW);    
  digitalWrite(spiMOSI, HIGH);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  delay(2); 
  // Next 2 turn off the secondary clock to leave only the primary
  
  digitalWrite(spiSCK, LOW);    
  digitalWrite(spiMOSI, HIGH);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!

  delay(2); 

  digitalWrite(spiSCK, LOW);
  digitalWrite(spiMOSI, LOW);   
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  
  
  digitalWrite(clockSelectLow, HIGH);    // turn the LED off by making the voltage LOW
  delay(2); 
  
  digitalWrite(spiSCK, LOW);
  delay(2); 
  digitalWrite(spiSCK, HIGH); // Latch it in!
  delay(2); 
  digitalWrite(spiSCK, LOW);
  
  }

// the loop routine runs over and over again forever:
void loop() {
  delay(1000);               // wait for a second
}

