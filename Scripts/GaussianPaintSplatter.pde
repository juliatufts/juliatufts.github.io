import java.util.Random;
Random generator;
int targetX;
int targetY;
int[] hueArray = {0, 17, 44, 100, 137, 170, 205};
int hueIndex = 0;
int meanSat = 200;
int dotSize = 5;
float sd_dist = 10;
float sd_sat = 50;
int splatCount;
//Splat[] splatArray = new Splat[10];

void setup(){
  size(400,400);
  background(255);
  colorMode(HSB);

  targetX = width/2;
  targetY = height/2;
  //generator = new Random();
  
  /*
  //initialize array
  for(int i = 0; i < splatArray.length; i++){       
      splatArray[i] = new Splat(targetX, targetY, meanSat);
  }
  */
}

void draw(){
  /*
  if(mousePressed){
    noStroke();
    for(Splat s: splatArray){
      s.move(mouseX, mouseY);
      s.display(hueArray[hueIndex]);  
    }
  }
  */

  fill(hueArray[hueIndex], meanSat, 255);
  stroke(0);
  rect(5, height - 15, 10, 10);
}

//Handles Keyboard input: SPACE - clears screen, 
//                        RIGHT/LEFT - toggle hue color
void keyPressed(){
  if(key == ' '){
    background(255);
  }
  if(keyCode == RIGHT){
    hueIndex = (hueIndex + 1) % hueArray.length;
  }
  if(keyCode == LEFT){
    hueIndex = (hueIndex + hueArray.length - 1) % hueArray.length;
  }
}
/*
class Splat{
  float x;
  float y;
  int sat;

  Splat(float tempX, float tempY, int tempSat){
    x = tempX;
    y = tempY;
    sat = tempSat;
  }  
  
  void move(int newTargetX, int newTargetY){
      //x,y position of dot
      float numX = (float) generator.nextGaussian();
      float numY = (float) generator.nextGaussian();
      
      x = numX * sd_dist + newTargetX;
      y = numY * sd_dist + newTargetY;
      
      //color palette
      float satTemp = (float) generator.nextGaussian();
      sat = (satTemp * sd_sat + meanSat > 255) || (satTemp * sd_sat + meanSat < 0) 
                 ? meanSat : (int) (satTemp * sd_sat + meanSat);
  }
  
  void display(int hue){
    fill(hue, sat, 255);
    ellipse(x, y, dotSize, dotSize);
  }
}
*/
