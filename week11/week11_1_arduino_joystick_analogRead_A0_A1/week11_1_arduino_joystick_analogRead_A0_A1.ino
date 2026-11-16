// week11_1_arduino_joystick_analogRead_A0_A1_tone
void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:
  int x = analogRead(A0); // 讀入 x 座標
  int y = analogRead(A1); // 讀入 y 座標
  tone(8, x); // 會把 x 的值，直接做吵的輸出
  // 如果太吵，想暫時停止，把 MakerUno 的跳針，往左推
}
