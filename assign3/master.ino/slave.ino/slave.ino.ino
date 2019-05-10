// Wire Slave Receiver
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Receives data as an I2C/TWI slave device
// Refer to the "Wire Master Writer" example for use with this

// Created 29 March 2006

// This example code is in the public domain.




#include <Wire.h>

void setup() {
  Wire.begin(8); 
  Serial.begin(9600);  
  Wire.onReceive(receiveEvent);
  Serial.println("SLAVE");
}

void loop() {
  delay(100);
}

// function that executes whenever data is received from master
// this function is registered as an event, see setup()
void receiveEvent(int howMany) {
  byte dataArray[4];
   for(int i=0; i<howMany; i++){
    dataArray[i]=Wire.read();
   }
 union float_tag {byte float_b[4]; float fval;} float_Union;    
 float_Union.float_b[0] = dataArray[0];
 float_Union.float_b[1] = dataArray[1];
 float_Union.float_b[2] = dataArray[2];
 float_Union.float_b[3] = dataArray[3];    
 float NUMBER = float_Union.fval  ;
 Serial.println(NUMBER);
}
