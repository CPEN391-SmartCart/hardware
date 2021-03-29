/*
 * interrupt.c
 *
 *  Created on: Feb 28, 2021
 *      Author: Amr
 */


#include  <stdio.h>
#include  "alt_interrupt.h"
#include  "hwlib.h"
#include  "socal/socal.h"
#include  "socal/hps.h"
#include  "../delay/delay.h"
#include "../wifi/wifi.h"
#include "../uart/uart.h"
#include "interrupt.h"
#include <string.h>

ALT_INT_INTERRUPT_t WIFI_INTERRUPT = ALT_INT_INTERRUPT_F2S_FPGA_IRQ2;


ALT_STATUS_CODE socfpga_int_setup (ALT_INT_INTERRUPT_t int_id, ALT_INT_TRIGGER_t trigger)
 {
    ALT_STATUS_CODE status = ALT_E_SUCCESS;

    printf ( "INFO: Setting up V-sync interrupt. \n" );

    // Initialize global interrupts
    status = alt_int_global_init ();
    // Initialize CPU interrupts
    status = alt_int_cpu_init ();
    // Set interrupt distributor target
    int target = 0x3 ;
    status = alt_int_dist_target_set (int_id, target);
    // Set interrupt trigger type
    status = alt_int_dist_trigger_set (int_id, trigger);
    // Enable interrupt at the distributor level
    status = alt_int_dist_enable (int_id);
    // Enable CPU interrupts
    status = alt_int_cpu_enable ();
    // Enable global interrupts
    status = alt_int_global_enable ();

    return status;
}

ALT_STATUS_CODE setup_interrupt(ALT_INT_INTERRUPT_t interrupt_id, alt_int_callback_t callback, void *callback_arg )
 {
    ALT_STATUS_CODE status = ALT_E_SUCCESS;

    printf ( "INFO: System Initialization. \n" );

    // Setup Interrupt
    status = socfpga_int_setup (interrupt_id, ALT_INT_TRIGGER_EDGE);
    status = alt_int_isr_register (interrupt_id, callback, (void *) callback_arg );

  return status;
}

int enableInterrupt(ALT_INT_INTERRUPT_t int_id){
   int status = alt_int_dist_enable (int_id);
   return status;
}

int disableInterrupt(ALT_INT_INTERRUPT_t int_id){
   int status = alt_int_dist_disable (int_id);
   return status;
}

