void testPositionAcceleration(int width, int height, int depth) {
  
  changeMode(width, height, depth);
  writeColor(B00000000, width, height, depth);
  delay(1000);
  
  
  changeMode(width, height, depth);
  movePosition(3);
  writeColor(B10001000, width, 1+(height/4), depth);
  delay(1000);
  
  
  changeMode(width, height, depth);
  movePosition(2);
  writeColor(B01000100, width, 1+(height/4), depth);
  delay(1000);
  
  
  changeMode(width, height, depth);
  movePosition(1);
  writeColor(B00010001, width, 1+(height/4), depth);
  delay(1000);
  
  
  changeMode(width, height, depth);
  writeColor(B10011001, width, 2+(height/4), depth);
  delay(1000);
}
  
void testFullScreenWrites() {
    // send test string
    writeScreen(640, 480, 3, 8);
    writeScreen(640, 480, 3, 4);
    writeScreen(640, 480, 3, 2);
    writeScreen(640, 480, 3, 1);
    writeScreen(320, 240, 3, 8);
    writeScreen(320, 240, 3, 4);
    writeScreen(320, 240, 3, 2);
    writeScreen(320, 240, 3, 1);
    writeScreen(160, 120, 3, 8);
    writeScreen(160, 120, 3, 4);
    writeScreen(160, 120, 3, 2);
    writeScreen(160, 120, 3, 1);
    writeScreen(80,  60, 3, 8);
    writeScreen(80,  60, 3, 4);
    writeScreen(80,  60, 3, 2);
    writeScreen(80,  60, 3, 1);
}   
    
void testSomeSolidColors() {
    writeColor(B10100101, 80, 60, 8);
    delay(3000);
    writeColor(B01010000, 80, 60, 8);
    delay(3000);
}
