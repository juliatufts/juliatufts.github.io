int WIDTH = 400;
int HEIGHT = 400;
int SQUARE_SIZE = 80;
Square[] squareArray = new Square[9];

void setup(){
  size(WIDTH, HEIGHT);
  int index = 0;
  int sqColorR = 255;
  int sqColorG = 0;
  int sqColorB = 0;
  for(int y = SQUARE_SIZE; y < height; y += 3*SQUARE_SIZE/2){
    for(int x = SQUARE_SIZE; x < width; x += 3*SQUARE_SIZE/2){
      if(y % SQUARE_SIZE == 0){
        sqColorG = (x % SQUARE_SIZE == SQUARE_SIZE/2) ? 255 : 0;
      } else {
        sqColorG = (x % SQUARE_SIZE == SQUARE_SIZE/2) ? 0 : 255;
      }
      squareArray[index] = new Square(x, y, sqColorR, sqColorG, sqColorB);
      index++;
    }
  }
}

void draw(){
  background(255);
  smooth();
  noStroke();
  int alpha = 120;

  for(Square square: squareArray){
    pushMatrix();
      translate(square.location.x, square.location.y);
      rotate(radians(frameCount));
      square.displayAtOrigin(0, 0, 0, 255);
      pushMatrix();
        rotate(radians(frameCount));
        square.displayAtOrigin(square.R, square.G, square.B, alpha);
        pushMatrix();
          rotate(radians(frameCount));
          square.displayAtOrigin(square.B, square.R, square.G, alpha);
          pushMatrix();
            rotate(radians(frameCount));
            square.displayAtOrigin(square.G, square.B, square.R, alpha);
          popMatrix();
        popMatrix();
      popMatrix();
    popMatrix();
  }
}

class Square{
  PVector location;
  int R, G, B;
  
  Square(float x, float y, int r, int g, int b){
     location = new PVector(x, y);
     R = r;
     G = g;
     B = b;
  }  
  
  void displayAtOrigin(int r, int g, int b, int a){
    rectMode(CENTER);
    fill(r, g, b, a);
    rect(0, 0, SQUARE_SIZE, SQUARE_SIZE);  
  }
}
