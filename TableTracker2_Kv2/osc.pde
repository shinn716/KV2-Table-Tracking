import oscP5.*;
import netP5.*;

class osc {

  OscP5 oscP5;
  NetAddress myRemoteLocation;
  int port = 12000;

  osc() {
    oscP5 = new OscP5(this, 9999);
    myRemoteLocation = new NetAddress("127.0.0.1", port);
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


  public int getPort() {
    return port;
  }

  //void oscEvent(OscMessage theOscMessage) {
  //  print("### received an osc message.");
  //  print(" addrpattern: "+theOscMessage.addrPattern());
  //  println(" value: " + theOscMessage.get(0).stringValue());
  //}
  
}