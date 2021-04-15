/*
 * hx711.c
 *
 *  Created on: Feb 26, 2021
 *      Author: jared
 */

/*
 * Source: https://www.instructables.com/How-to-Interface-HX711-Balance-Module-With-Load-Ce/
 */

#include "hx711.h"
#include "../io/digital.h"

uint8_t GAIN;
double OFFSET = 0;
float SCALE = 1.f;

uint8_t hx711_is_ready()
{
	return digitalRead(DT) == LOW;
}

void hx711_set_gain(uint8_t gain)
{
	switch (gain)
	{
		case 128:
			GAIN = 1;
			break;
		case 64:
			GAIN = 3;
			break;
		case 32:
			GAIN = 2;
			break;
	}

	digitalWrite(SCK, LOW);
	hx711_read();
}

long hx711_read()
{
	while (!hx711_is_ready());

	unsigned long value = 0;
	uint8_t data[3] = { 0 };
	uint8_t filler = 0x00;

	data[2] = shiftInMSB(DT, SCK);
	data[1] = shiftInMSB(DT, SCK);
	data[0] = shiftInMSB(DT, SCK);

	for (unsigned int i = 0; i < GAIN; i++)
	{
		digitalWrite(SCK, HIGH);
		digitalWrite(SCK, LOW);
	}

	data[2] = ~data[2];
	data[1] = ~data[1];
	data[0] = ~data[0];

	if (data[2] & 0x80)
	{
		filler = 0xFF;
	}
	else if ((data[2] == 0x7F) && (data[1] == 0xFF) && (data[0] == 0xFF))
	{
		filler = 0xFF;
	}
	else
	{
		filler = 0x00;
	}

	value = (
			(unsigned long)(filler) << 24 |
			(unsigned long)(data[2]) << 16 |
			(unsigned long)(data[1]) << 8 |
			(unsigned long)(data[0])
	);

	return (long)(++value);
}

long hx711_read_average(uint8_t times)
{
	double sum = 0;
	for (uint8_t i = 0; i < times; i++)
	{
		sum += hx711_read();
	}
	return sum / times;
}

double hx711_get_value(uint8_t times)
{
	return (hx711_read_average(times) - OFFSET);
}

float hx711_get_units(uint8_t times)
{
	return (hx711_read_average(times) - OFFSET) / SCALE;
}

void hx711_tare(uint8_t times)
{
	double sum = hx711_read_average(times);
	hx711_set_offset(sum);
}

void hx711_set_scale(float scale)
{
	SCALE = scale;
}

float hx711_get_scale()
{
	return SCALE;
}

void hx711_set_offset(long offset)
{
	OFFSET = offset;
}

long hx711_get_offset()
{
	return OFFSET;
}

void hx711_power_down()
{
	digitalWrite(SCK, LOW);
	digitalWrite(SCK, HIGH);
}

void hx711_power_up()
{
	digitalWrite(SCK, LOW);
}
