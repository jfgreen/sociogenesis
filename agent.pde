

class Agent {

  float SIZE = 8;
  color STROKE_COL = color(220, 220, 220);
  color FILL_COL = color(200, 200, 0);

  float VELOCITY = 3;
  float MAX_TURN = 0.3;
  float PERCEPTION = 25;

  PVector position; // Postion in the world space
  float direction;  // Direction the agent is facing

  Pellet heldPellet;

  Agent(PVector position, float direction) {
    this.position = position;
    this.direction = direction;
  }

  void update(Collection<Pellet> pellets) {
    if (heldPellet == null) {
      considerPickingUp(pellets);
    } else {
      considerPuttingDown();
    }
    move();
  }

  void draw() {
    stroke(STROKE_COL);
    fill(FILL_COL);
    ellipse(position.x, position.y, SIZE, SIZE);
  }

  void move() {
    // Move forward in the direction the agent is facing
    float dx = VELOCITY * sin(direction);
    float dy = VELOCITY * cos(direction);
    position.add(new PVector(dx, dy));

    // Limit positon to inside the bounds of the window
    if(position.x < 0)      position.x = 0;
    if(position.x > width)  position.x = width;
    if(position.y < 0)      position.y = 0;
    if(position.y > height) position.y = height;

    // Rotate the direction randomly
    direction += map(randomGaussian(), -1, 1, -MAX_TURN, MAX_TURN);

    if (heldPellet != null) {
      heldPellet.setPosition(position);
    }
  }

  void considerPickingUp(Collection<Pellet> pellets) {
    Pellet availablePellet = findAvailablePellet(pellets);
    if (availablePellet != null && random(0, 1) > 0.8) {
      availablePellet.claim();
      heldPellet = availablePellet;
    }
  }

  Pellet findAvailablePellet(Collection<Pellet> pellets) {
    // Return the closest pellet that is in range and not already claimed.
    for(Pellet pellet : pellets) {
      float distance = pellet.getPosition().dist(position);
      if (distance < PERCEPTION && !pellet.isClaimed()) {
        return pellet;
      }
    }
    return null;
  }

  void considerPuttingDown() {
    if (heldPellet != null && random(0, 1) > 0.95) {
      heldPellet.abandon();
      heldPellet = null;
    }
  } 

}