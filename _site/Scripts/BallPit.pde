Mover[] moverArray;
PVector wind;
PVector gravity;
color red;
color pink;
color blue;
color yellow;
color orange;
color green;

void setup(){
  size(400, 400);
  red = color(255, 0, 0);
  pink = color(255, 0, 160);
  yellow = color(255, 255, 0);
  orange = color(255, 128, 0);
  blue = color(0, 0, 255);
  green = color(0, 255, 0);
  color[] colorArray = {red, yellow, pink, orange, blue, green};
  
  wind = new PVector(0.1, -0.08);
  gravity = new PVector(0, 0.05);
  
  moverArray = new Mover[150];
  for(int i = 0; i < moverArray.length; i++){
    moverArray[i] = new Mover(colorArray[int(random(0, colorArray.length))]);  
  }
}

void draw(){
  background(255);
  
  for(Mover m: moverArray){
    if(m.location.y > (height - m.ballDiam/2)*0.99){
      m.applyForce(wind);
    }
    m.applyForce(gravity);
    m.update();
    m.checkEdges();
    m.display();
  }
}

class Mover{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  float ballDiam;
  color col;
  
  Mover(color tempCol){
    mass = random(1, 1.5);
    ballDiam = 32;
    location = new PVector(random(0, width-ballDiam/2), random(0, height*0.85));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0); 
    col = tempCol; 
  }
  
  void applyForce(PVector force){
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  void display(){
    noStroke();
    fill(col);
    ellipse(location.x, location.y, ballDiam, ballDiam);  
  }
  
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);  
  }
  
  void checkEdges(){
    if(location.x > width - ballDiam/2){
      location.x = width - ballDiam/2;
      velocity.x *= -1; 
    } else if(location.x < ballDiam/2){
      location.x = ballDiam/2;
      velocity.x *= -1; 
    }
    
    if(location.y > height - ballDiam/2){
      location.y = height - ballDiam/2;
      velocity.y *= -1; 
    } else if(location.y < ballDiam/2){
      location.y = ballDiam/2;
      velocity.y *= -1; 
    }
  }
}
