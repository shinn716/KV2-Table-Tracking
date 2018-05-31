/*
180528 - Shinn 
Kinectv2 Table
*/

import controlP5.*;
import KinectPV2.*;

KinectPV2 kinect;
ControlP5 cp5;
cp5Gui callgui;
osc callosc;

Box myBox[];
DebugFrame DF;
xml myxml = new xml();

String rows_temp;
String cols_temp;
String step_temp;
String boxWid_temp;

int rows = 46;
int cols = 38;

int step = 11;
int boxWidth=20;
float ImageScale = 1;

PVector translatePos = new PVector(50, 50);
boolean SendOSC = false;
boolean SendInit = false;

boolean showError = false;
boolean drawboxst = false;

PVector finPoint = new PVector(512, 424);
PVector orgPoint = new PVector(50, 50);
boolean rangesetting = false; 
int count=0;
String sendvalue;

boolean ShowLoadSucc = false;
boolean ShowSaveSucc = false;
int LoadCount=0, SaveCount=0;

public static float Min = 38.3;
public static float Max = 59.2;

public static float xml_thresholdLow;
public static float xml_thresholdHigh;

public static float xml_p1x;
public static float xml_p1y;
public static float xml_p2x;
public static float xml_p2y;

public static int xml_rows;
public static int xml_cols;

public static int xml_step;
public static int xml_boxwidth;

void settings() {
  size(1280, 500);
  //DF = new DebugFrame(this, 1920, 1080, "Controls" );
}

void setup() {

  cp5 = new ControlP5(this);
  callosc = new osc();

  kinect = new KinectPV2(this);
  kinect.enableDepthImg(true);

  kinect.init();
  boxinit();

  myxml.SetupXml();

  callgui = new cp5Gui();
  drawboxst = true;
}


public void draw() {
  background(0);

  DepthCamInit();

  if (drawboxst) {
    pushMatrix();
    translate(translatePos.x, translatePos.y);
    for (int j=0; j<cols; j++) {
      for (int i=0; i<rows; i++) {
        myBox[i+j*rows].Draw();
        myBox[i+j*rows].Update();

        if (myBox[i+j*rows].getTrigger() && SendOSC) {
          sendvalue = str(i+j*rows);
          callosc.oscSend("/raw", sendvalue);
        }
      }
    }
    popMatrix();
  }

  OnGUI();

  if (rangesetting) {
    noFill();
    stroke(255, 255, 255);
    PVector Point;

    if (count<2) {
      Point = new PVector(mouseX, mouseY);
    } else {
      Point = finPoint;
    }
    
    fill(100,255,100);
    text("Prjection Range", orgPoint.x, orgPoint.y);
    stroke(100,255,100);
    noFill();
    rect(orgPoint.x, orgPoint.y, Point.x-orgPoint.x, Point.y-orgPoint.y);
  }

  if (SendInit==true) {
    //Send OSC

    float ImageWidth = finPoint.x-orgPoint.x;
    float ImageHeight = finPoint.y-orgPoint.y;

    float px = 925;
    float py = 270;

    textSize(14);
    text("OSC Sending, Port: " + callosc.getPort(), px, py);
    text("/width " + ImageWidth, px, py+20*1);
    text("/height " + ImageHeight, px, py+20*2);
    text("/rows " + rows, px, py+20*3);
    text("/cols " + cols, px, py+20*4);
    text("/step " + step, px, py+20*5);
    text("/boxwidth " + boxWidth, px, py+20*6);

    if (SendOSC)
      text("/raw " + sendvalue, px, py+20*7);
  }


  if (ShowLoadSucc) {
    
    textSize(12);
    text("Load XML Success!!", 625, 225);

    if (LoadCount>500) {
      ShowLoadSucc = false;
      LoadCount=0;
    } else {
      LoadCount++;
    }
  }

  if (ShowSaveSucc) {
    
    textSize(12);
    text("Save XML Success!!", 625, 225);

    if (SaveCount>500) {
      ShowSaveSucc = false;
      SaveCount=0;
    } else {
      SaveCount++;
    }
    
  }
}

