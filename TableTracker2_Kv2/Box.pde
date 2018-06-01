class Box {

  PVector pos = new PVector(0, 0);
  float Width=1;
  float Height=1;
  float scale=1;

  public color BoxColor= color(255, 0, 0, 50);
  
  Box(PVector _pos, float _width, float _height, float _scale) {
    pos = _pos;
    Width = _width;
    Height = _height;
    scale = _scale;
  }

  void Draw() {
    fill(BoxColor);
    noStroke();
    rect(pos.x, pos.y, Width*scale-Width*scale/2, Height*scale-Height*scale/2);
  }
  
  public PVector position(){
    return pos;
  }

}