Walker w;
int screenWidth = 200;
int screenHeight = 200;
int maxFrames = 5000;
int frameCount = 0;

void setup(){
  size(screenWidth, screenHeight);
  w = new Walker();
  background(255);
}

void draw(){
  if(frameCount < maxFrames){
    w.step();
    w.display();
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
  
  void display(){
    stroke(0);
    point(x, y);  
  }
  
  void step(){
    int choice = int(random(4));

    if(choice == 0 && x < width - 1){
       x += 1;
    } else if(choice == 1 && x > 0){
       x -= 1;
    } else if(choice == 2 && y < height - 1){
       y+= 1;
    } else if(y > 0) {
       y -= 1;
    } 
  }
}
