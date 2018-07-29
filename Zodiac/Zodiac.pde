import java.util.*;
ArrayList<Star> stars;
Pixels textPixels;
Path path;
int seekMouse = 1, seekLink = 1, seekPath = 1;
float Index = 0;
float initialParticles = 60;
int maxParticles = 400;
void setup() {
  size(800, 1000);
  path = new Path();
  stars = new ArrayList<Star>();
  textPixels = new Pixels();
  for (int i = 0; i < initialParticles; i++)
    stars.add(new Star(random(width), random(height)));
}
void draw() {
  Index = 0;
  background(255);
  textPixels.show();
  textPixels.getPixel();;
  ArrayList<PVector> pixel = textPixels.pixel;
  background(255);
  intro();
  textPixels.reducePixel();
  if(textPixels.pixel.size() < stars.size() && textPixels.pixel.size() != 0) {
    reduceStars();
  }
  if(textPixels.pixel.size() > stars.size() && textPixels.pixel.size() != 0) {
    addStars();
  }
  //println("text : " + textPixels.pixel.size());
  //println("stars: " + stars.size());
  //textPixels.showByVector();
  //path.move();
  //path.display();
  for (Star v : stars) {
    if (seekLink == 1)  v.link(stars);
    PVector force = v.getForce(stars);
    //if (seekPath == 1) v.follow(path);
    v.run();
    v.applyForce(force.mult(1));
    if (seekMouse == 1) {
      v.seek(new PVector(mouseX, mouseY));
      v.applyForce(force.mult(15));
    }
    if(seekMouse == -1){
      v.reduceV();
    }
    if (pixel.size() > 0) {
      int addition = 1;
      if (Index < pixel.size())
      {
        PVector target = pixel.get((int)Index);
        v.seek(target);
        Index += addition;
      }
      if (Index == pixel.size())
        Index -= 1;
    }
  }
  filter(INVERT);
}
void keyPressed() {
  Index = 0.0;
  //if (key == 'r') path = new Path();
  if (key == ' ') seekMouse *= -1;
  //if (key == 'l') seekLink *= -1;
  //if (key == 'p') seekPath *= -1;
  //Add/Subtract maxspeed
  int addms = 0;
  if (keyCode == UP) addms ++;
  if (keyCode == DOWN) addms --;
  for (Star v : stars)
    v.addms(addms);
  if (key != ' ' && key != CODED) {loop();textPixels.loadText(key);}
}
void mouseDragged() {
  stars.add(new Star(mouseX, mouseY));
}
void mousePressed() {
  //path.addPoint();
  textPixels = new Pixels();
}
void reduceStars(){
  int diff = 0;
  if(stars.size() > maxParticles)
    diff += abs(stars.size() - maxParticles);
  if(textPixels.pixel.size() < stars.size())  
    diff += (stars.size() - textPixels.pixel.size());
  ListIterator<Star> iter = stars.listIterator();
  while(iter.hasNext()){
    Star tempV = iter.next();
    if(diff >= 0){
        tempV.disappeared = true;
        iter.set(tempV);
        diff--;
    }
  }
  iter = stars.listIterator();
  while(iter.hasNext()){
    Star tempV = iter.next();
    if(tempV.r < 1.0){
        iter.remove();
    }
  } 
}
void addStars(){
  int diff = abs(stars.size() - textPixels.pixel.size());
  while(diff > 0){
    Star tempV = new Star(random(width), random(height));
    tempV.r = 1;
    tempV.appeared = true;
    stars.add(tempV);
    diff--;
  }
}
void intro(){
  fill(0);
  textSize(15);
  textAlign(LEFT);
  text("Hit SPACE to track/untrack the mouse", 10, height - 80);
  text("Press mouse to reset the text", 10, height - 65);
  text("Press&Drag mouse to generate new particles", 10, height - 50);
  text("Use UP/DOWN to increase/decrease the maximum links between each particles", 10, height - 35);
  textAlign(RIGHT);
  fill(0, 70);
  text("Designed&Created by colorsky", width - 10, height - 10);
}
