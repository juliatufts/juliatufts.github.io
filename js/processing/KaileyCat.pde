/* @pjs preload="/js/processing/Resources/KaileyCat.png, /js/processing/Resources/KaileyCatLungs.png"; 
   font="/js/processing/Resources/Minecraftia.ttf"; */ 
PImage background;
PImage lungs;
int epsilon = 6;
boolean isWinning = false;
Confetti[] ConfettiArray = new Confetti[16 * 16];
int hue = 0; 

void setup() {
  size(512, 512);
  background = loadImage("/js/processing/Resources/KaileyCat.png");
  lungs = loadImage("/js/processing/Resources/KaileyCatLungs.png");
  colorMode(HSB);
  textFont(createFont("/js/processing/Resources/Minecraftia.ttf", 64));
  
  //initialize confetti
  for(int i = 0; i < 16; i++){
    for(int j = 0; j < 16; j++){
      ConfettiArray[(i * 16) + j] = 
        new Confetti(i*32 + 8, j*32 + 8, 2, 1);
    }
  }
}

void draw() {
  // Draw the image to the screen at coordinate (0,0)
  image(background, 0, 0);
  if(!isWinning) {
    image(lungs, mouseX-256, mouseY-300);
  } else {
    image(lungs, 0, 0);
    
    for(Confetti c: ConfettiArray){
      c.move();
      c.display(hue);
    }
    hue = ((hue + 10) % 255); 
    
    textAlign(CENTER);
    fill(hue, 255, 255);
    text("HAPPY", width/2, height/2 - 50); 
    text("BIRTHDAY", width/2, height/2 + 35); 
    text("KAILEY", width/2, height/2 + 120);  
  }
}

void mouseClicked() {
  if(abs(mouseX - 256) < epsilon && abs(mouseY - 300) < epsilon) {
    isWinning = true;
  }
}

class Confetti {
  float startx;
  float starty;
  float x;
  float y;
  float yspeed;
  float xspeed;

  Confetti(float tempX, float tempY, float ytempSpeed, float xtempSpeed) {
    startx = tempX;
    starty = tempY; 
    x = tempX;
    y = tempY;  
    yspeed = ytempSpeed;
    xspeed = xtempSpeed;
  }

  void move() {
    //move downwards
    if(y >= height) {
      y = 0;
    } else {
      y += yspeed;
    }
    
    //move left and right
    if(x > (startx + 8) || x < (startx - 8)){
      xspeed = -xspeed;  
    }
    x += xspeed;
  }

  void display(int h) {
    noStroke();
    fill(h, 255, 255);
    rect(x, y, 5, 10);
  }
}
