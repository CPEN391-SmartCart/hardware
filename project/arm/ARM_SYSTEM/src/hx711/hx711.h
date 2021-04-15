/*
 * Source: https://www.instructables.com/How-to-Interface-HX711-Balance-Module-With-Load-Ce/
 */

#include <stdint.h>

#define SCK (volatile uint8_t *)(0xFF200080)
#define DT (volatile uint8_t *)(0xFF200090)

/**
 * Checks if there is data available from the HX711 chip
 */
uint8_t hx711_is_ready();

/**
 * Sets the gain factor
 */
void hx711_set_gain(uint8_t gain);

/**
 * Waits for the HX711 chip to be ready and then returns a reading
 */
long hx711_read();

/**
 * Returns an average reading over how many "times"
 */
long hx711_read_average(uint8_t times);

/**
 * Returns the raw value offset by OFFSET
 */
double hx711_get_value(uint8_t times);

/**
 * Returns the scaled value of the weight based on calibration
 */
float hx711_get_units(uint8_t times);

/**
 * Sets the offset value, equivalent to "zeroing"
 */
void hx711_tare(uint8_t times);

/**
 * Sets the scale value based on calibration
 */
void hx711_set_scale(float scale);
