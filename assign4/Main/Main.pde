import processing.sound.*;

Animation animation1, animation2;
PImage chasedCar;
float chasedCarAngle;
float chasedCarAngleDrag = 10.0;
float chasedCarX;
float chasedCarXDrag = 10.0;


Street street;
PFont f;     

float xpos;
float ypos;
float drag = 30.0;

int numPoints = 15;
int diff; 
int [][] points = new int[numPoints][3]; // xL, xR, y

int r = 90;
int r1;
int c1 = 0;
int speed = 3;
int streetWidth;
int rnoise = 30;
int carSize=200;
boolean gameOver=false;
int score=0;
int framesAlready=0;

boolean withSound = false;
SoundFile policeSound, crashSound;

void setup() {
  size(1640, 960);
  background(255, 204, 204);
  frameRate(60);
  f = createFont("Sans", 16, true); 

  // Load a soundfile from the /data folder of the sketch and play it back
  if (withSound) {
    policeSound = new SoundFile(this, "../ressources/police.mp3");
    crashSound = new SoundFile(this, "../ressources/crash.mp3");
  }

  animation1 = new Animation("../ressources/Topdown_vehicle_sprites_pack/ambulance_animation/", 3, carSize);
  animation2 = new Animation("../ressources/Topdown_vehicle_sprites_pack/Police_animation/", 3, carSize);
  chasedCar = loadImage("../ressources/Topdown_vehicle_sprites_pack/Audi.png");
  chasedCar.resize(0, carSize);
  
  
  setUpData();
  setupHapkitControl();
  
  chasedCarX = width/2;
  chasedCarAngle = 0;
}

int c = 0;

float getNewDraggedValue (float oldPos, float newPos, float drag) {
  float dx = newPos - oldPos;
  return oldPos + dx/drag;
}

float getPos() {
  if (myPort == null) {
    return mouseX;
  }
  float hapkitPos = getHapkitPos();
  float pos = width/2 + (hapkitPos * width/150);
  return pos;
}

void draw() { 
  float pos = getPos();
  renderForce(0);
  xpos = getNewDraggedValue(xpos, pos, drag);
  ypos = height/2;

  background(128, 128, 128);
  street.drawSurfaces();
  street.display();
  
  street.drawMagnets();
  
  int underground=street.detectUndergroundCollision();
  
  if(underground!=0){
    renderUnderground(underground);
  }
 
  street.moveDown();
  int i=(int) random(0,200);
  if(i<1){
    street.generateUnderground(1);
  }
  street.cleanUnderground();
  street.cleanMagnets();

  /*if (mousePressed) {
    animation1.display(xpos-animation1.getWidth()/2, ypos);
  } else {
    animation2.display(xpos-animation1.getWidth()/2, ypos);
  }*/
  
  animation2.display(xpos-animation1.getWidth()/2, ypos);
  
  if (c1++ % 600 ==0 ) {
    println("SPEEDUP!");
    street.speedUp(1);
  }
  float carX=xpos;
  float carY=ypos;
  street.setCarPositions(carX, carY, carSize, animation1);
  boolean crashed=street.detectCollision();

  score=c1-framesAlready-1; //todo: maybe redo;
  textFont(f, 16);                 
  fill(0); 
  textAlign(CENTER);
  text("Score: "+score, width/2, 60); 

  if (crashed) {
    stopHapkitInstance();
    gameOver=true;
    textFont(f, 96);                 
    fill(0); 
    textAlign(CENTER);
    text("Game Over!", width/2, height/2);
    framesAlready=c1;
    noLoop();
    setUpData();

    if (withSound) {
      policeSound.stop();
      crashSound.jump(1);
      crashSound.play();
    }
  }
 
}

void setUpData() {
  ypos = height * 0.25;
  xpos=width/2;

  r1 = width / 4;
  streetWidth = width / 2;

  diff = height / (numPoints-11);

  for (int i=0; i<numPoints; i++) {
    //points[i][0] = width/6 + (int)random(-r,r);
    //points[i][1] = width - width/6 + (int)random(-r,r);
    points[i][0] = width/2 - streetWidth/2;
    points[i][1] = width/2 + streetWidth/2;

    // add noise
    points[i][0] += (int)random(-rnoise, rnoise);
    points[i][1] += (int)random(-rnoise, rnoise);

    points[i][2] = (i-5) * diff;
  }

  street=new Street(diff, r1, streetWidth, points, numPoints);
  noLoop();
}

void keyPressed() {
  startHapkitInstance();
  if (withSound) {
    policeSound.loop();
  }
  println(key);
  if (key=='r') {
    gameOver=false;
  }
  if (!gameOver) {
    loop();
  }
}
