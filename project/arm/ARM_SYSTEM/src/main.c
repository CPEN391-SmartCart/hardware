/*
 * main.c
 *
 *  Created on: Feb 21, 2021
 *      Author: jared
 */

#include "bluetooth/bluetooth.h"
#include "wifi/wifi.h"
#include "common.h"
#include "stdio.h"
#include "stdlib.h"
#include "wifi/wifi.h"
#include "uart/uart.h"
#include "luaRequests/item_request.h"
#include "delay/delay.h"

#include "hx711/hx711.h"

int main(void)
{
//	hx711_set_gain(128);
//
//	hx711_tare(10);
//
//
//	while (TRUE)
//	{
//		printf("TEST: %f\n", hx711_get_value(1));
//	}

	int i;
	int j;
	char test[256];

	initBluetooth();

	while (TRUE)
	{
		writeStringBT("HI!\n");
	}

	return 0;
}

void wifiRoutine(){
    initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);

     Item bc = requestItem("XCQOSAOA");

     printf(" barcode = %s, name = %s, section = %d", bc.barcode, bc.name, bc.section_id);
}

