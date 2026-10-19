// week07_1_processing_audio_SoundFile_play
// 想要在電腦，用程式控制聲音/音樂的輸入
// 方法1: Processing 的 Sound 外掛，方法2: Minim 的外掛
// Sketch - Library - Manage Libraries
// 或者用 google: processing sound library download
// Moodle 的「上課用軟體」也有一份 sound.zip
// 把「有3個資料夾」的 sound 放在「文件-Processing-Libraries」目錄裡
// 成功後，便可在Files-Example-Libraries核心函式庫-Sound-Soundfile-JumbleSoundfile

import processing.sound.*;
SoundFile sound; // 宣告變數
void setup(){
  size(300, 300);
  sound = new SoundFile(this, "sound.mp3");
  sound.play(); // 準備好 music.mp3 拉到程式裡，播放
}
void draw(){
  
}
