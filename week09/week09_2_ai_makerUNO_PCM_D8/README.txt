Maker UNO week09_2 / D8 buzzer / PCM effects

1. Unzip. Open week09_2_ai_makerUNO_PCM_D8.ino in Arduino IDE.
2. Set board to Arduino Uno; switch onboard BUZZER to ON.
3. Verify PCM.cpp, PCM.h and sounddata.h are in same sketch folder.
4. Upload; three different sounds repeat.

Notes: Uses 64 kHz Timer1 ISR; avoid Servo and libraries using Timer1.
8-bit unsigned PCM at 8000 Hz. Audio loudness is limited by physical piezo.
Not yet tested on physical Maker UNO.
