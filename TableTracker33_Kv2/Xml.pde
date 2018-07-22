class Xml {

  XML myxml;
  String filepath = "data/setting.xml";

  public int depthMin;
  public int depthMax;
  public int blobWid;

  public PVector beginPos;
  public PVector finalPos;
  
  public boolean oscauto = false;

  public void SetupXml() {
    myxml = loadXML(filepath);
  }

  public void LoadXml() {

    XML xml_c1 = myxml.getChild("thresholdLow");
    XML xml_c2 = myxml.getChild("thresholdHigh");
    XML xml_c3 = myxml.getChild("blobWidth");
    XML xml_c4 = myxml.getChild("bpx");
    XML xml_c5 = myxml.getChild("bpy");
    XML xml_c6 = myxml.getChild("fpx");
    XML xml_c7 = myxml.getChild("fpy");
    XML xml_c8 = myxml.getChild("oscAutoStart");

    depthMin = int(trim(xml_c1.getContent()));
    depthMax = int(trim(xml_c2.getContent()));
    blobWid = int(trim(xml_c3.getContent()));
    
    beginPos = new PVector(float(xml_c4.getContent()), float(xml_c5.getContent()));
    finalPos = new PVector(float(xml_c6.getContent()), float(xml_c7.getContent()));
    
    oscauto = boolean(xml_c8.getContent());
  }


  public void SaveXml() {

    XML xml_c1 = myxml.getChild("thresholdLow");
    XML xml_c2 = myxml.getChild("thresholdHigh");
    XML xml_c3 = myxml.getChild("blobWidth");
    XML xml_c4 = myxml.getChild("bpx");
    XML xml_c5 = myxml.getChild("bpy");
    XML xml_c6 = myxml.getChild("fpx");
    XML xml_c7 = myxml.getChild("fpy");

    xml_c1.setContent(str(depthMin));
    xml_c2.setContent(str(depthMax));
    xml_c3.setContent(str(blobWid));
    
    xml_c4.setContent(str(beginPos.x));
    xml_c5.setContent(str(beginPos.y));
    xml_c6.setContent(str(finalPos.x));
    xml_c7.setContent(str(finalPos.y));
    
    saveXML(myxml, filepath);
  }
}
