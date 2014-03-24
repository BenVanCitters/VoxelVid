import processing.opengl.*;
import processing.video.*;
import ddf.minim.*;
Minim minim;
AudioInput in;

RollingSampleListener rSlisten; 

//debug vars
boolean debug=false;
long drawMillis;
long updateMillis;
long threshholdingMillis;

MarchingSquareOutline mySurface;

float threshholdVal = .3f;
float zScaling = 1.f;
float spdMult = 1.f;
//Capture cam;

void setup()
{
  // push it to the second monitor but not when run as applet
  size (screenWidth,screenHeight, OPENGL);
//  cam = new Capture(this, 640, 480);
  noCursor();

  initLPD8();
//  setupAudio();
  mySurface = new MarchingSquareOutline();
  
  background(0);
}

void setupAudio()
{
   minim = new Minim(this);
  in = minim.getLineIn(Minim.MONO, 512,44100);
   rSlisten = new RollingSampleListener();
  in.addListener(rSlisten); 
}

// this is needed for fullscreen display on the second monitor
public void init() 
{
//  frame.removeNotify();
//  frame.setUndecorated(true);
//  frame.setAlwaysOnTop(true);
  // call PApplet.init() to take care of business 
  super.init(); 
} 

void lightPass()
{
  //  lights();
  lightSpecular(255, 255, 255);
//  directionalLight(255, 255, 255, -1, 0, 0);
  ambientLight(200,200,200);
  float s = mouseX*250 / float(width);
  specular(s, s, s);
  emissive(100,100,100);
  shininess(50);
}

void renderBack()
{
  noLights();
  hint(DISABLE_DEPTH_TEST);   
  noStroke();
  fill(0,255);
  rect(0,0,width,height);
  hint(ENABLE_DEPTH_TEST);
// float[] samples = new float[1024];//in.mix.toArray();
//  rSlisten.getLastSamples(samples);
//  
//  float hSpacing = samples.length/width;
//  noFill();
//  stroke(255);
//  beginShape();
//  for(int i = 0;  i < samples.length; i++)
//  {
////    vertex(hSpacing*i,height/2 + samples[i]*200);
//  }
////  println("samples.length" + samples.length);
//  endShape();
 
}

public void captureEvent(Capture c) {
  c.read();
  mySurface.textureImg = c;
}

void draw()
{
//  if (cam != null && cam.available() == true) 
//  {
//    cam.read();
////    mySurface.textureImg = cam;
//  }
  renderBack();
//  lightPass();


  fill(0);
  float tm = millis()/1000.f;
  pushMatrix();
//  translate(width/2,height/2);
//  rotateX(tm/2);
//  rotateY(tm/2.5);
//  rotateZ(tm/2.8);
//  translate(-width/2,-height/2);
  strokeWeight(1);
  long lTm = millis();
  mySurface.updateWeights(millis());
  int stepcount= 12;
  for(int i = 0; i < stepcount; i++)
  {
    stroke(255,i*255/(stepcount-1),0);
    threshholdVal = .2+.025*i;
    translate(0,0,10);
    pushMatrix();
    translate(-width/2,-height/2);
    rotateX(tm/22);
    rotateY(tm/22.5);
    rotateZ(tm/22.8);
    translate(width/2,height/2);
    mySurface.draw();  
    popMatrix();
  }
  
  popMatrix();
  if(debug)
  {
    fill(0);
    rect(0,0,350,80);
    hint(DISABLE_DEPTH_TEST);
    textSize(22);    
    String s = "frameRate: " + frameRate;
    fill(0,0,0);
    text(s, 10,30);
    
    fill(0,255,0);
    text(s,9,29);
    s = "drawMillis: " + drawMillis;
    
    fill(0,0,0);
    text(s, 10,55);
    
    fill(0,255,0);
    text(s,9,54);
    
     s = "updateMillis: " + updateMillis;
    
    fill(0,0,0);
    text(s, 10,80);
    
    fill(0,255,0);
    text(s,9,79);
    
     s = "threshholdingMillis: " + threshholdingMillis;
    
    fill(0,0,0);
    text(s, 10,110);
    
    fill(0,255,0);
    text(s,9,109);
    
    hint(ENABLE_DEPTH_TEST);
  }
}
 


