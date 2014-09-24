int speed = 80;
float ballDiam = 10;
PVector location = new PVector(20, 18);

void setup()
{
  size(400,400);
  background(25, 25, 112);
  fill(100);
  rect(width-10, height-20, 10, 20);
  float maxScale = 5;
  
  //stars
  for(int i = 0; i < 50; i++){
    fill(255, 255, 0);
    ellipse(random(width), random(height), 3, 3);  
  }
  
  //light beam
  for(int i = 0; i < 50; i++){
    float scaleAmt = map(i, 0, 49, 0, 1);
    pushMatrix();
    translate(-10, -10);
    translate(width - 0.9*scaleAmt*width, height - 0.9*scaleAmt*height);
    scale(scaleAmt*maxScale);
    
    fill(255);
    stroke(255);
    ellipse(20, 20, 40, 40);
    
    popMatrix();
  }
}

void draw(){
  float scaleAmt = map(frameCount % speed, 0, speed - 1, 0, 1);
  float maxScale = 5;
  pushMatrix();
  translate(-10, -10);
  translate(width - 0.9*scaleAmt*width, height - 0.9*scaleAmt*height);
  scale(scaleAmt*maxScale);
  
  /*
  fill(255);
  stroke(255);
  ellipse(20, 20, 40, 40);
  */
  //heart
  noStroke();
  fill(255, 0, 0);
  ellipse(location.x - ballDiam/2.1, location.y, ballDiam, ballDiam); 
  ellipse(location.x + ballDiam/2.1, location.y, ballDiam, ballDiam);
  beginShape();
  vertex(location.x - 0.96*ballDiam, location.y + ballDiam/6);
  vertex(location.x, location.y + 4*ballDiam/3);
  vertex(location.x + 0.96*ballDiam, location.y + ballDiam/6);
  endShape();
  
  popMatrix();
  
  pushMatrix();
  translate(-10, -10);
  float scaleAmt2 = map((frameCount + speed/2) % speed, 0, speed - 1, 0, 1);
  translate(width - 0.9*scaleAmt2*width, height - 0.9*scaleAmt2*height);
  scale(scaleAmt2*maxScale);
  
  fill(255);
  stroke(255);
  ellipse(20, 20, 40, 40);
  //heart
  noStroke();
  fill(255, 0, 0);
  ellipse(location.x - ballDiam/2.1, location.y, ballDiam, ballDiam); 
  ellipse(location.x + ballDiam/2.1, location.y, ballDiam, ballDiam);
  beginShape();
  vertex(location.x - 0.96*ballDiam, location.y + ballDiam/6);
  vertex(location.x, location.y + 4*ballDiam/3);
  vertex(location.x + 0.96*ballDiam, location.y + ballDiam/6);
  endShape();
  
  popMatrix();
  
}
