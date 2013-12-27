class PointMass
{
  float mass;
  float pos[];
  float vel[];
  
  PointMass(float[] position, float[] velocity)
  {
    pos = position;
    vel = velocity;
  }
  
  void update()
  {
    pos[0]+= vel[0];
    pos[1]+= vel[1];
    if(pos[0] > width || pos[0] < 0)
    {
      vel[0] *= -1;
      pos[0]+= vel[0];
    }
    if(pos[1] > height || pos[1] < 0)
    {
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
