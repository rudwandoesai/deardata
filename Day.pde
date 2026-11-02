// One day of data. Every row of data.csv becomes one Day object,
// and each Day knows how to draw itself as a footprint.
class Day {
  int number;      // 1 to 100
  String date;     // e.g. "25 Jul"
  String weekday;  // e.g. "Sat"
  int steps;       // steps walked that day
  float x, y;      // where the footprint sits on the page

  Day(int number, String date, String weekday, int steps) {
    this.number = number;
    this.date = date;
    this.weekday = weekday;
    this.steps = steps;

    // 10 footprints per row, like walking across the page
    int col = (number - 1) % 10;
    int row = (number - 1) / 10;
    x = 90 + col * 80;
    y = 150 + row * 78;

    // Left foot slightly higher, right foot slightly lower, like a real trail
    if (isLeftFoot()) {
      y -= 10;
    } else {
      y += 10;
    }
  }

  boolean isLeftFoot() {
    return number % 2 == 1;
  }

  // Bigger footprint = more steps (square root so small days are still visible)
  float footSize(int maxSteps) {
    return map(sqrt(steps), 0, sqrt(maxSteps), 0.2, 1.0);
  }

  void display(int maxSteps) {
    float s = footSize(maxSteps);
    pushMatrix();
    translate(x, y);
    rotate(HALF_PI);          // point the foot to the right (walking direction)
    if (!isLeftFoot()) {
      scale(-1, 1);           // mirror for the right foot
    }
    scale(s);

    noStroke();
    fill(colourFor(steps), 230);

    // Sole and heel
    ellipse(0, -6, 30, 44);
    ellipse(-1, 18, 22, 26);

    // Toes - the big toe is on the inside of the foot
    ellipse(-9, -36, 11, 13);
    ellipse(-1, -40, 8, 9);
    ellipse(6, -38, 7, 8);
    ellipse(11, -33, 6, 7);
    ellipse(14, -27, 5, 6);
    popMatrix();
  }

  boolean isHovered(float mx, float my) {
    return dist(mx, my, x, y) < 30;
  }

  void showLabel() {
    String label = weekday + " " + date + ": " + nfc(steps) + " steps";
    textSize(14);
    float w = textWidth(label) + 20;
    float bx = constrain(mouseX + 12, 10, width - w - 10);
    float by = mouseY - 40;
    fill(30, 230);
    noStroke();
    rect(bx, by, w, 28, 6);
    fill(255);
    textAlign(LEFT, CENTER);
    text(label, bx + 10, by + 14);
  }
}
