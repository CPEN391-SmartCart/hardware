
#include "stdint.h"

#define LOW 0
#define HIGH 1

/**
 * Reads from the specified address
 */
int digitalRead(volatile uint8_t *address);

/**
 * Writes to the specified address
 */
void digitalWrite(volatile uint8_t *address, uint8_t value);

/**
 * Shifts in data, bit by bit, depending on the clock
 */
uint8_t shiftInMSB(volatile uint8_t *dataPin, volatile uint8_t *clockPin);
