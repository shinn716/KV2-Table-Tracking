/*----------------------------------
 Kinect Interactive Table Traceing Ver3 (Blob + OSC).
 IP: 127.0.0.1
 Port: 12000
 Date: 20180629
 Author: Shinn
 ------------------------------------*/

import gab.opencv.*;
import KinectPV2.*;
import controlP5.*;
import blobDetection.*;

KinectPV2 kinect;
OpenCV opencv;
OpenCV opencv2;
ControlP5 cp5;
BlobDetection theBlobDetection;
Range range;

OSC myOsc = new OSC();
NewBlob blob  = new NewBlob();
Xml myxml = new Xml();

public PVector rangeBeg = new PVector(0, 0);
public PVector rangeEnd = new PVector(0, 0);
public boolean sendOsc = false;

int minD = 938;       //689      //2700
int maxD = 954;       //702      //2723
int count=0;
int countCalibration=0;
int LoadCount=0, SaveCount=0;

boolean invertst =true;
boolean detextRangest = true;
boolean rangesetting = false; 
boolean showMousePos = false;
boolean showColorImagest =false;
boolean calibrationst = false;
boolean showCalibration = false;
boolean ShowSaveSucc = false;
boolean ShowLoadSucc = false;

int blob_threshold = 40;
float step_dist = 1;

PVector[] mousePos = new PVector[2];
int[] depthdata = new int[2];

boolean point1st = false;
boolean point2st = false;

//ControlFrame cf;

void settings() {
  size(1536, 424);
}

void setup() {

  kinect = new KinectPV2(this);
  cp5 = new ControlP5(this);

  kinect.enableColorImg(true);
  kinect.enableDepthImg(true);
  kinect.enablePointCloud(true);
  kinect.enableBodyTrackImg(true);

  kinect.init();

  opencv = new OpenCV(this, 512, 424);

  blob.Init();
  myxml.SetupXml();

  LoadXml();

  cp5();

  for (int i=0; i<mousePos.length; i++)
    mousePos[i] = new PVector(0, 0);

  //cf = new ControlFrame(this, 1920, 1080, "Controls");
  //surface.setLocation(420, 10);
}

