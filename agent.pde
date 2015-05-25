class Agent {

  float SIZE = 5;
  color STROKE_COL = color(220, 220, 220);
  color FILL_COL = color(200, 200, 0, 100);

  float VELOCITY = 3;
  float MAX_TURN = 0.3;
  float PERCEPTION = 25;

  PVector position; // Postion in the world space
  float direction; // Direction the agent is facing

  Brain brain;  // Brain for deciding when to pick up and put down pellets.
  Pellet heldPellet; // Currently held pellet. Null when none is held.

  Agent(PVector position, float direction, Brain brain) {
    this.position = position;
    this.direction = direction;
    this.brain = brain;
  }

  void update(Collection<Pellet> pellets) {
    think(pellets);
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
      heldPellet.position.set(position);
    }
  }

  void think(Collection<Pellet> pellets) {
    if (heldPellet == null) {
      Pellet availablePellet = findAvailablePellet(pellets);
      if (availablePellet != null && brain.shouldTake(availablePellet, pellets)) {
        availablePellet.claimed = true;
        heldPellet = availablePellet;
      }
    } else {
      if (brain.shouldPlace(heldPellet, pellets)) {
        heldPellet.claimed = false;
        heldPellet = null;
      }
    }
  }

  Pellet findAvailablePellet(Collection<Pellet> pellets) {
    // Return the closest pellet that is in range and not already claimed.
    for(Pellet pellet : pellets) {
      float distance = pellet.position.dist(position);
      if (distance < PERCEPTION && !pellet.claimed) {
        return pellet;
      }
    }
    return null;
  }

}