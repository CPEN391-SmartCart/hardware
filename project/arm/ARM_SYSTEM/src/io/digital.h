
#include "stdint.h"

#define LOW 0
#define HIGH 1

int digitalRead(volatile uint8_t *address);

void digitalWrite(volatile uint8_t *address, uint8_t value);

uint8_t shiftInMSB(volatile uint8_t *dataPin, volatile uint8_t *clockPin);
