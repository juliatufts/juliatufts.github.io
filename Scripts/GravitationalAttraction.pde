Mover[] planets = new Mover[3];
Attractor a;

void setup() {
  size(400, 400);
  colorMode(HSB);
  //initialize planets
  for(int i = 0; i < planets.length; i++){
    float h = i < 2 ? random(height/4, height/3) : random(2*height/3, 3*height/4);
    planets[i] = new Mover(random(2*width/5, 3*width/5), h, random(2.5, 3.5));
  }
  a = new Attractor(width/2, height/2);
}

void draw() {
  background(0);
  a.display();
  for(Mover mover: planets){
    PVector f = a.attract(mover);
    mover.applyForce(f);
    mover.update();
    mover.display();
  }
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float ballDiam;
  int hue;

  Mover(float tempx, float tempy, float tempMass) {
    mass = tempMass;
    ballDiam = mass*8;

    location = new PVector(tempx, tempy);
    velocity = new PVector(location.y > height/2 ? -1 : 1, 0);
    acceleration = new PVector(0, 0);
    hue = int(random(125, 225));
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    checkEdges();
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void checkEdges(){
    PVector pushBack;
    float buffer = 10;
    if(location.x < ballDiam/2 + buffer){
      pushBack = new PVector(1, 0);
      applyForce(pushBack);
    } else if(location.x > width - (ballDiam/2 + buffer)){
      pushBack = new PVector(-1, 0);
      applyForce(pushBack);
    } 
    if(location.y < ballDiam/2 + buffer){
      pushBack = new PVector(0, 1);
      applyForce(pushBack);
    } else if(location.y > height - (ballDiam/2 + buffer)){
      pushBack = new PVector(0, -1);
      applyForce(pushBack);
    } 
  }

  void display() {
    noStroke();
    //planet
    fill(hue);
    ellipse(location.x, location.y, ballDiam, ballDiam);
    //crater
    fill(75);
    ellipse(location.x - ballDiam/6, location.y + ballDiam/6, ballDiam/4, ballDiam/4);
    ellipse(location.x - ballDiam/5, location.y - ballDiam/8, ballDiam/6, ballDiam/6);
  }
}

class Attractor {
  PVector location;
  float mass;
  float ballDiam;
  float G = 0.6;  //gravitational constant

  Attractor(float x, float y) {
    location = new PVector(x, y);
    mass = 30;
    ballDiam = mass*1.5;
  }  
  
  PVector attract(Mover m){
      PVector force = PVector.sub(location, m.location);
      float distance = force.mag();
      distance = constrain(distance, 5, 25);
      float forceMag = (G * m.mass * mass) / sq(distance);
      force.normalize();
      force.mult(forceMag);
      return force;
  }

  void display() {
    noStroke();
    fill(40, 255, 255);
    ellipse(location.x, location.y, ballDiam/6, ballDiam/6);
    for(int i = 0; i < 6; i++){
      fill(40, 100, 255, 120 - i*15);
      ellipse(location.x, location.y, (i+1)*ballDiam/6, (i+1)*ballDiam/6);
    }
  }
}

