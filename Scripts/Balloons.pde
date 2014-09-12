Mover[] moverArray;
PVector wind;
PVector gravity;
PVector helium;
color red;
color pink;
color blue;
color yellow;
color orange;

void setup() {
  size(400, 400);
  red = color(255, 0, 0);
  pink = color(255, 0, 160);
  yellow = color(255, 255, 0);
  orange = color(255, 128, 0);
  blue = color(185, 246, 255);
  color[] colorArray = {red, yellow, pink, orange};
  
  moverArray = new Mover[40];
  for (int i = 0; i < moverArray.length; i++) {
    moverArray[i] = new Mover(colorArray[i % colorArray.length]);
  }

  wind = new PVector(0.04, 0);
  helium = new PVector(0, -0.04);
  gravity = new PVector(0, 0.1);
}

void draw() {
  background(blue);

  for (Mover mover : moverArray) {
    if(mover.velocity.mag() < 3){
      mover.applyForce(helium);
    } else {
      mover.applyForce(gravity);
    }
    if((millis()/1000 % 2) < 1){
      mover.applyForce(wind);
    } else {
      mover.applyForce(PVector.mult(wind, -1));
    }
    mover.update();
    mover.checkEdges();
    mover.display();
  }
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float topSpeed;
  float ballDiam;
  color c;
  PVector b1; //Bezier points of string
  PVector b2;
  PVector b3;
  PVector b4;
  float stringSpeed;
  boolean swivleRight;

  Mover(color tempc) {
    location = new PVector(random(0, width), random(0, height));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    c = tempc;
    ballDiam = 32;
    topSpeed = 3.0;
    mass = random(1.0, 5.0);
    stringSpeed = 1.0;
    swivleRight = true;
    
    b1 = new PVector(location.x, location.y + 6*ballDiam/7);
    b2 = new PVector(location.x - 3*ballDiam/4, location.y + 10*ballDiam/7);
    b3 = new PVector(location.x + 3*ballDiam/4, location.y + 10*ballDiam/7);
    b4 = new PVector(location.x, location.y + 14*ballDiam/7);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    location.add(velocity);
    b1.add(velocity);
    b2.add(velocity);
    b3.add(velocity);
    b4.add(velocity);
    
    //check if the swivle direction needs to change
    if(b2.x >= location.x + 3*ballDiam/4 || b2.x < location.x - 3*ballDiam/4){
      swivleRight = !swivleRight;  
    }
    //update bezier curve
    if(swivleRight){
      b2.x += stringSpeed;
      b3.x -= stringSpeed;
    } else {
      b2.x -= stringSpeed;
      b3.x += stringSpeed;
    }
    acceleration.mult(0);
  }

  void display() {
    //balloon
    noStroke();
    fill(c);
    ellipse(location.x, location.y, ballDiam, ballDiam);
    //balloon bottom
    beginShape();
    vertex(location.x - ballDiam/2, location.y + ballDiam/8);
    vertex(location.x, location.y + 6*ballDiam/7);
    vertex(location.x + ballDiam/2, location.y + ballDiam/8);
    endShape();
    //balloon string
    noFill();
    stroke(255);
    bezier(b1.x, b1.y, b2.x, b2.y, b3.x, b3.y, b4.x, b4.y);
  }

  void checkEdges() { 
    //check edges of screen
    if (location.x > width + ballDiam/2) {
      location.x = -ballDiam/2;
      b1.x = location.x;
      b2.x = location.x - 3*ballDiam/4;
      b3.x = location.x + 3*ballDiam/4;
      b4.x = location.x;
    } else if (location.x < -ballDiam/2) {
      location.x = width + ballDiam/2;
      b1.x = location.x;
      b2.x = location.x - 3*ballDiam/4;
      b3.x = location.x + 3*ballDiam/4;
      b4.x = location.x;
    }
    if (location.y > height + ballDiam/2 + 4*ballDiam/3) {
      location.y = -ballDiam/2;
      b1.y = location.y + 6*ballDiam/7;
      b2.y = location.y + 10*ballDiam/7;
      b3.y = location.y + 10*ballDiam/7;
      b4.y = location.y + 14*ballDiam/7;
    } else if (location.y < -(ballDiam/2 + 4*ballDiam/3)) {
      location.y = height + ballDiam/2;
      b1.y = location.y + 6*ballDiam/7;
      b2.y = location.y + 10*ballDiam/7;
      b3.y = location.y + 10*ballDiam/7;
      b4.y = location.y + 14*ballDiam/7;
    }
  }
}
