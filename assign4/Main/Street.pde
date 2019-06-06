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
    fill(34,139,34);
    stroke(0);
    strokeWeight(20);
    beginShape();
    curveVertex(-500, -500);
    curveVertex(-500, -500);
    for(int i=0; i<numPoints; i++) {
      curveVertex(points[i][0], points[i][2]);
    }
    curveVertex(-500, height+500);
    curveVertex(-500, -500);
    curveVertex(-500, -500);

    endShape();
    beginShape();
    curveVertex(width+500, -500);
    curveVertex(width+500, -500);
    for(int i=0; i<numPoints; i++) {
      curveVertex(points[i][1], points[i][2]);
    }
    curveVertex(width+500, height+500);
    curveVertex(width+500, -500);
    curveVertex(width+500, -500);
    endShape();
   
    /*for(int i=1; i<numPoints; i++){
      line(points[i-1][0],points[i-1][2],points[i][0],points[i][2]);
      line(points[i-1][1],points[i-1][2],points[i][1],points[i][2]);
      
    }*/
    for(int i=0; i<numPoints; i++){
        fill(255,0,0);
        noStroke();
        ellipse(points[i][0],points[i][2],8,8);
        ellipse(points[i][1],points[i][2],8,8);
        noFill();
        
    }
    //move points down
    
    for(int i=0; i<numPoints; i++) {
      points[i][2] += speed;
    }
    if (points[numPoints-1][2] > height + 6 * diff) {
      
      //shift array
      for (int i = numPoints-2; i >= 0; i--) {     
          points[i+1][0] = points[i][0];
          points[i+1][1] = points[i][1];
          points[i+1][2] = points[i][2];
       
      }
      
      points[0][0] = (width/2 - streetWidth/2) + (int)random(-r1,r1);
      points[0][1] = points[0][0] + streetWidth;
      points[0][2] = -diff*5;
      

    }
  }
  
  void speedUp(int speed){
    this.speed+=speed;
  }
  
  boolean detectCollision(float carX,float carY, int carSize, Animation animation){
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
    
    if(get((int) carX-carWidth/2, (int) carY+pixelToMove)==color(0)
    ||get((int) carX+carWidth/2, (int) carY+pixelToMove)==color(0)
    ||get((int) carX-carWidth/2, (int) carY+carSize-pixelToMove)==color(0)
    ||get((int) carX+carWidth/2, (int) carY+carSize-pixelToMove)==color(0)
    ||get((int) carX+carWidth/2, (int) carY+carSize/2)==color(0)
    ||get((int) carX+carWidth/2, (int) carY+carSize/2)==color(0)
    
    ){
      return true;
    }
    return false;
  }
 

}
