float theta = 0.1;
class Path{
  ArrayList<PVector> points;
  PVector start, end;
  float radius;
  Path(){
    radius = 10;
    start = new PVector(0,height/3);
    end = new PVector(width, 2*height/3);
    points = new ArrayList<PVector>();
    points.add(start);
  }
  Path(float h1, float h2, float r){
    radius = r;
    start = new PVector(0,h1);
    end = new PVector(width, h2);
  }
  void inner(PVector a, PVector b){
    stroke(0);
    strokeWeight(1);
    line(a.x,a.y,b.x,b.y);
  }
  void outer(PVector a, PVector b){
    strokeWeight(radius*2);
    stroke(200);
    line(a.x,a.y,b.x,b.y);
  }
  void display(){
    for(int i = 0; i < points.size()-1; i++){
      outer(points.get(i), points.get(i+1));
    }
    for(int i = 0; i < points.size()-1; i++){
      inner(points.get(i), points.get(i+1));
    }
    
  }
  void addPoint(){
    points.add(new PVector(mouseX, mouseY));
  }
  void showPoint(){
    PVector a = points.get(points.size()-1);
    PVector b = new PVector(mouseX, mouseY);
    outer(a,b);
    display();
    inner(a,b); 
  }
  void move(){//6.11
    for (int i = 0; i < points.size(); i++){
      points.set(i,points.get(i).add(new PVector(0,1*cos(theta+i*5))));
    }
    theta += 0.1;
  }
  
}
