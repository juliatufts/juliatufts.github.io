/*
    Random walker defined region, have a collection of random walkers that are only
    allowed to walk in a certain region.
    
    This one is a river of walkers in a forest with randomly generated grass
    
    Note: change of color mode, HSB using hue:0-360, sat:0-100, brightness:0-100 
*/
  
int frameCount = 0;
int maxFrames = 8000;
int boxSize = 10;
int screenWidth = 400;
int screenHeight = 400;
int hue = 0;
int[] rectRegion = {0, 100, 400, 200};  //the defined region the walker is able to travel through

Walker[] walkerArray0 = new Walker[int(rectRegion[3]/boxSize - 1)];
Walker[] walkerArray1 = new Walker[int(rectRegion[3]/boxSize - 1)];

//the area where grass can be spawned, grass is 24x16
int[][] grassRegion = {{0, 0, 400, rectRegion[1]}, 
                       {0, rectRegion[1] + rectRegion[3], 400, 400 - (rectRegion[1] + rectRegion[3])}};
Grass[] grassArrayAbove = new Grass[30];
Grass[] grassArrayBelow = new Grass[30];

void setup(){
  size(screenWidth, screenHeight);
  colorMode(HSB, 360, 100, 100);
  
  //create two columns of random walkers in the defined rectRegion 
  for(int i=0; i < walkerArray0.length; i++){
    walkerArray0[i] = new Walker(rectRegion[0], rectRegion[1] + i*10);
    walkerArray1[i] = new Walker(rectRegion[0], rectRegion[1] + i*10);
  }
  
  ////////////////draw the background//////////////////
  //grass backdrop
  background(125, 100, 70);
  //grass above
  int randomX;
  int randomY;
  for(int i=0; i < grassArrayAbove.length; i++){
    randomX = int(random(grassRegion[0][0], grassRegion[0][2]));
    randomY = int(random(grassRegion[0][1], grassRegion[0][3]));
    int randomGrassColor = int(random(40, 60));
    grassArrayAbove[i] = new Grass(randomX, randomY, randomGrassColor);
    grassArrayAbove[i].display();
  }
  //initialize grass below
  for(int i=0; i < grassArrayBelow.length; i++){
    randomX = int(random(grassRegion[1][0], grassRegion[1][2]));
    randomY = int(random(grassRegion[1][1], grassRegion[1][1]+grassRegion[1][3]));
    int randomGrassColor = int(random(40, 60)); 
    grassArrayBelow[i] = new Grass(randomX, randomY, randomGrassColor);
  }
  //water backdrop
  stroke(190, 100, 100);
  fill(190, 100, 100);
  rect(rectRegion[0], rectRegion[1], rectRegion[2], rectRegion[3]);
}

void draw(){
  if(frameCount < maxFrames){
    //move all the walkers in walkerArray0
    for(Walker w : walkerArray0){
      w.step();
      
      int randomHue = int(random(255 - 190));
      hue = 190 + randomHue;
      w.display(hue);
    }
    
    //move all the walkers in walkerArray1
    for(Walker w : walkerArray1){
      w.step();
      
      int randomHue = int(random(255 - 190));
      hue = 190 + randomHue;
      w.display(hue);
    }
    
    //draw grass below
    for(Grass g : grassArrayBelow){
      g.display();
    }
    frameCount++;
  } else {
    noLoop();  
  }
}

//this random walker has increased probability to move to the right, and can never move left
class Walker{
  int x;   //x position
  int y;   //y position
  
  Walker(int tempX, int tempY){
    x = tempX;
    y = tempY;
  }
  
  void display(color c){
    stroke(c, 100, 100);
    fill(c, 100, 100);
    rect(x, y, boxSize, boxSize);  
  }
  
  void step(){
    int choice = int(random(4));

    if((choice == 0 || choice == 1) && x <= rectRegion[2] - rectRegion[0] - boxSize){
       x += boxSize;
    } else if(choice == 2 && y < rectRegion[1] + rectRegion[3] - boxSize){
       y+= boxSize;
    } else if(y > rectRegion[1]) {
       y -= boxSize;
    }
    
    //if the walker has walked off the screen to the right, reset at a random starting position
    if(x > rectRegion[2] - rectRegion[0] - boxSize){
      x = rectRegion[0];
      y = rectRegion[1] + int(random(rectRegion[3]/boxSize))*10;
    }
  }
}

class Grass{
   int x;  //x position
   int y;  //y position
   int c;  //the brightness of the green grass color, range:40-60
  
   Grass(int tempX, int tempY, int tempC){
      x = tempX;
      y = tempY;
      c = tempC;
   } 
   
   void display(){
      stroke(120, 100, c);
      fill(120, 100, c);
      beginShape();
      vertex(x, y);
      vertex(x+5, y-10);
      vertex(x+10, y-5);
      vertex(x+18, y-16);
      vertex(x+24, y);
      endShape(CLOSE); 
   }
}
