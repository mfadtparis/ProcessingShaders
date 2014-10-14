//  http://piratepad.net/cRl5IP8K4O
// TextWrangler

// Our shader
PShader myShader;

// Our shape
PShape myShape;

// 
boolean automaticMode;

// variables used to keep track of the shader parameters
boolean invert;
boolean adjust;
boolean bw;
boolean pixelate;
boolean hFlip;
boolean vFlip;
boolean edge;
boolean emboss;

// 
boolean colorFilter;
boolean filterRed;
boolean filterGreen;
boolean filterBlue;


void setup() {
  size(500, 500, P3D);

  // Load a fragment's shader  
  myShader = loadShader("fragment.glsl");
  // Set default values to be used by the shader
  myShader.set("minRed", .2);
  myShader.set("maxRed", .8);
  myShader.set("minGreen", .1);
  myShader.set("maxGreen", .8);
  myShader.set("minBlue", .3);
  myShader.set("maxBlue", .5);

  // Get the shape
  myShape = getShape();
}

void draw() {
  background(0);
  translate(width/2, height/2);
  shapeMode(CENTER);
  shader(myShader);

  //scale(map(mouseX, 0, width, .2, 2));
  // Draws the shape
  shape(myShape);

  // If automatic mode, then invert colors on a regular basis
  if (automaticMode && frameCount%25 == 0) {
    invert = !invert;
    myShader.set("invert", invert);
  }
}


void keyPressed() {

  if (key == 'i') {
    invert = !invert; 
    myShader.set("invert", invert);
  }
  if (key == 'f') {
    colorFilter = !colorFilter; 
    myShader.set("colorFilter", colorFilter);
  }
  if (key == 'a') {
    adjust = !adjust; 
    myShader.set("adjust", adjust);
  }
  if (key == 'e') {
    emboss = !emboss; 
    myShader.set("emboss", emboss);
  }
  if (key == 'd') {
    edge = !edge; 
    myShader.set("edge", edge);
  }
  if (key == 'w') {
    bw = !bw; 
    myShader.set("bw", bw);
  }
  if (key == 'h') {
    hFlip = !hFlip; 
    myShader.set("hFlip", hFlip);
  }
  if (key == 'p') {
    pixelate = !pixelate; 
    myShader.set("pixelate", pixelate);
  }
  if (key == 'v') {
    vFlip = !vFlip; 
    myShader.set("vFlip", vFlip);
  }

  // Toggle automtic mode ON/OFF
  if (key == 'm') {
    automaticMode = !automaticMode;
  }

  // Command used to change several parameters in the meantime
  if (key == 'x') {
    invert = !invert;
    adjust = !adjust;
    myShader.set("invert", invert);
    myShader.set("adjust", adjust);
  }

  if (key == 'r') {
    filterRed = !filterRed;
  }
  if (key == 'g') {
    filterGreen = !filterGreen;
  }
  if (key == 'b') {
    filterBlue = !filterBlue;
  }
} 

void mouseMoved() {

  if (colorFilter && (filterGreen || filterRed || filterBlue)) {
    // Change the red, green, blue min/max limits when mouse is moved
    // Color filter must me ON and one of the color selector ON as well (r, g, b)
    float minValue = map(mouseX, 0, width, 0, 1);
    float maxValue = map(mouseY, 0, height, 0, 1); 
    if (filterGreen) {
      myShader.set("minGreen", minValue);
      myShader.set("maxGreen", maxValue);
    } else if (filterRed) {
      myShader.set("minRed", minValue);
      myShader.set("maxRed", maxValue);
    } else if (filterBlue) {
      myShader.set("minBlue", minValue);
      myShader.set("maxBlue", maxValue);
    }
  } else if (adjust) {
    // Change the contrast and brightness when mouse is moved (adjust must be ON)
    myShader.set("contrast", map(mouseX, 0, width, 0, 1));
    myShader.set("brightness", map(mouseY, 0, height, 0, 1));
  }
}

// Change the pixel size when mouse is dragged (click + move)  (pixelate must be ON)
void mouseDragged() {
  myShader.set("pixelSize", map(mouseX, 0, width, 0., 100.));
}

PShape getShape() {
  PShape sh = createShape();
  PImage img = loadImage("img.jpg"); 
  float scaling = 1;

  sh.beginShape(QUADS);
  sh.texture(img); 
  sh.vertex(0, 0, 0, 0);
  sh.vertex(img.width*scaling, 0, img.width, 0);
  sh.vertex(img.width*scaling, img.height*scaling, img.width, img.height);
  sh.vertex(0, img.height*scaling, 0, img.height);
  sh.endShape();

  return sh;
}

