

#ifndef INTERRUPT_INTERRUPT_H_
#define INTERRUPT_INTERRUPT_H_

#include  <stdio.h>
#include  "hwlib.h"
#include  "socal/socal.h"
#include  "socal/hps.h"
#include  "alt_interrupt.h"
#include "alt_int_device.h"


extern ALT_INT_INTERRUPT_t WIFI_INTERRUPT;

ALT_STATUS_CODE setup_interrupt(ALT_INT_INTERRUPT_t interrupt_id, alt_int_callback_t callback, void *callback_arg );
ALT_STATUS_CODE socfpga_int_setup (ALT_INT_INTERRUPT_t int_id, ALT_INT_TRIGGER_t trigger);
void  wifi_isr_callback ( uint32_t icciar, void * context) ;
int disableInterrupt(ALT_INT_INTERRUPT_t int_id);
int enableInterrupt(ALT_INT_INTERRUPT_t int_id);



#endif /* INTERRUPT_INTERRUPT_H_ */
