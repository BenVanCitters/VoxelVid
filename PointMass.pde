class PointMass
{
  float m;
  float pos[];
  float vel[];
  boolean isDead;
  PointMass(float[] position, float[] velocity, float mass)
  {
    m = mass;
    pos = position;
    vel = velocity;
    isDead = false;
  }
  
  void update()
  {
    float margin = 30;
    pos[0]+= vel[0];
    pos[1]+= vel[1];
    if(pos[0] > width+margin || pos[0]+margin < 0)
    {
      isDead = true;
      vel[0] *= -1;
      pos[0]+= vel[0];
    }
    if(pos[1] > height+margin || pos[1]+margin < 0)
    {
      isDead = true;
      vel[1] *= -1;
      pos[1]+= vel[1];
    }
  }
  
  void draw()
  {
    pushMatrix();
    translate(pos[0],pos[1]);
    ellipse(0,0,10,10);
    popMatrix();
  }
}
