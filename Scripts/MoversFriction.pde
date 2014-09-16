Mover[] moverArray = new Mover[19];
float x = 16;
float y = 20;
int hue = 0;
float coef = 0.05;
int timer = 0;

void setup(){
  size(400, 400);
  colorMode(HSB);
  for(int i = 0; i < moverArray.length; i++){
    hue = int(map(abs(x - width/2), 0, width/2, 0, 255));
    moverArray[i] = new Mover(x, y, hue, coef);
    x += 20.0;
    
    if(i < 9){
      coef -= 0.003;
    } else {
      coef += 0.003;
    }
  }
}

void draw(){
  background(0);
  for(Mover m: moverArray){
    m.update();
    m.checkEdges();
    m.display();
  }
  if(timer > 750){
    changeDirection();
    timer = 0;  
  }
  timer += 1;
}

void changeDirection(){
  coef = 0.05;
  for(int i = 0; i < moverArray.length; i++){
    moverArray[i].gravity.y = -moverArray[i].gravity.y;
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
  float c;  //coefficient of friction
  PVector friction;

  Mover(float tempx, float tempy, int tempHue, float tempC) {
    mass = 1;
    ballDiam = mass*16;
    hue = tempHue;
    c = tempC;
    
    location = new PVector(tempx, tempy);
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    gravity = new PVector(0, 0.1*mass);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }

  void update() {
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(c);
    
    applyForce(friction);
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
    if (location.x > width - ballDiam/2) {
      location.x = width - ballDiam/2;
      velocity.x *= -1;
    } else if (location.x < ballDiam/2) {
      location.x = ballDiam/2;
      velocity.x *= -1;
    }

    if (location.y > height - ballDiam/2) {
      velocity.y *= -1;
      location.y = height - ballDiam/2;
    } else if(location.y < ballDiam/2){
      location.y = ballDiam/2;
      velocity.y *= -1;
    }
  }
}
