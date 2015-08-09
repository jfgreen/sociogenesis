AgentModel model;
Ui ui;
Parameters parameters;

void setup() {
  size(800, 800);
  parameters = new Parameters();
  model = new AgentModel(parameters);

  ui = new Ui();

  ControlGroup initGroup = new ControlGroup(10, 100);
  initGroup.add(new ControlSlider(0, 100, parameters.agentCount, "Agents", new SliderListener() {
    public void activate(float val) {
      parameters.agentCount = (int) val;
    }
  }));
  initGroup.add(new ControlButton("Reset", new ButtonListener() {
    public void activate() {
      model = new AgentModel(parameters);
    } 
  }));

  ui.add(initGroup);

  ControlGroup paramGroup = new ControlGroup(10, 10);
  paramGroup.add(new ControlSlider(0, 5, parameters.kPlace, "Place Constant", new SliderListener() {
    public void activate(float val) {
      parameters.kPlace = val;
    }
  }));
  paramGroup.add(new ControlSlider(0, 5, parameters.kTake, "Take Constant", new SliderListener() {
    public void activate(float val) {
      parameters.kTake = val;
    }
  }));
  paramGroup.add(new ControlSlider(5, 50, parameters.neighbourThreshold, "Neighbour Threshold", new SliderListener() {
    public void activate(float val) {
      parameters.neighbourThreshold = val;
    }
  }));
  paramGroup.add(new ControlSlider(0, 40, parameters.iterationsPerFrame, "Iterations/Frame", new SliderListener() {
    public void activate(float val) {
      parameters.iterationsPerFrame = int(val);
    }
  }));
  ui.add(paramGroup);
}

void draw() {
  for(int i = 0; i < parameters.iterationsPerFrame; i++) {
    model.update();
  }
  model.draw();
  ui.draw();
}

