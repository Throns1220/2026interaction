
const int joystickX = A0;
const int joystickY = A1;
const int joystickSW = 2;
const int buzzer = 8;

void setup() {
  Serial.begin(9600);

  pinMode(joystickSW, INPUT_PULLUP);
  pinMode(buzzer, OUTPUT);
}

void loop() {

  // 讀取搖桿
  int xValue = analogRead(joystickX);
  int yValue = analogRead(joystickY);
  int buttonState = digitalRead(joystickSW);

  // 傳送資料給 Processing
  Serial.print(yValue);
  Serial.print(",");
  Serial.println(buttonState);

  // 接收 Processing 的聲音指令
  while (Serial.available() > 0) {

    char command = Serial.read();

    if (command == 'J') {
      // 跳躍音效
      tone(buzzer, 1200, 100);
    }

    else if (command == 'H') {
      // 撞擊音效
      tone(buzzer, 200, 500);
    }

    else if (command == 'S') {
      // 得分音效
      tone(buzzer, 1800, 80);
    }
  }

  delay(20);
}
