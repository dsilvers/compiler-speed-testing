  
/*
XY Blink
 
  This sketch is intended to be used with the
  LightBlue Sandbox screen, particularly the
  X-Y trackpad screen.
  
  NOTE: This sketch is not a low-power sketch.
 
  This example code is in the public domain.
 */
 
void setup() 
{
  Serial.begin(57600);
 
  Serial.setTimeout(5);
}
 
#define XYPAD_X  8
#define XYPAD_Y  9
 
static uint8_t rate;
static uint8_t intensity;
 
void loop() {
  char buffer[64];
  size_t length = 64; 
      
  length = Serial.readBytes(buffer, length);    
  
  if ( length > 0 )
  {
    // There may be both X and Y values read in 
    // a single packet.  Handle this case.
    // Byte[0] : X/Y control #
    // Byte[1] : Value [0,255]
    for (int i = 0; i < length - 1; i += 2 )
    {
      if ( buffer[i] == XYPAD_X )
      {
        rate = buffer[i+1];
      }
      else if ( buffer[i] == XYPAD_Y )
      {
        intensity = buffer[i+1];
      }
    }
    // limit the rate
    if ( rate < 5 )
    {
      rate = 5;
    }
  }
  
    Bean.setLed( 0, intensity, 0 );
    delay( rate );
    Bean.setLed( 0, 0, 0 );
    delay( rate );
}
