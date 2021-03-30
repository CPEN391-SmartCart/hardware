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
#include "string.h"

#include "objectFactory.h"

#define PATH_GOAL_SET (volatile unsigned int *)(0xFF200200)
#define PATH_START (volatile unsigned int *)(0xFF200100)
#define PATH_FINISHED (volatile unsigned int *)(0xFF200210)

#define NODE_0_31 (volatile unsigned int *)(0xFF200120)
#define NODE_32_63 (volatile unsigned int *)(0xFF200130)
#define NODE_64_95 (volatile unsigned int *)(0xFF200140)
#define NODE_96_127 (volatile unsigned int *)(0xFF200150)
#define NODE_128_159 (volatile unsigned int *)(0xFF200160)
#define NODE_160_191 (volatile unsigned int *)(0xFF200170)
#define NODE_192_223 (volatile unsigned int *)(0xFF200180)
#define NODE_224_255 (volatile unsigned int *)(0xFF200190)
#define NODE_256_287 (volatile unsigned int *)(0xFF200200)

#define SRAM (void *) (0xC8000000)

int main(void)
{
	int i;
	int j;
	char test[512];


//	hx711_set_gain(128);
//
//	hx711_tare(10);
//
//	while (TRUE)
//	{
//		printf("SCALED WEIGHT: %.6f\n", hx711_get_value(10) / 118.2432);
//	}

//	initBluetooth();
//
//	while (TRUE)
//	{
//		readStringBT(test);
//		printf("BT: %s\n", test);
//		delay_us(100000);
//	}

//	initWiFi(115200);
//	resetWiFi();
//
//	readStringTillSizeWIFI(test, 10000000);
//
//
//	printf("WIFI Message: %s\n", test);
//
//
//	writeStringWIFI("test;");
//
//	readStringTillSizeWIFI(test, 10000000);
//
//
//	printf("WIFI Message: %s\n", test);


    *PATH_GOAL_SET = 0;

    char* SRAM_COPY = SRAM;

//    short start_node[] = {
//            0x0050,
//            0x0030,
//            0x0017,
//            0x0000,
//            0x0000,
//            0x0023,
//            0x000A,
//            0x0013,
//            0x0002,
//            0x0000,
//            0x0000,
//            0x0000,
//            0x0000,
//            0x0000,
//            0x0000,
//            0x0000,
//            0x0000
//    };

    short start_node[] = {
            0x0010,
            0x0010,
            0x0013,
            0x0000,
            0x0000,
            0x0016,
            0x0004,
            0x0017,
            0x0002,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000
    };

    short goal_node[] = {
            0x0082,
            0x0043,
            0x0045,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000,
            0x0000
    };

    for (i = 0, j = 0; i < 17; i++)
    {
        memcpy(SRAM_COPY + j, &start_node[i], 2);
        j += 2;
    }

    for (i = 0, j = 0; i < 17; i++)
    {
        memcpy(SRAM_COPY + 34 + j, &goal_node[i], 2);
        j += 2;
    }

    *PATH_GOAL_SET = 1;

	//vga test
	int sectionSize = sizeof(sections) / sizeof(Section);
	int legendSize = sizeof(legends) / sizeof(Legend);
	int listSize = sizeof(shoppingList) / sizeof(Item);
//	int pathOneSize = sizeof(itemOnePath) / sizeof(PathVertex);
//	int pathTwoSize = sizeof(itemTwoPath) / sizeof(PathVertex);
//	int pathThreeSize = sizeof(itemThreePath) / sizeof(PathVertex);

	printf("Clearing screen...\n");
	Reset();

	printf("Creating store map...\n");
	CreateStoreMap(sectionSize, sections, legendSize, legends);
	CreateSidePanel(legendSize, legends);

//	UpdateBalance(10.15, 0.05);
//	LoadItemColors(listSize, shoppingList);
//
//	Item selectedItem;
//
//	int k = 0;
//	int updated = FALSE;

	// intial product
//	ShowItem(shoppingList[0]);
//	DrawItemPath(pathThreeSize, itemThreePath, pathOneSize, itemOnePath);
//
//	ShowNextItem(shoppingList[0].name);
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

