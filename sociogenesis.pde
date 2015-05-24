AgentModel model;

void setup() {
  size(800, 800);
  model = new AgentModel(50);
}

void draw() {
  background(color(10,10,10));
  model.update();
  model.draw();
}