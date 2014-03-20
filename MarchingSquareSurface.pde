float innerCircleRadius = .6;
class MarchingSquareSurface
{
  int wWidth = 70;
  float wWSpacing;
  int wHeight = 70;
  float wHSpacing;
  float weights[][];
  byte thresh[][];
  
  int pointMassCount = 20;
  PointMass pointMasses[];
  
  PImage textureImg;
  
  public MarchingSquareSurface()
  {
    textureImg = loadImage("sample tex.jpg");
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
      pointMasses[i] = createPointMass();
    }
  }
   
  PointMass createPointMass()
  {
    float radian = random(TWO_PI);
      float spd = 1+random(3);
      return new PointMass(new float[]{width/2,height/2},
                                     new float[]{spd*cos(radian),spd*sin(radian)},
                                     .02+random(.04));
  }


void updateMasses()
{
  for(int i = 0; i < pointMasses.length; i++)
  {
    pointMasses[i].update();
    if(pointMasses[i].isDead)
    {
      pointMasses[i] = createPointMass();
    }
  }
}
final float SQRT_TWO_PI = sqrt(TWO_PI);

void updateWeights()
{
  updateMillis = millis();
  float curThresh = threshholdVal; //save off one value so we don't get weird/unsynced banding issues
  float myRadius = .05;
  float wScaling = cam.width*1.f/cam.height;
  for(int i =0 ; i < wHeight; i++)
  {
    for(int j = 0; j < wWidth; j++)
    {
      weights[i][j] = 0;
      if(dist(.5 * wScaling,.5,
                        j*1.f/wWidth * wScaling,
                        i*1.f/wHeight) < innerCircleRadius)
      {
        weights[i][j] = 50;
      }
//      else
      {
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
      }
      thresh[i][j] = curThresh > weights[i][j]?(byte)1:(byte)0;
    }
  }
  updateMillis = millis()-updateMillis;
}
 
void drawWeights()
{
  drawMillis = millis();
  textureMode(NORMALIZED);
  noStroke();
  float yScaling = height*1.0/(wHeight-1);
  float xScaling = width*1.0/(wWidth-1);
  pushMatrix();
  scale(xScaling,yScaling);
  
  beginShape(TRIANGLES);
  texture(cam);//(textureImg);
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
  drawMillis = millis() - drawMillis;
}

  void draw()
  {
    updateMasses();
    updateWeights();
    drawWeights();
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
float curScaling =  zScaling;
  for(int k = 0; k < hts.length;k++)
    hts[k] *= curScaling;  
//  beginShape();

  float pos[] = new float[]{j,i};
  
  switch(index){
    case 0:
        vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
        vertex(pos[0]+1,pos[1],hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
        vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
        
        vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
        vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
        vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
        break;
//      endShape();
    case 1:
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(pos[0]+1,pos[1],hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
        
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      
       vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      break;
    case 2:
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(pos[0]+1,pos[1],hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );  
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
        
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      break;
    case 3:
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(pos[0]+1,pos[1],hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
        
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      break;
    case 4:      
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
        
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
       vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
        
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );  
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      break;
    case 5:
        vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );              
        vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
        vertex(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
//      endShape();
//      beginShape(TRIANGLE_FAN);
//        texture(cam);
        vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
        vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
        vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      break;
    case 6:      
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
        
      vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      break;
    case 7:        
      vertex(pos[0],pos[1],hts[0]
        ,texBase[0],texBase[1]
        );
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 8:  
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(pos[0]+1,pos[1],hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
        
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 9:
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(pos[0]+1,pos[1],hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
       vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      break;
    case 10:
        vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
        vertex(pos[0]+1,pos[1],hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
        vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
//      endShape();
//      
//      beginShape(TRIANGLE_FAN);
//        texture(cam);
        vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
        vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
        vertex(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );      
      break;
    case 11:
      vertex(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vertex(pos[0]+1,pos[1],hts[2]
        ,texBase[0]+wWSpacing,texBase[1]
        );
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      break;
    case 12:
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
        
      vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      break;
    case 13:
      vertex(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vertex(pos[0]+1,pos[1]+1,hts[4]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
        );
      vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      break;
    case 14:
      vertex(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+1,hts[6]
        ,texBase[0],texBase[1]+wHSpacing
        );
      vertex(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    default:
      break;
  }
//  endShape();
}
}
