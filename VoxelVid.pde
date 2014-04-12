import processing.opengl.*;
import processing.video.*;
import ddf.minim.*;
Minim minim;
AudioInput in;

boolean recording = false;
float secondsRecorded = 0.0f;
MovieMaker mm;

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
//  size (1280,720, OPENGL);
//  cam = new Capture(this, 640, 480);
  noCursor();

  initLPD8();
//  setupAudio();
  mySurface = new MarchingSquareOutline();
  
  background(0);
    if(recording)
  {
    frameRate(30);    
    mm = new MovieMaker(this, width, height, "2nd'st recording.mov",
                         30, MovieMaker.VIDEO, MovieMaker.LOW);
  } 
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
float threshIncrement =0.031666666;// mouseX*.06/height;
float weightTimeDiv = 1.f;
float stepElev = 15;
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
  if(recording)
    tm = frameCount*30.f/1000.f;
  pushMatrix();
//  translate(width/2,height/2);
//  rotateX(tm/2);
//  rotateY(tm/2.5);
//  rotateZ(tm/2.8);
//  translate(-width/2,-height/2);
  strokeWeight(1);
  long lTm = millis();
  mySurface.updateWeights(tm);
  int stepcount= 15;
  float stepHeight = 15.f;
  
  println("threshIncrement: " + threshIncrement);
  for(int i = 0; i < stepcount; i++)
  {
    stroke((stepcount-i-1)*255,i*255/(stepcount-1),0);
    threshholdVal = .1+threshIncrement*i;
    
    pushMatrix();

    translate(width/2,height/8,-50);
    rotateX(PI/3);
    rotateZ(PI/2);
//       rotateY(PI);


//    rotateZ(tm/5.5);

    translate(0,0,(stepcount-1)*stepHeight/2-stepElev*i);
    translate(-width/2,-height/2);
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
        if(recording)
  {

    secondsRecorded = frameCount/30.0;
    mm.addFrame();  // Add window's pixels to movie
    println("kinectMush3D - frameRate: " + frameRate + " secondsRecorded: " + secondsRecorded);
  }
}
 
void exit() 
{
  if(recording)
  {
    mm.finish();
  }  
  super.exit ();
}
void stop()
{
  if(recording)
  {
    mm.finish();
  }
  super.stop();
}

