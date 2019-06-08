class Street {
  int numPoints;
  int diff; 
  int [][] points = new int[numPoints][3]; // xL, xR, y

  int r = 90;
  int r1;
  int c1 = 0;
  int speed = 3;
  int streetWidth;
  int rnoise = 30;

  Street(int diff, int r1, int streetWidth, int[][] points, int numPoints) {
    this.diff=diff;
    this.r1=r1;
    this.streetWidth=streetWidth;
    this.points=points;
    this.numPoints=numPoints;
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

    // draws orange line with tangents
    for (int i=0; i<numPoints-4; i++) {
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
    for (int i=0; i<numPoints; i++) {
      fill(255, 0, 0);
      noStroke();
      ellipse(points[i][0], points[i][2], 8, 8);
      ellipse(points[i][1], points[i][2], 8, 8);
      noFill();
    }
    //move points down

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
    }
  }

  void speedUp(int speed) {
    this.speed+=speed;
  }

  boolean detectCollision(float carX, float carY, int carSize, Animation animation) {
    int carWidth=animation.getWidth()/3;
    int pixelToMove=carSize/10;

    /* fill(0,255,0);
     noStroke();
     ellipse(carX-carWidth/2,carY+pixelToMove,8,8);
     ellipse(carX+carWidth/2,carY+pixelToMove,8,8);
     
     ellipse(carX-carWidth/2,carY+carSize-pixelToMove,8,8);
     ellipse(carX+carWidth/2,carY+carSize-pixelToMove,8,8);
     
     ellipse(carX-carWidth/2,carY+carSize/2,8,8);
     ellipse(carX+carWidth/2,carY+carSize/2,8,8);
     
     noFill();
     */

    if (get((int) carX-carWidth/2, (int) carY+pixelToMove)==color(0)
      ||get((int) carX+carWidth/2, (int) carY+pixelToMove)==color(0)
      ||get((int) carX-carWidth/2, (int) carY+carSize-pixelToMove)==color(0)
      ||get((int) carX+carWidth/2, (int) carY+carSize-pixelToMove)==color(0)
      ||get((int) carX+carWidth/2, (int) carY+carSize/2)==color(0)
      ||get((int) carX+carWidth/2, (int) carY+carSize/2)==color(0)

      ) {
      return true;
    }
    return false;
  }
}
