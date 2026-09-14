// week01_5_google_gemini_mouse_wheel_void_mouseWheel_MouseEvent_getCount
// google gemini: Processing 怎麼用到 mouse wheel
// 把 AI 摘要的程式碼 copy 過來用
float circleSize = 50; // 宣告全域變數控制大小

void setup() {
  size(400, 400);
}

void draw() {
  background(220);
  // 繪製圓形，大小由 circleSize 決定
  ellipse(width / 2, height / 2, circleSize, circleSize);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount(); // 取得滾動數值
  
  // 往下滾動放大，往上滾動縮小，每次改變 5 個像素
  circleSize -= e * 5; 
  
  // 限制圓形大小的極值，避免小於 0 或過大
  circleSize = constrain(circleSize, 10, 350);
}
