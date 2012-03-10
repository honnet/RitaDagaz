#include <Ping.h>
#include <RunningMedian.h>
// to use these custom libraries check the README file for advices.
#include <Servo.h> 


const int SONAR_PIN = A0;
const int SERVO_PIN = 9;
const int DIST_MAX = 120;

Ping ping = Ping(SONAR_PIN);
RunningMedian samples;
Servo myservo;


void setup() {
  samples = RunningMedian();
  myservo.attach(SERVO_PIN);
}


void loop()
{
  int angle;
  float cm;

  ping.fire();
  cm = ping.centimeters();              // get distance
  cm = dist_process(cm);                // multiple filters

  angle = map(cm, 0,DIST_MAX , 0,180);  // convert from distance to angle
  angle = angle_process(angle);         // limit speed of motor
  myservo.write(angle);                 // set motor position

  delay(5);
}


int dist_process(int cm)
{
  const float COEF = 0.1;
  static float cm_old = DIST_MAX;       // max number of cm that we can measure

  if (cm<0) cm = cm_old;                // keep old value if error
  cm = constrain(cm, 0, DIST_MAX);      // saturate to a reliable distance

  samples.add(cm);                      // median filter input
  cm = samples.getMedian();             // median filter output

  cm = cm*COEF + cm_old*(1-COEF);       // smooth with a simple low pass filter
  cm_old = cm;                          // save old value
  return cm;
}


int angle_process(int angle)
{
  const int ANGLE_MAX_DIFF = 1;
  static int angle_old = angle;

  int diff = angle - angle_old;         // get the difference
  int abs_diff = abs(diff);             // ...its absolute value
  int sign = (diff<0)? -1 : 1;          // ...and its sign
  
  if (abs_diff>ANGLE_MAX_DIFF)          // avoid changing the angle too quickly
    angle = angle_old + ANGLE_MAX_DIFF*sign;

  angle_old = angle;
  return angle;
}
