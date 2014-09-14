color red = color(255, 0, 0);
Curve[] curveArray;
int hue = 0;
boolean moving = true;

void setup() {
  size(400, 400);
  colorMode(HSB);
  curveArray = new Curve[int(height/55)];
  for(int i = 0; i < curveArray.length; i++){
    curveArray[i] = new Curve(0, 35 + i*55);  
  }
}

void draw() {
  background(0);
  for(int i = 0; i < curveArray.length; i++){
    if(moving){
      curveArray[i].update();
    }
    curveArray[i].display((hue + i*40) % 255);
  }
  hue = (hue + 10) % 255;
}

void keyPressed(){
  if(keyCode == ' '){
    moving = !moving; 
  }  
}

class Curve {
  PVector startPoint;
  int numVertices;
  float[][] vertexArray;
  float x, y;

  Curve(float tempx, float tempy) {
    numVertices = 20;
    vertexArray = new float[numVertices][6];
    startPoint = new PVector(tempx, tempy);
    float flip = 1;

    for (int i = 0; i < vertexArray.length; i++) {
      vertexArray[i][0] = startPoint.x + i*20;
      vertexArray[i][1] = startPoint.y - flip*25;
      vertexArray[i][2] = startPoint.x + (i+1)*20;
      vertexArray[i][3] = startPoint.y - flip*25;
      vertexArray[i][4] = startPoint.x + (i+1)*20;
      vertexArray[i][5] = startPoint.y;
      flip *= -1;
    }
  }

  void update() {
   float flip = 1;
   for (int i = 0; i < vertexArray.length; i++) {
      vertexArray[i][0] = lerp(startPoint.x + i*20, startPoint.x + (i+1)*20, sin(10*millis()/1000));
      vertexArray[i][1] = lerp(startPoint.y - flip*25, startPoint.y - flip*50, sin(10*millis()/1000));
      vertexArray[i][2] = lerp(startPoint.x + (i+1)*20, startPoint.x + (i+2)*20, sin(10*millis()/1000));
      vertexArray[i][3] = startPoint.y - flip*25;
      vertexArray[i][4] = startPoint.x + (i+1)*20;
      vertexArray[i][5] = startPoint.y;
      flip *= -1;
    }
  }

  void display(int hue) {
    noFill();
    strokeWeight(3);
    stroke(hue, 255, 255);
    beginShape();
    vertex(startPoint.x, startPoint.y);
    for (int i = 0; i < vertexArray.length; i++) {
      bezierVertex(vertexArray[i][0], vertexArray[i][1], vertexArray[i][2], vertexArray[i][3], vertexArray[i][4], vertexArray[i][5]);
    }
    endShape();
  }
}


