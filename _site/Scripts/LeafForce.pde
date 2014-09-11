Mover[] moverArray = new Mover[40];
PVector wind;
PVector gravity;
color blue;
color green;
color olive;
color darkGreen;

void setup(){
  size(400, 400);
  for(int i = 0; i < moverArray.length; i++){
    moverArray[i] = new Mover();
  }
  
  green = color(46, 204, 64);
  olive = color(61, 153, 112);
  blue = color(185, 246, 255);
  darkGreen = color(0, 100, 0);
  wind = new PVector(-1, -1.5);
  gravity = new PVector(0, 0.01);
}

void draw(){
  background(blue);
  
  for(Mover mover: moverArray){
    mover.applyForce(gravity);
    mover.update();
    mover.checkEdges();
    mover.display();
  }
  
}

void keyPressed(){
  if(keyCode == ' '){
     for(Mover mover: moverArray){
       mover.applyForce(wind);  
     }
  }  
  if(keyCode == ENTER){
     for(Mover mover: moverArray){
        mover.location = new PVector(random(0, width), random(0, height));
        mover.velocity = new PVector(0,0);
        mover.acceleration = new PVector(random(0, 1), random(0, 1)); 
     }
  }  
}

class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float topSpeed;
  float w;
  float h;
  float colorLerpTime;

  Mover(){
    location = new PVector(random(0, width), random(0, height));
    velocity = new PVector(0,0);
    acceleration = new PVector(random(0, 1), random(0, 1));
    
    topSpeed = 5;
    w = 50;
    h = 35;
    colorLerpTime = random(0,1);
    mass = map(colorLerpTime, 0, 1, 1, 3);
  }
  
  void applyForce(PVector force){
    PVector f = force.get();
    f.div(mass);
    acceleration.add(force);
  }
  
  void update(){
    velocity.add(acceleration);
    //velocity.limit(topSpeed);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display(){
    //leaf
    stroke(lerpColor(olive, darkGreen, colorLerpTime));
    strokeWeight(2);
    fill(lerpColor(green, olive, colorLerpTime));
    beginShape();
    vertex(location.x, location.y);
    bezierVertex(location.x + 10, location.y - 15, location.x + 30, location.y - 5, location.x + 50, location.y + 5);
    bezierVertex(location.x + 40, location.y + 10, location.x + 10, location.y + 20, location.x, location.y);
    endShape();
    //leaf line
    noFill();
    beginShape();
    vertex(location.x, location.y);
    bezierVertex(location.x + 10, location.y - 15/2, location.x + 30, location.y + 5/2, location.x + 50, location.y + 5);
    endShape();
  }
  
  void checkEdges(){
    if(location.x > width){
      location.x = -w;  
    } else if(location.x < -w){
      location.x = width;
    }
    
    if(location.y > height + h/2){
      location.y = -h/2;  
    } else if(location.y < -h/2){
      location.y = height + h/2;
    }
  }
}
