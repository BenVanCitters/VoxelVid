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
