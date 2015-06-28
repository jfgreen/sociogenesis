AgentModel model;
ControlSet controls;
Parameters parameters;

void setup() {
  size(800, 800);
  parameters = new Parameters();
  //TODO: How to make the control data binding a 2 way thing?

  model = new AgentModel(parameters);
  //controls = new ControlSet(10, height-50);
  controlSet.addControl(new ControlButton(260, 0, "Reset", new ButtonListener() {
    public void activate() {
      model = new AgentModel(parameters);
    } 
  }));
  controlSet.addControl(new ControlSlider(70, 0, 0, 100, parameters.agentCount, "Agents", new SliderListener() {
    public void activate(float val) {
      parameters.agentCount = (int) val;
    }
  }));
}


void draw() {
  background(color(10,10,10));
  model.update();
  model.draw();
  controlSet.draw();
}

/**
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
**/