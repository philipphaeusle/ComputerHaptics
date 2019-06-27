int[][][] carPositions=new int[3][2][2]; // left, mid, x eg.
ArrayList<int []> magnets = new  ArrayList<int []>(); // x,y,force, lr, radius

class Street {
  int numPoints;
  int diff; 
  int [][] points = new int[numPoints][3]; // xL, xR, y

  ArrayList<int []> surfaces = new  ArrayList<int []>(); // y,h,type
  

  int r = 90;
  int r1;
  int c1 = 0;
  int speed = 3;
  int streetWidth;
  int rnoise = 30;

  int undergroundSize=450;
  PImage imgSurfaceStones = loadImage("../ressources/rocks_2.png");
  PImage imgSurfaceIce = loadImage("../ressources/ice.png");

  PImage magBlue = loadImage("../ressources/magnet_blue.png");
  PImage magRed = loadImage("../ressources/magnet_red.png");

  PImage magBlueR = loadImage("../ressources/magnet_blue_right.png");
  PImage magRedR = loadImage("../ressources/magnet_red_right.png");
  PImage explosion = loadImage("../ressources/explosion.png");

  /* PImage magBlue_mirror=
   PImage magRed_mirror=*/


  Street(int diff, int r1, int streetWidth, int[][] points, int numPoints) {
    this.diff=diff;
    this.r1=r1;
    this.streetWidth=streetWidth;
    this.points=points;
    this.numPoints=numPoints;

    imgSurfaceStones.resize((int) (width*1.2), undergroundSize);
    imgSurfaceIce.resize((int) (width*1.2), undergroundSize);
    
   explosion.resize(100, 100);
 
    magBlue.resize(100, 100);
    magRed.resize(100, 100);

    magBlueR.resize(100, 100);
    magRedR.resize(100, 100);
  }

  void display() {
    //line
    smooth();
    //noFill();
    fill(34, 139, 34);
    stroke(0);
    strokeWeight(20);
    beginShape();
    curveVertex(-500, -500);
    curveVertex(-500, -500);
    for (int i=0; i<numPoints; i++) {
      curveVertex(points[i][0], points[i][2]);
    }
    curveVertex(-500, height+500);
    curveVertex(-500, -500);
    curveVertex(-500, -500);

    endShape();
    beginShape();
    curveVertex(width+500, -500);
    curveVertex(width+500, -500);
    for (int i=0; i<numPoints; i++) {
      curveVertex(points[i][1], points[i][2]);
    }
    curveVertex(width+500, height+500);
    curveVertex(width+500, -500);
    curveVertex(width+500, -500);
    endShape();

    // draws orange line with tangents
    /* for (int i=0; i<numPoints-4; i++) {
     noFill();
     stroke(255, 102, 0);
     curve(points[i][0], points[i][2], 
     points[i+1][0], points[i+1][2], 
     points[i+2][0], points[i+2][2], 
     points[i+3][0], points[i+3][2]);
     
     int steps = 6;
     for (int j = 0; j <= steps; j++) {
     float t = j / float(steps);
     float x = curvePoint(points[i][0], points[i+1][0], points[i+2][0], points[i+3][0], t);
     float y = curvePoint(points[i][2], points[i+1][2], points[i+2][2], points[i+3][2], t);
     float tx = curveTangent(points[i][0], points[i+1][0], points[i+2][0], points[i+3][0], t);
     float ty = curveTangent(points[i][2], points[i+1][2], points[i+2][2], points[i+3][2], t);
     float a = atan2(ty, tx);
     a -= PI/2.0;
     line(x, y, cos(a)*20 + x, sin(a)*20 + y);
     }
     }
     */
    // draw chased car
    int chasedCarY = height/8;
    //println(chasedCarY);
    for (int i=1; i<numPoints-2; i++) {
      int pointY = points[i][2];
      int nextPointY = points[i+1][2];
      if (pointY <= chasedCarY && nextPointY >= chasedCarY) {
        // linepoint after car
        int steps = 10;
        for (int j = 0; j <= steps; j++) {
          float t = j / float(steps);
          float tNext = (j+1) / float(steps);
          float y = curvePoint(points[i-1][2], points[i][2], points[i+1][2], points[i+2][2], t);
          float yNext = curvePoint(points[i-1][2], points[i][2], points[i+1][2], points[i+2][2], tNext);

          if (y <= chasedCarY && yNext >= chasedCarY) {
            float xL = curvePoint(points[i-1][0], points[i][0], points[i+1][0], points[i+2][0], t);
            float xR = curvePoint(points[i-1][1], points[i][1], points[i+1][1], points[i+2][1], t);
            int xMid = (int)(xL + xR) / 2;

            float tx = curveTangent(points[i-1][0], points[i][0], points[i+1][0], points[i+2][0], t);
            float ty = curveTangent(points[i-1][2], points[i][2], points[i+1][2], points[i+2][2], t);
            float angle = atan2(ty, tx);
            angle -= PI/2.0;
            int xMidDraw = xMid;
            int yMidDraw = chasedCarY;

            chasedCarAngle = getNewDraggedValue(chasedCarAngle, angle, chasedCarAngleDrag);
            chasedCarX = getNewDraggedValue(chasedCarX, xMidDraw, chasedCarXDrag);

            translate(chasedCarX, yMidDraw);
            rotate(chasedCarAngle);
            image(chasedCar, -chasedCar.width/2, -chasedCar.height/2);
            rotate(-chasedCarAngle);
            translate(-chasedCarX, -yMidDraw);
            break;
          }
        }
        break;
      }
    }


    /*for(int i=1; i<numPoints; i++){
     line(points[i-1][0],points[i-1][2],points[i][0],points[i][2]);
     line(points[i-1][1],points[i-1][2],points[i][1],points[i][2]);
     
     }*/
    /* for (int i=0; i<numPoints; i++) {
     fill(255, 0, 0);
     noStroke();
     ellipse(points[i][0], points[i][2], 8, 8);
     ellipse(points[i][1], points[i][2], 8, 8);
     noFill();
     }*/
    //move points down
  }

