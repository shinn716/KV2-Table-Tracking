class NewBlob {
  
  PImage img;
  OSC osc = new OSC();

  public void Init() {
    // BlobDetection
    // img which will be sent to detection (a smaller copy of the cam frame);
    img = new PImage(800, 600); 
    theBlobDetection = new BlobDetection(img.width, img.height);
    theBlobDetection.setPosDiscrimination(true);
    theBlobDetection.setThreshold(.93f); // will detect bright areas whose luminosity > 0.2f;
  }

  // ==================================================
  // drawBlobsAndEdges()
  // ==================================================
  public void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges, PVector min, PVector max)
  {
    noFill();
    Blob b;
    EdgeVertex eA, eB;

    for (int n=0; n<theBlobDetection.getBlobNb(); n++)
    {
      b=theBlobDetection.getBlob(n);

      if ((b.xMin*width/3)>min.x && (b.xMin*width/3)<max.x && (b.yMin*height)>min.y && (b.yMin*height)<max.y) {

        if (b!=null)
        {
          // Edges
          if (drawEdges)
          {
            strokeWeight(3);
            stroke(0, 255, 0);
            for (int m=0; m<b.getEdgeNb(); m++)
            {
              eA = b.getEdgeVertexA(m);
              eB = b.getEdgeVertexB(m);

              if (eA !=null && eB !=null )
                line(
                  eA.x*width, eA.y*height, 
                  eB.x*width, eB.y*height
                  );
            }
          }

          // Blobs
          //float maxium = 50;
          //ArrayList<PVector> sendArray = new ArrayList<PVector>();

          if (drawBlobs && b.w*width<blob_threshold && b.h*height<blob_threshold && b.w>.01 && b.h >.01)
          {
            pushMatrix();
            noFill();
            strokeWeight(1);
            stroke(255, 0, 0);
            rect(
              b.xMin*width, b.yMin*height, 
              b.w*width, b.h*height
              );


            //Send Data---
            float mapDataX = map(b.xMin*width/3, rangeBeg.x, rangeEnd.x, 0, 1080);
            float mapDataY = map(b.yMin*height, rangeBeg.y, rangeEnd.y, 1080, 0);

            //sendArray.add(new PVector(mapDataX, mapDataY));

            fill(255, 0, 0);
            scale(3, 1);
            textSize(12);
            text(round(mapDataX)+"  "+round(mapDataY), (b.xMin*width)/3-50, (b.yMin*height));
            //text(round(b.xMin*width/3)+"  "+round(b.yMin*height), (b.xMin*width)/3, (b.yMin*height));

            if (sendOsc) {

              //for (int k=0; k<sendArray.size(); k++) {

              //  tx = sendArray.get(k).x;
              //  ty = sendArray.get(k).y;

              //  osc.oscSend_float("/posx", sendArray.get(k).x);
              //  osc.oscSend_float("/posy", sendArray.get(k).y);
              //}

              float[] _array = new float[2]; 

              _array[0] = mapDataX;
              _array[1] = mapDataY;
              osc.oscSend_Array("/pos", _array);
            }

            popMatrix();
          }
          //sendArray.clear();
        }
      }
    }
  }

  // ==================================================
  // Super Fast Blur v1.1
  // by Mario Klingemann 
  // <http://incubator.quasimondo.com>
  // ==================================================
  public void fastblur(PImage img, int radius)
  {
    if (radius<1) {
      return;
    }
    int w=img.width;
    int h=img.height;
    int wm=w-1;
    int hm=h-1;
    int wh=w*h;
    int div=radius+radius+1;
    int r[]=new int[wh];
    int g[]=new int[wh];
    int b[]=new int[wh];
    int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
    int vmin[] = new int[max(w, h)];
    int vmax[] = new int[max(w, h)];
    int[] pix=img.pixels;
    int dv[]=new int[256*div];

    for (i=0; i<256*div; i++) {
      dv[i]=(i/div);
    }

    yw=yi=0;

    for (y=0; y<h; y++) {
      rsum=gsum=bsum=0;
      for (i=-radius; i<=radius; i++) {
        p=pix[yi+min(wm, max(i, 0))];
        rsum+=(p & 0xff0000)>>16;
        gsum+=(p & 0x00ff00)>>8;
        bsum+= p & 0x0000ff;
      }
      for (x=0; x<w; x++) {

        r[yi]=dv[rsum];
        g[yi]=dv[gsum];
        b[yi]=dv[bsum];

        if (y==0) {
          vmin[x]=min(x+radius+1, wm);
          vmax[x]=max(x-radius, 0);
        }
        p1=pix[yw+vmin[x]];
        p2=pix[yw+vmax[x]];

        rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
        gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
        bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
        yi++;
      }
      yw+=w;
    }

    for (x=0; x<w; x++) {
      rsum=gsum=bsum=0;
      yp=-radius*w;
      for (i=-radius; i<=radius; i++) {
        yi=max(0, yp)+x;
        rsum+=r[yi];
        gsum+=g[yi];
        bsum+=b[yi];
        yp+=w;
      }
      yi=x;
      for (y=0; y<h; y++) {
        pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
        if (x==0) {
          vmin[y]=min(y+radius+1, hm)*w;
          vmax[y]=max(y-radius, 0)*w;
        }
        p1=x+vmin[y];
        p2=x+vmax[y];

        rsum+=r[p1]-r[p2];
        gsum+=g[p1]-g[p2];
        bsum+=b[p1]-b[p2];

        yi+=w;
      }
    }
  }
}