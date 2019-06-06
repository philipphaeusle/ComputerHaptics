Animation animation1, animation2;

float xpos;
float ypos;
float drag = 30.0;

int numPoints = 5;
int diff; 
int [][] points = new int[numPoints][3]; // xL, xR, y

int r = 90;
int r1;
int c1 = 0;
int speed = 3;
int streetWidth;
int rnoise = 30;
//int[] newPoint() {
  //return { 0 };
//}

void setup() {
  size(640, 360);
  background(255, 204, 0);
  frameRate(60);
  animation1 = new Animation("/home/thiger/Downloads/Topdown_vehicle_sprites_pack/ambulance_animation/", 3);
  animation2 = new Animation("/home/thiger/Downloads/Topdown_vehicle_sprites_pack/Police_animation/", 3);
  ypos = height * 0.25;
  
  r1 = width / 4;
  streetWidth = width / 2;
  
  diff = height / (numPoints-2);
  
  for(int i=0; i<numPoints; i++) {
    //points[i][0] = width/6 + (int)random(-r,r);
    //points[i][1] = width - width/6 + (int)random(-r,r);
    points[i][0] = (width/2 - streetWidth/2) + (int)random(-r1,r1);
    points[i][1] = points[i][0] + streetWidth;
    
    // add noise
    points[i][0] += (int)random(-rnoise,rnoise);
    points[i][1] += (int)random(-rnoise,rnoise);
    
    points[i][2] = (i-1) * diff;
  }
      for (int i = 0; i < numPoints; i++) {                
        print(points[i][2]);
        print(", ");
    }
    println();
}

int c = 0;

void draw() { 
  float dx = mouseX - xpos;
  xpos = xpos + dx/drag;
  xpos = mouseX;
  ypos = mouseY;
  // Display the sprite at the position xpos, ypos
  if (mousePressed) {
    background(153, 153, 0);
    animation1.display(xpos-animation1.getWidth()/2, ypos);
  } else {
    background(255, 204, 0);
    animation2.display(xpos-animation1.getWidth()/2, ypos);
  }
  
  //line
  smooth();
  noFill();
  stroke(0);
  beginShape();
  for(int i=0; i<numPoints; i++) {
    if(i == 0 || i == numPoints - 1) {
      curveVertex(points[i][0], points[i][2]);
    }
    curveVertex(points[i][0], points[i][2]);
  }
  endShape();
  beginShape();
  for(int i=0; i<numPoints; i++) {
    if(i == 0 || i == numPoints - 1) {
      curveVertex(points[i][1], points[i][2]);
    }
    curveVertex(points[i][1], points[i][2]);
  }
  endShape();
  
  //move points down
  
  for(int i=0; i<numPoints; i++) {
    points[i][2] += speed;
  }
  if (points[numPoints-1][2] > height + diff) {
    for (int i = 0; i < numPoints; i++) {                
        print(points[i][2]);
        print(", ");
    }
    println();
    
    //shift array
    for (int i = numPoints-2; i >= 0; i--) {                
        points[i+1][0] = points[i][0];
        points[i+1][1] = points[i][1];
        points[i+1][2] = points[i][2];
    }
    points[0][0] = (width/2 - streetWidth/2) + (int)random(-r1,r1);
    points[0][1] = points[0][0] + streetWidth;
    points[0][2] = -diff;
    
    for (int i = 0; i < numPoints; i++) {                
        print(points[i][2]);
        print(", ");
    }
    println();

  }
  if (c1++ % 60 == 0) {
    //speed++;
  }
    //noLoop();
}



// Class for animating a sequence of GIFs

class Animation {
  PImage[] images;
  int imageCount;
  int frame;
  int c;
  
  Animation(String imagePrefix, int count) {
    imageCount = count;
    images = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + (i+1) + ".png";
      images[i] = loadImage(filename);
      images[i].resize(0, 100);
    }
  }

  void display(float xpos, float ypos) {
    c++;
    if (c % 5 == 0){
      frame = (frame+1) % imageCount;
    }
    image(images[frame], xpos, ypos);
  }
  
  int getWidth() {
    return images[0].width;
  }
}
