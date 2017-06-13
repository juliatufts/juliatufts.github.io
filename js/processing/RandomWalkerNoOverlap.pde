Walker w;
int boxSize = 10;
int screenWidth = 400;
int screenHeight = 400;
int hue = 0;
int[][] screenGrid = new int[screenWidth/boxSize + 1][screenHeight/boxSize + 1];
int screenGridCounter = (screenWidth/boxSize + 1) * (screenHeight/boxSize + 1);

void setup(){
  size(screenWidth, screenHeight);
  w = new Walker();
  background(255);
  colorMode(HSB);
  
  //initialize grid of screen blocks
  for(int j=0; j<screenHeight/boxSize + 1; j++){
    for(int i=0; i<screenWidth/boxSize + 1; i++){
      screenGrid[i][j] = 0;
    }
  }
}

void draw(){
  if(screenGridCounter > 0){
    w.step();
    w.display(hue);
    hue = (hue + 1) % 255;
  }
}

class Walker{
  int x;
  int y;
  
  Walker(){
    x = width/2;
    y = height/2;
  }
  
  void display(color c){
    stroke(c, 255, 255);
    fill(c, 255, 255);
    rect(x, y, boxSize, boxSize);  
  }
  
  void step(){
    int[] currentGridIndex = new int[2];
    currentGridIndex = screenCoordToGrid(x, y);
    do {
      tryStep();
      currentGridIndex = screenCoordToGrid(x, y);
    } while(screenGrid[currentGridIndex[0]][currentGridIndex[1]] == 1);
    
    //update screen grid
    screenGrid[currentGridIndex[0]][currentGridIndex[1]] = 1;
    screenGridCounter--;
  }
  
  void tryStep(){
    int choice = int(random(4));

    if(choice == 0 && x < width - 1){
       x += boxSize;
    } else if(choice == 1 && x > 0){
       x -= boxSize;
    } else if(choice == 2 && y < height - 1){
       y+= boxSize;
    } else if(y > 0) {
       y -= boxSize;
    } 
  }
}

int[] screenCoordToGrid(int x, int y){
  int[] gridIndex = new int[2];
  gridIndex[0] = x/boxSize;
  gridIndex[1] = y/boxSize;
  return gridIndex;
}
