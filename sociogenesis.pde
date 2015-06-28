AgentModel model;
ControlSet controlSet;
Parameters parameters;

void setup() {
  size(800, 800);
  parameters = new Parameters();
  //TODO: How to make the control data binding a 2 way thing?

  model = new AgentModel(parameters);
  controlSet = new ControlSet();
  ControlGroup group = new ControlGroup(0, height-40);
  group.addControl(new ControlButton(260, 0, "Reset", new ButtonListener() {
    public void activate() {
      model = new AgentModel(parameters);
    } 
  }));
  group.addControl(new ControlSlider(70, 0, 0, 100, parameters.agentCount, "Agents", new SliderListener() {
    public void activate(float val) {
      parameters.agentCount = (int) val;
    }
  }));
  controlSet.add(group);
}


void draw() {
  background(color(10,10,10));
  model.update();
  model.draw();
  controlSet.draw();
}

