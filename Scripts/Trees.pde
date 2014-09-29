float pi = 3.14159;
float theta;
int branchFactor;
float minBranchLength;

void setup() {
  size(400, 400);
  background(255);
}

void draw() {
  background(205, 246, 250);
  translate(width/2, height);
  
  theta = map(mouseX, 0, width, 0, pi/2);
  branchFactor = floor(map(mouseY, 0, height, 2, 8));
  minBranchLength = branchFactor + 2*(branchFactor-2);

  branch(100, theta, branchFactor);
}

void branch(float len, float theta, int bFactor) {
  //if the next branch is out of bounds, it's a green leaf
  if (len*0.66 <= minBranchLength) {
    stroke(0, 200, 0);
  } else {
    stroke(59, 29, 9);
  }
  strokeWeight(map(len, 0, 100, 1, 5));

  //draw branch
  line(0, 0, 0, -len);
  translate(0, -len);
  len *= 0.66;

  if (len > minBranchLength) {
      float anglePartition = 2*theta/(bFactor-1);
      float offset = bFactor % 2 == 1 ? 1 : 0.5;
      int half = bFactor % 2 == 1 ? (bFactor-1)/2 : bFactor/2;
      //right side
      for (int i = 0; i < half; i++) {
        pushMatrix();
        rotate(anglePartition*(i+offset));
        branch(len, theta, bFactor);
        popMatrix();
      }
      //middle, only for odd numbered branching factor
      if(bFactor % 2 == 1){
        pushMatrix();
        branch(len, theta, bFactor);
        popMatrix();
      }
      //left side
      for (int i = 0; i < half; i++) {
        pushMatrix();
        rotate(-anglePartition*(i+offset));
        branch(len, theta, bFactor);
        popMatrix();
      }
  }
}

