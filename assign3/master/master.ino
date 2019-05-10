// Wire Master Writer
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Writes data to an I2C/TWI slave device
// Refer to the "Wire Slave Receiver" example for use with this

// Created 29 March 2006

// This example code is in the public domain.


#include <Wire.h>
int i=0;

void setup() {
  Serial.begin(9600);      
  Wire.begin();
}


void loop() {
  Wire.beginTransmission(8); // transmit to device #8
  i++;
  float x = sin(0.1*(double) i);
  byte* px = (byte*)&x;
  Serial.println("Sending");                               
  Wire.write(px,4);              // sends 4 bytes
  Wire.endTransmission();    // stop transmitting
  
  Wire.requestFrom(8,4);
   byte dataArray[4];
   for(int i=0; i<4; i++){
    dataArray[i]=Wire.read();
   }
   union float_tag {byte float_b[4]; float fval;} float_Union;    
   float_Union.float_b[0] = dataArray[0];
   float_Union.float_b[1] = dataArray[1];
   float_Union.float_b[2] = dataArray[2];
   float_Union.float_b[3] = dataArray[3];    
   float NUMBER = float_Union.fval  ;
   Serial.println(NUMBER);
  
  delay(100);
}

