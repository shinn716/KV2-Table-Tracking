class Box {

  PVector pos = new PVector(0, 0);
  float Width=1;
  float Height=1;
  float scale=1;

  boolean touch = false;
  color BoxColor= color(255, 0, 0, 50);
  int thisIndex=0;

  boolean trigger = false;

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

  void Update() {

    color color_under_point = get((int)(pos.x+translatePos.x), (int)(pos.y+translatePos.y) );

    if (blue(color_under_point)>TableTracker2_Kv2.Min && blue(color_under_point)<TableTracker2_Kv2.Max) {
      //Been touch
      
      if(!start){
        BoxColor = color(0, 0, 255, 50);
        trigger = true;
        start = true;
      }
    } 
    
    //else {
    //  BoxColor = color(255, 0, 0, 75);
    //  trigger = false;
    //}
    
    if(start){
      
      if(count>50){
        backdefault();
      }
      else
        count++;
    }
    
    
  }

  public boolean getTrigger() {
    return trigger;
  }


  void backdefault() {
    BoxColor = color(255, 0, 0, 50);
    trigger = false;
    start = false;
    count=0;
  }
  
  
  boolean start=false;
  int count=0;
}