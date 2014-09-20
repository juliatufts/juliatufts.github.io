int WIDTH = 400;
int HEIGHT = 400;
int BOX_SIZE = 20;
int[][] gridArray = new int[((WIDTH+2*BOX_SIZE)*HEIGHT)/(BOX_SIZE*BOX_SIZE)][2];

void setup(){
  size(400, 400);
  
  //initialize gridArray
  int index = 0;
  for(int y = 0; y < HEIGHT; y += BOX_SIZE){
    for(int x = 0; x < WIDTH + 2*BOX_SIZE; x += BOX_SIZE){
      gridArray[index][0] = x;
      gridArray[index][1] = y;  
      index++;
    }
  }
}

void draw(){
  background(255);
  moveGrid(1);
  checkEdges();
  drawGrid();
}

void moveGrid(int value){
  for(int i = 0; i < gridArray.length; i++){
    //if y position is even
    if((gridArray[i][1]/BOX_SIZE % 2) == 0){
      gridArray[i][0] += value;
    } else {
      gridArray[i][0] -= value;
    }
  }
}

void checkEdges(){
  for(int i = 0; i < gridArray.length; i++){
    //if y position is even
    if((gridArray[i][1]/BOX_SIZE % 2) == 0){
      if(gridArray[i][0] >= width + BOX_SIZE){
        gridArray[i][0] = -BOX_SIZE;
      }
    } else {
      if(gridArray[i][0] <= -BOX_SIZE){
        gridArray[i][0] = width + BOX_SIZE;
      }
    }
  }
}

void drawGrid(){
  noStroke();
  for(int i = 0; i < gridArray.length; i++){
    //if y position is even
    if((gridArray[i][1]/BOX_SIZE % 2) == 0){
      //alternate black and white
      int col = (i % 2) == 0 ? 0 : 255;
      fill(col);
    } else {
      //else alternate white and black
      int col = (i % 2) == 1 ? 0 : 255;
      fill(col);
    }
    rect(gridArray[i][0], gridArray[i][1], BOX_SIZE, BOX_SIZE);
  }  
}
