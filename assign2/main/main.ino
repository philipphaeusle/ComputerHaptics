#include <math.h>

#define SIZE 5
/*
    DECLARATION
*/
const int delaytime = 10;

enum ForceType {SPRING, WALL, FRICTION_C, FRICTION_V, HARD_SURFACE, TEXTURE} ;

enum ForceType ftype = WALL;

//****CONSTANTNTS

//double springConstant = 0.001; //not osc
//double springConstant = 0.003; // osc
//double springConstant = 0.005; //osc
double springConstant = 0.030; //osc

double wallConstant = 1;

double frictionConstant = 1;

double wallDistance = 5;


//calibration
//specific device numbers for the sensor

bool with_calibration = true;


//double a=0.01165;
double a = 0.01197;
double b = with_calibration ? 0.000 : 3.9;

double distanceCurve=0.0;


// Pin
int pwmPin = 5; // PWM output pin for motor
int dirPin = 8; // direction output pin for motor
int sensorPosPin = A2; // input pin for MR sensor

// position tracking

int updatedPos = 0;     // keeps track of the latest updated value of the MR sensor reading
int rawPos = 0;         // current raw reading from MR sensor
int lastRawPos = 0;     // last raw reading from MR sensor
int lastLastRawPos = 0; // last last raw reading from MR sensor
int flipNumber = 0;     // keeps track of the number of flips over the 180deg mark
int tempOffset = 0;
int rawDiff = 0;
int lastRawDiff = 0;
int rawOffset = 0;
int lastRawOffset = 0;
const int flipThresh = 700;  // threshold to determine whether or not a flip over the 180 degree mark occurred
boolean flipped = false;

// Kinematics
double xh = 0;         // position of the handle [m]
double xh_prev = 0;
double vh = 0;         //velocity of the handle
double v[SIZE];
double lastVh = 0;     //last velocity of the handle
double lastLastVh = 0; //last last velocity of the handle
double rp = 0.004191;   //[m]
double rs = 0.073152;   //[m]
double rh = 0.065659;   //[m]
// Force output variables
double force = 0;           // force at the handle
double Tp = 0;              // torque of the motor pulley
double duty = 0;            // duty cylce (between 0 and 255)
unsigned int output = 0;    // output command to the motor

/*
      Setup function - this function run once when reset button is pressed.
*/

void setup() {
  // Set up serial communication
  Serial.begin(57600);

  // Set PWM frequency
  setPwmFrequency(pwmPin, 1);
  // Input pins
  pinMode(sensorPosPin, INPUT); // set MR sensor pin to be an input

  // Output pins
  pinMode(pwmPin, OUTPUT);  // PWM pin for motor
  pinMode(dirPin, OUTPUT);  // dir pin for motor

  // Initialize motor
  analogWrite(pwmPin, 0);     // set to not be spinning (0/255)
  digitalWrite(dirPin, LOW);  // set direction

  // Initialize position valiables
  lastLastRawPos = analogRead(sensorPosPin);
  lastRawPos = analogRead(sensorPosPin);
  if(with_calibration){
      readPosCount();
      calPosMeter();
     double angle=a*updatedPos+b;
     Serial.println(b);
     b = -1.0 *angle;
     Serial.println(b);
   }   
}

/*
    readPosCount() function
*/
void readPosCount() {
  // Get voltage output by MR sensor
  rawPos = analogRead(sensorPosPin);  //current raw position from MR sensor
  // Calculate differences between subsequent MR sensor readings
  rawDiff = rawPos - lastRawPos;          //difference btwn current raw position and last raw position
  lastRawDiff = rawPos - lastLastRawPos;  //difference btwn current raw position and last last raw position
  rawOffset = abs(rawDiff);
  lastRawOffset = abs(lastRawDiff);
  
  // Update position record-keeping vairables
  lastLastRawPos = lastRawPos;
  lastRawPos = rawPos;

  // Keep track of flips over 180 degrees
  if ((lastRawOffset > flipThresh) && (!flipped)) { // enter this anytime the last offset is greater than the flip threshold AND it has not just flipped
    if (lastRawDiff > 0) {       // check to see which direction the drive wheel was turning
      flipNumber--;              // cw rotation
    } else {                     // if(rawDiff < 0)
      flipNumber++;              // ccw rotation
    }
    if (rawOffset > flipThresh) { // check to see if the data was good and the most current offset is above the threshold
      updatedPos = rawPos + flipNumber * rawOffset; // update the pos value to account for flips over 180deg using the most current offset
      tempOffset = rawOffset;
    } else {                     // in this case there was a blip in the data and we want to use lastactualOffset instead
      updatedPos = rawPos + flipNumber * lastRawOffset; // update the pos value to account for any flips over 180deg using the LAST offset
      tempOffset = lastRawOffset;
    }
    flipped = true;            // set boolean so that the next time through the loop won't trigger a flip
  } else {                        // anytime no flip has occurred
    updatedPos = rawPos + flipNumber * tempOffset; // need to update pos based on what most recent offset is
    flipped = false;
  }
}

