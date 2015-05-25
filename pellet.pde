class Pellet {

  float SIZE = 5;
  color STROKE_COL = color(220, 220, 220);
  color FILL_COL = color(0, 200, 255);

  PVector position;
  boolean claimed;

  Pellet(PVector position) {
    this.position = position; 
    this.claimed = false;
  }

  void draw() {
    stroke(STROKE_COL);
    fill(FILL_COL);
    ellipse(position.x, position.y, SIZE, SIZE); 
  }

}