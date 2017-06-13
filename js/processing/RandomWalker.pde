Walker w;
int boxSize = 10;
int screenWidth = 400;
int screenHeight = 400;
int hue = 0;
int maxFrames = 5000;
int frameCount = 0;

void setup(){
  size(screenWidth, screenHeight);
  w = new Walker();
  background(255);
  colorMode(HSB);
}

void draw(){
  if(frameCount < maxFrames){
    w.step();
    w.display(hue);
    hue = (hue + 1) % 255;
    frameCount++;
  } else {
    noLoop(); 
  }
}

class Walker{
  int x;
  int y;
  
  Walker(){
    x = width/2;
    y = height/2;
  }
  
  void display(color c){
    stroke(c, 255, 255);
    fill(c, 255, 255);
    rect(x, y, boxSize, boxSize);  
  }
  
  void step(){
    int choice = int(random(4));

    if(choice == 0 && x < width - 1){
       x += boxSize;
    } else if(choice == 1 && x > 0){
       x -= boxSize;
    } else if(choice == 2 && y < height - 1){
       y+= boxSize;
    } else if(y > 0) {
       y -= boxSize;
    } 
  }
}
