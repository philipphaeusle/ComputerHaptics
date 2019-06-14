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
float force=0;

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

void calcUnderground(int type) {
  switch(type) {
  case 0:
    break;
  case 1:
    force+=random(-1, 1);
    break;
  default:
    break;
  }
}

void calcMagnetForces() {
  //TODO: smooter 
  for(int[] magnet : magnets){
    float distance=sqrt(pow (xpos-magnet[0], 2) + pow (ypos-magnet[1], 2));
    if(distance>height){
      continue;
    }
    if (magnet[3]==0 && magnet[2]<.0 || magnet[3]==1 && magnet[2]>0.0){
      //push right
      float temp=100/distance;
      if(temp>0){
        temp*=-1;
      }
      force+=temp;

    }else{
      //push left
       float temp=100/distance;
      if(temp<0){
        temp*=-1;
      }
      force+=temp;
    }
  }
}


void renderAllForces(int type){
  //calculate magnet force
  calcMagnetForces();
  //calculate underground force
  calcUnderground(type);
  //render force and set then to 0
  renderForce(force);
  force=0;
}
