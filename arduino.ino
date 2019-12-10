/*
USB(mega2560)-to-BLE sketch
Apploader project
http://www.apploader.info
Anton Smirnov
2015
Note:
  HM-10 applies baud rate set in 'AT+BAUD' after switch off and on
*/

int led = 13;
int ledHIGH = 0;

void setup() {
  // init
  Serial.begin(38400);  // USB (choose 115200 in terminal)
  Serial1.begin(38400);

  pinMode(led, OUTPUT);
}

int i = 0;
int j = 0;
String text = "";

void loop() {
  
i = i+1;
j = j+10;
text = text + i+','+j+';';
if(i%10 == 0)
  {
   text = text + "\n";
   Serial.print(text);
   Serial1.print(text);
   j = 0;
   text = "";
   delay(200);
  }
if(i == 100)
{
  i = 0;
}

  // read from BLE (HM-10)
  if (Serial1.available()) {
    Serial.write("ble: ");
    String str = Serial1.readString();
    Serial.print(str);
    Serial.write('\n');
  }
  
  // read from USB (Arduino Terminal)
  if (Serial.available()) {
    Serial.write("usb: ");
    String str = Serial.readString();
    Serial1.print(str);
    Serial.print(str);
    Serial.write('\n');
  }
}
