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
#include "luaRequests/sections_request.h"
#include "luaRequests/legends_request.h"
#include "hx711/hx711.h"
#include "vga/map.h"

void wifiSectionsRoutine();
void wifiRoutine();
void wifiLegendsRoutine();
void vgaRoutine();

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

	vgaRoutine();

	return 0;
}


void vgaRoutine(){

    initWiFi(115200);
    resetWiFi();

    printf("hi\n");
    enableUARTInterrupt(WiFi_InterruptEnableReg);

    printf("\n 2setup interrupt complete \n");
    printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

    delay_us(100000);

    SectionArr ss = requestSections(1);
    Section *sections = ss.sections;

    LegendArr l = requestLegends(1);
    Legend *legends = l.legends;

	int sectionSize = ss.size;
	int legendSize = l.size;

	printf("Clearing screen...\n");
	Reset();

	printf("Creating store map...\n");
	CreateStoreMap(sectionSize, sections, legendSize, legends);
	CreateSidePanel(legendSize, legends);

}
//working
void wifiRoutine(){
     initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);

     Item bc = requestItem("XGAO9797");
     Item bc2 = requestItem("THEY8635");


     printf(" barcode = %s, name = %s, section = %d\n", bc.barcode, bc.name, bc.section_id);
     printf(" barcode2 = %s, name = %s, section = %d", bc2.barcode, bc2.name, bc2.section_id);

}

//working
void wifiSectionsRoutine(){
     initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);

     SectionArr ss = requestSections(1);

     int size = ss.size;
     Section *s = ss.sections;

     printf("   x      y    height width colour\n");
     for(int i = 0; i < size; i++){
         printf("%5d %5d %5d %5d %5d \n", s[i].originX, s[i].originY, s[i].sectionHeight, s[i].sectionWidth, s[i].aisleColor);
     }
}

void wifiLegendsRoutine(){
     initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);

     LegendArr ss = requestLegends(1);

     int size = ss.size;
     Legend *s = ss.legends;

     for(int i = 0; i < size; i++){
         printf("%s %5d \n", s[i].key, s[i].color);
     }
}
