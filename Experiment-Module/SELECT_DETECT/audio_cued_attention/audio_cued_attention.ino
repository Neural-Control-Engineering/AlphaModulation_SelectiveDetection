

unsigned long int reg;
int LeftCue = 3; //change to 1 if no onset tone
int RightCue = 4; 
int Onset = 9;
int noise = 10;
int Tone1 = 11;
int Tone2 = 12;
//int Tone2 = 5;
  
void setup() {
 
  
  // Audio
  pinMode(LeftCue, INPUT);
  pinMode(RightCue, INPUT);
  pinMode(Onset, INPUT);
  pinMode(noise, OUTPUT);
  pinMode(Tone1, OUTPUT);
  pinMode(Tone2, OUTPUT);
  reg = 0x55aa55aaL; //The seed for the bitstream. It can be anything except 0.
}

void loop() {
  
  // Audio
  if (digitalRead(LeftCue) == 1) {
    tone(Tone1, 6670, 1000);
    delay(1);
  }

  else if (digitalRead(RightCue) == 1) {
    tone(Tone2, 3335, 1000);
    delay(1);
  }

  else if (digitalRead(Onset) == 1) {
    tone(Tone1, 2000, 1000);
    delay(1);
  }

  generateNoise();
}

void generateNoise(){
   unsigned long int newr;
   unsigned char lobit;
   unsigned char b31, b29, b25, b24;
   b31 = (reg & (1L << 31)) >> 31;
   b29 = (reg & (1L << 29)) >> 29;
   b25 = (reg & (1L << 25)) >> 25;
   b24 = (reg & (1L << 24)) >> 24;
   lobit = b31 ^ b29 ^ b25 ^ b24;
   newr = (reg << 1) | lobit;
   reg = newr;
   digitalWrite(noise, reg & 1);
   delayMicroseconds (80); // Changing this value changes the frequency.
}
