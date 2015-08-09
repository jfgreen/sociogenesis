import java.util.Collection;
import java.util.ArrayList;
import java.util.List;

//TODO: Refactor this somewhat. Maybe controlset can do more heavy lifting. Simpler hooks for the controls?, eg handleGainOver, handleLoseOver...

Ui activeUi;

void mousePressed() {
  if (activeUi != null) {
    activeUi.handleMousePressed(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (activeUi != null) {
    activeUi.handleMouseReleased(mouseX, mouseY);
  }
}

void mouseMoved() {
  if (activeUi != null) {
    activeUi.handleMouseMoved(mouseX, mouseY);
  }
}

void mouseDragged() {
  if (activeUi != null) {
    activeUi.handleMouseDragged(mouseX, mouseY);
  }
}

class Ui {

  Collection<Control> controls;
  Control focusedControl;
  PFont defaultFont;

  Ui() {
    this.controls = new ArrayList();
    this.defaultFont = createFont("Monospaced", 12);
    activeUi = this;
  }

  void add(ControlGroup group) {
    for (Control control : group.controls) {
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

static int DEFAULT_GRID_YSTEP = 7;

class ControlGroup {
  int x; 
  int y;
  int yStep;
  int lastY;
  List<Control> controls;

  ControlGroup(int x, int y, int yStep) {
    this.x = x;
    this.y = y;
    this.yStep = yStep;
    this.lastY = y;
    controls = new ArrayList();
  }

  ControlGroup(int x, int y) {
    this(x, y, DEFAULT_GRID_YSTEP);
  }

  int getNextY() {
    int nextY = lastY + yStep;
    if (controls.size() > 0) {
      nextY += controls.get(controls.size() -1).controlHeight;
    }
    lastY = nextY;
    return nextY;
  }

  void add(Control control) {
    control.x = x;
    control.y = getNextY();
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

  Control(int controlWidth, int controlHeight) {
    this.x = 0;
    this.y = 0;
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

  ControlButton(int buttonWidth, int buttonHeight, String label, ButtonListener listener) {
    super(buttonWidth, buttonHeight);
    this.currentCol = FILL_COL_NORMAL;
    this.label = label;
    this.listener = listener;
  }

  ControlButton(String label, ButtonListener listener) {
    this(DEFAULT_BUTTON_WIDTH, DEFAULT_BUTTON_HEIGHT, label, listener);
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
static int SLIDER_HEIGHT = 15;
static int SLIDER_HANDLE_SIZE = 12;

interface SliderListener {
  abstract void activate(float val);
}

class ControlSlider extends Control {

  float handlePosition; 
  float minVal;
  float maxVal;
  float val;
  String label;
  SliderListener listener;

  //TODO: How can we account for whole numbers?

  ControlSlider(int sliderWidth, float minVal, float maxVal, float initVal, String label, SliderListener listener) {
    super(sliderWidth, SLIDER_HEIGHT);
    this.handlePosition = map(initVal, minVal, maxVal, 0, controlWidth);
    this.label = label;
    this.minVal = minVal;
    this.maxVal = maxVal;
    this.val = initVal;
    this.listener = listener;
  }

  ControlSlider(float minVal, float maxVal, float initVal, String label, SliderListener listener) {
    this(DEFAULT_SLIDER_WIDTH, minVal, maxVal, initVal, label, listener);
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
    fill(255);
    textAlign(LEFT, CENTER);
    text(label + ": " + val, controlWidth + 12, -2);
  }
}
