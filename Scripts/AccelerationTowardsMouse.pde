Puff[] puffArray;
float red;
int hue = 0;

void setup(){
  size(400, 400);
  colorMode(HSB);
  puffArray = new Puff[50];
  for(int i = 0; i < puffArray.length; i++){
    puffArray[i] = new Puff();  
  }
}

void draw(){
  background(0);
  for(Puff puff: puffArray){
    puff.update();
    puff.display();
  }
}

class Puff{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector mouse;
  float topSpeed;
  float ballDiam;
  int alpha;
  int hue;

  Puff(){
    location = new PVector(random(0, width), random(0, height));
    velocity = new PVector(0,0);
    mouse = new PVector(width/2, height/2);
    
    ballDiam = random(12, 32);
    topSpeed = ballDiam/5;
    hue = int(random(0, 60));
  }
  
  void update(){
    mouse.x = mouseX;
    mouse.y = mouseY;
    PVector dir = PVector.sub(mouse, location);
    alpha = int(map(dir.mag(), 0, sqrt(sq(width) + sq(height)), 0, 255));
    alpha = 255 - alpha;
    hue = (hue + 1) % 255;
    
    dir.normalize();
    dir.mult(0.2);
    
    acceleration = dir;
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    location.add(velocity);
  }
  
  void display(){
    noStroke();
    fill(hue, 255, 255, alpha);
    ellipse(location.x, location.y, ballDiam, ballDiam);
  }
}
