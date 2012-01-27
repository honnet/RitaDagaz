#include <Ping.h>
#include <RunningMedian.h>
// to use these libraries check the README file for advices.

const int SONAR_PIN = 0;
Ping ping = Ping(SONAR_PIN);
RunningMedian samples = RunningMedian();


void setup() {
  Serial.begin(115200);
}


void loop()
{
  int cm_raw, cm;

  ping.fire();
  cm_raw = ping.centimeters();

  samples.add(cm_raw);
  cm = samples.getMedian();

  Serial.print(cm);
  Serial.print("cm\t");

  for (int i=0; i<cm/4; i++)
    Serial.print("*");
  Serial.println();
  
  delay(20);
}


