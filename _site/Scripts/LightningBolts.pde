Bolt[] boltArray;
float SPEED = 8;
color black;
color yellow;

void setup() {
  size(400, 400);
  background(0);
  boltArray = new Bolt[15*8];
  black = color(0);
  yellow = color(255, 255, 0);

  int index = 0;
  for(int y = 5; y < height-10; y+=50){
    for(int x = 5; x < width-20; x+=26){
        boltArray[index] = new Bolt(x, y);
        index++;
    }
  }
  //make sure last flash is black, and slowest
  boltArray[boltArray.length-1].timer = 0;
  boltArray[boltArray.length-1].flash = black;
}

void draw() {
  for(Bolt bolt: boltArray){
    bolt.display();
    if(bolt.timer >= SPEED){
      bolt.update();
      bolt.timer = 0;
    }
    bolt.timer++;
  }
}

class Bolt {
  PVector location;
  int[][] animationArray = {{0, 0, 0, 0},
                            {0, 0, 10, 10},
                            {0, 10, 10, 10}, 
                            {10, 12, 8, 8}, 
                            {10, 20, 8, 8}, 
                            {16, 22, 6, 6}, 
                            {16, 28, 6, 6}, 
                            {20, 30, 4, 4}, 
                            {20, 34, 4, 4}, 
                            {20, 38, 4, 4},
                            {22, 42, 2, 2}};
  int animIndex;
  float timer;
  color flash;

  Bolt(float x, float y) {
    location = new PVector(x, y);
    animIndex = 0;
    timer = random(SPEED);
    if(random(1) < 0.5){
      flash = black;
    } else {
      flash = yellow;
    }
  }  

  void display() {
    fill(255, 255, 0);
    noStroke();
    for(int i = 0; i < animIndex; i++){
      rect(location.x + animationArray[i][0], 
           location.y + animationArray[i][1],
           animationArray[i][2],
           animationArray[i][3]);
    }
  }

  void update() {
    animIndex = (animIndex + 1) % animationArray.length;
    if(animIndex == animationArray.length-1){
      if(random(1) < 0.5){
        background(flash);
      } else {
        background(flash);
      }
      animIndex = 0;  
    }
  }
}

