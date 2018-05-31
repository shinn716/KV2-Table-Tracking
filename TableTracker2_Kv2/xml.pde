class xml {

  XML myxml;
  String filepath = "data/setting.xml";


  public void SetupXml() {
    myxml = loadXML(filepath);
  }

  public void LoadXml() {

    XML xml_c3 = myxml.getChild("rows");
    XML xml_c4 = myxml.getChild("cols");

    XML xml_c5 = myxml.getChild("step");
    XML xml_c6 = myxml.getChild("boxwidth");

    XML xml_c7 = myxml.getChild("thresholdLow");
    XML xml_c8 = myxml.getChild("thresholdHigh");

    XML xml_c9 = myxml.getChild("pox");
    XML xml_c10 = myxml.getChild("poy");

    XML xml_c11 = myxml.getChild("pfx");
    XML xml_c12 = myxml.getChild("pfy");


    TableTracker2_Kv2.xml_rows = int(trim(xml_c3.getContent()));
    TableTracker2_Kv2.xml_cols = int(trim(xml_c4.getContent()));

    TableTracker2_Kv2.xml_step = int(trim(xml_c5.getContent()));
    TableTracker2_Kv2.xml_boxwidth = int(trim(xml_c6.getContent()));

    TableTracker2_Kv2.xml_thresholdLow = float(trim(xml_c7.getContent()));
    TableTracker2_Kv2.xml_thresholdHigh = float(trim(xml_c8.getContent()));


    TableTracker2_Kv2.xml_p1x = float(trim(xml_c9.getContent()));
    TableTracker2_Kv2.xml_p1y = float(trim(xml_c10.getContent()));

    TableTracker2_Kv2.xml_p2x = float(trim(xml_c11.getContent()));
    TableTracker2_Kv2.xml_p2y = float(trim(xml_c12.getContent()));
  }


  public void SaveXml() {

    XML xml_c9 = myxml.getChild("pox");
    XML xml_c10 = myxml.getChild("poy");

    XML xml_c11 = myxml.getChild("pfx");
    XML xml_c12 = myxml.getChild("pfy");

    XML xml_c3 = myxml.getChild("rows");
    XML xml_c4 = myxml.getChild("cols");

    XML xml_c5 = myxml.getChild("step");
    XML xml_c6 = myxml.getChild("boxwidth");

    XML xml_c7 = myxml.getChild("thresholdLow");
    XML xml_c8 = myxml.getChild("thresholdHigh");



    xml_c3.setContent(str(TableTracker2_Kv2.xml_rows));
    xml_c4.setContent(str(TableTracker2_Kv2.xml_cols));

    xml_c5.setContent(str(TableTracker2_Kv2.xml_step));
    xml_c6.setContent(str(TableTracker2_Kv2.xml_boxwidth));

    xml_c7.setContent(str(TableTracker2_Kv2.xml_thresholdLow));
    xml_c8.setContent(str(TableTracker2_Kv2.xml_thresholdHigh));

    xml_c9.setContent(str(TableTracker2_Kv2.xml_p1x));
    xml_c10.setContent(str(TableTracker2_Kv2.xml_p1y));

    xml_c11.setContent(str(TableTracker2_Kv2.xml_p2x));
    xml_c12.setContent(str(TableTracker2_Kv2.xml_p2y));

    saveXML(myxml, filepath);

    print();
  }
}