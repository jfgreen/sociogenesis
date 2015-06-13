AgentModel model;
ControlSet controls;

void setup() {

  size(800, 800);
  model = new AgentModel(100, 100);
  controls = new ControlSet(10, height-200);
  controls.addControl(new ControlButton(0, 0, "Reset", new ButtonListener() {
    public void activate() {
      model = new AgentModel(100, 100);
    } 
  }));
  controls.addControl(new ControlSlider(100, 50, 5, 7, "Foo", new SliderListener() {
    public void activate(float val) {
      println(val);
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

void mouseDragged() {
  controls.handleMouseDragged(mouseX, mouseY);
}