class Agent {

  float SIZE = 4;
  color STROKE_COL = color(220, 220, 220);
  color FILL_COL = color(200, 200, 0, 100);

  float VELOCITY = 3;   // Distance an agent travels at each step.
  float MAX_TURN = 0.3; // Maximum angle (in radians) an agent can turn in one step.
  float REACH = 25;     // Radius of agents reach. Pellets must be within to be picked up.
  int THINK_STEP = 10;  // Number of steps in between each call to think.

  PVector position;     // Postion in the world space
  float direction;      // Direction the agent is facing
  Pellet heldPellet;    // Currently held pellet. Null when none is held.
  int stepsTaken;       // Used to keep track of the number of steps taken.

  Environment environment;
  Parameters parameters;

  Agent(PVector position, float direction, Environment environment, Parameters parameters) {
    this.position = position;
    this.direction = direction;
    this.stepsTaken = 0;
    this.environment = environment;
    this.parameters = parameters;
  }

  void update() {
    if (stepsTaken % THINK_STEP == 0) {
      think();
    }
    move();
    stepsTaken++;
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

  void think() {
    if (heldPellet == null) {
      Pellet availablePellet = findAvailablePellet(environment.pellets);
      if (availablePellet != null && shouldTake(availablePellet, environment.pellets)) {
        availablePellet.claimed = true;
        heldPellet = availablePellet;
      }
    } else {
      if (shouldPlace(heldPellet, environment.pellets)) {
        heldPellet.claimed = false;
        heldPellet = null;
      }
    }
  }

  Pellet findAvailablePellet(Collection<Pellet> pellets) {
    // Return the closest pellet that is in range and not already claimed.
    for(Pellet pellet : pellets) {
      float distance = pellet.position.dist(position);
      if (distance < REACH && !pellet.claimed) {
        return pellet;
      }
    }
    return null;
  }

    boolean shouldPlace(Pellet pellet, Collection<Pellet> allPellets) {
    float f = float(getNeighbourhood(pellet, allPellets, parameters.neighbourThreshold).size());
    float kP = parameters.kPlace;
    float probability = pow(f/(f+kP), 2);
    return random(0, 1) < probability;
  }

  boolean shouldTake(Pellet pellet, Collection<Pellet> allPellets) {
    float f = float(getNeighbourhood(pellet, allPellets, parameters.neighbourThreshold).size());
    float kT = parameters.kTake;
    float probability = pow(kT/(f+kT), 2);
    return random(0, 1) < probability;
  }

  Collection<Pellet> getNeighbourhood(Pellet pellet, Collection<Pellet> allPellets, float threshold) {
    ArrayList<Pellet> neighbours = new ArrayList();
    for (Pellet otherPellet : allPellets) {
      if (pellet.position.dist(otherPellet.position) < threshold && otherPellet != pellet) {
        neighbours.add(otherPellet);
      }
    }
    return neighbours;
  }

}