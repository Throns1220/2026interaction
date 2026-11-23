
import processing.serial.*;
import java.util.ArrayList;

// =================================
// 1. Arduino 序列通訊
// =================================

Serial myPort;

int joystickY = 512;
int joystickButton = 1;

int upThreshold = 400;

boolean upState = (joystickY < upThreshold);
boolean lastJoystickUp = false;
boolean lastButtonPressed = false;

// =================================
// 2. 遊戲狀態
// =================================

final int START = 0;
final int PLAY = 1;
final int OVER = 2;

int gameState = START;

// =================================
// 3. 遊戲參數
// =================================

int birdX = 100;
float birdY = 250;
float birdSpeed = 0;

int birdSize = 20;

float gravity = 0.35;
float jumpPower = -5.8;

int pipeWidth = 60;
int pipeGap = 155;

float pipeSpeed = 3;

ArrayList<Pipe> pipes;

int score = 0;
int bestScore = 0;

int spawnTimer = 0;

// =================================
// 4. 初始化
// =================================

void setup() {

  size(600, 500);

  frameRate(60);

  // 固定使用已確認的 COM3
  println("連接 Maker UNO：COM3");

  myPort = new Serial(this, "COM3", 9600);

  myPort.clear();
  myPort.bufferUntil('\n');

  // 等待 Arduino 重新啟動
  delay(1500);

  pipes = new ArrayList<Pipe>();
}

// =================================
// 5. 主畫面更新
// =================================

void draw() {

  background(135, 206, 235);

  // 偵測搖桿按鈕
  checkJoystickButton();

  if (gameState == START) {

    drawStartScreen();

  }

  else if (gameState == PLAY) {

    updateBird();
    updatePipes();
    checkCollision();

    drawBird();
    drawPipes();
    drawScore();
    drawGround();

  }

  else if (gameState == OVER) {

    drawBird();
    drawPipes();
    drawScore();
    drawGround();

    drawGameOver();
  }
}

// =================================
// 6. 接收 Arduino 資料
// =================================

void serialEvent(Serial p) {

  String data = p.readStringUntil('\n');

  if (data != null) {

    data = trim(data);

    String[] values = split(data, ',');

    if (values.length == 2) {

      try {

        joystickY = int(values[0]);
        joystickButton = int(values[1]);

      }

      catch(Exception e) {

        println("資料格式錯誤：" + data);

      }
    }
  }
}

// =================================
// 7. 開始遊戲
// =================================

void startGame() {

  gameState = PLAY;

  birdY = 250;
  birdSpeed = 0;

  score = 0;

  pipeSpeed = 3;

  spawnTimer = 0;

  pipes.clear();

  // 第一個障礙物
  pipes.add(new Pipe(width + 150));

  lastJoystickUp = false;

}

// =================================
// 8. 開始畫面
// =================================

void drawStartScreen() {

  drawBird();

  fill(255);
  textAlign(CENTER);

  textSize(42);
  text("PIXEL BIRD", width/2, 120);

  textSize(20);
  text("Press SPACE to Start", width/2, 330);

  text("Or Press Joystick Button", width/2, 370);

  textSize(16);
  text("Push joystick upward to fly!", width/2, 420);

  drawGround();
}

// =================================
// 9. 搖桿按鈕控制
// =================================

void checkJoystickButton() {

  boolean pressed = (joystickButton == 0);

  // 只偵測按下的瞬間
  if (pressed && !lastButtonPressed) {

    if (gameState == START || gameState == OVER) {

      startGame();

    }
  }

  lastButtonPressed = pressed;
}

// =================================
// 10. 小鳥控制
// =================================

void updateBird() {

  boolean upState = (joystickY < upThreshold);

  // 搖桿由放開變成向上推時跳躍
  if (upState && !lastJoystickUp) {

    jumpBird();

  }

  lastJoystickUp = upState;

  // 重力
  birdSpeed += gravity;

  birdY += birdSpeed;

  // 天花板碰撞
  if (birdY <= 0) {

    endGame();

  }

  // 地板碰撞
  if (birdY + birdSize >= 460) {

    endGame();

  }
}

// =================================
// 11. 跳躍功能
// =================================

void jumpBird() {

  birdSpeed = jumpPower;

  // 通知 Arduino 播放跳躍音效
  myPort.write('J');

}

// =================================
// 12. 像素鳥外觀
// =================================

