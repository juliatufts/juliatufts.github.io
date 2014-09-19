int NUM_MOVERS = 1000;
int NUM_ATTRACTORS = 6;
int hue = 255;

Mover[] moverArray = new Mover[NUM_MOVERS];
Attractor[] attArray = new Attractor[NUM_ATTRACTORS];

void setup() {
  size(400, 400);
  background(0);
  //initialize movers
  for (int i = 0; i < moverArray.length; i++) {
    moverArray[i] = new Mover();
  }
  //initialize attractors
  for (int i = 0; i < attArray.length; i++) {
    attArray[i] = new Attractor();
  }
}

void draw() {
  for (Mover mover : moverArray) {
    for (Attractor a : attArray) {
      PVector f = a.attract(mover);
      mover.applyForce(f);
      mover.update();
    }
    mover.display(hue);
  }

  if (mousePressed) {
    reset();
  }
}

void reset() {
  background(0);  
  //reset movers
  for (int i = 0; i < moverArray.length; i++) {
    moverArray[i] = new Mover();
  }
  //reset attractors
  for (int i = 0; i < attArray.length; i++) {
    attArray[i] = new Attractor();
  }
}

class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;

  Mover() {
    mass = 0.1;
    location = new PVector(random(width), random(height));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display(color h) {
    stroke(h, 15);
    fill(h, 15);
    point(location.x, location.y);
  }
}

class Attractor {
  PVector location;
  float mass;
  float G = 0.6;  //gravitational constant

  Attractor() {
    location = new PVector(random(width), random(height));
    mass = 10;
  }  

  PVector attract(Mover m) {
    PVector force = PVector.sub(location, m.location);
    float distance = force.mag();
    //distance = constrain(distance, 5, 25);
    float forceMag = (G * m.mass * mass) / sq(distance);
    force.normalize();
    force.mult(forceMag);
    return force;
  }
}

