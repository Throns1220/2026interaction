// week05_3_processing_do_re_mi_Serial_draw
// 修改自 week05_2_processing_do_re_mi_serial_keyPressed_keyReleased
// 希望有視覺的互動 畫面會出現按鍵
import processing.serial.*; // 使用 USB Serial 外掛
Serial myPort; // 將用myPort 來傳 USB Serial 資料
void setup(){
  size(300, 200);
  myPort = new Serial(this, "COM3", 9600); // 中間 "COM4" or "COM3" 自己查
}
void draw() {
  background(128); // 這裡要寫程式喔
  if (p1==1) fill(0); // 黑色, 按下去
  else fill(255); // 否則是白色, 沒按下去
  rect(0, 0, 100, 200); // 第1個按鍵
  
  if (p2==1) fill(0);
  else fill(255);
  rect(100, 0, 100, 200); // 第2個按鍵
  
  if (p3==1) fill(0);
  else fill(255);
  rect(200, 0, 100, 200); // 第3個按鍵
  
  fill(255, 0, 0); // 紅色圈圈
  if(now=='1') ellipse(50, 175, 50, 50);
  if(now=='2') ellipse(150, 175, 50, 50);
  if(now=='3') ellipse(250, 175, 50, 50);
}
char now = '0'; // 現在在按哪個鍵
int p1=0, p2=0, p3=0; // 變數記錄按鍵, 按鍵一開始沒按, 下面有做修改
void keyPressed() {
  now = key;
  if (p1==0 && key=='1') myPort.write('1');
  if (p1==0 && key=='2') myPort.write('2');
  if (p1==0 && key=='3') myPort.write('3');
  if (p1==0 && key=='1') p1=1; // 0代表「沒有按」, 1代表「按下去」
  if (p1==0 && key=='2') p2=2;
  if (p1==0 && key=='3') p3=3;
}
void keyReleased(){
  now = '0';
  if (key=='1') p1=0; // 放開1鍵
  if (key=='2') p2=0; // 放開2鍵
  if (key=='3') p3=0; // 放開3鍵
  myPort.write('0'); // 告訴 Arduino 不要發出任何聲音
}
