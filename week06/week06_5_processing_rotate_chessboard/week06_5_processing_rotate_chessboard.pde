// week06_5_processing_rotate_chessboard
// 修改自 week06_3_processing_rotate_translate_rotate_rect
// 想要做一個會旋轉的迷宮
void setup() {
  size(500, 500);
}
void draw() {
  background(0); // 黑色背景
  // translate(250, 250); // 往右移、往下移 (暫時註解掉, 要做實驗)
  translate(mouseX, mouseY); // (暫時改用 mouse 當移動輛)
  println(mouseX, mouseY); // (暫時在小黑, 印出 mouse 座標)
  rotate( radians(frameCount)); // 持續移動
  rect(-200, -200, 400, 400); // 座標奇怪的四邊形
  for (int i=0; i<8; i++) { // 左手i 對應y座標
    for (int j=0; j<8; j++) { // 右手j 對應x座標
      if ( (i+j)%2 == 1 ) fill(255); // 白色
      else fill(0); // 黑色
      rect(j*50-200, i*50-200, 50, 50); // 小格子
    }
  }
}
