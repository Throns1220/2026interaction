// week03_2_Arduino_delay_blink
// 用delay() 來延後、控制發亮的時間
void setup() {
  // put your setup code here, to run once:
  //pinMode(2, INPUT_PULLUP); // 第2是按鈕, 沒按時「拉高」
  //for (int i=3; i<=13; i++) pinMode(i, OUTPUT);
  for (int i=2; i<=13; i++) pinMode(i, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  for (int i=2; i<=7; i++) digitalWrite(i, HIGH);
  for (int i=8; i<=13; i++) digitalWrite(i, LOW);
  delay(1000); // 延後1秒
  for (int i=2; i<=7; i++) digitalWrite(i, LOW);
  for (int i=8; i<=13; i++) digitalWrite(i, HIGH);
  delay(500); // 延後0.5秒
}
