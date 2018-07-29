class Star {
  PVector loc, v, a, attract;
  ArrayList<Star> linkTo;
  int maxlinks;
  float r, maxforce, maxspeed;
  float randomness;
  PVector pixelTarget;
  boolean disappeared = false, appeared = false;
  PVector randomLoc;
  PGraphics pg;
  Star(float x, float y) {
    randomness = 20;
    r = 4.0;
    loc = new PVector(x, y);
    maxforce = 3;
    maxspeed = 20;
    maxlinks = 7;
    randomLoc = new PVector(random(-randomness, randomness), random(-randomness, randomness));
    a = new PVector();
    v = new PVector();
    pixelTarget = new PVector(0, 0);
    linkTo = new ArrayList<Star>();
  }
 
  void run() {
    if(appeared == true){
      appear();
      if(r >= 4.0){
        r = 4.0;
        appeared = false;
      }
    }
    if(disappeared == true) disappear();
    update();
    border();
    render();
  }
  void update() {
    v.add(a);
    v.limit(maxspeed);
    loc.add(v);
    if (v.mag() < 0.1) v.mult(0);
    a.mult(0);
  }
  void reduceV(){
    v.mult(0.9);
  }
  void border() {//To prevent the particles from eluding the edge of the sketch
    if (loc.x < -r) loc.x = width - r;
    if (loc.y < -r) loc.y = height - r;
    if (loc.x > width + r) loc.x = -r;
    if (loc.y > height + r) loc.y = -r;
  }
  void render() {//Visualize all the data
    /*
    float theta = v.heading2D() + radians(90);
     fill(175);
     stroke(0);
     pushMatrix();
     translate(loc.x,loc.y);
     rotate(theta);
     beginShape();
     vertex(0,-r*2);
     vertex(-r,r*2);
     vertex(r,r*2);
     endShape();
     popMatrix();
     */
      //Create Lines
      for (int i = 0; i < linkTo.size(); i++) {
        float d = PVector.dist(loc, linkTo.get(i).loc);
        float t = map(d, 0, r*30, 0, 255);
        stroke(0, 255 - t);
        line(loc.x, loc.y, linkTo.get(i).loc.x, linkTo.get(i).loc.y);
      }
    //Create circles
    fill(0);
    ellipseMode(CENTER);
    float resize = 1.5;
    ellipse(loc.x, loc.y, r*resize, r*resize);
    fill(255);
    ellipse(loc.x, loc.y, r/resize, r/resize);
    
    
    
  }




  void follow(Path p) {
    PVector normalPoint = new PVector();
    float worldRecord = 999999;
    PVector target = null; 
    PVector a = new PVector();
    PVector b = new PVector();

    PVector predict = v.get();
    predict.normalize();
    predict.mult(25);
    PVector predictLoc = PVector.add(loc, predict);

    if (p.points.size() == 1) {
      a = new PVector(width/2, height/2);
      b = a;
      target = a;
      predictLoc = a;
      normalPoint = a;
    } else {
      for (int i = 0; i < p.points.size()-1; i++) {
        PVector a1 = p.points.get(i);
        PVector b1 = p.points.get(i+1);
        PVector normalPoint1 = getNormalPoint(predictLoc, a1, b1);
        if (normalPoint1.x < a1.x || normalPoint1.x > b1.x)
          normalPoint1 = b1.get();  
        float dist = PVector.dist(predictLoc, normalPoint1);
        if (dist < worldRecord) {
          worldRecord = dist;
          target = normalPoint1.get();
          normalPoint = normalPoint1.get();
          a = a1;
          b = b1;
        }
      }
    }


    PVector dir = PVector.sub(b, a);
    dir.normalize();
    dir.mult(10);

    target = PVector.add(target, dir);

    float distance = PVector.dist(predictLoc, normalPoint);
    if (distance > p.radius)
      seek(target);

    //line(loc.x,loc.y,predictLoc.x,predictLoc.y);
    //line(predictLoc.x,predictLoc.y,normalPoint.x,normalPoint.y);
  }
  void link(ArrayList<Star> vehicles) {
    float desiredSeperation = r * 30;
    for (Star other : vehicles) {
      float d = PVector.dist(loc, other.loc);
      for (int i = 0; i < linkTo.size(); i++) {
        Star v = linkTo.get(i);
        float dist = PVector.dist(loc, v.loc);
        if (d < dist || d == dist)
          linkTo.remove(i);
      }
      if ( d > 0 && d < desiredSeperation && linkTo.size() < maxlinks)
      {
        if (linkTo.size() < maxlinks)
          linkTo.add(other);
      }
    }
    //println(linkTo.size());
  }
  PVector getForce(ArrayList<Star> vehicles) {
    float desiredSeperation = r*60;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Star other : vehicles) {
      float d = PVector.dist(loc, other.loc);
      if ( d > 0 && d < desiredSeperation) {
        PVector diff = PVector.sub(loc, other.loc);
        diff.normalize();
        diff.div(d);
        sum.add(diff);
        count ++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, v);
      steer.limit(maxforce);
      attract = steer.get().mult(-1);
      return(steer.mult(0.05));
    }
    return new PVector(0, 0);
  }
  void seek(PVector target) {
    PVector desired = PVector.sub(target, loc);
    desired.add(randomLoc);
    if (desired.mag() < 15) return;
    desired.setMag(maxspeed);
    PVector steer = PVector.sub(desired, v);
    steer.limit(maxforce);
    applyForce(steer);
  }
  void applyForce(PVector steer) {
    a = PVector.add(a, steer);
  }
  PVector getNormalPoint(PVector predictLoc, PVector a, PVector b) {
    PVector ap = PVector.sub(predictLoc, a);
    PVector ab = PVector.sub(b, a);
    ab.normalize();
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }
  void addms(int ms) {
    maxlinks += ms;
  }
  void disappear(){
    r *= 0.9;
  }
  void appear(){
    r *= 1.1;
  }
}
