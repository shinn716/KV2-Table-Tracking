import oscP5.*;
import netP5.*;

class OSC {

  OscP5 oscP5;
  NetAddress myRemoteLocation;

  public int port = 12000;
  public String ip = "127.0.0.1";        //192.168.0.106      127.0.0.1

  String _address;
  float[] tvalue = new float[2];
  float offsety;

  OSC() {
    oscP5 = new OscP5(this, 9999);
    myRemoteLocation = new NetAddress(ip, port);
  }

  public void oscSend_Array(String address, float[] message) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(message); 
    oscP5.send(myMessage, myRemoteLocation);

    _address = address;
    tvalue = message;

    ShowData(new PVector(512+380, 240+offsety));

    if (offsety>280)
      offsety=0;
    else
      offsety+=20;
  }

  public void oscSend_int(String address, int message) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(message); 
    oscP5.send(myMessage, myRemoteLocation);
  }

  public void oscSend_float(String address, float message) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(message); 
    oscP5.send(myMessage, myRemoteLocation);
  }

  public void ShowData(PVector pos) {
    fill(100, 255, 100);
    textSize(12);
    //text("Port: " + getPort(), pos.x, pos.y);
    text(_address + " " + round(tvalue[0])+" " + round(tvalue[1]), pos.x, pos.y+20*1);
    //println(round(tvalue[0])+" " + round(tvalue[1]));
  }
}