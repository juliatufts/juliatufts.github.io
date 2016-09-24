/* @pjs font="/js/processing/Resources/Minecraftia.ttf"; */ 
Bubble[] bubbleArray = new Bubble[100];
Blowfish blowfish;
Heart heart;
Heart[] heartArray = new Heart[200];
PVector heartLoc;
PVector zero = new PVector(0, 0);
Boolean gotHeart;
color blue;
color aqua;
color lightBlue;
color softWhite;
color lime;
color darkLime;
color lightLime;
color creamyLime;
color red;
color pink;
color black;
float timerBlowfish = 0;
float timerHeart = 0;
float timerText = 0;
Boolean textColorDown = false;

void setup(){
  size(400, 400); 
  blue = color(0, 116, 217);
  lightBlue = color(30, 143, 242);
  aqua = color(127, 219, 225);
  softWhite = color(240, 240, 230);
  lime = color(124, 252, 0);
  lightLime = color(154, 255, 94);
  darkLime = color(94, 232, 0);
  creamyLime = color(184, 255, 114);
  red = color(255, 0, 0);
  pink = color(255, 160, 160);
  black = color(0, 0, 0);
  
  PVector tempLoc;
  PVector tempVel;
  PVector tempAccel;
  float tempSize;
  color tempCol;
  for(int i = 0; i < heartArray.length; i++){
    tempLoc = new PVector(random(0, width), random(-height/2, 0));
    tempVel = new PVector(0, random(0, 3));
    tempAccel = new PVector(0, random(0.0001, 0.001));
    tempSize = int(random(12, 32));
    tempCol = lerpColor(pink, red, random(0,1));
    heartArray[i] = new Heart(tempLoc, tempVel, tempAccel, 0, tempSize, tempCol);
  }
  for(int i = 0; i < bubbleArray.length; i++){
    bubbleArray[i] = new Bubble();
  }
  
  blowfish = new Blowfish();
  heartLoc = new PVector(random(12, width - 12), height/5);
  heart = new Heart(heartLoc, zero, zero, 0.1, 12, red);
  gotHeart = false;
  textFont(createFont("/js/processing/Resources/Minecraftia.ttf", 64));
}

void draw(){
  //Background and background bubbles
  background(lightBlue);
  for(Bubble bubble: bubbleArray){
    bubble.update();
    bubble.checkEdges();
    bubble.display();
  }
  
  //Heart
  if(!gotHeart){
    heart.update();
    heart.display();
    if(timerHeart > 33){
      heart.sizeVelocity = -heart.sizeVelocity;
      timerHeart = 0;
    }
    timerHeart += 1;  
    //Did blowfish get heart?
    gotHeart = heart.hasBeenHit(blowfish.location, blowfish.ballDiam);
  } else {
    timerText = map(timerBlowfish, 0, 70, 0.01, 0.99);
    if(textColorDown){
      fill(lerpColor(pink, red, 1 - timerText));
    } else {
      fill(lerpColor(pink, red, timerText));  
    }
    textAlign(CENTER);
    text("HAPPY", width/2, height/2 - 60); 
    text("BIRTHDAY", width/2, height/2 + 20); 
    text("SONYA", width/2, height/2 + 100); 
    
    for(Heart h: heartArray){
      h.update();
      h.display();
    }  
  }
  
  //Blowfish
  blowfish.update();
  blowfish.checkEdges();
  blowfish.display();
  if(timerBlowfish > 50){
    blowfish.sizeVelocity = -blowfish.sizeVelocity;
    timerBlowfish = 0;
    textColorDown = !textColorDown;
  }
  timerBlowfish += 1;
}

//Keyboard input to move around
float forceMag = 0.2;
PVector force;
void keyPressed() {
  force = new PVector(0,0);
  if (keyCode == UP) {
    force.y -= 1;
  }
  if (keyCode == DOWN) {
    force.y += 1;
  } 
  if (keyCode == RIGHT) {
    force.x += 1;
  }
  if (keyCode == LEFT) {
    force.x -= 1;
  } 
  force.normalize();
  force.mult(forceMag);
  blowfish.applyForce(force);
}

class Blowfish{
  PVector location;
  PVector velocity;  
  PVector acceleration; 
  float sizeVelocity;
  float sizeAcceleration;
  float ballDiam; 
  float topSpeed;
  
