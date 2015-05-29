AgentModel model;
ControlSet controls;

void setup() {
  size(800, 800);
  model = new AgentModel(100, 100);
  controls = new ControlSet(10, 10);
  controls.addControl(new ControlButton(10, 10, new ButtonListener() {
    public void activate() {
      println("foo");
    } 
  }));
  controls.addControl(new ControlButton(10, 100, new ButtonListener() {
    public void activate() {
      println("bar");
    } 
  }));
}

void draw() {
  background(color(10,10,10));
  model.update();
  model.draw();
  controls.draw();
}

void mousePressed() {
  controls.handleMousePressed(mouseX, mouseY);
}

void mouseReleased() {
  controls.handleMouseReleased(mouseX, mouseY);
}

void mouseMoved() {
  controls.handleMouseMoved(mouseX, mouseY);
}