void draw() {
  background(0);

  noFill();
  opencv.loadImage(kinect.getPointCloudDepthImage());

  if (invertst)
    opencv.invert();

  opencv.dilate();
  opencv.erode();
  opencv.erode();
  opencv.flip(OpenCV.HORIZONTAL);

  PImage src = opencv.getSnapshot();                   

  if (showColorImagest) {

    pushMatrix();

    scale(-1, 1);
    image(kinect.getColorImage(), 0-512, 0, 512, 424);
    noStroke();
    stroke(255);
    rect(-512+0+2, 0+2, 512-2, 424-2);

    popMatrix();
  } else {
    opencv.loadImage(kinect.getDepthImage());
    opencv.flip(OpenCV.HORIZONTAL);
    PImage src_org = opencv.getSnapshot();

    pushMatrix();

    image(src_org, 0, 0, 512, 424);
    noStroke();
    stroke(255);
    rect(0+2, 0+2, 512-2, 424-2);

    popMatrix();
  }

  image(src, 512+2, 0, 512, 424);
  noStroke();
  stroke(100);
  rect(512+2, 0+2, 512-2, 424-2);

  kinect.setLowThresholdPC(minD);
  kinect.setHighThresholdPC(maxD);

  if (rangesetting) {

    pushMatrix();
    translate(512, 0);
    scale(.333f, 1);

    blob.img.copy(src, 0, 0, src.width, src.height, 0, 0, blob.img.width, blob.img.height);
    blob.fastblur(blob.img, 1);
    theBlobDetection.computeBlobs(blob.img.pixels);
    blob.drawBlobsAndEdges(true, false, rangeBeg, rangeEnd);

    popMatrix();
  }

  if (rangesetting) {
    PVector Point;

    if (count<2) 
      Point = new PVector(mouseX, mouseY);
    else 
    Point = rangeEnd;

    pushMatrix();
    textSize(12);
    fill(100, 255, 100);
    text("Detection Range", rangeBeg.x, rangeBeg.y);
    stroke(100, 255, 100);
    noFill();
    rect(rangeBeg.x, rangeBeg.y, Point.x-rangeBeg.x, Point.y-rangeBeg.y);

    translate(512, 0);
    fill(100, 255, 100);
    text("Detection Range", rangeBeg.x, rangeBeg.y);
    noFill();
    stroke(100, 255, 100);
    rect(rangeBeg.x, rangeBeg.y, Point.x-rangeBeg.x, Point.y-rangeBeg.y);
    popMatrix();
  }


  if (showMousePos) {
    fill(100, 100, 255);
    text(mouseX+" "+mouseY, mouseX+10, mouseY+10);
  }

  ShowDist();

  if (showCalibration && calibrationst) {

    for (int i=0; i<mousePos.length; i++) {
      stroke(255, 10, 10);
      noFill();
      rect(mousePos[i].x-5, mousePos[i].y-5, 10, 10);

      fill(255, 10, 10);
      text(depthdata[i], mousePos[i].x-5, mousePos[i].y-10);
    }
  }

  if (ShowLoadSucc) {
    fill(100, 255, 100);
    textSize(12);
    text("Load XML Success!!", width-400, 150);

    if (LoadCount>300) {
      ShowLoadSucc = false;
      LoadCount=0;
    } else {
      LoadCount++;
    }
  }


  if (ShowSaveSucc) {
    fill(100, 255, 100);
    textSize(12);
    text("Save XML Success!!", width-400, 150);

    if (SaveCount>300) {
      ShowSaveSucc = false;
      SaveCount=0;
    } else {
      SaveCount++;
    }
  }



  if (calibrationst) {
    int [] rowData = kinect.getRawDepthData();
    int mx = constrain(mouseX, 0, 512-1);
    int my = constrain(mouseY, 0, 424-1);
    int loc = 512 - mx + my*512;                    //mirror
    fill(100, 100, 255);
    textSize(12);
    text("Depth: " + rowData[loc], mouseX, mouseY);
  }




  if (point1st && rangesetting) {
    fill(255, 0, 0);
    ellipse(rangeBeg.x, rangeBeg.y, 10, 10);
    if (keyPressed) {
      if (key == 'q' || key == 'Q')
        rangeBeg.x -= step_dist;
      else if (key == 'w' || key == 'W') 
        rangeBeg.x += step_dist;


      if (key == 'a' || key == 'A') 
        rangeBeg.y -= step_dist;
      else if (key == 's' || key == 'S') 
        rangeBeg.y += step_dist;
    }
  }

  if (point2st && rangesetting) {
    fill(255, 0, 0);
    ellipse(rangeEnd.x, rangeEnd.y, 10, 10);
    if (keyPressed) {
      if (key == 'q' || key == 'Q')
        rangeEnd.x -= step_dist;
      else if (key == 'w' || key == 'W') 
        rangeEnd.x += step_dist;


      if (key == 'a' || key == 'A') 
        rangeEnd.y -= step_dist;
      else if (key == 's' || key == 'S') 
        rangeEnd.y += step_dist;
    }
  }
}


void ShowDist() {
  fill(255, 255, 255);
  text("FPS: "+round(frameRate), width-140, 20);
  text("MinDist: "+minD, width-140, 40);
  text("MaxDist: "+maxD, width-140, 60);
  text("blob_threshold: "+blob_threshold, width-140, 80);

  text("IP: "+myOsc.ip, width-140, 100);
  text("Port: "+myOsc.port, width-140, 120);

  text("Step: "+step_dist, width-220, 20);
  text("1,2 -> MinDist", width-140, 160);
  text("3,4 -> MaxDist", width-140, 180);
  text("5,6 -> BlobThreshold", width-140, 200);
  text("+,- -> Step", width-140, 220);
}


