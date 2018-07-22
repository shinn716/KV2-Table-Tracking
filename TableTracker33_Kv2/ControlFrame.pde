

class ControlFrame extends PApplet {

  OSC osc = new OSC();
  PVector pos = new PVector(width/2, height/2);
  int w, h;
  PApplet parent;

  public ControlFrame(PApplet _parent, int _w, int _h, String _name) {
    super();   
    parent = _parent;
    w=_w;
    h=_h;
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
  }

  public void settings() {
    size(w, h);
  }

  public void setup() {
       
  }
  float[] tmppos = new float[2];
  void draw() {
    background(190);
    pos =  new PVector(osc.tvalue[0], osc.tvalue[1]);
    ellipse(pos.x ,pos.y, 50, 50);
  }
}