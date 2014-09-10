/* @pjs preload="/Scripts/Resources/BeeBackground.png"; */
PImage background;
Bee[] beeArray;
color skyBlue;
color gold;
color goldenrod;
color brown;
int beeCount = 0;
int timer = 0;
int beeTracker = 0;

void setup() {
  size(400, 400); 
  background = loadImage("/Scripts/Resources/BeeBackground.png");
  skyBlue = color(100, 203, 255);
  gold = color(255, 215, 00);
  goldenrod = color(218, 165, 32);
  brown = color(96, 57, 16);

  beeArray = new Bee[6];
  for (int i = 0; i < beeArray.length; i++) {
    beeArray[i] = new Bee();
  }
}

void draw() {
  //background(skyBlue);
  image(background, 0, 0);

  for (int i = 0; i < min(beeCount, beeArray.length); i++) {
    beeArray[i].update();
    beeArray[i].checkEdges();
    beeArray[i].display();
  }
  timer += 1;
  if (timer > 200) {
    beeCount += 1; 
    if(beeCount > beeArray.length){
      beeArray[beeTracker].location.x = width + 100;
      beeArray[beeTracker].location.y = random(0, height);
      beeTracker = (beeTracker + 1) % beeArray.length;
    }
    timer = 0;
  }
}

class Bee {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector hive;
  float cubeDiam;
  float topSpeed;

  Bee() {
    location = new PVector(width + 100, random(0, height));
    if(random(0,1) < 0.5){
      location.x *= -1;  
    }
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    hive = new PVector(200, 220);
    hive.x += random(-5, 5);
    hive.y += random(-30, 5);
    
    cubeDiam = 24;
    topSpeed = 4;
  }  

  void update() {
    PVector dir = PVector.sub(hive, location);
    float dist = dir.mag();
    dir.normalize();
    dir.x += + random(-0.5, 0.5);
    dir.y += + random(-0.5, 0.5);
    dir.mult(random(0.001, dist));
    acceleration = dir;

    velocity.add(acceleration);
    velocity.limit(topSpeed);
    location.add(velocity);
  }

  void display() {
    rectMode(CENTER);
    //body
    fill(255, 255, 0);
    rect(location.x, location.y, cubeDiam, cubeDiam); 
    fill(0);
    rect(location.x, location.y, cubeDiam, cubeDiam/6); 
    rect(location.x, location.y + cubeDiam/3, cubeDiam, cubeDiam/6);  
    //eyes
    rect(location.x - cubeDiam/5, location.y - cubeDiam/4, cubeDiam/8, cubeDiam/8);
    rect(location.x + cubeDiam/5, location.y - cubeDiam/4, cubeDiam/8, cubeDiam/8);
    //wings
    fill(255, 255, 255, 150);
    rect(location.x - cubeDiam/3, location.y + cubeDiam/4, 2*cubeDiam/3, cubeDiam/3);
    rect(location.x + cubeDiam/3, location.y + cubeDiam/4, 2*cubeDiam/3, cubeDiam/3);
  }

  void checkEdges() {
    if (location.x > width + cubeDiam/2) {
      location.x = -cubeDiam/2;
    } else if (location.x < -cubeDiam/2) {
      location.x = width + cubeDiam/2;
    }
    if (location.y > height + cubeDiam/2) {
      location.y = -cubeDiam/2;
    } else if (location.y < -cubeDiam/2) {
      location.y = height + cubeDiam/2;
    }
  }
}

