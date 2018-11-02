#include <math.h>

#define PIN_LIGHT 1
#define PIN_TEMP 0

#define ST_MODEL_A 2.108
#define ST_MODEL_B 0.797
#define ST_MODEL_C 6.535

#define RESISTANCE 10000
#define AR_VOLTAGE 5.3


float lastTemp;
float lastLight;

void setup() {
  Serial.begin(9600);
}

void computeTemp(float voltage) {
  float corrected_voltage = voltage * (float)AR_VOLTAGE / 1023.0;
  float computedR = ((float)corrected_voltage * (float)RESISTANCE) / ((float)AR_VOLTAGE - (float)corrected_voltage);
  lastTemp = 1.0 / (ST_MODEL_A + ST_MODEL_B * log(computedR) + ST_MODEL_C * pow(log(computedR), 3));
}

void loop() {
  computeTemp(analogRead(PIN_TEMP));
}

void serialEvent() {
  while (Serial.available()) {
    char inChar = (char)Serial.read();
    if (inChar == '1') {
      Serial.println(String(String(lastTemp) + "," + String(lastLight)));
    }
  }
}

