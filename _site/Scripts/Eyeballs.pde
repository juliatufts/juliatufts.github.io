int WIDTH = 400;
int HEIGHT = 400;
int SPACING = 32;
Mover[] moverArray = new Mover[((WIDTH - 16)/SPACING)*((HEIGHT - 16)/SPACING)];

void setup(){
  size(400, 400); 
  int index = 0;
  for(int y = 25; y < height; y += SPACING){
    for(int x = 25; x < width; x += SPACING){
      moverArray[index] = new Mover(x, y);
      index++;
    }
  }
}

void draw(){
  background(0);
  for(Mover mover: moverArray){
    mover.update();
    mover.display();
  }
}

class Mover{
  PVector location;
  float angle = 0;
  
  Mover(int x, int y){
    location = new PVector(x, y);
  }
  
  void update(){
    PVector mouse = new PVector(mouseX, mouseY);
    PVector ang = PVector.sub(mouse, location);
    angle = ang.heading(); 
  }
  
  void display(){   
    pushMatrix();
      translate(location.x, location.y);
      rotate(angle);
      //eyeball
      fill(255);
      stroke(0);
      ellipse(0, 0, 25, 25);
      //iris
      noStroke();
      fill(30, 143, 242);
      ellipse(4, 0, 12, 12);
      //pupil
      fill(0);
      ellipse(4, 0, 6, 6);
    popMatrix();
  }
}
