Mover[] moverArray = new Mover[500];
color red;
color pink;
color aqua;
color black;

void setup(){
  size(400, 400);
  for(int i = 0; i < moverArray.length; i++){
    moverArray[i] = new Mover();
  }
  
  red = color(255, 0, 0);
  pink = color(255, 60, 100);
  aqua = color(127, 219, 225);
  black = color(0);
}

void draw(){
  background(255);
  
  for(Mover mover: moverArray){
    mover.update();
    mover.checkEdges();
    mover.display();
  }
  
}

void keyPressed() {
    if (keyCode == UP) {
      for(Mover mover: moverArray){
        //used to increase/decrease acceleration wrt current velocity
        PVector increment = mover.getStartAccel();
        
        increment.mult(120 * sq(mover.velocity.x/mover.topSpeed) + 1);
        mover.acceleration.add(increment);
      }
    } else if (keyCode == DOWN) {
      for(Mover mover: moverArray){
        //used to increase/decrease acceleration wrt current velocity
        PVector increment = mover.getStartAccel();
        
        increment.mult(120 * sq(mover.velocity.x/mover.topSpeed) + 1);
        mover.acceleration.sub(increment);
      }
    }
}

class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector startAccel;     //the starting accel, used to increase/decrease acceleration
  float topSpeed;
  float ballDiam;
  float colorLerpTime;

  Mover(){
    location = new PVector(random(0, width), random(0, height));
    velocity = new PVector(0,0);
    startAccel = new PVector(random(0, 0.001), 0);
    acceleration = new PVector(startAccel.x, 0);
    
    topSpeed = 6;
    ballDiam = random(4, 32);
    colorLerpTime = location.y/height;
  }
  
  //Gets a new copy of the startAccel
  PVector getStartAccel(){
    PVector accel = new PVector();
    accel.x = startAccel.x;
    return accel;  
  }
  
  void update(){
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    location.add(velocity);
  }
  
  void display(){
    colorLerpTime = velocity.mag()/topSpeed;
    noStroke();
    if(velocity.x > 0){
      fill(lerpColor(black, pink, colorLerpTime));
    } else {
      fill(lerpColor(black, aqua, colorLerpTime));
    }
    ellipse(location.x, location.y, ballDiam, ballDiam);
  }
  
  void checkEdges(){
    if(location.x > width + ballDiam/2){
      location.x = -ballDiam/2;  
    } else if(location.x < -ballDiam/2){
      location.x = width;
    }
    
    if(location.y > height + ballDiam/2){
      location.y = -ballDiam/2;  
    } else if(location.y < -ballDiam/2){
      location.y = height;
    }
  }
}
