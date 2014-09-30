float pi = 3.14159;
float theta;
float startx;
float starty;
float l;
float MAX_LENGTH = 110;
int numTrees = 3;

void setup() {
  size(400, 400);
  drawBackground();
  generateForest(numTrees);
}

void draw() {

}

void mousePressed(){
  drawBackground();
  generateForest(numTrees);
}

void generateForest(int n){
    //center tree
    pushMatrix();
    translate(width/2, 4*height/5); 
    branch(MAX_LENGTH);
    popMatrix();
    
    for(int i = 0; i < n; i++){
      pushMatrix();
      float offset = i % 2 == 1 ? width/(2*n) : -width/(2*n);
      startx = width/2 + i*offset;
      starty = random(2*height/3 + 10, 4*height/5);
      translate(startx, starty);
      l = random(20, MAX_LENGTH - 40);  
      branch(l);
      popMatrix();
    }
}

void branch(float len) {
  stroke(0);
  strokeWeight(map(len, 0, MAX_LENGTH, 1, 5));

  //draw branch
  line(0, 0, 0, -len);
  translate(0, -len);
  len *= random(0.6, 0.75);

  int n = int(random(1, 4));
  if (len > 2) {
      len *= random(0.9, 1);
      theta = random(-pi/2, pi/2);
      for (int i = 0; i < n; i++) {
        pushMatrix();
        rotate(theta);
        branch(len);
        popMatrix();
      }
  }
}

void drawBackground(){
    //background(25, 25, 112);
    background(230, 220, 244);
    noStroke();
    
    //dark green hill
    fill(0, 60, 0);
    float y = 2*height/3;
    beginShape();
    vertex(0, height);
    vertex(0, y);
    bezierVertex(50, y - 15, 70, y - 5, 100, y + 5);
    bezierVertex(190, y + 10, 160, y + 20, 190, y);
    vertex(width, y-50);
    vertex(width, height);
    endShape();  
    
    //black hill
    fill(0);
    y = 3*height/4;
    beginShape();
    vertex(0, height);
    vertex(0, y);
    bezierVertex(100, y - 15, 110, y - 5, 120, y + 5);
    bezierVertex(80, y + 10, 160, y + 20, 200, y + 10);
    bezierVertex(230, y - 10, 260, y + 5, 320, y);
    vertex(width, y-10);
    vertex(width, height);
    endShape();  
}