  Blowfish(){
    ballDiam = 64;
    location = new PVector(random(ballDiam, width - ballDiam), 4*height/5);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
    sizeVelocity = 0.1;
    sizeAcceleration = 0;
    topSpeed = 2;
  }
  
  void update(){
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    location.add(velocity);  
    
    sizeVelocity += sizeAcceleration;
    ballDiam += sizeVelocity;
  }
  
  void applyForce(PVector direction){
      velocity.add(direction);
  }
  
  void display(){
    //body
    fill(lime);
    ellipse(location.x, location.y, ballDiam, ballDiam); 
    fill(creamyLime);
    arc(location.x, location.y, ballDiam, ballDiam, 0, 3.14);
    fill(lightLime);
    arc(location.x, location.y, ballDiam, 3*ballDiam/4, 0, 3.14);
    fill(lime);
    arc(location.x, location.y, ballDiam, ballDiam/2, 0, 3.14);
    //flipper
    fill(darkLime);
    arc(location.x - ballDiam/5, location.y, ballDiam/3, ballDiam/5, 3.14/2, 3*3.14/2);
    //face
    fill(0);
    noStroke();
    ellipse(location.x + ballDiam/6, location.y - ballDiam/6, 4, 4);
    ellipse(location.x + 2*ballDiam/6, location.y - ballDiam/6, 4, 4);
  }
  
  void checkEdges(){
    if(location.x > width + ballDiam/2){
      location.x = 0;  
    } else if(location.x < -ballDiam/2){
      location.x = width + ballDiam/2;
    }
    
    if(location.y > height + ballDiam/2){
      location.y = 0;  
    } else if(location.y < -ballDiam/2){
      location.y = height + ballDiam/2;
    }
  }
}

class Heart{
  PVector location;
  PVector velocity;
  PVector acceleration;
  float sizeVelocity;
  float topSpeed;
  float ballDiam; 
  color c;
  
  Heart(PVector tempLoc, PVector tempVel, PVector tempAccel, float tempSizeVel, float tempBallDiam, color tempc){
    location = tempLoc;
    velocity = tempVel;
    acceleration = tempAccel;
    sizeVelocity = tempSizeVel;
    ballDiam = tempBallDiam;
    sizeVelocity = tempSizeVel;
    c = tempc;
    
    topSpeed = 5;
  }
  
  void update(){
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    location.add(velocity);
    ballDiam += sizeVelocity;
  }
  
  Boolean hasBeenHit(PVector otherLocation, float otherBallDiam){
    if(abs(otherLocation.x - location.x) < otherBallDiam/2 && abs(otherLocation.y - location.y) < otherBallDiam/2){
      return true;
    } else {  
      return false;
    }
  }
  
  void display(){
    noStroke();
    fill(c);
    ellipse(location.x - ballDiam/2.1, location.y, ballDiam, ballDiam); 
    ellipse(location.x + ballDiam/2.1, location.y, ballDiam, ballDiam);
    beginShape();
    vertex(location.x - ballDiam, location.y + ballDiam/8);
    vertex(location.x, location.y + 4*ballDiam/3);
    vertex(location.x + ballDiam, location.y + ballDiam/8);
    endShape();
  }
}

class Bubble{
  PVector location;
  PVector velocity;  
  float ballDiam;
  float colorLerpTime;
  
  Bubble(){
    location = new PVector(random(width),random(height));
    velocity = new PVector(random(-0.5,0.5),random(-2,0));
    ballDiam = random(4, 24);
    colorLerpTime = random(1);
  }
  
  void update(){
    location.add(velocity);  
  }
  
  void display(){
    noStroke();
    fill(lerpColor(softWhite, aqua, colorLerpTime));
    ellipse(location.x, location.y, ballDiam, ballDiam);  
  }
  
  void checkEdges(){
    if(location.x > width + ballDiam/2){
      location.x = -ballDiam/2;  
    } else if(location.x < -ballDiam/2){
      location.x = width + ballDiam/2;
    }
    
    if(location.y > height + ballDiam/2){
      location.y = -ballDiam/2;  
    } else if(location.y < -ballDiam/2){
      location.y = height + ballDiam/2;
    }
  }
}
