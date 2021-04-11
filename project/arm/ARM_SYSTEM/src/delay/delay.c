/*
 * delay.c
 *
 *  Created on: Feb 21, 2021
 *      Author: jared
 */

#include "delay.h"

void setup_hps_timer() {
	assert(ALT_E_SUCCESS == alt_globaltmr_init());
}

void delay_us(uint32_t us)
{
	uint64_t start_time = alt_globaltmr_get64();
	uint32_t timer_prescaler = alt_globaltmr_prescaler_get() + 1;
	uint64_t end_time;
	alt_freq_t timer_clock;

	assert(ALT_E_SUCCESS == alt_clk_freq_get(ALT_CLK_MPU_PERIPH, &timer_clock));
	end_time = start_time + us * ((timer_clock / timer_prescaler) / ALT_MICROSECS_IN_A_SEC);

	while(alt_globaltmr_get64() < end_time);
}

uint64_t getEndTimeFromCurr(uint32_t us){
	uint64_t start_time;
	start_time = alt_globaltmr_get64();
	uint32_t timer_prescaler = alt_globaltmr_prescaler_get() + 1;
	uint64_t end_time;
	alt_freq_t timer_clock;

	assert(ALT_E_SUCCESS == alt_clk_freq_get(ALT_CLK_MPU_PERIPH, &timer_clock));
	end_time = start_time + us * ((timer_clock / timer_prescaler) / ALT_MICROSECS_IN_A_SEC);

	return end_time;
}
