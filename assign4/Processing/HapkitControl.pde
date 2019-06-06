import processing.serial.*;
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
  myPort = new Serial(this, "/dev/ttyUSB0", 57600);
  myPort.bufferUntil('\n');
}

void renderForce(float force) {
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
  myPort.write("START\n");
}

void stopHapkitInstance() {
  myPort.write("STOP\n");
}
