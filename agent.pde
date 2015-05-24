class Agent {

  float VELOCITY = 3;
  float NOISE_STEP = 0.01;
  float MAX_TURN = 0.3;

  PVector position; // Postion in the world space
  float direction;  // Direction the agent is facing

  Agent(PVector position, float direction) {
    this.position = position;
    this.direction = direction;
  }

  void update() {
    // Move forward in the direction the agent is facing
    float dx = VELOCITY * sin(direction);
    float dy = VELOCITY * cos(direction);
    this.position.add(new PVector(dx, dy));

    // Limit positon to inside the bounds of the window
    if(position.x < 0) position.x = 0;
    if(position.x > width) position.x = width;
    if(position.y < 0) position.y = 0;
    if(position.y > height) position.y = height;

    // Rotate the direction randomly
    direction += map(randomGaussian(), -1, 1, -MAX_TURN, MAX_TURN);

  }

  void draw() {
    ellipse(position.x, position.y, 5, 5);
  }
}