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
  Wire.begin(); // join i2c bus (address optional for master)
}


void loop() {
  Wire.beginTransmission(8); // transmit to device #8
  i++;
  float x = sin(0.1*(double) i);
  byte* px = (byte*)&x;
  Serial.println("Sending");                               
  Wire.write(px,4);              // sends 4 bytes
  Wire.endTransmission();    // stop transmitting

  delay(100);
}
