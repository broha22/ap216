#define PIN_LIGHT 1
#define PIN_TEMP 0

#define RESISTANCE 10000
#define AR_VOLTAGE 5.3


float lastTemp;
float lastLight;

void setup() {
  Serial.begin(9600);
}
void computeLux(float voltage) {
  float corrected_voltage = voltage * (float)AR_VOLTAGE / 1023.0;
  float computedR = ((float)corrected_voltage * (float)RESISTANCE) / ((float)AR_VOLTAGE - (float)corrected_voltage);
  lastLight = computedR;
}
void computeTemp(float voltage) {
  float corrected_voltage = voltage * (float)AR_VOLTAGE / 1023.0;
  float computedR = ((float)corrected_voltage * (float)RESISTANCE) / ((float)AR_VOLTAGE - (float)corrected_voltage);
  lastTemp = computedR;
}

void loop() {
  computeTemp(analogRead(PIN_TEMP));
  computeLux(analogRead(PIN_LIGHT));
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == '1') {
      Serial.println(String(String(lastTemp) + "," + String(lastLight)));
    }
  }
}

