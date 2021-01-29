Isochahedron isoShape;
Anchor a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12;
public boolean mousePresent = false;
color[][] backgroundColors = { {5, 35, 50}, {39, 107, 122}, {0, 64, 84}, {86, 105, 162}, {170, 162, 204}, {28, 53, 101} };
int numberOfColors, currentColor, nextColor, gradientPercentage, backgroundRed, backgroundGreen, backgroundBlue;

void setup() {
size(500, 500);
//frameRate(20); //TODO REMOVE THIS
  a0 = new Anchor(0, 135, 42);
  a1 = new Anchor(1, 338, 42);
  a2 = new Anchor(2, 358, 94);
  a3 = new Anchor(3, 126, 145);
  a4 = new Anchor(4, 157, 231);
  a5 = new Anchor(5, 12, 262);
  a6 = new Anchor(6, 253, 248);
  a7 = new Anchor(7, 347, 263);
  a8 = new Anchor(8, 493, 231);
  a9 = new Anchor(9, 376, 347);
  a10 = new Anchor(10, 146, 399);
  a11 = new Anchor(11, 164, 454);
  a12 = new Anchor(12, 373, 454);
  Anchor[] AnchorArray= {a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12};
  int[][] Lines = { {6, 1}, {6, 2}, {6, 9}, {6, 12}, {6, 5}, {6, 4}, {3, 0}, {3, 1}, {3, 7}, {3, 10}, {3, 5}, {5, 10}, {7, 1}, {7, 8}, {7, 12}, {10, 7}, {10, 11}, {10, 12}, {0, 1}, {0, 2}, {0, 4}, {0, 5}, {1, 2}, {1, 8}, {2, 4}, {2, 8}, {2, 9}, {4, 5}, {4, 9}, {4, 11}, {5, 11}, {8, 9}, {8, 12}, {9, 11}, {9, 12}, {11, 12}};
  isoShape = new Isochahedron(AnchorArray, Lines);
  numberOfColors = 5;
  currentColor = 0;
  nextColor = 1;
  gradientPercentage = 0;
  backgroundRed = 0;
  backgroundGreen = 0;
  backgroundBlue = 0;
  
  //Set background color
  updateBackgroundColor();
  background(backgroundRed, backgroundGreen, backgroundBlue);
  
  //Draw for the first time
  isoShape.drawIso();
}

void draw() {
  //If the mouse is over the window, update the shape
  if (mousePresent) {
    isoShape.updateAnchors();
  }
  //Update background color
  updateBackgroundColor();
  background(backgroundRed, backgroundGreen, backgroundBlue);
  isoShape.drawIso();
  isoShape.resetAnchors(); //Then, reset anchors to original to use for calculating again (or if mouse leaves window)
}

//Built-in mouseExited funcion - runs once to update state
public void mouseExited() {
  mousePresent = false;
}

//Built-in mouseEntered funcion - runs once to update state
public void mouseEntered() {
  mousePresent = true;
}

//Class for the isochahedron shape itself
class Isochahedron {
  //Variables
  int[][] lines;
  Anchor[] anchors;
  
  //Isochahedron constructor
  Isochahedron(Anchor[] anchorArray, int[][] lineRelationships) {
    lines = lineRelationships;
    anchors = anchorArray;
  }
  
  //Update anchors
  void updateAnchors() {
    //Call .update function for all anchors in shape
    for (int a=0; a<anchors.length; a++) {
      anchors[a].update();
    }
  }
  
  //Reset anchors to original values
  void resetAnchors() {
    // Call .reset for all anchors in shape
    for (int a=0; a<anchors.length; a++) {
      anchors[a].reset();
    }
  }
  
  //Redraw the shape on the screen
  void drawIso() {
    for (int l=0; l < (lines.length); l++) {
      int anchorANumber = lines[l][0];
      int anchorBNumber = lines[l][1];
      Anchor anchorA = anchors[anchorANumber];
      Anchor anchorB = anchors[anchorBNumber];
      if (l < 6) {
        strokeWeight(.75);
      } else if (l < 18) {
        strokeWeight(2);
      } else {
        strokeWeight(5);
      }
      stroke(255);
      line(anchorA.x, anchorA.y, anchorB.x, anchorB.y);
    }
  }
}

class Anchor {
  //Variables
  float xOriginal; //original x value for shape to compare against
  float yOriginal; //original y value for shape to compare against
  float x; //variable for new calculated x value
  float y; //variable for new calculated y value
  
  //Anchor constructor
  Anchor(int num, float xCoord, float yCoord) {
    xOriginal = xCoord;
    yOriginal = yCoord;
    x = xCoord;
    y = yCoord;
  }
  
  //Function for updating anchor x and y based on original 
  void update() {
    //Calculate the distance between original anchor point and cursor position
    float distance = dist(xOriginal, yOriginal, mouseX, mouseY);
    
    //Calculate what percentage to move point, based on proximity to mouse
    float percentageToMove = (700-distance)/700;
    
    //Calculate how far to move point with added coefficient for fine-tuning
    float coefficient = 6;
    float distanceToMove = (percentageToMove*distance)/coefficient;
    
    float xDistanceToMove = distanceToMove;
    if (xDistanceToMove > abs(mouseX - xOriginal)) {
      xDistanceToMove = abs(mouseX - xOriginal);
    }
    
    //Update anchor coordinates
    if (xOriginal < mouseX){
      this.x = x+xDistanceToMove;
    } else {
      this.x = x-xDistanceToMove;
    }
    
    float yDistanceToMove = distanceToMove;
    if (yDistanceToMove > abs(mouseX - yOriginal)) {
      yDistanceToMove = abs(mouseX - yOriginal);
    }
    
    if (yOriginal < mouseY) {
      this.y = y+yDistanceToMove;
    } else {
      this.y = y-yDistanceToMove;
    }
  }
  
  //Reset anchor coordinates to original values
  void reset() {
    this.x = xOriginal;
    this.y = yOriginal;
  }
}

void updateBackgroundColor() {
  //Calculate background colors
  backgroundRed = ((backgroundColors[currentColor][0] * (100-gradientPercentage)) + (backgroundColors[nextColor][0] * gradientPercentage))/100;
  backgroundGreen = ((backgroundColors[currentColor][1] * (100-gradientPercentage)) + (backgroundColors[nextColor][1] * gradientPercentage))/100;
  backgroundBlue = ((backgroundColors[currentColor][2] * (100-gradientPercentage)) + (backgroundColors[nextColor][2] * gradientPercentage))/100;

  //Once color has fully transitioned
  if (gradientPercentage == 100) {
    gradientPercentage = 0; //Reset gradient percentage to start transition again
    currentColor = nextColor; //Move the current color to next color in array
    if (nextColor == numberOfColors) { //If transitioned to last color in array, increment variable to move to next color in array
      nextColor = 0; //Loop around to first color
    } else {
      nextColor++; //Increment variable to move to next color in array  
    }
  } else {
    gradientPercentage++; //If color hasn't fully transitioned yet, just increase gradient  
  }
}
