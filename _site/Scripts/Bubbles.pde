Mover[] moverArray = new Mover[200];
float ballDiam = 24; 
color blue;
color aqua;
color lightBlue;

void setup(){
  size(400, 400); 
  blue = color(0, 116, 217);
  lightBlue = color(30, 143, 242);
  aqua = color(127, 219, 225);
  
  for(int i = 0; i < moverArray.length; i++){
    moverArray[i] = new Mover();
  }
}

void draw(){
  background(blue);
  
  //if the mouse is pressed, slow mo
  //else bubbles move normally
  if(mousePressed == true){
    for(Mover mover: moverArray){
      mover.slowUpdate();
      mover.checkEdges();
      mover.display();
    }
  } else {
    for(Mover mover: moverArray){
      mover.update();
      mover.checkEdges();
      mover.display();
    }
  }
}

class Mover{
  PVector location;
  PVector velocity;  
  PVector slowVel;
  float ballDiam;
  float colorLerpTime;
  
  Mover(){
    location = new PVector(random(width),random(height));
    velocity = new PVector(random(-0.5,0.5),random(-3,0));
    slowVel = new PVector(velocity.x/2, velocity.y/2);
    ballDiam = random(4, 32);
    colorLerpTime = random(1);
  }
  
  void update(){
    location.add(velocity);  
  }
  
  void slowUpdate(){
    location.add(slowVel);  
  }
  
  void display(){
    noStroke();
    fill(lerpColor(aqua, lightBlue, colorLerpTime));
    ellipse(location.x, location.y, ballDiam, ballDiam);  
  }
  
  void checkEdges(){
    if(location.x > width + ballDiam/2){
      location.x = 0;  
    } else if(location.x < -ballDiam/2){
      location.x = width;
    }
    
    if(location.y > height + ballDiam/2){
      location.y = 0;  
    } else if(location.y < -ballDiam/2){
      location.y = height;
    }
  }
}
