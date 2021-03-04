
#include "digital.h"


int digitalRead(volatile uint8_t *address)
{
	return *address;
}

void digitalWrite(volatile uint8_t *address, uint8_t value)
{
	*address = value;
}

uint8_t shiftInMSB(volatile uint8_t *dataPin, volatile uint8_t *clockPin)
{

	uint8_t value = 0;

	uint8_t i;

	for (i = 0; i < 8; ++i)
	{

		digitalWrite(clockPin, HIGH);

		value |= digitalRead(dataPin) << (7 - i);

		digitalWrite(clockPin, LOW);

	}

	return value;

}
