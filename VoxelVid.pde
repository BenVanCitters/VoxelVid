//debug vars
boolean debug=false;
long drawMillis;
long updateMillis;
long threshholdingMillis;

MarchingSquareOutline mySurface;

float threshholdVal = .3f;
float zScaling = 1.f;
float spdMult = 1.f;

void setup()
{
  // push it to the second monitor but not when run as applet
  //  size (500,500, P3D);
  size (1280, 720, P3D);
//  noCursor();

  mySurface = new MarchingSquareOutline();

  background(0);
}

float threshIncrement =0.031666666;
float weightTimeDiv = 1.f;
float stepElev = 15;
void draw()
{
 background(0);

  fill(0);
  float tm = millis()/1000.f;
  pushMatrix();
  strokeWeight(1);
  long lTm = millis();
  mySurface.updateWeights(tm);
  int stepcount= 15;
  float stepHeight = 15.f;

  println("threshIncrement: " + threshIncrement);
  for (int i = 0; i < stepcount; i++)
  {
    stroke((stepcount-i-1)*255, i*255/(stepcount-1), 0);
    threshholdVal = .1+threshIncrement*i;

    pushMatrix();
    translate(width/2, height/2, -50);
//    rotateX(PI/3);
//    rotateZ(PI/2);
    translate(0, 0, (stepcount-1)*stepHeight/2-stepElev*i);
    translate(-width/2, -height/2);
    mySurface.draw();  
    popMatrix();
  }

  popMatrix();
  if (debug)
  {
    fill(0);
    rect(0, 0, 350, 80);
    hint(DISABLE_DEPTH_TEST);
    textSize(22);    
    String s = "frameRate: " + frameRate;
    fill(0, 0, 0);
    text(s, 10, 30);

    fill(0, 255, 0);
    text(s, 9, 29);
    s = "drawMillis: " + drawMillis;

    fill(0, 0, 0);
    text(s, 10, 55);

    fill(0, 255, 0);
    text(s, 9, 54);

    s = "updateMillis: " + updateMillis;

    fill(0, 0, 0);
    text(s, 10, 80);

    fill(0, 255, 0);
    text(s, 9, 79);

    s = "threshholdingMillis: " + threshholdingMillis;

    fill(0, 0, 0);
    text(s, 10, 110);

    fill(0, 255, 0);
    text(s, 9, 109);
    hint(ENABLE_DEPTH_TEST);
  }
}

