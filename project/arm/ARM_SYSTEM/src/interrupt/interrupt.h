

#ifndef INTERRUPT_INTERRUPT_H_
#define INTERRUPT_INTERRUPT_H_

#include  <stdio.h>
#include  "hwlib.h"
#include  "socal/socal.h"
#include  "socal/hps.h"
#include  "alt_interrupt.h"
#include "alt_int_device.h"


extern ALT_INT_INTERRUPT_t WIFI_INTERRUPT;

/**
 * Sets up an interrupt to be triggered
 */
ALT_STATUS_CODE setup_interrupt(ALT_INT_INTERRUPT_t interrupt_id, alt_int_callback_t callback, void *callback_arg );

/**
 * Sets up an interrupt based on our DE1-SoC
 */
ALT_STATUS_CODE socfpga_int_setup (ALT_INT_INTERRUPT_t int_id, ALT_INT_TRIGGER_t trigger);

/**
 * Called when the wifi isr is triggered
 */
void  wifi_isr_callback ( uint32_t icciar, void * context) ;

/**
 * Disables the specified interrupt
 */
int disableInterrupt(ALT_INT_INTERRUPT_t int_id);

/**
 * Enables the specified interrupt
 */
int enableInterrupt(ALT_INT_INTERRUPT_t int_id);



#endif /* INTERRUPT_INTERRUPT_H_ */
