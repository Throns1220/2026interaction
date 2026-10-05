// week05_1_arduino_do_re_mi_Serial
// 修改自 week02_5_arduino_do_re_mi_Serial_begin_a
// google: 我想要把 Arduino 跟 Processing 結合
// 在 Processing 按下 key 1 2 3 對應 Arduino 的 Do Re Mi 使用 USB Serial
// 寫完程式, 用Tool-SerialMonitor 來監控
void setup(){
  Serial.begin(9600); // USB Serial 開始傳輸, 速度 9600 bps
  tone(8, 523, 100); // Do 0.1秒
  delay(300); // 會出錯, 滑過去, 沒聽到
  
  tone(8, 587, 100); // Re 0.1秒
  delay(300); // 會出錯, 滑過去, 沒聽到
  
  tone(8, 659, 100); // Mi 0.1秒
  delay(300); // 會出錯, 滑過去, 沒聽到

  tone(8, 587, 100); // Re 0.1秒
  delay(300); // 會出錯, 滑過去, 沒聽到

  tone(8, 523, 100); // Do 0.1秒
}

void loop(){
  if (Serial.available()){ // 如果 USB Serial 有收到資料
    char c = Serial.read(); // 就讀進來
    if (c=='1') tone(8, 523, 1000); // Do 1秒
    if (c=='2') tone(8, 587, 1000); // Re 1秒
    if (c=='3') tone(8, 659, 1000); // Mi 1秒  
  }
}
