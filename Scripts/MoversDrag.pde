Mover mover;
Liquid[] liquidArray = new Liquid[3];
float m;
int hue = 0;
int sat = 100;
boolean clicked;

void setup(){
  size(400, 400);
  colorMode(HSB);
  //initialize mover
  mover = new Mover(width/2, height/5, 2, hue);
  //initialize liquid stack
  for(int i = 0; i < liquidArray.length; i++){
    liquidArray[i] = new Liquid(i*width/3, height/2, width/3, height, (i+1)*0.1, (i*75)+sat);  
  }
  liquidArray[2].x -= 1; //pixel perfect for web
  liquidArray[2].w += 2; //pixel perfect for web
}

void draw(){
  background(255);
  for(Liquid liquid: liquidArray){
    if(mover.isInside(liquid)){
      mover.drag(liquid);  
    }
  }
  if(mover.isClickable() && mousePressed){
    clicked = true;  
  }
  if(clicked){
    mover.location.x = mouseX;
    mover.location.y = mouseY;
  } else {
    mover.update();
    mover.checkEdges();
  }
  mover.display();
  for(Liquid liquid: liquidArray){
    liquid.display();
  }
}

void mouseReleased(){
  if(clicked){
    clicked = false;
    mover.acceleration = new PVector(0,0);
    mover.velocity = new PVector(0,0);
  }
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector gravity;
  float mass;
  float ballDiam;
  int hue;

  Mover(float tempx, float tempy, float tempMass, int tempHue) {
    mass = tempMass;
    ballDiam = mass*16;
    hue = tempHue;
    
    location = new PVector(tempx, tempy);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    gravity = new PVector(0, 0.1*mass);
  }
  
  boolean isClickable(){
    PVector mouse = new PVector(mouseX, mouseY);
    PVector diff = PVector.sub(mouse,location);
    if(diff.mag() < ballDiam/2){
      return true;
    } else {
      return false;  
    }
  }
  
  boolean isInside(Liquid l){
    if(location.x >= l.x && location.x <= l.w + l.x && location.y >= l.y && location.y <= l.h + l.y){
      return true; 
    } else {
      return false;  
    }
  }
  
  void drag(Liquid l){
    float speed = velocity.mag();
    float dragMag = l.c * speed * speed;
    PVector drag = velocity.get();
    drag.normalize();
    drag.mult(-1);
     
    drag.mult(dragMag);
    applyForce(drag);   
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }

  void update() {
    applyForce(gravity);
    
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    noStroke();
    fill(hue, 255, 255);
    ellipse(location.x,location.y,ballDiam,ballDiam);
  }

  void checkEdges() {
    if (location.y > height - ballDiam/2) {
      velocity.y *= -1;
      location.y = height - ballDiam/2;
    }
  }
}

class Liquid {
  float x, y, w, h;
  float c;
  float s;   //saturation of color

  Liquid(float x_, float y_, float w_, float h_, float c_, float s_){
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
    s = s_;
  }  
  
  void display(){
    noStroke();
    fill(125, s, 255, 100);
    rect(x, y, w, h);  
  }
}