void drawBird() {

  noStroke();

  // 鳥身
  fill(255, 220, 0);

  rect(birdX, birdY, birdSize, birdSize);

  // 翅膀
  fill(255, 150, 0);

  rect(birdX - 5, birdY + 8, 8, 8);

  // 眼睛
  fill(0);

  rect(birdX + 13, birdY + 4, 4, 4);

  // 嘴巴
  fill(255, 80, 0);

  rect(birdX + 18, birdY + 11, 8, 5);

}

// =================================
// 13. 障礙物類別
// =================================

class Pipe {

  float x;
  float gapY;

  boolean counted = false;

  Pipe(float startX) {

    x = startX;

    gapY = random(120, 330);

  }

  void move() {

    x -= pipeSpeed;

  }

  void display() {

    noStroke();

    fill(0, 180, 70);

    // 上方障礙物
    rect(
      x,
      0,
      pipeWidth,
      gapY - pipeGap/2
    );

    // 下方障礙物
    rect(
      x,
      gapY + pipeGap/2,
      pipeWidth,
      460 - gapY - pipeGap/2
    );

    // 障礙物頂端裝飾
    fill(0, 140, 50);

    rect(
      x - 5,
      gapY - pipeGap/2 - 10,
      pipeWidth + 10,
      10
    );

    rect(
      x - 5,
      gapY + pipeGap/2,
      pipeWidth + 10,
      10
    );

  }
}

// =================================
// 14. 更新障礙物
// =================================

void updatePipes() {

  spawnTimer++;

  // 固定時間產生新障礙物
  if (spawnTimer >= 100) {

    pipes.add(new Pipe(width));

    spawnTimer = 0;

  }

  for (int i = pipes.size() - 1; i >= 0; i--) {

    Pipe p = pipes.get(i);

    p.move();

    // 成功通過障礙物
    if (!p.counted && p.x + pipeWidth < birdX) {

      p.counted = true;

      score++;

      // 得分音效
      myPort.write('S');

      // 隨著分數增加，遊戲逐漸加速
      pipeSpeed = min(5, 3 + score * 0.1);

    }

    // 移除畫面外障礙物
    if (p.x + pipeWidth < 0) {

      pipes.remove(i);

    }

  }
}

// =================================
// 15. 畫出障礙物
// =================================

void drawPipes() {

  for (Pipe p : pipes) {

    p.display();

  }

}

// =================================
// 16. 碰撞判斷
// =================================

void checkCollision() {

  for (Pipe p : pipes) {

    boolean horizontal =
      birdX + birdSize > p.x &&
      birdX < p.x + pipeWidth;

    boolean hitTop =
      birdY < p.gapY - pipeGap/2;

    boolean hitBottom =
      birdY + birdSize > p.gapY + pipeGap/2;

    if (horizontal && (hitTop || hitBottom)) {

      endGame();

      return;

    }

  }

}

// =================================
// 17. 地板
// =================================

void drawGround() {

  noStroke();

  fill(220, 190, 100);

  rect(0, 460, width, 40);

  fill(100, 190, 70);

  rect(0, 460, width, 8);

}

// =================================
// 18. 分數
// =================================

void drawScore() {

  fill(255);

  textAlign(CENTER);

  textSize(30);

  text("SCORE: " + score, width/2, 40);

}

// =================================
// 19. 遊戲結束
// =================================

void endGame() {

  if (gameState == PLAY) {

    gameState = OVER;

    if (score > bestScore) {

      bestScore = score;

    }

    // 撞擊音效
    myPort.write('H');

  }

}

// =================================
// 20. 遊戲結束畫面
// =================================

void drawGameOver() {

  fill(0, 0, 0, 170);

  rect(0, 0, width, height);

  fill(255, 70, 70);

  textAlign(CENTER);

  textSize(40);

  text("GAME OVER", width/2, 200);

  fill(255);

  textSize(22);

  text("SCORE: " + score, width/2, 250);

  text("BEST: " + bestScore, width/2, 285);

  textSize(18);

  text("Press SPACE to Restart", width/2, 340);

  text("Or Press Joystick Button", width/2, 375);

}

// =================================
// 21. 鍵盤控制
// =================================

void keyPressed() {

  if (key == ' ') {

    if (gameState == START || gameState == OVER) {

      startGame();

    }

    else if (gameState == PLAY) {

      jumpBird();

    }

  }

}
