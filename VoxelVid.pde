import processing.opengl.*;
import processing.video.*;

final float E = 2.718281828459045235360287471352;

boolean debug=true;

int wWidth = 80;
float wWSpacing;
int wHeight = 80;
float wHSpacing;
float weights[][];
byte thresh[][];
float threshholdVal = .3;
float zScaling = 1.f;

Capture cam;
PImage textureImg;//sample tex.png

int pointMassCount = 20;
PointMass pointMasses[];

void setup()
{
  // push it to the second monitor but not when run as applet
  size (1024,768, P3D);
  textureImg = loadImage("sample tex.png");
  cam = new Capture(this, 320, 240);
  noCursor();

  initLPD8();
  weights = new float[wHeight][wWidth];
  thresh = new byte[wHeight][wWidth];
  wWSpacing = 1.f/wWidth;
  wHSpacing = 1.f/wHeight;
  initMasses();
}
 
void initMasses()
{
  pointMasses = new PointMass[pointMassCount];
  for(int i = 0; i < pointMasses.length; i++)
  {
    float radian = random(TWO_PI);
    float spd = 1+random(3);
    pointMasses[i] = new PointMass(new float[]{width/2,height/2},
                                   new float[]{spd*cos(radian),spd*sin(radian)},
                                   .02+random(.04));
  }
}
 
void updateMasses()
{
  for(int i = 0; i < pointMasses.length; i++)
  {
    pointMasses[i].update();
  }
}
final float SQRT_TWO_PI = sqrt(TWO_PI);

void updateWeights()
{
  float curThresh = threshholdVal; //save off one value so we don't get weird/unsynced banding issues
  float myRadius = .05;
  for(int i =0 ; i < wHeight; i++)
  {
    for(int j = 0; j < wWidth; j++)
    {
      weights[i][j] = 0;
//      weights[i][j] = random(curThresh*2);
      for(int k = 0; k < pointMasses.length; k++)
      {
        float curDist = dist(pointMasses[k].pos[0],
                        pointMasses[k].pos[1],
                        j*width/wWidth,
                        i*height/wHeight);
        myRadius = pointMasses[k].m;                        
        //normal dist -> y = e^(-(x-mu)^2/(2*sigma^2)/sqrt(2*Pi*sigma) ... delta is a the spread, mu is the 'x' displacement
        //y = e^(-x^2/(2*delta^2))/sqrt(2*Pi)*sigma
        weights[i][j] += exp(-curDist*curDist/2*myRadius*myRadius)/myRadius*SQRT_TWO_PI;
//        weights[i][j] += 5/curDist;

//        if(curDist < myRadius)                                
//          weights[i][j] += sqrt(myRadius*myRadius- curDist*curDist);
      }
      thresh[i][j] = curThresh > weights[i][j]?(byte)1:(byte)0;
    }
  }
}
 
void drawWeights()
{
  textureMode(NORMALIZED);
  noStroke();
  float yScaling = height*1.0/(wHeight-1);
  float xScaling = width*1.0/(wWidth-1);
  pushMatrix();
  scale(xScaling,yScaling);
  
  beginShape(TRIANGLES);
  texture(cam);
  for(int i = 0; i < wHeight-1; i++)
  {
    for(int j = 0; j < wWidth-1; j++)
    {
//      pushMatrix();
//      translate(j,i);
      int index = thresh[i][j]<<3 | thresh[i][j+1]<<2 | thresh[i+1][j+1]<<1 | thresh[i+1][j];
      drawCase(index,i,j);
//      popMatrix();
    }
  }
  endShape();
  popMatrix();
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
  directionalLight(255, 255, 255, -1, 0, 0);
  ambientLight(200,200,200);
  float s = mouseX*250 / float(width);
  specular(s, s, s);
  emissive(100,100,100);
  shininess(50);
}

public void captureEvent(Capture c) {
  c.read();
}

void draw()
{
//  if (cam.available() == true) {
//    cam.read();
//  }
  lightPass();
  updateMasses();
  updateWeights();
  background(255);
  fill(0);
  float tm = millis()/1000.f;
  pushMatrix();
//  translate(width/2,height/2);
//  rotateX(tm/2);
//  rotateY(tm/2.5);
//  rotateZ(tm/2.8);
//  translate(-width/2,-height/2);
  drawWeights();
  popMatrix();
  if(debug)
  {
    hint(DISABLE_DEPTH_TEST);
    textSize(22);    
    fill(0,0,0);
    text("frameRate: " + frameRate, 10,30);
    
    fill(0,255,0);
    text("frameRate: " + frameRate,9,29);
    hint(ENABLE_DEPTH_TEST);
  }
}
 


