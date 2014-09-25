int boxSize = 1;
int WIDTH = 400;
CA ca;

void setup(){
  size(WIDTH, 200);
  background(255);
  ca = new CA();
}

void draw(){
  if(ca.generation < (WIDTH / boxSize)){
    ca.display();
    ca.generate();
  }
}

//press space to reset
void keyPressed(){
  if(keyCode == ' '){
    background(255);
    ca.cells = new int[width/boxSize];
    ca.cells[ca.cells.length/2] = 1;
    ca.generation = 0;
  }  
}

class CA {
  int[] cells;
  int[] ruleset = {0,1,0,1,1,0,1,0};
  int generation = 0;
  int  cols = width/boxSize;
  
  CA() {
    cells = new int[cols];
    cells[cells.length/2] = 1;
  }
  
  //ignores edge cases
  void generate(){
    int[] nextGen = new int[cells.length];
    for(int i = 1; i < cols-1; i++){
      int left = cells[i-1];
      int middle = cells[i];
      int right = cells[i+1];
      nextGen[i] = rules(left, middle, right);
    }
    cells = nextGen;
    generation++;
  }
   
  int rules(int a, int b, int c){
    return ruleset[4*a + 2*b + 1*c];
  }
  
  void display(){
    for(int i = 0; i < cells.length; i++){
      if(cells[i] == 0){
        fill(255);  
      } else {
        fill(0);  
      }
      noStroke();
      rect(i*boxSize, generation*boxSize, boxSize, boxSize);
    }
  }
}
