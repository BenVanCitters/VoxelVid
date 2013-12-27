import processing.opengl.*;


boolean debug=true;

int wWidth = 100;
int wHeight = 100;
float weights[][];
byte thresh[][];
float threshholdVal = .3;

PointMass pointMasses[];

void setup()
{
  // push it to the second monitor but not when run as applet
  size (1024,768, P3D);
  noCursor();

  initLPD8();
  weights = new float[wHeight][wWidth];
  thresh = new byte[wHeight][wWidth];
  initMasses();
}
 
void initMasses()
{
  pointMasses = new PointMass[10];
  for(int i = 0; i < pointMasses.length; i++)
  {
    float radian = random(TWO_PI);
    float spd = 1+random(3);
    pointMasses[i] = new PointMass(new float[]{width/2,height/2},
                                   new float[]{spd*cos(radian),spd*sin(radian)});
  }
}
 
void updateMasses()
{
  for(int i = 0; i < pointMasses.length; i++)
  {
    pointMasses[i].update();
  }
}
 
void updateWeights()
{
  float curThresh = threshholdVal; //save off one value so we don't get weird/unsynced banding issues
  for(int i =0 ; i < wHeight; i++)
  {
    for(int j = 0; j < wWidth; j++)
    {
      weights[i][j] = 0;
      weights[i][j] = random(curThresh*2);
//      for(int k = 0; k < pointMasses.length; k++)
//      {
//        weights[i][j] += 5/dist(pointMasses[k].pos[0],
//                                pointMasses[k].pos[1],
//                                j*width/wWidth,
//                                i*height/wHeight);
//      }
      thresh[i][j] = curThresh > weights[i][j]?(byte)1:(byte)0;
    }
  }
}
 
void drawWeights()
{
  float yScaling = height*1.0/(wHeight-1);
  float xScaling = width*1.0/(wWidth-1);
  for(int i = 0; i < wHeight-1; i++)
  {
    for(int j = 0; j < wWidth-1; j++)
    {
      pushMatrix();
      scale(xScaling,yScaling);
      translate(j,i);
       int index = thresh[i][j]<<3 | thresh[i][j+1]<<2 | thresh[i+1][j+1]<<1 | thresh[i+1][j];
       drawCase(index);
       popMatrix();
    }
  }
}
 
void drawCase(int index)
{
  beginShape();
  switch(index){
    case 0:
        vertex(0,0);
        vertex(1,0);
        vertex(1,1);
        vertex(0,1);
        break;
    case 1:
      vertex(0,0);
      vertex(1,0);
      vertex(1,1);
      vertex(.5,1);
      vertex(0,.5);
      break;
    case 2:
      vertex(0,0);
      vertex(1,0);
      vertex(1,.5);
      vertex(.5,1);
      vertex(0,1);
      break;
    case 3:
      vertex(0,0);
      vertex(1,0);
      vertex(1,.5);
      vertex(0,.5);
      break;
    case 4:      
      vertex(0,0);
      vertex(.5,0);
      vertex(1,.5);
      vertex(1,1);
      vertex(0,1);
      break;
    case 5:
        vertex(0,0);              
        vertex(.5,0);
        vertex(0,.5);
      endShape();
      beginShape();
        vertex(1,.5);
        vertex(1,1);
        vertex(.5,1);
      break;
    case 6:      
      vertex(0,0);
      vertex(.5,0);
      vertex(.5,1);
      vertex(0,1);
      break;
    case 7:        
      vertex(0,0);
      vertex(.5,0);
      vertex(0,.5);
      break;
    case 8:  
      vertex(.5,0);
      vertex(1,0);
      vertex(1,1);
      vertex(0,1);
      vertex(0,.5);
      break;
    case 9:
      vertex(.5,0);
      vertex(1,0);
       vertex(1,1);
      vertex(.5,1);
      break;
    case 10:
        vertex(.5,0);
        vertex(1,0);
        vertex(1,.5);
      endShape();
      
      beginShape();
        vertex(.5,1);
        vertex(0,1);
        vertex(0,.5);      
      break;
    case 11:
      vertex(.5,0);
      vertex(1,0);
      vertex(1,.5);
      break;
    case 12:
      vertex(1,.5);
      vertex(1,1);
      vertex(0,1);
      vertex(0,.5);
      break;
    case 13:
      vertex(1,.5);
      vertex(1,1);
      vertex(.5,1);
      break;
    case 14:
      vertex(.5,1);
      vertex(0,1);
      vertex(0,.5);
      break;
    default:
      break;
  }
  endShape();
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
 
void draw()
{
  updateMasses();
  updateWeights();
  background(255);
  fill(0);
  drawWeights();
  
  if(debug)
  {
    textSize(22);
    fill(0);
    text("frameRate: " + frameRate, 10, 30);
  }
}
 


