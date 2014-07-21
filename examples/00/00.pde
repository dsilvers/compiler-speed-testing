#define XYPAD_X 8
#define XYPAD_Y 9
 
void setup() {
// initialize serial communication at 57600 bits per second:
Serial.begin(57600);
}
 
void loop() 
{
char buffer[4];
 
  AccelerationReading accel = {0, 0, 0};
 
  accel = Bean.getAcceleration();
 
  uint8_t x = (accel.xAxis + 511 ) / 4;
  uint8_t y = (accel.yAxis + 511 ) / 4;
 
  buffer[0] = XYPAD_X;
  buffer[1] = x;
  buffer[2] = XYPAD_Y;
  buffer[3] = y;
 
  Serial.write( (uint8_t*)buffer, 4 );
 
  Bean.sleep(50);
 
}
