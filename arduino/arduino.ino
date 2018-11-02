#include <math.h>

#define PIN_LIGHT 1
#define PIN_TEMP 0

#define ST_MODEL_A 0.00277904
#define ST_MODEL_B -0.00000692823
#define ST_MODEL_C 0.000000889873

#define ST_MODEL_A_L -2.676
#define ST_MODEL_B_L 0.535324
#define ST_MODEL_C_L -0.00306058

#define RESISTANCE 10000
#define AR_VOLTAGE 5.3


float lastTemp;
float lastLight;

void setup() {
  Serial.begin(9600);
}
void computeLux(float voltage) {
  float corrected_voltage = voltage * (float)AR_VOLTAGE / 1023.0;
  float computedR = ((float)1corrected_voltage * (float)RESISTANCE) / ((float)AR_VOLTAGE - (float)corrected_voltage);
  lastLight = 1.0 / (ST_MODEL_A_L + ST_MODEL_B_L * log(computedR) + ST_MODEL_C_L * pow(log(computedR), 3));
}
void computeTemp(float voltage) {
  float corrected_voltage = voltage * (float)AR_VOLTAGE / 1023.0;
  float computedR = ((float)corrected_voltage * (float)RESISTANCE) / ((float)AR_VOLTAGE - (float)corrected_voltage);
  lastTemp = 1.0 / (ST_MODEL_A + ST_MODEL_B * log(computedR) + ST_MODEL_C * pow(log(computedR), 3));
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

