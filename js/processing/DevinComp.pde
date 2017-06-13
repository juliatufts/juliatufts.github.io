/* @pjs preload="/js/processing/Resources/DevinComp.png"; 
   font="/js/processing/Resources/Minecraftia.ttf"; */ 
PImage backgroundComp;
int screenStartX = 94;
int screenStartY = 81;
int screenWidth = 220;
int screenHeight = 160;
int boxSize = 10;
int screenGridCounter = (screenWidth/boxSize + 1) * (screenHeight/boxSize + 1);
Prompt[] promptArray = new Prompt[screenWidth/boxSize * screenHeight/boxSize];
int promptIndex = 0;
int[][] KEYS = new int[50][2];
int[] keyArray = new int[50];  //if key i is pressed, keyArray[i] = 1
int[] keyColor = new int[50];
int lastHue = 0;

boolean isWinning = false;
int screenHue = 0;
int hue = 0;
int sat = 255;
int brt = 255;
Prompt prompt;

void setup() {
  size(400, 400);
  backgroundComp = loadImage("/js/processing/Resources/DevinComp.png");
  colorMode(HSB);
  textFont(createFont("/js/processing/Resources/Minecraftia.ttf", 32));
  
  //initialize prompt squares
  int index = 0;
  for(int i = screenStartY; i < screenStartY + screenHeight; i+=boxSize){
    for(int j = screenStartX; j < screenStartX + screenWidth; j+=boxSize){
      promptArray[index] = new Prompt(j, i);
      index++;
    }  
  }
  
  ////initialize KEYS////
  //the first two rows
  int keyStartx = 75;
  int keyStarty = 269;
  int keyIndex = 0;
  for(int i = keyStarty; i < keyStarty + 2*18; i+=18){
    for(int j = keyStartx; j < keyStartx + 14*19; j+=19){
      KEYS[keyIndex][0] = j;
      KEYS[keyIndex][1] = i;
      keyIndex++;
    }
  }
  //third row
  KEYS[keyIndex][0] = 75;  //longer key, index 28 and 40
  KEYS[keyIndex][1] = 306;
  keyIndex++;
  keyStartx = 106;
  keyStarty = 306;
  for(int i = keyStartx; i < keyStartx + 12*19; i+=19){
    KEYS[keyIndex][0] = i;
    KEYS[keyIndex][1] = keyStarty;  
    keyIndex++;
  }
  //fourth row
  KEYS[keyIndex][0] = 75;  //longer key, index 41 and 
  KEYS[keyIndex][1] = 325;
  keyIndex++;
  keyStartx = 112;
  keyStarty = 325;
  for(int i = keyStartx; i < keyStartx + 62 + 8*19; i+=19){
    KEYS[keyIndex][0] = i;
    KEYS[keyIndex][1] = keyStarty;  
    if(i == keyStartx + 3*19){
      i+=62;
    }
    keyIndex++;
  }
  //key colors
  for(int i = 0; i < keyColor.length; i++){
    keyColor[i] = int(random(0, 255));  
  }
}

void draw() {
  background(0);
  //screen background
  fill(screenHue, 10, 100);
  rect(94, 81, 220, 160);
  screenHue = (screenHue + 100) % 255;
  
  if(promptIndex == promptArray.length){
    isWinning = true; 
  }
  promptIndex = min(promptIndex, promptArray.length);
 //Screen prompt
 for(int i = 0; i < promptIndex; i++){
  promptArray[i].display();
 }
 
 //keys
 drawKeys();
 
 if(isWinning){
   fill(0);
   textAlign(CENTER);
   text("HAPPY", width/2 + 5, height/2 - 65); 
   text("BIRTHDAY", width/2 + 5, height/2 - 25);
   text("DEVIN", width/2 + 5, height/2 + 15); 
 }
 image(backgroundComp, 0, 0);
}

void drawKeys(){  
  for(int i = 0; i < keyArray.length; i++){
    fill(keyColor[i], 255, 255);
    if(keyArray[i] == 0){
      continue;
    } else if(i == 28 || i == 40){
      rect(KEYS[i][0], KEYS[i][1], 25, 18); 
    } else if(i == 41 || i == 49){
      rect(KEYS[i][0], KEYS[i][1], 31, 18);
    } else if(i == 45){
      rect(KEYS[i][0], KEYS[i][1], 81, 18);  //space bar
    } else {
      rect(KEYS[i][0], KEYS[i][1], 19, 18);  
    }
  }
}

class Prompt{
  int x;
  int y;
  int h;
  
  Prompt(int tempx, int tempy){
    x = tempx;
    y = tempy;
    h = 0;
  }
  
  void display(){
    noStroke();
    fill(h, 255, 255);
    rect(x, y, boxSize, boxSize);  
  }
}

