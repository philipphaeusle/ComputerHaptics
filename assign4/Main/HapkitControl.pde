import processing.serial.*;

/*class Serial {
 public Serial(Object o, String s, int i) {
 }
 public String readStringUntil(char c){
 return "";
 }
 public void bufferUntil(char c){
 }
 public void write(String s){
 }
 }*/

Serial myPort;

float hPositionHandle = 0.0;

//boolean gameIsRunning = false;
boolean hIsConnected = false;

void serialEvent(Serial myPort) {
  String val = myPort.readStringUntil('\n');
  if (val != null) {
    hIsConnected = true;
    val = trim(val);
    //println("---------");
    //println(val);
    hPositionHandle = Float.parseFloat(val);
  }
}

void setupHapkitControl() {
  try {
    myPort = new Serial(this, "/dev/ttyUSB0", 57600);
    myPort.bufferUntil('\n');
  } 
  catch(Exception e) {
    // ignore
  }
}

void renderForce(float force) {
  if (myPort == null) {
    return;
  }
  if (!hIsConnected) {
    myPort.write("START\n");
    return;
  }
  myPort.write(Float.toString(force) + "\n");
}

float getHapkitPos() {
  return hPositionHandle;
}

void startHapkitInstance() {
  if (myPort == null) {
    return;
  }
  myPort.write("START\n");
}

void stopHapkitInstance() {
  if (myPort == null) {
    return;
  }
  myPort.write("STOP\n");
}
