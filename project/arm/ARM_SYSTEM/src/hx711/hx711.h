
#include <stdint.h>

#define SCK (volatile uint8_t *)(0xFF200080)
#define DT (volatile uint8_t *)(0xFF200090)

uint8_t hx711_is_ready();

void hx711_set_gain(uint8_t gain);

long hx711_read();

long hx711_read_average(uint8_t times);

double hx711_get_value(uint8_t times);

float hx711_get_units(uint8_t times);

void hx711_tare(uint8_t times);

void hx711_set_scale(float scale);

float hx711_get_scale();

void hx711_set_offset(long offset);

long hx711_get_offset();

void hx711_power_down();

void hx711_power_up();
