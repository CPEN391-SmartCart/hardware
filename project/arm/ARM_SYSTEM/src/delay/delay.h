/*
 * delay.h
 *
 *  Created on: Feb 21, 2021
 *      Author: jared
 */

#ifndef DELAY_H_
#define DELAY_H_

#include "assert.h"
#include "alt_clock_manager.h"
#include "alt_globaltmr.h"
#include <stdint.h>

/**
 * Delays/sleeps the CPU by "us" microseconds
 */
void delay_us(uint32_t us);

/**
 * Sets up the hps timer
 */
void setup_hps_timer(void);

/**
 * Returns the endtime from the current delay
 */
uint64_t getEndTimeFromCurr(uint32_t us);

#endif /* DELAY_H_ */
