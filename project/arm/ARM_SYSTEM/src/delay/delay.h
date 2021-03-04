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

void delay_us(uint32_t us);
void setup_hps_timer(void);

#endif /* DELAY_H_ */
