int hue;

void setup(){
  size(400, 400);
  colorMode(HSB);
  background(0);
  noStroke();
}

void draw(){
  cantor(10, 40, width-20, true);
  cantor(10, height-40, width-20, false);
}

void cantor(float x, float y, float len, boolean goingDown){

  if(len >= 1){
    //to fix small length pixel error
    if(len <= 4){
      len = floor(len);  
    }
    hue = int(map(abs(y - height/2), 40, height/2, 50, 200));
    fill(hue, 255, 255);
    rect(x, y, len, 10); 
    
    if(goingDown){
      y+=20;
    } else {
      y-=20;  
    }
    cantor(x, y, len/3, goingDown); 
    cantor(x + len*2/3, y, len/3, goingDown); 
  }
}

void invCantor(float x, float y, float len){
  if(len >= 1){
    //to fix small length pixel error
    if(len <= 4){
      len = floor(len);  
    }
    rect(x, y, len, 10);  
    y-=20;
    invCantor(x, y, len/3); 
    invCantor(x + len*2/3, y, len/3); 
  }
}
