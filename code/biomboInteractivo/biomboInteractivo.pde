

import processing.video.*;

import org.openkinect.freenect.*;
import org.openkinect.processing.*;

import codeanticode.syphon.*;
SyphonServer server;

KinectTracker tracker;
Boolean bPintarTracker = false;


Kinect kinect;
// Depth image
PImage depthImg;
  int minDepth =  60;
  int maxDepth = 860;

Movie myMovie1;
Movie myMovie2;
int sizeW = 640;
int sizeH = 480;
PGraphics pg;

void settings() {
  //size(640, 480);
  size(1024,768, P3D);
  PJOGL.profile=1;
  fullScreen(P3D);
}

void setup() {

    frameRate(15);
  //kinect cosas
  kinect = new Kinect(this);
  kinect.initDepth();
  // Which pixels do we care about?

  depthImg = new PImage(kinect.width, kinect.height);
  
  
  tracker = new KinectTracker();
  
  myMovie1 = new Movie(this, "ciudad.mov");
  myMovie1.loop();
  myMovie1.speed(0.2);
  myMovie2 = new Movie(this, "rio_bueno_mejor.mov");
  myMovie2.loop();
  myMovie2.speed(1);
  
  
  
  pg = createGraphics(sizeW, sizeH);
  
  
  //syphon
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");
}  

  


void draw() {
    tracker.track();
    PVector v1 = tracker.getPos();
    //PVector v1 = tracker.getPos();

   // Draw the thresholded image
   depthImg.updatePixels();
   
  // Threshold the depth image
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(255);
    } else {
      depthImg.pixels[i] = color(0);
    }
  }
  
  pg.beginDraw();
  pg.background(0, 0, 0);
  pg.fill(200);
  
  //pg.ellipse(sizeW/2, sizeH/2, v1.x, v1.y);
  pg.image(depthImg, 0, 0);
  pg.endDraw();
  //image(pg, 0, 0);

  image(myMovie2, 0, 0, sizeW, sizeH);
  
  
  
  //aplicar la mascara al video
  myMovie1.mask(pg);

  color(255,255,255);
  image(myMovie1, 0, 0, sizeW,sizeH);
  
  //Inicialmente a true
   if(bPintarTracker){
     tracker.display(); 
     float myThreshold = tracker.getThreshold();
     String myText_Threshold = str(myThreshold);
     text("Threshold Kinect "+myText_Threshold, 10, 10);
   }
   
   //syphon
   server.sendScreen();
}



//Control del teclado
void keyPressed() {
  
  int keyIndex = -1;
  if (key == '+') {
    int myThershold = tracker.getThreshold();
    myThershold = myThershold + 100;
    tracker.setThreshold(myThershold);
  }
  
  if (key == '-') {
    int myThershold = tracker.getThreshold();
    myThershold = myThershold - 100;
    tracker.setThreshold(myThershold);
  }
  if (key == ' ') {
    bPintarTracker = !bPintarTracker;
    
  }
 
}


//Funciones de video aqui


// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
  
  //
}