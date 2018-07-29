class Pixels {
  ArrayList<PVector> pixel;
  PGraphics pg;
  int w = 10;
  float maxD = 30;
  Pixels() {
    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.fill(0, 0);
    pg.ellipseMode(CENTER);
    pg.ellipse(-10, -10, 1, 1);
    pg.endDraw();
    pixel = new ArrayList<PVector>();
  }
  void loadText(String text) {
    int textSize = 500;
    pg.beginDraw();
    pg.textFont(f);
    pg.fill(0);
    pg.textAlign(CENTER);
    pg.textSize(textSize);
    pg.strokeWeight(5);
    pg.text(text, width/2, height/2 + textSize / 3);
    pg.endDraw();
  }
  void getPixel() {
    pixel = new ArrayList<PVector>();
    loadPixels();
    for (int i = 0; i < height; i += w) {
      for (int j = 0; j < width; j += w)
      {
        float b = brightness(pixels[j + i * width]);
        if (b <= 5) pixel.add(new PVector(j, i));
      }
    }
  }
  void reducePixel() { // reduce the pixels
    int index = 0;
    while (index < pixel.size())
    {
      int i = index, j = 0;
      while (j < pixel.size()) {
        PVector pi = pixel.get(i);
        PVector pj = pixel.get(j);
        float d = PVector.dist(pi, pj);
        if (d > 0 && d < maxD) {
          pixel.remove(j);
          index--;
          if (index < 0) index ++;
        } else j++;
      }
      index ++;
    }
  }

  void show() {
    image(pg, 0, 0);
    pg.clear();
  }
  void showByVector() {
    //reducePixel();
    for (PVector p : pixel) {
      //println(p.x + ", " + p.y);
      fill(0);
      rect(p.x, p.y, w, w);
    }
  }
  void addD(int ms) {
    maxD += ms*3;
  }
}
