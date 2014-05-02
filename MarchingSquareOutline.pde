class MarchingSquareOutline
{
  int wWidth = 150*1366/768;
  float wWSpacing;
  int wHeight = 150;
  float wHSpacing;
  float weights[][];
  byte thresh[][];
  
  int pointMassCount = 20;
  PointMass pointMasses[];
  
  
  public MarchingSquareOutline()
  {
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

void updateWeights(float tm)
{
  noiseDetail(8,.3);
  updateMillis = millis();
  float myRadius = .05;
  float wScaling =1;
  for(int i =0 ; i < wHeight; i++)
  {
    for(int j = 0; j < wWidth; j++)
    {
      float xval = i/75.f;
      float yval = j/75.f;
      
//      weights[i][j] = noise(xval,yval,tm/1800.f)/2 +noise(xval,tm/2300.f,yval)/2;// 0;
      weights[i][j] = noise(xval,yval-tm/4.8f, tm/(weightTimeDiv*18.f));// +noise(xval,tm/2300.f,yval)/2;// 0;
      
//      for(int k = 0; k < pointMasses.length; k++)
//      {
//        float curDist = dist(pointMasses[k].pos[0],
//                        pointMasses[k].pos[1],
//                        j*width/wWidth,
//                        i*height/wHeight);
//        myRadius = pointMasses[k].m;                        
//        //normal dist -> y = e^(-(x-mu)^2/(2*sigma^2)/sqrt(2*Pi*sigma) ... delta is a the spread, mu is the 'x' displacement
//        //y = e^(-x^2/(2*delta^2))/sqrt(2*Pi)*sigma
//        weights[i][j] += exp(-curDist*curDist/2*myRadius*myRadius)/myRadius*SQRT_TWO_PI;
//      }
    }
  }
  updateMillis = millis()-updateMillis;
}


private void evalThreshholds()
{
  threshholdingMillis = millis();
  float curThresh = threshholdVal; //save off one value so we don't get weird/unsynced banding issues
  for(int i =0 ; i < wHeight; i++)
   {
     for(int j = 0; j < wWidth; j++)
     {
       thresh[i][j] = curThresh > weights[i][j]?(byte)1:(byte)0;
     }
   } 
  threshholdingMillis = millis()-threshholdingMillis;
}
 
void drawWeights()
{
  drawMillis = millis();
//  textureMode(NORMALIZED);

//lights();
  float yScaling = height*1.0/(wHeight-1);
  float xScaling = width*1.0/(wWidth-1);
  pushMatrix();
  scale(xScaling,yScaling);
  
  beginShape(LINES);
  for(int i = 0; i < wHeight-1; i++)
  {
    for(int j = 0; j < wWidth-1; j++)
    {
      int index = thresh[i][j]<<3 | thresh[i][j+1]<<2 | thresh[i+1][j+1]<<1 | thresh[i+1][j];
//      if(index != 0)
      drawCase(index,i,j);
    }
  }
  endShape();
  popMatrix();
  drawMillis = millis() - drawMillis;
}

  void draw()
  {
//    updateMasses();    
    evalThreshholds();
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

  float pos[] = new float[]{j,i};
  
  switch(index){
    case 0:
        break;
    case 1:      
       vert(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vert(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
//      vert(pos[0],pos[1],hts[0]
//        ,texBase[0],texBase[1]
//        );
      break;
    case 2:      
//      vert(pos[0],pos[1],hts[0]
//        ,texBase[0],texBase[1]
//        );  
      vert(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vert(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );        
      break;
    case 3:        
      vert(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      vert(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
//      vert(pos[0],pos[1],hts[0]
//        ,texBase[0],texBase[1]
//        );
      break;
    case 4:      
//      vert(pos[0],pos[1],hts[0]
//        ,texBase[0],texBase[1]
//        );
      vert(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vert(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );        
      break;
    case 5:
//        vert(pos[0],pos[1],hts[0]
//        ,texBase[0],texBase[1]
//        );              
        vert(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
        vert(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );

        vert(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
//        vert(pos[0]+1,pos[1]+1,hts[4]
//        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
//        );
        vert(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      break;
    case 6:      
//      vert(pos[0],pos[1],hts[0]
//        ,texBase[0],texBase[1]
//        );
      vert(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vert(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );        
      break;
    case 7:        
//      vert(pos[0],pos[1],hts[0]
//        ,texBase[0],texBase[1]
//        );
      vert(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      vert(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 8:       
      vert(pos[0]+.5,pos[1],hts[1]//
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
//      vert(pos[0],pos[1]+1,hts[6]
//        ,texBase[0],texBase[1]+wHSpacing
//        );
      vert(pos[0],pos[1]+.5,hts[7]///
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    case 9:      
//      vert(pos[0]+1,pos[1]+1,hts[4]
//        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
//        );
      vert(pos[0]+.5,pos[1]+1,hts[5]//
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      vert(pos[0]+.5,pos[1],hts[1]//
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
      break;
    case 10:
        vert(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
//        vert(pos[0]+1,pos[1],hts[2]
//        ,texBase[0]+wWSpacing,texBase[1]
//        );
        vert(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );

        vert(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
//        vert(pos[0],pos[1]+1,hts[6]
//        ,texBase[0],texBase[1]+wHSpacing
//        );
        vert(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );      
      break;
    case 11:
      vert(pos[0]+.5,pos[1],hts[1]
        ,texBase[0]+wWSpacing/2,texBase[1]
        );
//      vert(pos[0]+1,pos[1],hts[2]
//        ,texBase[0]+wWSpacing,texBase[1]
//        );
      vert(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      break;
    case 12:
//      vert(pos[0],pos[1]+1,hts[6]
//        ,texBase[0],texBase[1]+wHSpacing
//        );
      vert(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      vert(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
      break;
    case 13:
      vert(pos[0]+1,pos[1]+.5,hts[3]
        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing/2
        );
//      vert(pos[0]+1,pos[1]+1,hts[4]
//        ,texBase[0]+wWSpacing,texBase[1]+wHSpacing
//        );
      vert(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
      break;
    case 14:
      vert(pos[0]+.5,pos[1]+1,hts[5]
        ,texBase[0]+wWSpacing/2,texBase[1]+wHSpacing
        );
//      vert(pos[0],pos[1]+1,hts[6]
//        ,texBase[0],texBase[1]+wHSpacing
//        );
      vert(pos[0],pos[1]+.5,hts[7]
        ,texBase[0],texBase[1]+wHSpacing/2
        );
      break;
    default:
      break;
    }
  }
  
  void vert(float pos1,float pos2,float pos3,float uv1,float uv2)
  {
    vertex(pos1,pos2,pos3
//        ,uv1,uv2
        );
  }
}
