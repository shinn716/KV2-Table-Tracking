class ShinnUtils 
{
  
  
  float distSq(float x1, float y1, float z1, float x2, float y2, float z2){
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1);
    return d;
  }
  
  
  public color GetColor(float px, float py) 
  {
    color pointColor = get((int)px, (int)py);
    return pointColor;
  }


  //----
  //Java default parameter must use overlanding
  public void ShowFPS(){
    ShowFPS(width-50, 20, 12, 255);
  }

  public void ShowFPS(float px, float py, int size, color col)
  {
    fill(col);
    strokeWeight(size);
    textSize(size);
    text("FPS " + round(frameRate), px, py);
  }
  //----
  
}