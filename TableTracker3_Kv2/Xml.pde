class Xml {

  XML myxml;
  String filepath = "data/setting.xml";

  public int depthMin;
  public int depthMax;
  public int blobWid;

  public void SetupXml() {
    myxml = loadXML(filepath);
  }

  public void LoadXml() {

    XML xml_c1 = myxml.getChild("thresholdLow");
    XML xml_c2 = myxml.getChild("thresholdHigh");
    XML xml_c3 = myxml.getChild("blobWidth");

    depthMin = int(trim(xml_c1.getContent()));
    depthMax = int(trim(xml_c2.getContent()));
    blobWid = int(trim(xml_c3.getContent()));
  }


  public void SaveXml() {

    XML xml_c1 = myxml.getChild("thresholdLow");
    XML xml_c2 = myxml.getChild("thresholdHigh");
    XML xml_c3 = myxml.getChild("blobWidth");

    xml_c1.setContent(str(depthMin));
    xml_c2.setContent(str(depthMax));
    xml_c3.setContent(str(blobWid));
    
    saveXML(myxml, filepath);
  }
}