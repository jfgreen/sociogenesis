import java.util.Collection;
import java.util.ArrayList;

//TODO: Refactor this somewhat. Maybe controlset can do more heavy lifting. Simpler hooks for the controls?

ControlSet activeControlSet;

void mousePressed() {
  if (activeControlSet != null) {
    activeControlSet.handleMousePressed(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (activeControlSet != null) {
    activeControlSet.handleMouseReleased(mouseX, mouseY);
  }
}

void mouseMoved() {
  if (activeControlSet != null) {
    activeControlSet.handleMouseMoved(mouseX, mouseY);
  }
}

void mouseDragged() {
  if (activeControlSet != null) {
    activeControlSet.handleMouseDragged(mouseX, mouseY);
  }
}

class ControlSet {

  Collection<Control> controls;
  Control focusedControl;
  PFont defaultFont;

  ControlSet() {
    this.controls = new ArrayList();
    this.defaultFont = createFont("Monospaced", 12);
    activeControlSet = this;
  }

  void add(Control control) {
    controls.add(control);
  }

  void add(ControlGroup group) {
    for (Control control : group.controls) {
      control.x += group.x;
      control.y += group.y;
      controls.add(control);
    }
  }

  Control getControlAt(int x, int y) {
    for(Control control : controls) {
      if (control.encompassesPoint(x, y)) {
        return control;
      }
    }
    return null;
  }

  void handleMousePressed(int mx, int my) {
    focusedControl = getControlAt(mx, my);
    if (focusedControl != null) {
      focusedControl.handleMousePressed(mx, my);
    }
  }

  void handleMouseReleased(int mx, int my) {
    if (focusedControl != null) {
      focusedControl.handleMouseReleased(mx, my);
      focusedControl = null;
    }
  }

  void handleMouseMoved(int mx, int my) {
    if (focusedControl != null) {
      focusedControl.handleMouseMoved(mx, my);
    } else {
      for(Control control : controls) {
        control.handleMouseMoved(mx, my);
      }
    }
  }

  void handleMouseDragged(int mx, int my) {
    if (focusedControl != null) {
      focusedControl.handleMouseDragged(mx, my);
    }
  }

  void draw() {
    textFont(this.defaultFont);
    for(Control control : controls) {
      pushStyle();
      pushMatrix();
      control.draw();
      popStyle();
      popMatrix();
    }
  }
}

class ControlGroup {
  int x; 
  int y;
  Collection<Control> controls;

  ControlGroup(int x, int y) {
    this.x = x;
    this.y = y;
    controls = new ArrayList();
  }

  void addControl(Control control) {
    controls.add(control);
  }

}

abstract class Control {
  int x;
  int y;
  int controlWidth;
  int controlHeight;

  color LABEL_COL = color(255);
  color STROKE_COL = color(220, 220, 220, 100);
  color FILL_COL_NORMAL = color(10, 100, 230, 255);
  color FILL_COL_HOVER = color(10, 120, 250, 255);
  color FILL_COL_DOWN = color(10, 90, 200, 255);

  Control(int x, int y, int controlWidth, int controlHeight) {
    this.x = x;
    this.y = y;
    this.controlWidth = controlWidth;
    this.controlHeight = controlHeight;
  }

  boolean encompassesPoint(int px, int py) {
    return (px > x &&
            px < x + controlWidth &&
            py > y &&
            py < y + controlHeight);
  }

  void handleMousePressed(int mx, int my) {}
  void handleMouseReleased(int mx, int my) {}
  void handleMouseMoved(int mx, int my) {}
  void handleMouseDragged(int mx, int my) {}
  abstract void draw();
}

interface ButtonListener {
  abstract void activate();
}

static int DEFAULT_BUTTON_WIDTH = 48;
static int DEFAULT_BUTTON_HEIGHT = 30;

class ControlButton extends Control {

  color currentCol;
  ButtonListener listener;
  String label;

  ControlButton(int x, int y, int buttonWidth, int buttonHeight, String label, ButtonListener listener) {
    super(x, y, buttonWidth, buttonHeight);
    this.currentCol = FILL_COL_NORMAL;
    this.label = label;
    this.listener = listener;
  }

  ControlButton(int x, int y, String label, ButtonListener listener) {
    this(x, y, DEFAULT_BUTTON_WIDTH, DEFAULT_BUTTON_HEIGHT, label, listener);
  }

  void handleMouseMoved(int lx, int ly) {
    if (encompassesPoint(lx, ly)) {
      currentCol = FILL_COL_HOVER;
    } else {
      currentCol = FILL_COL_NORMAL;
    }
  }

  void handleMousePressed(int lx, int ly) {
    listener.activate();
    currentCol = FILL_COL_DOWN;
  }

  void handleMouseReleased(int lx, int ly) {
    currentCol = FILL_COL_NORMAL;
    handleMouseMoved(lx, ly);
  }

  void draw() {
    stroke(STROKE_COL);
    fill(currentCol);
    rect(x, y, controlWidth, controlHeight); 
    fill(LABEL_COL);
    textAlign(CENTER, CENTER);
    text(label, x + controlWidth/2, y + controlHeight/2);
  }
}

static int DEFAULT_SLIDER_WIDTH = 100;
static int SLIDER_HEIGHT = 40;
static int SLIDER_HANDLE_SIZE = 12;

interface SliderListener {
  abstract void activate(float val);
}

class ControlSlider extends Control {

  int handlePosition; 
  float minVal;
  float maxVal;
  float val;
  String label;
  SliderListener listener;

  //TODO: How can we account for whole numbers?

  ControlSlider(int x, int y, int sliderWidth, float minVal, float maxVal, float initVal, String label, SliderListener listener) {
    super(x, y, sliderWidth, SLIDER_HEIGHT);
    this.handlePosition = 0;
    this.label = label;
    this.minVal = minVal;
    this.maxVal = maxVal;
    this.val = initVal;
    this.listener = listener;
  }

  ControlSlider(int x, int y, float minVal, float maxVal, float initVal, String label, SliderListener listener) {
    this(x, y, DEFAULT_SLIDER_WIDTH, minVal, maxVal, initVal, label, listener);
  }

  void moveHandle(int lx, int ly) {
    if (lx < x) {
      handlePosition = 0;
    } else if (lx > x + controlWidth) {
      handlePosition = controlWidth;
    } else {
      handlePosition = lx-x;
    }
    val = map(handlePosition, 0, controlWidth, minVal, maxVal);
    listener.activate(val);
  }

  //TODO: Make handle highlightable like button is.

  void handleMousePressed(int lx, int ly) {
    moveHandle(lx, ly);
  }

  void handleMouseDragged(int lx, int ly) {
    moveHandle(lx, ly);
  }


  boolean isOnHandle(int lx, int ly) {
    return dist(x + handlePosition, y +this.controlHeight/2, lx, ly) < SLIDER_HANDLE_SIZE;
  }

  void draw() {
    stroke(STROKE_COL);
    fill(FILL_COL_NORMAL);
    translate(x, y +this.controlHeight/2);
    line(0,0,this.controlWidth, 0);
    ellipse(handlePosition, 0, SLIDER_HANDLE_SIZE, SLIDER_HANDLE_SIZE);
    textAlign(RIGHT, CENTER);
    fill(255);
    text(label + ":", -12, -2);
    textAlign(LEFT, CENTER);
    text(val, controlWidth + 12, -2);
  }
}
