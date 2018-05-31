import oscP5.*;
import netP5.*;

class osc {

  OscP5 oscP5;
  NetAddress myRemoteLocation;
  int port = 12000;

  osc() {
    oscP5 = new OscP5(this, port);
    myRemoteLocation = new NetAddress("127.0.0.1", port);
  }

  // address /test
  // message "s1"

  public void oscSend(String address, String message) {
    OscMessage myMessage = new OscMessage(address);
    myMessage.add(message); 
    oscP5.send(myMessage, myRemoteLocation);
  }


  public int getPort() {
    return port;
  }

  void oscEvent(OscMessage theOscMessage) {
      print("### received an osc message.");
      print(" addrpattern: "+theOscMessage.addrPattern());
      //println(" typetag: "+theOscMessage.typetag());
      println(" value: " + theOscMessage.get(0).stringValue());
  }
  
  
}