  void speedUp(int speed) {
    this.speed+=speed;
  }

  boolean detectCollision() {

    fill(0, 255, 0);
    noStroke();
    for (int[][] temp : carPositions) {
      for (int[] xy : temp) {
        if (get(xy[0], xy[1])==color(0)) {
          image(explosion,xy[0]-explosion.width/2,xy[1]-explosion.height/2);
          return true;
        }
      //  ellipse(xy[0], xy[1], 8, 8);
      }
    }
    noFill();
    return false;
  }

  void generateUnderground(int type) {

    int[] temp= new int[3];
    int h = undergroundSize;
    temp[0]=0-h;
    temp[1]=h;
    temp[2]=type;
    for (int i=surfaces.size()-1; i>=0; i--) {
      if (surfaces.get(i)[0] <= temp[0]+temp[1]) {
        return;
      }
    }   
    surfaces.add(temp);
  }

  void generateMagnets(int x, int y, int leftOrRight) {
    if(leftOrRight==0){
      if(x-250<=0){
        return;
      }
    }else{
      if(x+250>=width){
        //println("skipping");
        return;
      }
     
    }
    int[] temp = new int[5];
    temp[2]=(int) random(-100, 100);
    if (leftOrRight==0) {
      temp[0]=x-150;
    } else {
      temp[0]=x+150;
    }
    temp[1]=y;
    temp[3]=leftOrRight;
    temp[4]=0;
    magnets.add(temp);
  }

  void setCarPositions(float posx, float posy, int carSize, Animation animation) {
    int carWidth=animation.getWidth()/3;
    int pixelToMove=carSize/10;
    float carX = posx-2;
    float carY = posy-carSize/2;

    carPositions[0][0][0]=(int) carX-carWidth/2;
    carPositions[0][0][1]=(int) carY+pixelToMove+10;

    carPositions[0][1][0]=(int) carX+carWidth/2;
    carPositions[0][1][1]=(int) carY+pixelToMove+10;

    carPositions[1][0][0]=(int) carX-carWidth/2;
    carPositions[1][0][1]=(int) carY+carSize-pixelToMove;

    carPositions[1][1][0]=(int) carX+carWidth/2;
    carPositions[1][1][1]=(int) carY+carSize-pixelToMove;

    carPositions[2][0][0]=(int) carX-carWidth/2;
    carPositions[2][0][1]=(int) carY+carSize/2;

    carPositions[2][1][0]=(int) carX+carWidth/2;
    carPositions[2][1][1]=(int) carY+carSize/2;


    pushMatrix();
    translate(xpos, ypos);
    rotate(mainCarAngle);
    for (int i=0; i<carPositions.length; i++) {
      for (int j=0; j<carPositions[i].length; j++) {    
        int newX = (int)(screenX((float)(carPositions[i][j][0]-posx), ((float)carPositions[i][j][1]-posy)));
        int newY = (int)(screenY((float)(carPositions[i][j][0]-posx), ((float)carPositions[i][j][1]-posy)));
        carPositions[i][j][0] = newX;
        carPositions[i][j][1] = newY;
      }
    }
    popMatrix();
  }

  int[][][] getCarPositions() {
    return carPositions;
  }

