// Dear Data 100 - My Steps
// 100 days of steps (25 Jul - 1 Nov 2026), taken from my iPhone Health app.
// Each day is one footprint, walking across the page in rows of 10:
//   size   = how many steps I did that day
//   colour = how active the day was
//   left and right feet alternate, like real walking
// Hover over a footprint to see the date and step count.

ArrayList<Day> days = new ArrayList<Day>();
int maxSteps = 0;

void setup() {
  size(900, 1000);
  loadData("data.csv");
}

void draw() {
  background(250, 247, 240);
  drawTitle();

  for (Day d : days) {
    d.display(maxSteps);
  }

  drawLegend();

  // Show details for the footprint under the mouse
  for (Day d : days) {
    if (d.isHovered(mouseX, mouseY)) {
      d.showLabel();
      break;
    }
  }
}

// Reads each row of the CSV and turns it into a Day object
void loadData(String filename) {
  Table table = loadTable(filename, "header");
  for (TableRow row : table.rows()) {
    Day d = new Day(
      row.getInt("day"),
      row.getString("date"),
      row.getString("weekday"),
      row.getInt("steps")
    );
    days.add(d);
    maxSteps = max(maxSteps, d.steps);
  }
}

// Method that returns a value: the average steps per day
int averageSteps() {
  int total = 0;
  for (Day d : days) {
    total += d.steps;
  }
  return total / days.size();
}

// Method that returns a value: how many days hit a target
int daysOver(int target) {
  int count = 0;
  for (Day d : days) {
    if (d.steps >= target) {
      count++;
    }
  }
  return count;
}

// Method that returns a value: a colour for a step count
color colourFor(int steps) {
  if (steps < 3000) return color(158, 168, 186);   // quiet day - grey blue
  if (steps < 8000) return color(233, 176, 84);    // some walking - amber
  if (steps < 12000) return color(91, 168, 120);   // active - green
  return color(30, 110, 80);                       // very active - dark green
}

void drawTitle() {
  fill(40);
  textAlign(LEFT, TOP);
  textSize(28);
  text("100 Days of Walking", 50, 30);
  textSize(14);
  fill(100);
  text("25 Jul - 1 Nov 2026  |  average " + averageSteps() + " steps a day  |  "
       + daysOver(10000) + " days over 10,000", 50, 68);
}

void drawLegend() {
  textAlign(LEFT, CENTER);
  textSize(13);
  int[] examples = {1000, 5000, 9000, 13000};
  String[] labels = {"under 3,000", "3,000 - 7,999", "8,000 - 11,999", "12,000+"};
  for (int i = 0; i < examples.length; i++) {
    float x = 60 + i * 210;
    float y = 950;
    noStroke();
    fill(colourFor(examples[i]));
    ellipse(x, y, 16, 16);
    fill(80);
    text(labels[i], x + 16, y);
  }
}
