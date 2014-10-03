import SimpleOpenNI.*;
import processing.serial.*;

Serial myPort;
SimpleOpenNI kinect;

boolean flag = true;
 
void setup() {
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  textSize(50);
  //必要があればArduinoを繋いでいるcomポートに変更してください。
  myPort=new Serial(this,"com7",9600);
  
}
 
void draw() {  
  background(0);
  fill(255, 0, 0);
  
  kinect.update();
  image(kinect.depthImage(), 0, 0);
  int[] depthMap = kinect.depthMap();
  
  //Left
  int Lx = width/4;
  int Ly = height/2;
  int Lindex = Lx + Ly * width;
  int Ldistance = depthMap[Lindex];
  ellipse(Lx, Ly, 10, 10);
  
  //Center
  int Cx = width/2;
  int Cy = height/2;
  int Cindex = Cx + Cy * width;
  int Cdistance = depthMap[Cindex];
  ellipse(Cx, Cy, 10, 10);
  
  //Right
  int Rx = width/4 * 3;
  int Ry = height/2;
  int Rindex = Rx + Ry * width;
  int Rdistance = depthMap[Rindex];
  ellipse(Rx, Ry, 10, 10);
  
  //距離表示text
  text(Ldistance +" mm", 0, 200);
  text(Cdistance +" mm", 200, 100);
  text(Rdistance +" mm", 400, 200);
  
  //Arduinoからの処理終了合図(E)かつflagがfalseのときtrueに戻す
  if(myPort.read() == 'E' && flag == false){
    flag = true;
  }
  
  //flagがtrueのとき、各距離が1000以内だったらSerialで文字送る
  /*現在はelseで並べているため、同時に複数は動かない。
    また複数で距離が1000位内の場合は先の処理（LとCならL）が優先される。*/
  if(flag == true){
    if(Ldistance > 0 && Ldistance < 1000){
      myPort.write("L");
      flag = false;
      text("L", Lx, height-100);
    }else if(Cdistance > 0 && Cdistance < 1000){
      myPort.write("C");
      flag = false;
      text("C", Cx, height-100);
    }else if(Rdistance > 0 && Rdistance < 1000){
      myPort.write("R");
      flag = false;
      text("R", Rx, height-100); 
    }
  }
}