void mouseReleased() {

  if (mouseButton == LEFT) {

    if (mouseX<512 && mouseX>0) {

      if (count<1) {
        rangeBeg = new PVector(mouseX, mouseY);
        rangesetting = true;
      } else if (count==1) 
        rangeEnd = new PVector(mouseX, mouseY);

      count++;
    }
  }

  if (mouseButton == RIGHT) 
    Clear();

  if (mouseButton == CENTER && calibrationst) {
    int [] rowData = kinect.getRawDepthData();
    int mx = constrain(mouseX, 0, 512-1);
    int my = constrain(mouseY, 0, 424-1);
    int loc = 512 - mx + my*512;
    println("Index: " + loc+" "+rowData[loc]);

    if (mouseX < 512 && mouseY < 424 && countCalibration<mousePos.length) {
      showCalibration = true;
      mousePos[countCalibration] = new PVector(mouseX, mouseY);
      depthdata[countCalibration] = rowData[loc];
      countCalibration++;
    }
  }
}

void keyPressed() {

  if (key == '1') 
    minD -= step_dist;
  else if (key == '2') 
    minD += step_dist;

  if (key == '3') 
    maxD -= step_dist;
  else if (key == '4') 
    maxD += step_dist;


  if (key == '5') 
    blob_threshold-=1f;
  else if (key =='6') 
    blob_threshold+=1f;

  if (key == '=') 
    step_dist *= 1.25f;

  if (key == '-') 
    step_dist /= 1.25f;
}



//----cp5
void cp5() {

  cp5.addButton("Invert")
    .setPosition(width-500, 20)
    .setSize(80, 20)
    ;

  cp5.addButton("Clear")
    .setPosition(width-500, 50)
    .setSize(80, 20)
    ;

  cp5.addButton("ShowMousePos")
    .setPosition(width-500, 90)
    .setSize(80, 20)
    ;

  cp5.addButton("ShowColorImage")
    .setPosition(width-500, 120)
    .setSize(80, 20)
    ;

  cp5.addButton("DepthCalibration")
    .setPosition(width-500, 160)
    .setSize(80, 20)
    ;

  cp5.addButton("CalibrationOK")
    .setPosition(width-500, 190)
    .setSize(80, 20)
    ;

  cp5.addToggle("sendOsc")
    .setPosition(width-400, 20)
    .setSize(50, 20)
    ;

  cp5.addButton("LoadXml")
    .setPosition(width-400, 70)
    .setSize(80, 20)
    ;

  cp5.addButton("SaveXml")
    .setPosition(width-400, 100)
    .setSize(80, 20)
    ;

  cp5.addToggle("Point1")
    .setPosition(width-400, 160)
    .setSize(40, 20)
    ;

  cp5.addToggle("Point2")
    .setPosition(width-400, 200)
    .setSize(40, 20)
    ;
}

void ShowColorImage() {
  showColorImagest = !showColorImagest;
}

void Invert() {
  invertst = !invertst;
}

void Clear() {
  count = 0;
  rangesetting = false;
}

void ShowMousePos() {
  showMousePos = !showMousePos;
}

void DepthCalibration() {
  calibrationst = !calibrationst;

  if (!calibrationst) {
    countCalibration=0;
    showCalibration = false;

    for (int i=0; i<mousePos.length; i++)
      mousePos[i] = new PVector(0, 0);
  }
}

void CalibrationOK() {
  int depth = (int) (depthdata[0]+depthdata[1])/2;
  maxD = depth;
  minD = depth-50;
}

void LoadXml() {
  myxml.LoadXml();
  minD = myxml.depthMin;
  maxD = myxml.depthMax;
  blob_threshold = myxml.blobWid;
  ShowLoadSucc = true;
}

void SaveXml() {
  myxml.depthMin = minD;
  myxml.depthMax = maxD;
  myxml.blobWid = blob_threshold;
  myxml.SaveXml();
  ShowSaveSucc = true;
}

void Point1(boolean theFlag) {
  if (theFlag) 
    point1st = true;
  else 
  point1st = false;
}

void Point2(boolean theFlag) {
  if (theFlag) 
    point2st = true;
  else 
  point2st = false;
}