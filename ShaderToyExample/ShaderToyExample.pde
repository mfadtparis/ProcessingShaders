// Processing sketch to be used to test http://shadertoy.com examples
//
// Original version form Raphael de Courville
//
// How to :
// Replace the shader.glsl file content with a shadertoy example
// Run the sketch
// Note : some examples may not work. If so, just pick another one or try to fix the issues by yourself

PShader myShader;
String shaderName = "shader.glsl";

void setup() {
  size(500, 500, OPENGL);
  noSmooth();
  try {

    myShader = loadShader(shaderName);
    myShader.set("resolution", float(width), float(height));
    myShader.set("mouse", float(mouseX), float(mouseY));  
    myShader.set("time", (float)(millis() / 1000.0));
  }
  catch (Exception e) {
    println("Something went bad");
    println(e);
  }
}

void draw() {
  frame.setTitle(""+floor(frameRate));
  try {
    myShader.set("mouse", float(mouseX), float(mouseY));  
    myShader.set("time", (float)(millis() / 1000.0));

    shader(myShader);

    noStroke();
    fill(0);
    rect(0, 0, width, height);  
    resetShader();
  }
  catch (Exception e) {
    println("Something went bad");
    println(e);
  }
}

