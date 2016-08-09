/* Aristotab 0304
 * ----------------
 *
 * Program to read the parallel data sent out by the Aristotab 0304. Based on
 *
 * PrinterCapturePoll.ino
 * ------------------
 * Monitor a parallel port printer output and capture each character. Output the
 * character on the USB serial port so it can be captured in a terminal program.
 *
 * By............: Paul Jewell
 * Date..........: 29th January 2015
 * Version.......: 0.1a
 *-------------------------------------------------------------------------------
 * Wiring Layout
 * -------------
 *
 * Parallel Port Output               Arduino Input
 * --------------------               -------------
 * Name      Dir.   Pin                Name    Pin
 * ----             ---                ----    ---
 * nSTROBE    >       1..........................2
 * DATA BYTE  >     2-9.......................3-10   
 * nACK       <      10.........................11
 * BUSY       <      11.........................12
 * OutofPaper <      12................GND
 * Selected   <      13.................5v
 * GND        <>  18-25................GND
 *-------------------------------------------------------------------------------
 ********************************************************************************/

int nStrobe = 2;
int Data0   = 3;
int Data1   = 4;
int Data2   = 5;
int Data3   = 6;
int Data4   = 7;
int Data5   = 8;
int Data6   = 9;
int Data7   = 10;
int nAck    = 11;
int Busy    = 12;
int led     = 13; // use as status led

void setup() {
  // Configure pins
  pinMode(nStrobe, INPUT_PULLUP);
 
  for (int n = Data0; n < (Data7+1); n++)
    pinMode(n, INPUT_PULLUP);
 
  pinMode(nAck, OUTPUT);
  pinMode(Busy, OUTPUT);
  pinMode(led, OUTPUT);
 
  Serial.begin(9600);
  while (!Serial) {
    ;
  }
 
  State = READY;
  delay(1000);
  Serial.println("Initialised");
}


void loop() {
  while (digitalRead(nStrobe) == HIGH) {
    digitalWrite(Busy, LOW);
    digitalWrite(nAck,HIGH);
    digitalWrite(led, HIGH);
  }   
  digitalWrite(Busy, HIGH);
  digitalWrite(led, LOW);
  ProcessChar();
  digitalWrite(nAck,LOW);
  delay(5); //milliseconds. Specification minimum = 5 us
}   

void ProcessChar() {
  byte Char;
 
  Char = digitalRead(Data0) +
         (digitalRead(Data1) << 1) +
         (digitalRead(Data2) << 2) +
         (digitalRead(Data3) << 3) +
         (digitalRead(Data4) << 4) +
         (digitalRead(Data5) << 5) +
         (digitalRead(Data6) << 6) +
         (digitalRead(Data7) << 7);
         
  Serial.print((char)Char);
}
