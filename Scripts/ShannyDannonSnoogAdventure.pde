/* @pjs font="/Scripts/Resources/Minecraftia.ttf"; */ 

// --------------- Initialization --------------------
// colors
color black;
color white;
color lightBlue;
color darkOceanBlue;
color oceanBlue;
color pink;
color red;
color sand;
color skyBlue;
color softWhite;
color lime;
color darkLime;
color lightLime;
color creamyLime;
color tempColor;

// camera
PVector cameraOffset;
PVector center;

// world specs
float totalWidth;
float totalHeight;

// Fonts and text display bools/timers
PFont f;
boolean displayTitle;
float titleTimer;
boolean displayGameover;
float gameoverTimer;

// ---- Game objects
// ocean
Ocean ocean;
boolean hitOcean;
boolean displaySplash;

// fish
int numBlowfish = 40;
Blowfish[] blowfish = new Blowfish[numBlowfish];

// stars
int numStars = 400;
Star[] starArray = new Star[numStars];

// clouds
int numClouds = 170;
Cloud[] cloudArray = new Cloud[numClouds];

// keyboard input
float forceMag = 0.3;
PVector force;

// player
Player player;

// ----------------------- MAIN -------------------------
void setup() {
  size(400, 400);
  frameRate(45);
  totalWidth = 400 * 16;
  totalHeight = 400 * 16;
  float[] worldBounds = {200 - (4 * 400), totalWidth - 200,
                        -600 - (4 * 400), 7.5 * height};  

  // colors
  black = color(0, 0, 0);
  white = color(255, 255, 255);
  red = color(255, 0, 0);
  lightBlue = color(30, 143, 242);
  oceanBlue = color(30, 113, 182);
  darkOceanBlue = color(5, 33, 96);
  pink = color(255, 160, 160);
  sand = color(193, 154, 107);
  skyBlue = color(127, 219, 225);
  softWhite = color(240, 240, 230);
  lime = color(124, 252, 0);
  lightLime = color(154, 255, 94);
  darkLime = color(94, 232, 0);
  creamyLime = color(184, 255, 114);
  tempColor = color(0, 0, 0);

  // camera
  cameraOffset = new PVector(0, 0);
  center = new PVector(width / 2, height / 2);

  // Fonts and text things
  //textFont(createFont("Minecraftia", 24));
  f = createFont("Courier", 32, true);
  displayTitle = true;
  titleTimer = 0;
  displayGameover = false;
  gameoverTimer = 0;

  // ---- Game objects
  // ocean
  ocean = new Ocean(worldBounds[0], 6 * height, totalWidth, 2 * height, 0.1, oceanBlue, darkOceanBlue);
  hitOcean = false;
  displaySplash = false;
  
  // fish
  for (int i = 0; i < numBlowfish; i++) {
    blowfish[i] = new Blowfish(random(worldBounds[0], totalWidth),
                               random(6 * height + 12, 8 * height - 200),
                               random(12, 32)); 
  }

  // stars
  for (int i = 0; i < numStars; i++) {
    starArray[i] = new Star(random(width) * 16, 
                            random(- height * 4, height), 
                            random(2, 8));
  }

  // clouds
  // upper atmosphere - sparse
  for (int i = 0; i < numClouds / 4; i++) {
    cloudArray[i] = new Cloud(random(width) * 10, 
                              random(height, height * 2), 
                              int(random(40, 100)), 
                              int(random(40, 100)));
  }
  // mid atmosphere - dense
  for (int i = 0; i < numClouds; i++) {
    cloudArray[i] = new Cloud(random(width) * 10, 
                              random(height * 2, height * 4), 
                              int(random(40, 100)), 
                              int(random(40, 100)));
  }
  // lower atmosphere - sparse
  for (int i = 0; i < numClouds / 4; i++) {
    cloudArray[i] = new Cloud(random(width) * 10, 
                              random(height * 4, height * 5), 
                              int(random(40, 100)), 
                              int(random(40, 100)));
  }

  // player
  player = new Player(2, worldBounds);
  player.location.x += (width * 6);              // move to middle of world
  player.sleepbar.location.x += (width * 6);     // move to middle of world
}

