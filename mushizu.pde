import SimpleOpenNI.*;
import processing.serial.*;

Serial myPort;
SimpleOpenNI kinect;
 
void setup() {
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  textSize(50);
  myPort=new Serial(this,"com7",9600);
}
 
void draw() {  
  background(0);
  kinect.update();
  image(kinect.depthImage(), 0, 0);
   
  int[] depthMap = kinect.depthMap();
 
  int x = width/2;
  int y = 170;
  //int y = height/2;
  int index = x + y * width;
  int distance = depthMap[index];
   
  fill(255, 0, 0);
  ellipse(x, y, 10, 10);
   
  if(distance > 0){
    text(distance +" mm", x+10, y-10);
    if(distance < 590 ){
      //distance > 530 && distance < 570 
      myPort.write("B");
      text("ok", x+50, y+100);
    }else{
      myPort.write("A");
      text("but", x+50, y+100);
    }
  }else{
    text("-- mm", x+10, y-10);
    myPort.write("B");
  }
}
