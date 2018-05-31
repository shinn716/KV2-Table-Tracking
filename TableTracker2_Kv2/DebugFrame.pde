class DebugFrame extends PApplet {

  int w, h;
  PApplet parent;

  public DebugFrame(PApplet _parent, int _w, int _h, String _name) {
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
    //kinect = new KinectPV2(this);
    //kinect.enableDepthImg(true);
  }

  void draw() {
    //image(kinect.getDepthImage(), 0, 0, width, height);
  }
}