void mousePressed() {

  if (mouseX<512+50 && mouseX>50) {

    if (count<1) {
      orgPoint = new PVector(mouseX, mouseY);
      rangesetting = true;
    } else if (count==1) {
      finPoint = new PVector(mouseX, mouseY);
      print(finPoint);
    }
    count++;
  }
}



void boxinit() {

  myBox = new Box[rows*cols];
  for (int j=0; j<cols; j++) {
    for (int i=0; i<rows; i++) {

      float px = i*step + step/2;   // x position
      float py = j*step + step/2;   // y position
      myBox[i+j*rows] = new Box(new PVector(px, py), boxWidth, boxWidth, 1);
    }
  }
  drawboxst = true;
}

void OnGUI() {

  fill(255, 255, 255);
  textSize(18);
  text("FPS " + floor(frameRate), width-150, 50);
  text("Counts " + rows*cols, width-150, 70);

  textSize(10);
  text("ex: 46, 11", 850, 138);
  text("ex: 38, 9 ", 850, 188);
  text("ex: 11, 40", 850, 238);
  text("ex: 20, 78", 850, 288);

  //error
  if (showError) {
    fill(255, 0, 0);
    text("Error(Only Number)", 750, 500);
  }
}

void DepthCamInit() {
  float ImagePosX = 50;
  float ImagePosY = 50;
  float ImageWidth = 512 * ImageScale;
  float ImageHeight = 424 * ImageScale;

  noFill();
  stroke(255);
  rect(ImagePosX-1, ImagePosY-1, ImageWidth+1, ImageHeight+1);

  image(kinect.getDepthImage(), ImagePosX, ImagePosY, ImageWidth, ImageHeight);
}

void Refresh() {

  try {
    drawboxst = false;

    rows_temp = cp5.get(Textfield.class, "rows_temp").getText();
    cols_temp = cp5.get(Textfield.class, "cols_temp").getText();
    step_temp = cp5.get(Textfield.class, "step_temp").getText();
    boxWid_temp = cp5.get(Textfield.class, "boxWid_temp").getText();

    rows = (int) Integer.parseInt(rows_temp);
    cols = (int) Integer.parseInt(cols_temp);
    step = (int) Integer.parseInt(step_temp);
    boxWidth = (int) Integer.parseInt(boxWid_temp);
    translatePos = orgPoint;

    boxinit();
    showError = false;
  }

  catch(java.lang.RuntimeException e) {
    //e.printStackTrace();
    showError = true;
  }
}


void Clear() {
  count = 0;
  rangesetting = false;
}



void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("Threshold")) {
    Min = int(theControlEvent.getController().getArrayValue(0));
    Max = int(theControlEvent.getController().getArrayValue(1));
    //println("range update, done.");
  }

  if (theControlEvent.getController().getName().equals("initData")) {
    float ImageWidth = finPoint.x-orgPoint.x;
    float ImageHeight = finPoint.y-orgPoint.y;

    callosc.oscSend("/width", Float.toString(ImageWidth));
    callosc.oscSend("/height", Float.toString(ImageHeight));
    callosc.oscSend("/rows", Integer.toString(rows));
    callosc.oscSend("/cols", Integer.toString(cols));
    callosc.oscSend("/step", Float.toString(step));
    callosc.oscSend("/boxwidth", Float.toString(boxWidth));

    SendInit = true;
  }
}


void Load_XML() {
  println("load ");
  myxml.LoadXml();

  orgPoint = new PVector(xml_p1x, xml_p1y);
  finPoint = new PVector(xml_p2x, xml_p2y); 

  rows = xml_rows;
  cols = xml_cols;

  Min = xml_thresholdLow;
  Max = xml_thresholdHigh;

  step = xml_step;
  boxWidth = xml_boxwidth;


  translatePos = orgPoint;
  showError = false;
  rangesetting = true;
  count = 2;
  boxinit();

  ShowLoadSucc = true;
}


void Save_XML() {
  println("save");

  xml_p1x = orgPoint.x;
  xml_p1y = orgPoint.y;
  xml_p2x = finPoint.x;
  xml_p2y = finPoint.y;

  xml_rows = rows;
  xml_cols = cols;

  xml_thresholdLow = Min;
  xml_thresholdHigh = Max;

  xml_step = step;
  xml_boxwidth = boxWidth;

  myxml.SaveXml();

  ShowSaveSucc = true;
}