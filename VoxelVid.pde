import processing.opengl.*;


boolean debug=true;

int wWidth = 100;
float wWSpacing;
int wHeight = 100;
float wHSpacing;
float weights[][];
byte thresh[][];
float threshholdVal = .3;

PImage textureImg;//sample tex.png

PointMass pointMasses[];

void setup()
{
  // push it to the second monitor but not when run as applet
  size (1024,768, P3D);
  textureImg = loadImage("sample tex.png");
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
//      weights[i][j] = random(curThresh*2);
      for(int k = 0; k < pointMasses.length; k++)
      {
        weights[i][j] += 5/dist(pointMasses[k].pos[0],
                                pointMasses[k].pos[1],
                                j*width/wWidth,
                                i*height/wHeight);
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
  for(int i = 0; i < wHeight-1; i++)
  {
    for(int j = 0; j < wWidth-1; j++)
    {
      pushMatrix();
      translate(j,i);
      int index = thresh[i][j]<<3 | thresh[i][j+1]<<2 | thresh[i+1][j+1]<<1 | thresh[i+1][j];
      drawCase(index,i,j);
      popMatrix();
    }
  }
  popMatrix();
}
 

void drawCase(int index, int i, int j)
{
  float texBase[] = new float[]{j*wWSpacing,i*wHSpacing};
  float hts[] = new float[]{weights[i][j],
                            (weights[i][j+1]+weights[i][j])/2,
                            weights[i][j+1],
                            (weights[i][j+1]+weights[i+1][j+1])/2,
                            weights[i+1][j+1],
                            (weights[i+1][j+1]+weights[i+1][j])/2,
                            weights[i+1][j],
                            (weights[i+1][j]+weights[i][j])/2};
  //scale the zvalues                            
  for(int k = 0; k < hts.length;k++)
    hts[k] *= 5;  
  beginShape();
  texture(textureImg);
  switch(index){
    case 0:
        vertex(0,0,hts[0]
        ,texBase[0],texBase[1]
        );
        vertex(1,0,hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
        vertex(1,1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
        vertex(0,1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
        break;
    case 1:
      vertex(0,0,hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(1,0,hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(1,1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(.5,1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(0,.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 2:
      vertex(0,0,hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(1,0,hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(1,.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(.5,1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(0,1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      break;
    case 3:
      vertex(0,0,hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(1,0,hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(1,.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(0,.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 4:      
      vertex(0,0,hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(.5,0,hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(1,.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(1,1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(0,1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      break;
    case 5:
        vertex(0,0,hts[0]
        ,texBase[0],texBase[1]
        );              
        vertex(.5,0,hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
        vertex(0,.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      endShape();
      beginShape();
        texture(textureImg);
        vertex(1,.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
        vertex(1,1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
        vertex(.5,1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      break;
    case 6:      
      vertex(0,0,hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(.5,0,hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(.5,1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(0,1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      break;
    case 7:        
      vertex(0,0,hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(.5,0,hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(0,.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 8:  
      vertex(.5,0,hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(1,0,hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(1,1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(0,1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      vertex(0,.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 9:
      vertex(.5,0,hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(1,0,hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
       vertex(1,1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(.5,1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      break;
    case 10:
        vertex(.5,0,hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
        vertex(1,0,hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
        vertex(1,.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      endShape();
      
      beginShape();
        texture(textureImg);
        vertex(.5,1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
        vertex(0,1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
        vertex(0,.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );      
      break;
    case 11:
      vertex(.5,0,hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(1,0,hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(1,.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      break;
    case 12:
      vertex(1,.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(1,1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(0,1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      vertex(0,.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 13:
      vertex(1,.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(1,1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(.5,1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      break;
    case 14:
      vertex(.5,1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(0,1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      vertex(0,.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
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
  lights();
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
 


