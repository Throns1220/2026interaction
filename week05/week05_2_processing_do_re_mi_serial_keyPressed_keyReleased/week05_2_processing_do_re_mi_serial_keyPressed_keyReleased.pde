// week05_2_processing_do_re_mi_serial_keyPressed_keyReleased
// 修改自week05_1_processing_do_re_mi_serial
// 按多久、叫多久, 放開、就不叫了 不是永遠0.1秒
import processing.serial.*; // 使用 USB Serial 外掛
Serial myPort; // 將用myPort 來傳 USB Serial 資料
void setup(){
  size(300, 200);
  myPort = new Serial(this, "COM3", 9600); // 中間 "COM4" or "COM3" 自己查
}
void draw(){

}
int p1=0, p2=0, p3=0; // 變數記錄按鍵, 按鍵一開始沒按, 下面有做修改
void keyPressed() {
  if (p1==0 && key=='1') myPort.write('1');
  if (p1==0 && key=='2') myPort.write('2');
  if (p1==0 && key=='3') myPort.write('3');
  if (p1==0 && key=='1') p1=1; // 0代表「沒有按」, 1代表「按下去」
  if (p1==0 && key=='2') p2=2;
  if (p1==0 && key=='3') p3=3;
}
void keyReleased(){
  if (key=='1') p1=0; // 放開1鍵
  if (key=='2') p2=0; // 放開2鍵
  if (key=='3') p3=0; // 放開3鍵
  myPort.write('0'); // 告訴 Arduino 不要發出任何聲音
}