void draw() {  
  pushMatrix();

  // translate based on player location
  cameraOffset = player.location.get();
  cameraOffset.sub(center);
  cameraOffset.mult(-1);
  translate(cameraOffset.x, cameraOffset.y);

  // -------------- drawing --------------
  // background, ocean, fish, stars and clouds
  drawBackground();
  
  if (player.location.y < height) {
    for (Star star : starArray) {
      star.display();
    }
  } else if (player.location.y < height * 2) {
    for (Star star : starArray) {
      star.display();
    }
    
    for (Cloud cloud : cloudArray) {
      cloud.update();
      cloud.display();
    }
  } else if (player.location.y < height * 6) {
    for (Cloud cloud : cloudArray) {
      cloud.update();
      cloud.display();
    }
  } else {
    for (Blowfish fish : blowfish) {
      fish.update();
      fish.display();
    }
  }

  // player
  if (player.isInside(ocean)) {
    // trigger splash once upon hitting the ocean
    if (!hitOcean) {
      // player has no control
      player.no_controls = true;
      
      // update splash location to player location
      PVector splashLocation = player.location.get();
      splashLocation.add(new PVector(0, player.spaceship.h - 5));
      ocean.splash.update(splashLocation);
      
      // start that splash a happening
      ocean.splash.start();
      
      hitOcean = true;
      displaySplash = true;
    }
    player.drag(ocean); 
  }
  
  player.update();
  player.display();
  
  if (displaySplash) {
    ocean.splash.display();
    for (WaterParticle w : ocean.splash.waterParticles) {
      w.update();
    }
  }
  
  // check if player has hit bottom of ocean
  if (ocean.bottom - player.location.y <= 1) {
    displayGameover = true; 
  }
  
  // title and end screen
  if (displayTitle) {
    displayText("Shanny and Dannon\'s Snoog Adventure", titleTimer);
    titleTimer += 1.5;
  }
  
  if (displayGameover) {
    displayText("\n\n\nGAME OVER", gameoverTimer);
    gameoverTimer += 1.5;
  }
  // ------------ end drawing ------------

  popMatrix();
}
// ------------------ END MAIN ----------------------

//Keyboard input to move around
void keyPressed() {
  // if the player has started moving, clear title text
  displayTitle = false;
  
  force = new PVector(0, 0);
  if (!player.no_controls) {
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
  }

  force.normalize();
  force.mult(forceMag);
  player.applyForce(force);
}

// ---------------- Functions ------------------
void displayText(String words, float offset) {
  textFont(f);
  textSize(32);
  textAlign(CENTER);
  float max = offset;
  float t;
    
  while (offset > 0) {
    t = offset / max;
    fill(lerpColor(red, pink, t));
    text(words, player.location.x - (100 + offset), 
               player.location.y - (100 - offset),
               200,
               200); 
    offset -= 2;
  }
  
  fill(pink);
  text(words, player.location.x - 100, 
             player.location.y - 100,
             200,
             200); 
}

void drawBackground() {
  background(black);
  float worldbound_x = - (4 * 400);

  // gradient
  int subdivisionsPerUnit = 200;
  int subdivisionHeight = height / subdivisionsPerUnit;
  int buffer = 2;
  float normHeightIndex = 0;
  for (int i = 1 * height; i < 5 * height; i += subdivisionHeight) {
    normHeightIndex = (float(i) - height) / (4 * height);
    tempColor = lerpColor(black, skyBlue, normHeightIndex);
    noStroke();
    fill(tempColor);
    rect(worldbound_x, i - buffer, totalWidth, (height / subdivisionsPerUnit) + buffer);
  }  

  // sky blue below
  fill(skyBlue);
  rect(worldbound_x, 5 * height - buffer, totalWidth, height + buffer);

  // ocean
  ocean.display();
  
  // bottom of ocean
  fill(sand);
  rect(worldbound_x, 7.5 * height - buffer, totalWidth, height + buffer);
}

// --------------------- Classes ----------------------
// ----------------------------------------------------
class Player {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector gravity;
  float topSpeed;
  float mass;
  float[] worldBounds;
  boolean no_controls;
  SleepBar sleepbar;
  Spaceship spaceship;

