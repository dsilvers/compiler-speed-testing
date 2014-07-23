#include "Arduino.h"
#include "Bean.h"
void setup() {
    // initialize serial communication at 57600 bits per second:
    Serial.begin(57600);
}
 
// the loop routine runs over and over again forever:
void loop() {
    Bean.setLed(0,0,255);  // blue
    Bean.sleep(250);
    Bean.setLed(0,255,0);  // green
    Bean.sleep(250);
    Bean.setLed(255,0,0);  // red
    Bean.sleep(250);
    Bean.setLed(0,0,0);    // off
    Bean.sleep(3000);
}
extern "C" void __cxa_pure_virtual() { while (1) ; }
#include <Arduino.h>

int main(void)
{
  init();

#if defined(USBCON)
  USBDevice.attach();
#endif
  // Ensure that BeanSerialTransport.begin() is called for control messages
  // even if users are not using the serial port.
  // A user calling this again shouldn't cause any harm.

  // Need to turn off SPI as it's on at boot for some reason
  SPCR &= ~_BV(SPE);

  Serial.begin();
  setup();

  for (;;) {
    loop();
    if (serialEventRun) serialEventRun();
  }

  return 0;
}

