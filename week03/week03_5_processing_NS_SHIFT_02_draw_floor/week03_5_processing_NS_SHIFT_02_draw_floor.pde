// week03_5_processing_NS_SHIFT_02_draw_floor
// 修改自 week03_4_processing_NS_SHIFT_01_build_wall
// 小朋友下樓梯
void setup() {
  size(600, 600); // 小畫家截 YOUTUBE 圖片, 得到大小
  for(int i=0; i<20; i++) floorX[i] = int(random(600-140-25));
}
int [] floorX = new int[20];
void draw() {
  background(0, 5, 95); // 小畫家的吸管「吸色彩」再編輯
  fill(47, 105, 190); // 左右磚的色彩
  for(int i=0; i<=10; i++) {
    rect(0, i*60, 25, 50); // 左邊的牆
    rect(600-25, i*60, 25, 60); // 右邊的牆
  }
  fill(208, 216, 189); // 畫地板
  //rect(200, 200, 140, 52); // 大概量一下寬度 140
  for(int i=0; i<20; i++) {
    rect(floorX[i], 75+i*75, 140, 25);
  }
}
