class cp5Gui {

  Range range;

  public int TF_rows = 46;
  public int TF_cols = 38;
  public int TF_step = 11;
  public int TF_boxwidth = 20;
  public float Range_Low =  38.25f;
  public float Range_High = 59.2f;  

  cp5Gui() {

    range = cp5.addRange("Threshold")
      .setBroadcast(false) 
      .setPosition(925, 100)
      .setSize(300, 30)
      .setHandleSize(10)
      .setRange(0, 255)
      .setRangeValues(Range_Low, Range_High)
      .setBroadcast(true)
      .setColorForeground(color(255, 40)) 
      ;


    // Send init data
    cp5.addBang("initData")
      .setPosition(925, 170)
      .setSize(50, 20)
      ;


    // create a toggle
    cp5.addToggle("SendOSC")
      .setPosition(925, 210)
      .setSize(50, 20)
      ;


    //---Setting
    PFont font = createFont("arial", 14);

    cp5.addTextfield("rows_temp")
      .setPosition(750, 100)
      .setSize(100, 20)
      .setValue(46)
      .setFont(font)
      .setAutoClear(false)
      .setInputFilter(ControlP5.INTEGER)
      .setFocus(true)
      .setText(Integer.toString(TF_rows))
      ;

    cp5.addTextfield("cols_temp")
      .setPosition(750, 150)
      .setSize(100, 20)
      .setFont(font)
      .setAutoClear(false)
      .setInputFilter(ControlP5.INTEGER)
      .setText(Integer.toString(TF_cols))
      ;

    cp5.addTextfield("step_temp")
      .setPosition(750, 200)
      .setSize(100, 20)
      .setFont(font)
      .setAutoClear(false)
      .setInputFilter(ControlP5.INTEGER)
      .setText(Integer.toString(TF_step))
      ;

    cp5.addTextfield("boxWid_temp")
      .setPosition(750, 250)
      .setSize(100, 20)
      .setFont(font)
      .setAutoClear(false)
      .setInputFilter(ControlP5.INTEGER)
      .setText(Integer.toString(TF_boxwidth))
      ;



    cp5.addBang("Refresh")
      .setPosition(750, 300)
      .setSize(100, 40)
      .setFont(font)
      .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
      ;


    cp5.addBang("Clear")
      .setPosition(750, 350)
      .setSize(100, 40)
      .setFont(font)
      .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
      ;



    //---XML

    cp5.addBang("Load_XML")
      .setPosition(625, 100)
      .setSize(50, 20)
      ;

    cp5.addBang("Save_XML")
      .setPosition(625, 150)
      .setSize(50, 20)
      ;
  }
  
}