/*
    calPosMeter()
*/
void calPosMeter()
{
  //length of device
  double radius=75;

  //the anngle of the device
  double angle=a*updatedPos+b;
  
  //the distance the device moved on the circle
  distanceCurve=(angle/360)*2*PI*radius;

  xh_prev = xh;
  xh = distanceCurve;

  lastVh = vh;
  double distanceMoved = (xh_prev - xh);

  vh = distanceMoved / ((double) delaytime / 1000.0);
  

  /*double distance=radius*sin(angle*PI/180.0);*/


  //Serial.println(angle);
}
/*
    forceRendering()
*/
void forceRendering()
{
  // Add the function for force calculation here.
  switch(ftype){
    case SPRING:
      calculateSpringForce();
      break;
    case WALL:
      calculateWallForce();
      break;
    case FRICTION_C:
      calculateFrictionCForce();
      break;
    case FRICTION_V:
      calculateFrictionVForce();
      break;
    case HARD_SURFACE:
       break;
    case TEXTURE:
      break;
    default:
      Serial.println("NOT SUPORTED");
    
  }
}

boolean isZero(double x){
  if(x>0.1 || x< -0.1){
    return false; 
  }
  return true;
}

int sign(double x){
  if(isZero(x)){
    return 0;
  }
  if(x>0){
    return 1;
  }else{
    return -1;
  };
}

void calculateFrictionCForce(){
  if (isZero(vh)){
    force = 0;
  }else{
    force=-frictionConstant*sign(vh);
  }
  Serial.println(vh);
}


void calculateFrictionVForce(){
  //TODO

}

void calculateSpringForce(){
  if(abs(distanceCurve) < 2){
    force=0;
  }else{
     force = distanceCurve*springConstant;
  }
}

void calculateWallForce(){
  if(distanceCurve > wallDistance){
    force = -1*sign(distanceCurve)*wallConstant*(wallDistance - abs(distanceCurve));
  }else{
  	force = 0;
  }
}


/*
      Output to motor
*/
void motorControl()
{

  Tp = rp / rs * rh * force;  // Compute the require motor pulley torque (Tp) to generate that force
  // Determine correct direction for motor torque
  if (force < 0) {
    digitalWrite(dirPin, HIGH);
  } else {
    digitalWrite(dirPin, LOW);
  }

  // Compute the duty cycle required to generate Tp (torque at the motor pulley)
  duty = sqrt(abs(Tp) / 0.03);

  // Make sure the duty cycle is between 0 and 100%
  if (duty > 1) {
    duty = 1;
  } else if (duty < 0) {
    duty = 0;
  }
  output = (int)(duty * 255);  // convert duty cycle to output signal
  // Serial.println(output);
  analogWrite(pwmPin, output); // output the signal
}
/*
   setPwmFrequency
*/
void setPwmFrequency(int pin, int divisor) {
  byte mode;
  if (pin == 5 || pin == 6 || pin == 9 || pin == 10) {
    switch (divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 64: mode = 0x03; break;
      case 256: mode = 0x04; break;
      case 1024: mode = 0x05; break;
      default: return;
    }
    if (pin == 5 || pin == 6) {
      TCCR0B = TCCR0B & 0b11111000 | mode;
    } else {
      TCCR1B = TCCR1B & 0b11111000 | mode;
    }
  } else if (pin == 3 || pin == 11) {
    switch (divisor) {
      case 1: mode = 0x01; break;
      case 8: mode = 0x02; break;
      case 32: mode = 0x03; break;
      case 64: mode = 0x04; break;
      case 128: mode = 0x05; break;
      case 256: mode = 0x06; break;
      case 1024: mode = 0x7; break;
      default: return;
    }
    TCCR2B = TCCR2B & 0b11111000 | mode;
  }
}

void turnLeft(double velocity){
   digitalWrite(dirPin, LOW);
   analogWrite(pwmPin, velocity);
}

void turnRight(double velocity){
  digitalWrite(dirPin, HIGH);
  analogWrite(pwmPin, velocity);
}

void stopMotor(){
  digitalWrite(dirPin, HIGH);
  analogWrite(pwmPin, 0);
}


/*
    Loop function
*/
void loop() {
  // put your main code here, to run repeatedly
  // read the position in count
  readPosCount();
  // convert position to meters
  calPosMeter();
  // calculate rendering force
  forceRendering();
  // output to motor
  motorControl();
  // delay before next reading:
  delay(delaytime);
}