  Player(float temp_mass, float[] temp_bounds) {
    location = new PVector(width / 2, height / 2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    topSpeed = 3;
    mass = temp_mass;
    worldBounds = temp_bounds;
    gravity = new PVector(0, 0.1 * mass);
    
    float[] worldBoundsSleepBar = {15  - (4 * 400), totalWidth - (width - 15),
                                   (-6 * height) + (height - 30), 8 * height - 30};
    sleepbar = new SleepBar(15, height - 30, 60, 10, worldBoundsSleepBar);
    spaceship = new Spaceship(width / 2, height / 2, 100, 50);
  }
  
  boolean isInside(Ocean o){
    if(location.x >= o.x && location.x <= o.w + o.x &&
       location.y >= o.y && location.y <= o.h + o.y){
      return true; 
    } else {
      return false;  
    }
  }

  void applyForce(PVector direction) {
    acceleration.add(direction);
  }
  
  void drag(Ocean o) {
    float speed = velocity.mag();
    float dragMag = o.c * speed * speed;
    PVector drag = velocity.get();
    drag.normalize();
    drag.mult(-1);
    
    drag.mult(dragMag);
    applyForce(drag);
  }
  
  void checkBounds() {
    if (location.x < worldBounds[0]) {
      location.x = worldBounds[0];
    } else if (location.x > worldBounds[1]) {
      location.x = worldBounds[1];
    } else if (location.y < worldBounds[2]) {
      location.y = worldBounds[2];
    } else if (location.y > worldBounds[3]) {
      location.y = worldBounds[3];
    }
  }

  void update() {
    // update player position
    if (no_controls) {
      topSpeed = 6;
      applyForce(gravity);
    }
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    location.add(velocity);
    checkBounds();

    // update sleepbar
    sleepbar.location.add(velocity);
    sleepbar.checkBounds();
    float sleep_value = sleepbar.update();
    no_controls = sleep_value == 1;

    // if sleepbar almost full
    if (sleep_value >= 0.7 && sleep_value < 1) {
      spaceship.displayText("so sleepy");
    }

    // if sleepbar full
    if (no_controls) {
      spaceship.snoogs[0].fellAsleep();
      spaceship.snoogs[1].fellAsleep();
    }

    // update spaceship
    spaceship.update(location);    

    // clear acceleration
    acceleration.mult(0);
  }

  void display() {
    // display spaceship
    spaceship.display();

    // display sleepbar
    sleepbar.display();
  }
}

class Spaceship {
  PVector location;
  float w, h;
  Snoog[] snoogs = new Snoog[2];

  Spaceship(float temp_x, float temp_y, float w_temp, float h_temp) {
    location = new PVector(temp_x, temp_y);
    w = w_temp;
    h = h_temp;
    snoogs[0] = new Snoog(location.x - 10, location.y - h * 0.3, 10, 10, red);
    snoogs[1] = new Snoog(location.x + 10, location.y - h * 0.3, 10, 10, pink);
  }

  void update(PVector pos) {
    location = pos;
    snoogs[0].update(pos.x - 10, pos.y - h * 0.3);
    snoogs[1].update(pos.x + 10, pos.y - h * 0.3);
  }

  void displayText(String words) {
    // white background, black outline
    fill(255);
    stroke(0);
    rect(location.x - 50, location.y + 50, 100, 30, 30);

    // text
    textFont(f);
    textSize(16);
    textAlign(CENTER);
    fill(0);
    text(words, location.x, location.y + 70);
  }

  void display() {
    // underneath
    stroke(100);
    strokeWeight(2);
    fill(100);
    ellipse(location.x, location.y + h * 0.15, w * 0.8, h * 0.6);

    // bottom
    stroke(100);
    fill(150);
    ellipse(location.x, location.y, w, h * 0.6);

    // snoog
    snoogs[0].display();
    snoogs[1].display();

    // top top
    noFill();
    stroke(225, 225, 225, 200);
    arc(location.x, location.y - h * 0.1, w * 0.5, h * 1.1, 3.14, 2 * 3.14);

    fill(225, 225, 225, 70);
    arc(location.x, location.y - h * 0.1, w * 0.5, h * 1.1, 3.14, 2 * 3.14);

    // top bottom
    noFill();
    stroke(225, 225, 225, 200);
    arc(location.x, location.y - h * 0.43, w * 0.69, h * 0.9, 0.76, 2.37);

    fill(225, 225, 225, 70);
    arc(location.x, location.y - h * 0.43, w * 0.69, h * 0.9, 0.76, 2.37);
  }
}

class Snoog {
  PVector location;
  float w, h;
  color c;
  float blink_timer;
  float time_until_next_blink;
  boolean blink_open;
  boolean time_to_blink;
  boolean asleep;

  Snoog(float temp_x, float temp_y, float temp_w, float temp_h, color temp_c) {
    location = new PVector(temp_x, temp_y);
    w = temp_w;
    h = temp_h;
    c = temp_c;
    time_until_next_blink = random(2);
    blink_timer = 1;
    blink_open = false;
    time_to_blink = false;
    asleep = false;
  }

