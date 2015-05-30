import java.util.Collection;
import java.util.ArrayList;

class ControlSet {

  int x;
  int y;
  Collection<Control> controls;
  Control focusedControl;
  PFont defaultFont;

  ControlSet(int x, int y) {
    this.x = x;
    this.y = y;
    this.controls = new ArrayList();
    this.focusedControl = null;
    this.defaultFont = createFont("Monospaced", 12);
  }

  void addControl(Control control) {
    controls.add(control);
  }

  Control getControlAt(int localMx, int localMy) {
    for(Control control : controls) {
      if (control.encompassesPoint(localMx, localMy)) {
        return control;
      }
    }
    return null;
  }

  int toLocalX(int mx) {
    return mx - x;
  }

  int toLocalY(int my) {
    return my - y;
  }

  void handleMousePressed(int mx, int my) {
    int localMx = toLocalX(mx);
    int localMy = toLocalY(my);

    focusedControl = getControlAt(localMx, localMy);
    if (focusedControl != null) {
      focusedControl.handleMousePressed(localMx, localMy);
    }
  }

  void handleMouseReleased(int mx, int my) {
    int localMx = toLocalX(mx);
    int localMy = toLocalY(my);

    if (focusedControl != null) {
      focusedControl.handleMouseReleased(localMx, localMy);
      focusedControl = null;
    }
  }

  void handleMouseMoved(int mx, int my) {
    int localMx = toLocalX(mx);
    int localMy = toLocalY(my);

    if (focusedControl != null) {
      focusedControl.handleMouseMoved(localMx, localMy);
    } else {
      for(Control control : controls) {
        control.handleMouseMoved(localMx, localMy);
      }
    }
  }

  void draw() {
    pushMatrix();
    translate(x, y);
    textFont(this.defaultFont);
    for(Control control : controls) {
      pushStyle();
      control.draw();
      popStyle();
    }
    popMatrix();
  }
}

abstract class Control {
  int x;
  int y;
  int controlWidth;
  int controlHeight;

  Control(int x, int y, int controlWidth, int controlHeight) {
    this.x = x;
    this.y = y;
    this.controlWidth = controlWidth;
    this.controlHeight = controlHeight;
  }

  boolean encompassesPoint(int lx, int ly) {
    return (lx > x &&
            lx < x + controlWidth &&
            ly > y &&
            ly < y + controlHeight);
  }

  void handleMousePressed(int lx, int ly) {}
  void handleMouseReleased(int lx, int ly) {}
  void handleMouseMoved(int lx, int ly) {}
  abstract void draw();
}

static int DEFAULT_BUTTON_WIDTH = 48;
static int DEFAULT_BUTTON_HEIGHT = 30;

interface ButtonListener {
  abstract void activate();
}

class ControlButton extends Control {

  color LABEL_COL = color(255);
  color STROKE_COL = color(220, 220, 220, 100);
  color FILL_COL_NORMAL = color(10, 100, 230, 255);
  color FILL_COL_HOVER = color(10, 120, 250, 255);
  color FILL_COL_DOWN = color(10, 90, 200, 255);

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