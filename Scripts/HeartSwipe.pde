Heart heart;
Heart heart2;
Heart[] heartArray = new Heart[12];
PVector center;
PVector zero = new PVector(0, 0);
color red;
color pink;
color lightBlue;
float timerHeart = 0;
int maxLength = 1;
int timer = 0; 

void setup(){
  size(400, 400); 
  lightBlue = color(30, 143, 242);
  red = color(255, 0, 0);
  pink = color(255, 160, 160);
  
  center = new PVector(width/2, height/2 - 50);
  color tempCol;
  for(int i = 0; i < heartArray.length; i++){
    tempCol = (i % 2) == 0 ? red : pink;
    heartArray[i] = new Heart(center.get(), 3, 0, tempCol);
    //center 
    heartArray[i].location.y += i*5;
  }
}

void draw(){
  //Background
  background(pink);

  for(int i = 0; i < maxLength; i++){
    heartArray[i].update();
    heartArray[i].display();
  }
  
  if(timer > 40){
    int temp = ++maxLength;
    maxLength = min(temp, heartArray.length);
    timer = 0;
    
    for(int i = 0; i < maxLength; i++){    
      //if the heart is off the screen
      //reset and push to back of array
      if(heartArray[i].ballDiam > width * 3.5){
        heartArray[i].ballDiam = 0;
        Heart tempHeart = heartArray[i];
        for(int j = 1; j < heartArray.length; j++){
          heartArray[j-1] = heartArray[j]; 
        }
        heartArray[heartArray.length-1] = tempHeart;
      }
    }
  }
  timer++;
}

class Heart{
  PVector location;
  float sizeVelocity;
  float topSpeed;
  float ballDiam; 
  color c;
  
  Heart(PVector tempLoc, float tempSizeVel, float tempBallDiam, color tempc){
    location = tempLoc;
    sizeVelocity = tempSizeVel;
    ballDiam = tempBallDiam;
    c = tempc;
  }
  
  void update(){
    ballDiam += sizeVelocity;
  }
  
  void display(){
    noStroke();
    fill(c);
    ellipse(location.x - ballDiam/2.1, location.y, ballDiam, ballDiam); 
    ellipse(location.x + ballDiam/2.1, location.y, ballDiam, ballDiam);
    beginShape();
    vertex(location.x - ballDiam*0.93, location.y + 1.8*ballDiam/8);
    vertex(location.x, location.y + 4*ballDiam/3);
    vertex(location.x + ballDiam*0.93, location.y + 1.8*ballDiam/8);
    vertex(location.x, location.y - ballDiam/8);
    endShape();
  }
}
