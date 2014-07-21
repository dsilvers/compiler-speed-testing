#define FORECASTDAYS 6
 
static int d0 = 0;
static int d1 = 1;
static int d2 = 2;
static int d3 = 3;
static int d4 = 4;
static int d5 = 5;
static uint8_t waveHeights[FORECASTDAYS];
static uint8_t waveConditions[FORECASTDAYS];
bool receivedConditions = false;
 
void setup()
{
    // initialize serial communication
    Serial.begin(57600);
    // this makes it so that the arduino read function returns
    // immediatly if there are no less bytes than asked for.
    Serial.setTimeout(25);
    for (int i=0; i++; i<FORECASTDAYS) {
        waveHeights[i]=0;
        waveConditions[i]=0;
    }
 
}
 
// the loop routine runs over and over again forever:
void loop()
{
    char buffer[64];
    size_t readLength = 16;
    uint8_t length = 0;
    uint8_t loopCount = 0;
 
    length = Serial.readBytes(buffer, readLength);
    if (16 == length) {
        if (buffer[0] == 0x00 && buffer[1] == 0x06) { //0 == wave heights
            for (int i = 0; i < FORECASTDAYS; i++) {
                waveHeights[i]=buffer[i+2];
            }
            for (int i = 0; i < FORECASTDAYS; i++) { //surf conditions
                waveConditions[i]=buffer[i+10];
            }
 
            receivedConditions = true;
            Bean.setLedRed(255);
            delay(100);
            Bean.setLed(0,0,0);
        }
    }
 
    /* 
        http://www.surfline.com/surf-science/rating-of-surf-heights-and-quality_31942/
 
        The Surfline Surf Quality Scale
        © Copyright 2000-2010 Surfline/Wavetrak, Inc.
        
        1 = FLAT: Unsurfable or flat conditions. No surf.
        2 = VERY POOR: Due to lack of surf, very poor wave shape for surfing, bad surf due to other conditions like wind, tides, or very stormy surf.
        3 = POOR: Poor surf with some (30%) FAIR waves to ride.
        4 = POOR to FAIR: Generally poor surf many (50%) FAIR waves to ride.
        5 = FAIR: Very average surf with most (70%) waves rideable.
        6 = FAIR to GOOD: Fair surf with some (30%) GOOD waves.
        7 = GOOD: Generally fair surf with many (50%) GOOD waves.
        8 = VERY GOOD: Generally good surf with most (70%) GOOD waves.
        9 = GOOD to EPIC: Very good surf with many (50%) EPIC waves.
        10 = EPIC: Incredible surf with most (70%) waves being EPIC to ride and generally some of the best surf all year.
    */
 
    if (receivedConditions) {
        for (int i = 0; i < FORECASTDAYS; i++) {
            if (waveConditions[i] < 2) { // flat or no forecast
                Bean.setLed(0,0,10); // dull blue
            } else if (waveConditions[i] >= 2 && waveConditions[i] < 5) { // poor = blue
                Bean.setLed(0,0,waveHeights[i]*16);
            } else if (waveConditions[i] >= 5 && waveConditions[i] < 7) { // fair = green
                Bean.setLed(0,waveHeights[i]*16,0);
            } else if (waveConditions[i] >= 7 && waveConditions[i] < 9) { // good = orange
                Bean.setLed(waveHeights[i]*4,waveHeights[i]*16,0);
            } else if (waveConditions[i] >= 9) { // EPIC!! Stop what you're doing and go surf!!1
                Bean.setLed(waveHeights[i]*16,0,0);
            }
            delay(200);
            Bean.setLed(0,0,0); // turn led off
            delay(500);
        }
    }
    if (!receivedConditions) {
        Bean.setLed(0,0,0);
    }
    Bean.sleep(10000);          // sleep for ten seconds
}