  void fellAsleep() {
    asleep = true;
  }  

  void update(float pos_x, float pos_y) {
    location.x = pos_x;
    location.y = pos_y;

    // blink eyes sometimes
    if (time_to_blink) {
      if (blink_open) {
        blink_timer += 0.08;
        if (blink_timer > 1) {
          blink_open = false;
          blink_timer = 1;
          time_to_blink = false;  // done blinking
          time_until_next_blink = random(5); // reset for next blink
        }
      } else {
        blink_timer -= 0.08;
        if (blink_timer < 0.4) {
          blink_open = true;
          blink_timer = 0.4;
        }
      }
    } else {
      time_until_next_blink -= 0.016;
      if (time_until_next_blink < 0) {
        time_to_blink = true;
      }
    }
  }

  void display() {
    // torso 
    noStroke();
    fill(c);
    ellipse(location.x, location.y, w, h);
    rectMode(CENTER);
    rect(location.x, location.y + h / 2, w, h);
    rectMode(CORNER);

    // eyes
    fill(0);

    if (asleep) {
      blink_timer = 0.35;
    }
    ellipse(location.x - w / 4, location.y, w /4, (h / 4) * blink_timer);
    ellipse(location.x + w / 4, location.y, w /4, (h / 4) * blink_timer);
  }
}

class SleepBar {
  PVector location;
  float value;       // between 0 and 1
  float w, h;
  float[] worldBounds;

  SleepBar(float temp_x, float temp_y, float w_temp, float h_temp, float[] temp_bounds) {
    location = new PVector(temp_x, temp_y);
    w = w_temp;
    h = h_temp;
    value = 0;
    worldBounds = temp_bounds;
  }
  
  void checkBounds() {
    if (location.x < worldBounds[0]) {
      location.x = worldBounds[0];
    } else if (location.x > worldBounds[1]) {
      location.x = worldBounds[1];
    } else if (location.y < worldBounds[2]) {
      location.y = worldBounds[2];
    } else if (location.y > worldBounds[3]) {
      location.y = worldBounds[3];
    }
  }

  float update() {
    // 60 fps, approximately 16.6 seconds of time
    value += 0.001;
    // value += 0.01; // for testing
    value = min(value, 1);
    return value;
  }

  void display() {    
    // fill value red
    noStroke();
    fill(red);
    rect(location.x, location.y, w * value, h);

    // white outline
    stroke(255);
    noFill();
    strokeWeight(2);
    rect(location.x, location.y, w, h);

    // black outline
    stroke(0);
    strokeWeight(1.5);
    rect(location.x, location.y, w, h);
    strokeWeight(1);
  }
}

// ---------------------- Background Classes ----------------------
// fish
class Blowfish{
  PVector location;
  PVector velocity;  
  float ballDiam;
  
  Blowfish(float temp_x, float temp_y, float temp_size){
    ballDiam = temp_size;
    location = new PVector(temp_x, temp_y);
    velocity = new PVector(random(2), 0);
  }
  
  void update(){
    location.add(velocity);
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
    ellipse(location.x + ballDiam / 6, location.y - ballDiam / 6, 2, 2);
    ellipse(location.x + 2 * ballDiam / 6, location.y - ballDiam / 6, 2, 2);
  }
}
  
class Ocean {
  float x, y, w, h;
  float c;  // coefficient of friction(?)
  float bottom; 
  color col;
  color dark_col;
  Splash splash;

  Ocean(float temp_x, float temp_y,
        float temp_w, float temp_h,
        float temp_c, color temp_col, color temp_dark_col) {
    x = temp_x;
    y = temp_y;
    w = temp_w;
    h = temp_h;
    c = temp_c;
    bottom = y + h - (height / 2);
    col = temp_col;
    dark_col = temp_dark_col;
    splash = new Splash(0, 0, col, 100);
  }

  void display() {    
    // gradient
    int subdivisionsPerUnit = 200;
    int subdivisionHeight = int(height / subdivisionsPerUnit);
    int buffer = 2;
    float normHeightIndex = 0;
    for (int i = int(y); i < y + h; i += subdivisionHeight) {
      normHeightIndex = (float(i) - y) / h;
      tempColor = lerpColor(col, dark_col, normHeightIndex);
      noStroke();
      fill(tempColor);
      rect(x, i - buffer, w, subdivisionHeight + buffer);
    } 
  }
}

class Splash {
  PVector location;
  color col;
  WaterParticle[] waterParticles;
  int numParticles;
 
