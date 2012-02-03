#include <Ping.h>
#include <RunningMedian.h>
// to use these custom libraries check the README file for advices.
#include <Servo.h> 

//#define DEBUG

const int SONAR_PIN = A0;
const int SERVO_PIN = 9;
Ping ping = Ping(SONAR_PIN);
RunningMedian samples = RunningMedian();
Servo myservo;


void setup() {
  myservo.attach(SERVO_PIN);
#ifdef DEBUG
  Serial.begin(115200);
#endif
}


void loop()
{
  int cm, cm_raw, cm_old=0;
  const float COEF = 0.5;

  ping.fire();
  cm_raw = ping.centimeters();    // get distance
  
  samples.add(cm_raw);
  cm = samples.getMedian();       // median filter output

  cm = (cm<0)? cm_old : cm;       // keep old value if error
  cm = constrain(cm, 0, 150);     // saturate to 1m50
  cm = map(cm, 0,150 , 0,360);    // convert from distance to angle
  cm = cm*COEF + cm_old*(1-COEF); // smooth with a simple low pass filter
  cm_old = cm;                    // save old value

  myservo.write(cm);              // set motor position

#ifdef DEBUG
  Serial.print(cm);
  Serial.print("cm\t");

  for (int i=0; i<cm/4; i++)
    Serial.print("*");
  Serial.println();
#endif

  delay(30);
}


