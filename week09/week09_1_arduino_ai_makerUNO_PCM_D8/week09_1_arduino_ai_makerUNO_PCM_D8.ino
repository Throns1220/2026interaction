// week09_1_arduino_ai_makerUNO_PCM_D8
// 想要讓 MakerUNO 發出更多元的聲音，不要只是用單調的 tone()
// 老師要示範，用 AI 一步步找出答案
// Q1: UNO 本身可以用 pin 8 的 buzzer 利用 tone() 來發出單調的聲音
// 有辦法發出比較精彩的聲音嗎? ex. wav or mp3
// (註: 老師教 AI 要十問十答、百問百簽，所以現在要一步步練習問、互動，找到答案)
// Q2: 請幫我找 PCM 相關的 libraries 我想試試看
// Q3: 如何修改 PCM Library，讓它利用 pin 8 的軟體 PWM 或其它輸出技術播放 PCM

/*
  MakerUNO PCM-D8 Player
  Board: Arduino UNO / MakerUNO
  MCU: ATmega328P

  Audio:
    8-bit unsigned PCM
    8000 Hz
    Mono
    PROGMEM

  Output:
    D8 (PB0)
    Timer1 interrupt
    64kHz PDM

  No external audio module required.
*/

#include <Arduino.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

// =====================================
// PCM AUDIO DATA
// Demo: 800Hz sine wave
// 8kHz sample rate, 40 samples
// =====================================

const uint8_t soundData[] PROGMEM = {
  128,203,249,249,203,128,53,7,7,53,
  128,203,249,249,203,128,53,7,7,53,
  128,203,249,249,203,128,53,7,7,53,
  128,203,249,249,203,128,53,7,7,53
};

#define SOUND_LENGTH (sizeof(soundData))

// =====================================
// PCM PLAYER VARIABLES
// =====================================

volatile uint8_t currentSample = 128;
volatile uint8_t pdmAccumulator = 0;
volatile uint8_t subTick = 0;

volatile uint16_t sampleIndex = 0;
volatile bool playing = false;

// =====================================
// TIMER1 ISR
// 64kHz PDM output
// 8 PDM bits = 1 PCM sample
// =====================================

ISR(TIMER1_COMPA_vect) {

  if (!playing) {
    PORTB &= ~_BV(PORTB0);
    return;
  }

  // 8-bit PDM accumulator
  uint16_t sum =
      (uint16_t)pdmAccumulator + currentSample;

  pdmAccumulator = (uint8_t)sum;

  // Output on D8
  if (sum >= 256) {
    PORTB |= _BV(PORTB0);
  } else {
    PORTB &= ~_BV(PORTB0);
  }

  // Update PCM sample at 8kHz
  subTick++;

  if (subTick >= 8) {

    subTick = 0;

    sampleIndex++;

    if (sampleIndex >= SOUND_LENGTH) {
      sampleIndex = 0;
    }

    currentSample =
        pgm_read_byte(&soundData[sampleIndex]);
  }
}

// =====================================
// TIMER INITIALIZATION
// 16MHz / 250 = 64kHz
// =====================================

void initAudioTimer() {

  cli();

  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1 = 0;

  OCR1A = 249;

  // CTC mode, prescaler = 1
  TCCR1B =
      _BV(WGM12) |
      _BV(CS10);

  // Enable Timer1 Compare A interrupt
  TIMSK1 = _BV(OCIE1A);

  sei();
}

// =====================================
// PLAY
// =====================================

void playAudio() {

  cli();

  sampleIndex = 0;
  subTick = 0;
  pdmAccumulator = 0;

  currentSample =
      pgm_read_byte(&soundData[0]);

  playing = true;

  sei();
}

// =====================================
// STOP
// =====================================

void stopAudio() {

  cli();

  playing = false;

  PORTB &= ~_BV(PORTB0);

  sei();
}

// =====================================
// SETUP
// =====================================

void setup() {

  Serial.begin(9600);

  // D8 = PB0
  DDRB |= _BV(DDB0);

  PORTB &= ~_BV(PORTB0);

  initAudioTimer();

  Serial.println("MakerUNO PCM-D8 Ready");
  Serial.println("P = Play");
  Serial.println("S = Stop");

  playAudio();
}

// =====================================
// MAIN LOOP
// =====================================

void loop() {

  if (Serial.available()) {

    char cmd = Serial.read();

    if (cmd == 'P' || cmd == 'p') {

      playAudio();

      Serial.println("Playing");

    }

    if (cmd == 'S' || cmd == 's') {

      stopAudio();

      Serial.println("Stopped");

    }
  }
}