  void moveDown() {
    //points
    for (int i=0; i<numPoints; i++) {
      points[i][2] += speed;
    }
    if (points[numPoints-1][2] > height + 6 * diff) {

      //shift array
      for (int i = numPoints-2; i >= 0; i--) {     
        points[i+1][0] = points[i][0];
        points[i+1][1] = points[i][1];
        points[i+1][2] = points[i][2];
      }

      points[0][0] = (width/2 - streetWidth/2) + (int)random(-r1, r1);
      points[0][1] = points[0][0] + streetWidth;
      points[0][2] = -diff*5;

      //add magnets
      float temp=random(0, 10);
      int nearesty;
      if(magnets.size()==0){
        nearesty=height;
      }else{
        nearesty=magnets.get(magnets.size()-1)[1];
      }
      if (random(0, 100)<=70.0 && (nearesty-points[0][2]) > height*0.75) {
        if (temp<5.0) {
          generateMagnets(points[0][0], points[0][2], 0);
        } else {
          generateMagnets(points[0][1], points[0][2], 1);
        }
      }
    }
    //surfaces
    for (int i=surfaces.size()-1; i>=0; i--) {
      int[] temp=surfaces.get(i);
      temp[0]+=speed;
      surfaces.set(i, temp);
    }  

    //magnets
    for (int i=magnets.size()-1; i>=0; i--) {
      int[] temp=magnets.get(i);
      temp[1]+=speed;
      temp[4]++;
      magnets.set(i, temp);
    }
  }

  void cleanUnderground() {
    for (int i=surfaces.size()-1; i>=0; i--) {
      if (surfaces.get(i)[0] >= height) {
        surfaces.remove(i);
      }
    }
  }

  void cleanMagnets() {
    for (int i=magnets.size()-1; i>=0; i--) {
      if (magnets.get(i)[1] >= height+height/2) {
        magnets.remove(i);
      }
    }
  }

  void drawSurfaces() {
    for (int[] elem : surfaces) {
      if(elem[2]==1){
         image(imgSurfaceStones, -50, elem[0]);
      }else{
        //todo change to image 
        image(imgSurfaceIce, -50, elem[0]);
      }
    }
  }
  
  void drawWhiteLines(){
    fill(255, 255, 255);
    stroke(1, 1, 1); // dont make it black
    strokeWeight(1);


    // draw white road marks
    for (int i=1; i<numPoints-2; i++) {
      int mid = (points[i][0] + points[i][1]) / 2;

      float tx = curveTangent(points[i-1][0], points[i][0], points[i+1][0], points[i+2][0], 0);
      float ty = curveTangent(points[i-1][2], points[i][2], points[i+1][2], points[i+2][2], 0);
      float angle = atan2(ty, tx);
      int blockHeight = 50;
      int blockWidth = 16;

      angle -= PI/2.0;
      translate(mid, points[i][2]);
      rotate(angle);
      rect(-blockWidth/2, -blockHeight/2, blockWidth, blockHeight, 2);
      rotate(-angle);
      translate(-mid, -points[i][2]);
    }
  }

  void drawMagnets() {
    //TODO size defined by strongness
    for (int[] elem : magnets) {
      //fill(255,0,0);
      //float factor=elem[2];
      //int mwidth=50*(int)(factor*0.1);
      //int mheight=20*(int)(factor*0.1);
      //rect(elem[0], elem[1], 20, 50);

      //ellipse(elem[0], elem[1],elem[2], elem[2]);
      if (elem[2]>0) {
        if (elem[3]==1) {
          image(magRedR, elem[0]-(magRedR.width/2), elem[1]-(magRedR.height/2));
        } else {
          image(magRed, elem[0]-(magRed.width/2), elem[1]-(magRed.height/2));
        }
      } else {
        if (elem[3]==1) {
          image(magBlueR, elem[0]-(magBlueR.width/2), elem[1]-(magBlueR.height/2));
        } else {
          image(magBlue, elem[0]-(magBlue.width/2), elem[1]-(magBlue.height/2));
        }
      }

      //noFill();
    }
  }
  
 void drawMagnetForces() {
   int rMax = height;
   noFill();
   strokeWeight(10);
   stroke(0, 0, 0, 50);
   for (int[] elem : magnets) {
     int radius = (elem[4]*13) % rMax;
     if(elem[2] > 0){
       radius = rMax - radius;
     }
     circle(elem[0], elem[1], radius);
   }
 }

  int detectUndergroundCollision() {
    for (int[][] temp : carPositions) {
      for (int[] carxy : temp) {
        for (int[] s : surfaces) {
          //check if car is on surface
          if (carxy[1]>s[0] && carxy[1]<s[0]+s[1]) {
            return s[2];
          }
        }
      }
    }
    return 0;
  }
}
