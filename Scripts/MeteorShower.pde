Mover[] moverArray;
Cloud[] cloudArray;
color red;
color pink;
color yellow;
color orange;
color grey;
color darkGrey;
color skyBlue;

void setup(){
  size(400, 400);
  red = color(255, 0, 0);
  pink = color(255, 60, 200);
  yellow = color(255, 255, 0);
  orange = color(255, 133, 27);
  grey = color(100);
  darkGrey = color(50);
  skyBlue = color(100, 203, 255);
  
  moverArray = new Mover[100];
  for(int i = 0; i < moverArray.length; i++){
    moverArray[i] = new Mover();  
  }
  cloudArray = new Cloud[2];
  cloudArray[0] = new Cloud(random(50, 350), 100);
  cloudArray[1] = new Cloud(random(30, 350), 300);
}

void draw(){
  background(skyBlue);
  
  for(Cloud cloud: cloudArray){
    cloud.update();
    cloud.checkEdges();
    cloud.display();
  }
  
  for(Mover mover: moverArray){
    mover.update();
    mover.checkEdges();
    mover.display();
  }
}

//SPACE resets
void keyPressed() {
  if (keyCode == ' ') {
    for(Mover mover: moverArray){
      mover.location = new PVector(random(0, width), random(0, height));
      mover.velocity = new PVector(random(2, 3), random(2, 4));
    }
  }
}

class Mover{
  PVector location;
  PVector velocity;
  PVector normVelocity;  //used for triangle tail
  PVector acceleration;
  PVector tail;
  float tailLength;
  float ballDiam;
  float colorLerpTime;
  float greyLerpTime;
  
  Mover(){
    location = new PVector(random(0, width), random(0, height));
    velocity = new PVector(random(2, 3), random(2, 4));
    acceleration = new PVector(0.001, 0.001);
    
    ballDiam = random(4, 32);
    colorLerpTime = location.y/height;
    greyLerpTime = random(0, 1);
    
    normVelocity = new PVector(velocity.x, velocity.y);
    normVelocity.normalize();
    normVelocity.mult(ballDiam/2);
    
    tail = new PVector(velocity.x, velocity.y);
    tail.normalize();
    tailLength = ballDiam * 1.5;
    tail.mult(tailLength);
  }
  
  void update(){
    velocity.add(acceleration);
    velocity.limit(10);
    location.add(velocity);
  }
  
  void display(){
    //meteor tail
    colorLerpTime = location.y/height;
    fill(lerpColor(yellow, orange, colorLerpTime));
    noStroke();
    beginShape();
    vertex(location.x - tail.x, location.y - tail.y);
    vertex(location.x - normVelocity.x, location.y + normVelocity.y);
    vertex(location.x + normVelocity.x, location.y - normVelocity.y);
    endShape();
    //meteor
    noStroke();
    fill(lerpColor(grey, darkGrey, greyLerpTime));
    ellipse(location.x, location.y, ballDiam, ballDiam);
  }
  
  void checkEdges(){
    if(location.x - tail.x > width + ballDiam/2){
      location.x = 0;  
    } else if(location.x < -ballDiam/2){
      location.x = width;
    }
    
    if(location.y - tail.y > height + ballDiam/2){
      location.y = 0;  
    } else if(location.y < -ballDiam/2){
      location.y = height;
    }
  }
}

class Cloud{
  PVector location;
  PVector velocity;
  float puffRad;
  float whiteShade;

  Cloud(float xLoc, float yLoc){
    location = new PVector(xLoc, yLoc);
    velocity = new PVector(random(-0.5, -0.1), 0);
    puffRad = random(30, 60);
    whiteShade = int(random(230,250));
  }  
  
  void update(){
    location.add(velocity);
  }
  
  void display(){
    fill(whiteShade);
    ellipse(location.x, location.y, puffRad*2, puffRad*2);
    ellipse(location.x - puffRad, location.y + puffRad/3, puffRad*1.5, puffRad*1.5);
    ellipse(location.x - 3*puffRad/2, location.y + puffRad/2, puffRad*1.2, puffRad*1.2);
    ellipse(location.x + puffRad, location.y + puffRad/3, puffRad*1.7, puffRad*1.7);
  }
  
  void checkEdges(){
    if(location.x < -(puffRad + puffRad*1.7/2)){
      location.x = width + (3*puffRad/2 + puffRad*1.2/2);
    }
  }
}
