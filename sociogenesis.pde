AgentModel model;
ControlSet controlSet;
Parameters parameters;

void setup() {
  size(800, 800);
  parameters = new Parameters();
  model = new AgentModel(parameters);

  controlSet = new ControlSet();

  //TODO: Wouldn't it be really cool if we could auto gen controls from parameter class. 

  ControlGroup initGroup = new ControlGroup(width-320, height-40);
  initGroup.add(new ControlButton(260, 0, "Reset", new ButtonListener() {
    public void activate() {
      model = new AgentModel(parameters);
    } 
  }));
  initGroup.add(new ControlSlider(70, 0, 0, 150, parameters.agentCount, "Agents", new SliderListener() {
    public void activate(float val) {
      parameters.agentCount = (int) val;
    }
  }));
  controlSet.add(initGroup);

  ControlGroup paramGroup = new ControlGroup(160, height - 80);
  paramGroup.add(new ControlSlider(0, 0, 0, 5, parameters.kPlace, "Place Constant", new SliderListener() {
    public void activate(float val) {
      parameters.kPlace = val;
    }
  }));
  paramGroup.add(new ControlSlider(0, 20, 0, 5, parameters.kTake, "Take Constant", new SliderListener() {
    public void activate(float val) {
      parameters.kTake = val;
    }
  }));
  paramGroup.add(new ControlSlider(0, 40, 5, 50, parameters.neighbourThreshold, "Neighbour Threshold", new SliderListener() {
    public void activate(float val) {
      parameters.neighbourThreshold = val;
    }
  }));
  controlSet.add(paramGroup);
}

void draw() {
  background(color(10,10,10));
  model.update();
  model.draw();
  controlSet.draw();
}

