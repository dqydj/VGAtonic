void changeMode(int width, int height, int depth) {
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
    
    
    digitalWrite(CS, LOW);    // SS is pin 10
    delay(.001);
    SPI.transfer (mByte);
    delay(.001);
    digitalWrite(CS, HIGH);
}

void writeColor(byte pixel, int width, int height, int depth) {

  //changeMode(width, height, depth);
  delay(.01);
  digitalWrite(CS, LOW);    // SS is pin 10
  for (int row = 0; row < height; row++) {
        for (int column = 0; column < ((width+1)/(8/depth))-1; column++) { //
        
        
          SPI.transfer (pixel);
        
        }
      }
      
   delay (.01);
       digitalWrite(CS, HIGH);    // SS is pin 10
}

void movePosition(byte positionByte) {    
    
    digitalWrite(CS, LOW);    // SS is pin 10
    delay(.01);
    SPI.transfer (positionByte);
    delay(.01);
    digitalWrite(CS, HIGH);
    
}

void writeScreen(int width, int height, int nTimes, int colorDepth) {
    changeMode(width, height, colorDepth);
    for(int i = 0; i < nTimes; ++i) {
    
  
      digitalWrite(CS, LOW);    // SS is pin 10
      delay(.01);
      

      
      for (int row = 0; row < height; row++) {
        for (int column = 0; column <= ((width)/(8/colorDepth))-1; column++) {
        
        
          SPI.transfer (counter+=7);
        
        }
        counter -=5;
      }
      
      
      delay(.01);
      digitalWrite(CS, HIGH);
      delay(1000);
    }
}

