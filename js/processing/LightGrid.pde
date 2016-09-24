int square = 10;
int NUM_MOVERS = 41*41;
int NUM_ATTRACTORS = 1;
int hue = 255;

Mover[] moverArray = new Mover[NUM_MOVERS];
Attractor[] attArray = new Attractor[NUM_ATTRACTORS];

void setup() {
  size(400, 400);
  background(0);
  //initialize movers
  int index = 0;
  for (int i = 0; i < 41; i++) {
    for(int j = 0; j < 41; j++){
      moverArray[index] = new Mover(i*10, j*10);
      index++;
    }
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
  for (Attractor a : attArray) {
      a.update();
   }

  if (mousePressed) {
    reset();
  }
}

void reset() {
  background(0);  
  //reset movers
  int index = 0;
  for (int i = 0; i < 41; i++) {
    for(int j = 0; j < 41; j++){
      moverArray[index] = new Mover(i*10, j*10);
      index++;
    }
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

  Mover(float x, float y) {
    mass = 0.1;
    location = new PVector(x, y);
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
  float G = 2;  //gravitational constant

  Attractor() {
    location = new PVector(width/2, height/2);
    //location = new PVector(random(width), random(height));
    mass = 10;
  }  
  
  void update() {
    location.x = width/2 + 100*cos(millis()/100);
    location.y = height/2 + 100*sin(millis()/100);
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