//SO TERRIBLE, but can't use dictionary since it's an import
void keyPressed(){
  if(key == '`' || key == '~'){
    keyArray[0] = 1;
    lastHue = keyColor[0];
  }
  if(key == '1' || key == '!'){
    keyArray[1] = 1;  
    lastHue = keyColor[1];
  }
  if(key == '2' || key == '@'){
    keyArray[2] = 1; 
    lastHue = keyColor[2]; 
  }
  if(key == '3' || key == '#'){
    keyArray[3] = 1;  
    lastHue = keyColor[3]; 
  }
  if(key == '4' || key == '$'){
    keyArray[4] = 1;  
    lastHue = keyColor[4]; 
  }
  if(key == '5' || key == '%'){
    keyArray[5] = 1;  
    lastHue = keyColor[5]; 
  }
  if(key == '6' || key == '^'){
    keyArray[6] = 1;  
    lastHue = keyColor[6]; 
  }
  if(key == '7' || key == '&'){
    keyArray[7] = 1;  
    lastHue = keyColor[7]; 
  }
    if(key == '8' || key == '*'){
    keyArray[8] = 1;  
    lastHue = keyColor[8]; 
  }
    if(key == '9' || key == '('){
    keyArray[9] = 1;  
    lastHue = keyColor[9]; 
  }
    if(key == '0' || key == ')'){
    keyArray[10] = 1;  
    lastHue = keyColor[10]; 
  }
    if(key == '-' || key == '_'){
    keyArray[11] = 1; 
   lastHue = keyColor[11];  
  }
  if(key == '=' || key == '+'){
    keyArray[12] = 1;  
    lastHue = keyColor[12]; 
  }
  if(key == 'p' || key == 'P'){
    keyArray[13] = 1;  
    lastHue = keyColor[13]; 
  }
  if(key == 'q' || key == 'Q'){
    keyArray[14] = 1;  
    lastHue = keyColor[14]; 
  }
  if(key == 'w' || key == 'W'){
    keyArray[15] = 1;  
    lastHue = keyColor[15]; 
  }
  if(key == 'e' || key == 'E'){
    keyArray[16] = 1;  
    lastHue = keyColor[16]; 
  }
  if(key == 'r' || key == 'R'){
    keyArray[17] = 1;  
    lastHue = keyColor[17]; 
  }
  if(key == 't' || key == 'T'){
    keyArray[18] = 1;  
    lastHue = keyColor[18]; 
  }
  if(key == 'y' || key == 'Y'){
    keyArray[19] = 1;  
    lastHue = keyColor[19]; 
  }
  if(key == 'h' || key == 'H'){
    keyArray[20] = 1;  
    lastHue = keyColor[20]; 
  }
  if(key == 'u' || key == 'U'){
    keyArray[21] = 1;  
    lastHue = keyColor[21]; 
  }
    if(key == 'j' || key == 'J'){
    keyArray[22] = 1;  
    lastHue = keyColor[22]; 
  }
    if(key == 'i' || key == 'I'){
    keyArray[23] = 1;  
    lastHue = keyColor[23]; 
  }
    if(key == 'k' || key == 'K'){
    keyArray[24] = 1;  
    lastHue = keyColor[24]; 
  }
    if(key == 'o' || key == 'O'){
    keyArray[25] = 1;  
    lastHue = keyColor[25]; 
  }
  if(key == 'l' || key == 'L'){
    keyArray[26] = 1; 
   lastHue = keyColor[26];  
  }
  if(key == '[' || key == ']'){
    keyArray[27] = 1;  
    lastHue = keyColor[27]; 
  }
  if(keyCode == TAB){
    keyArray[28] = 1;  
    lastHue = keyColor[28]; 
  }
  if(key == 'a' || key == 'A'){
    keyArray[29] = 1;  
    lastHue = keyColor[29]; 
  }
  if(key == 's' || key == 'S'){
    keyArray[30] = 1;  
    lastHue = keyColor[30]; 
  }
  if(key == 'x' || key == 'X'){
    keyArray[31] = 1;  
    lastHue = keyColor[31]; 
  }
    if(key == 'd' || key == 'D'){
    keyArray[32] = 1; 
   lastHue = keyColor[32];  
  }
    if(key == 'c' || key == 'C'){
    keyArray[33] = 1;  
    lastHue = keyColor[33]; 
  }
    if(key == 'f' || key == 'F'){
    keyArray[34] = 1;  
    lastHue = keyColor[34]; 
  }
    if(key == 'v' || key == 'V'){
    keyArray[35] = 1;  
    lastHue = keyColor[35]; 
  }
  if(key == 'g' || key == 'G'){
    keyArray[36] = 1;  
    lastHue = keyColor[36]; 
  }
  if(key == 'b' || key == 'B'){
    keyArray[37] = 1;  
    lastHue = keyColor[37]; 
  }
  if(key == 'n' || key == 'N'){
    keyArray[38] = 1;  
    lastHue = keyColor[38]; 
  }
  if(key == 'm' || key == 'M'){
    keyArray[39] = 1; 
   lastHue = keyColor[39];  
  }
  if(keyCode == RETURN || keyCode == ENTER){
    keyArray[40] = 1;  
    lastHue = keyColor[40]; 
  }
  if(keyCode == SHIFT){
    keyArray[41] = 1;  
    lastHue = keyColor[41]; 
  }
  if(keyCode == CONTROL){
    keyArray[42] = 1; 
    keyArray[49] = 1; 
    lastHue = keyColor[42]; 
  }
  if(keyCode == ALT){
    keyArray[43] = 1;
    keyArray[48] = 1;  
    lastHue = keyColor[43]; 
  }
  if(key == 'z' || key == 'Z'){
    keyArray[44] = 1;  
    lastHue = keyColor[44]; 
  }
  if(keyCode == ' '){
    keyArray[45] = 1;
    lastHue = keyColor[45]; 
  }
  if(key == ',' || key == '<'){
    keyArray[46] = 1;  
    lastHue = keyColor[46]; 
  }
  if(key == '.' || key == '>'){
    keyArray[47] = 1; 
   lastHue = keyColor[47]; 
  }
}

void keyReleased(){
  if(promptIndex < promptArray.length){
    promptArray[promptIndex].h = lastHue;
  }
  promptIndex++;
  for(int i = 0; i < keyArray.length; i++){
    keyArray[i] = 0;  
  }
}
