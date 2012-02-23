#include <Ping.h>
#include <RunningMedian.h>
// to use these custom libraries check the README file for advices.
#include <Servo.h> 

#define DEBUG

const int SONAR_PIN = A0;
const int SERVO_PIN = 9;
Ping ping = Ping(SONAR_PIN);
RunningMedian samples = RunningMedian();
Servo myservo;
bool stopPrint = false;


void setup() {
  myservo.attach(SERVO_PIN);
#ifdef DEBUG
  Serial.begin(115200);
#endif
}


void loop()
{
  const float COEF = 0.3;
  const int DIST_MAX = 120;           // number of cm that we can measure
  float cm, cm_old=DIST_MAX/2;
  int angle;

  ping.fire();
  cm = ping.centimeters();              // get distance

  //if (cm<0) cm = cm_old;                // keep old value if error
  cm = constrain(cm, 0, DIST_MAX);      // saturate to a reliable distance

  samples.add(cm);                      // median filter input
  cm = samples.getMedian();             // median filter output

  cm = cm*COEF + cm_old*(1-COEF);       // smooth with a simple low pass filter
  cm_old = cm;                          // save old value

  angle = map(cm, 0,DIST_MAX , 0,360);  // convert from distance to angle
  myservo.write(angle);                 // set motor position

#ifdef DEBUG
  char received = Serial.read();        // get -1 if empty
  if (received == '0') stopPrint = true;
  if (received == '1') stopPrint = false;

  if (stopPrint == false)
  {
    Serial.print(cm);
    Serial.print("cm\t");

    //for (int i=0; i<cm/2; i++)
    for (int i=0; i<angle/2; i++)
      Serial.print("*");

    Serial.println();
  }
#endif

  delay(20);
}


