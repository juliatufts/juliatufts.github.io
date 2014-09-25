int boxSize = 10;
int WIDTH = 400;
int columns = WIDTH / boxSize;
int rows = WIDTH / boxSize;
int[][] board = new int[columns][rows];

void setup() {
  size(WIDTH, WIDTH);
  background(255);
  frameRate(8);
  
  //initialize grid
  for (int x = 0; x < columns; x++) {
    for (int y = 0; y < rows; y++) {
      board[x][y] = int(random(2));
    }
  }
}

void draw() {
  //draw a black box if it's alive / else white
  for (int i = 0; i < columns; i++) {
    for (int j = 0; j < rows; j++) {
      if (board[i][j] == 1) {
        fill(0);
      } else {
        fill(255);
      }
      stroke(0);
      rect(i*boxSize, j*boxSize, boxSize, boxSize);
    }
  }
  //generate
  generate();
}

void generate() {
  int[][] nextBoard = new int[columns][rows];
  for (int x = 1; x < columns-1; x++) {
    for (int y = 1; y < rows-1; y++) {
      //count neighbors
      int neighborCount = 0;
      for(int i = -1; i <= 1; i++){
        for(int j = -1; j <= 1; j++){
          neighborCount += board[x+i][y+j];
        }
      }
      //subtract self
      neighborCount -= board[x][y];
      if(neighborCount > 0){
      }
      //update nextBoard accordingly
      //if it's alive / else if it's dead
      if(board[x][y] == 1){
        if(neighborCount < 2 || neighborCount > 3){
          nextBoard[x][y] = 0;  
        } else {
          nextBoard[x][y] = 1;    
        }
      } else if(board[x][y] == 0){
        if(neighborCount == 3){
          nextBoard[x][y] = 1; 
        }
      }
    }
  }
  board = nextBoard;
}

//press space to reset
void keyPressed() {
  if (keyCode == ' ') {
    background(255);
    //reset
    for (int x = 0; x < columns; x++) {
      for (int y = 0; y < rows; y++) {
        board[x][y] = int(random(2));
      }
    }
  }
}

