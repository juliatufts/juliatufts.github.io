ArrayList<KochLine> lines0;
PVector start;
float len;
float timer = 0;
int count = 0;

void setup() {
  size(400, 400);
  lines0 = new ArrayList<KochLine>();  
  len = width-60;
  start = new PVector(30, 300);
  setupFlake(lines0, len, start);
}

void draw() {
  background(220, 245, 255);
  if(timer >= 5){
    lines0 = generate(lines0); 
    count += 1;
    if(count == 6){
      lines0 = new ArrayList<KochLine>();
      setupFlake(lines0, len, start);
      count = 0;
    }
    timer = 0;
  }
  for (KochLine l : lines0) {
    l.display(0);
  }
  timer++;
}

void setupFlake(ArrayList<KochLine> lines, float l, PVector st){
  PVector end = new PVector(st.x + l, st.y);
  PVector mid = new PVector(st.x + l/2, st.y - sqrt(sq(l) - sq(l/2)));
  lines.add(new KochLine(st, mid));
  lines.add(new KochLine(mid, end));
  lines.add(new KochLine(end, st));
}

ArrayList<KochLine> generate(ArrayList<KochLine> lines) {
  ArrayList next = new ArrayList<KochLine>();

  for (KochLine l : lines) {

    //figure out intermediate points
    PVector a = l.kochA();
    PVector b = l.kochB();
    PVector c = l.kochC();
    PVector d = l.kochD();
    PVector e = l.kochE();

    next.add(new KochLine(a, b));
    next.add(new KochLine(b, c));
    next.add(new KochLine(c, d));
    next.add(new KochLine(d, e));
  }  
  return next;
}

class KochLine {
  PVector start;
  PVector end;

  KochLine(PVector a, PVector b) {
    start = a.get();
    end = b.get();
  }  

  PVector kochA() {
    return start.get();
  }

  PVector kochB() {
    PVector v = PVector.sub(end, start);
    v.div(3);
    v.add(start);
    return v;
  }

  PVector kochC() {
    PVector a = start.get();
    PVector v = PVector.sub(end, start);
    v.div(3);
    a.add(v);
    v.rotate(-radians(60));
    a.add(v);
    return a;
  }

  PVector kochD() {
    PVector v = PVector.sub(end, start);
    v.mult(2/3.0);
    v.add(start);
    return v;
  }

  PVector kochE() {
    return end.get();
  }

  void display(int c) {
    stroke(c);
    line(start.x, start.y, end.x, end.y);
  }
}