  Splash(float temp_x, float temp_y, color temp_col, int temp_numParticles) {
    location = new PVector(temp_x, temp_y);
    col = temp_col;
    waterParticles = new WaterParticle[temp_numParticles];
    numParticles = temp_numParticles;
  }
  
  void update(PVector pos) {
    location = pos;
  }
  
  void start() {
    // create water particles
    for (int i = 0; i < numParticles; i++) {
      // random colors from white to ocean blue
      color randomColor = lerpColor(white, col, random(0.75, 1));
      waterParticles[i] = new WaterParticle(location.x + random(-20, 20), 
                                            location.y + random(-10, 10), 
                                            random(2, 20),
                                            4,
                                            randomColor); 
    }
    
    // blast them up
    PVector f;
    for (WaterParticle w : waterParticles) {
      // vary direction
      float x = random(-5, 5);
      float y = random(-5, -1);
      f = new PVector(x, y);
      
      w.applyForce(f);
    } 
  }
  
  void display() {    
    for (WaterParticle w : waterParticles) {
      w.display();
    } 
  }
}

class WaterParticle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector gravity;
  float size;
  float mass;
  color col;
  
  WaterParticle(float temp_x, float temp_y, float temp_size, float temp_mass, color temp_col) {
    location = new PVector(temp_x, temp_y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    gravity = new PVector(0, 0.1 * mass);
    size = temp_size;
    mass = temp_mass;
    col = temp_col;
  }
  
  void applyForce(PVector force) {
     PVector f = PVector.div(force, mass);
     acceleration.add(f);
  } 
  
  void update() {
    applyForce(gravity);
    
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display() {
    noStroke();
    fill(col);
    ellipse(location.x, location.y, size, size);
  }
}

class Star {
  PVector loc; // location
  float s; // size

  Star(float x_temp, float y_temp, float size_temp) {
    loc = new PVector(x_temp, y_temp);
    s = size_temp;
  }

  void display() {
    strokeWeight(0.8);
    stroke(255);
    line(loc.x - (s * 0.5), loc.y, loc.x + (s * 0.5), loc.y);
    line(loc.x, loc.y  - (s * 0.5), loc.x, loc.y  + (s * 0.5));
    line(loc.x - (s * 0.7 * 0.5), loc.y - (s * 0.7 * 0.5), loc.x + (s * 0.7 * 0.5), loc.y + (s * 0.7 * 0.5));
    line(loc.x - (s * 0.7 * 0.5), loc.y + (s * 0.7 * 0.5), loc.x + (s * 0.7 * 0.5), loc.y - (s * 0.7 * 0.5));
  }
}

class Cloud {
  PVector location;
  PVector velocity;
  float w, h;
  CloudPuff[] puffArray = new CloudPuff[10];

  Cloud(float x_temp, float y_temp, float w_temp, float h_temp) {
    location = new PVector(x_temp, y_temp);     
    velocity = new PVector(random(-0.8, -0.2), 0);

    w = w_temp;
    h = h_temp;
    for (int i = 0; i < 10; i++) {
      PVector variedLocation = new PVector(location.x + int(random(w - 5)), 
      location.y + int(random(20 - i)));
      float variedWidth = w * random(0.5, 0.75);
      float variedHeight = h * random(0.5, 0.75);
      puffArray[i] = new CloudPuff(variedLocation, 
      velocity, 
      variedWidth, 
      variedHeight);
    }
  }

  void update() {
    for (CloudPuff puff : puffArray) {
      puff.location.add(velocity);
    }
  }

  void display() {
    noStroke();
    fill(softWhite);
    for (CloudPuff puff : puffArray) {
      puff.display();
    }
  }
}

class CloudPuff {
  PVector location;
  PVector velocity;
  float w, h;

  CloudPuff(PVector loc_temp, PVector vel_temp, float w_temp, float h_temp) {
    location = new PVector(loc_temp.x, loc_temp.y);
    velocity = vel_temp;
    w = w_temp;
    h = h_temp;
  }

  void display() {
    ellipse(location.x, location.y, w, h);
  }

  void checkEdges() {
    // only need to check horizontal edge
    if (location.x > totalWidth + w/2) {
      location.x = -w / 2;
    } else if (location.x < 0 - w/2) {
      location.x = totalWidth + w/2;
    }
  }
}

