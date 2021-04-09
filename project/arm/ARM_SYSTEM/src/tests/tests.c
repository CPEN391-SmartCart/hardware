#include "../bluetooth/bluetooth.h"
#include "../wifi/wifi.h"
#include "../common.h"
#include "stdio.h"
#include "stdlib.h"
#include "../wifi/wifi.h"
#include "../uart/uart.h"
#include "../luaRequests/item_request.h"
#include "../delay/delay.h"
#include "../luaRequests/sections_request.h"
#include "../luaRequests/legends_request.h"
#include "../luaRequests/node_info_request.h"
#include "../hx711/hx711.h"
#include "../vga/map.h"
#include "tests.h"
#include "../hx711/hx711.h"


void addToCart(){

	int *ec;
    initWiFi(115200);
    resetWiFi();

    printf("hi\n");
    enableUARTInterrupt(WiFi_InterruptEnableReg);

    printf("\n 2setup interrupt complete \n");
    printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

    delay_us(100000);


	char *barcodes[] = {
		"XEAQ5424",
		"XGAO9797",
		"SCEU6683",
		"THEY8635",
		"NTSN6378",
		"GNLK7691",
		"ZTZZ2398",
		"CXKC2105",
		"SNBN0794",
		"RCJJ7746",
		"WBPG8611"
	};

	Item start_item = requestItem(barcodes[0],ec );
	Item goal_item = requestItem(barcodes[1], ec);

	short *start_node = requestNodeInfo(barcodes[0]).nodeInfo;
	short *goal_node = requestNodeInfo(barcodes[1]).nodeInfo;


	//draw vga stuff
    SectionArr ss = requestSections(1, ec);
    Section *sections = ss.sections;

    LegendArr l = requestLegends(1, ec);
    Legend *legends = l.legends;

	int sectionSize = ss.size;
	int legendSize = l.size;

	printf("Clearing screen...\n");
	Reset();

	CreateStoreMap(sectionSize, sections, legendSize, legends);
	CreateSidePanel(legendSize, legends);

	AddItemToCart(start_item);
	AddItemToCart(goal_item);

}


void vgaRoutine(){
	int *ec;

    initWiFi(115200);
    resetWiFi();

    printf("hi\n");
    enableUARTInterrupt(WiFi_InterruptEnableReg);

    printf("\n 2setup interrupt complete \n");
    printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

    delay_us(100000);

    SectionArr ss = requestSections(1, ec);
    Section *sections = ss.sections;

    LegendArr l = requestLegends(1, ec);
    Legend *legends = l.legends;

	int sectionSize = ss.size;
	int legendSize = l.size;

    printf("   x      y    height width colour\n");
    for(int i = 0; i < sectionSize; i++){
        printf("%5d %5d %5d %5d %5d \n", sections[i].originX, sections[i].originY, sections[i].sectionWidth, sections[i].sectionHeight, sections[i].aisleColor);
    }

	printf("Clearing screen...\n");
	Reset();

	printf("Creating store map...\n");
	CreateStoreMap(sectionSize, sections, legendSize, legends);
	CreateSidePanel(legendSize, legends);

	printf("check screen...\n");

}
//working
void wifiItemRoutine(){
	int *ec;

     initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);

     Item bc = requestItem("XGAO9797", ec);
     Item bc2 = requestItem("THEY8635", ec);


     printf(" barcode barcode,name,sectionid = %s, name = %s, section = %d\n", bc.barcode, bc.name, bc.section_id);
     printf(" barcode2 barcode,name,sectionid = %s, name = %s, section = %d", bc2.barcode, bc2.name, bc2.section_id);

}

//working
void wifiSectionsRoutine(){
	int *ec;

     initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);

     SectionArr ss = requestSections(1, ec);

     int size = ss.size;
     Section *s = ss.sections;

     printf("   x      y    height width colour\n");
     for(int i = 0; i < size; i++){
         printf("%5d %5d %5d %5d %5d \n", s[i].originX, s[i].originY, s[i].sectionHeight, s[i].sectionWidth, s[i].aisleColor);
     }
}

//working
void wifiLegendsRoutine(){
	int *ec;

     initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);

     LegendArr ss = requestLegends(1, ec);

     int size = ss.size;
     Legend *s = ss.legends;

     for(int i = 0; i < size; i++){
         printf("%s %5d \n", s[i].key, s[i].color);
     }
}

void wifiNodeInfoRoutine(){
	int *ec;

     initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);


     NodeInfo i1 = requestNodeInfo("XEAQ5424");
     NodeInfo i2 = requestNodeInfo("ZTZZ2398");


     printf("node info 1:\n");
     for(int i = 0; i < NODE_INFO_ARRAY_SIZE; i++){
    	 printf("%d\n", i1.nodeInfo[i]);
     }

     printf("\nnode info 2:\n");

     for(int i = 0; i < NODE_INFO_ARRAY_SIZE; i++){
    	 printf("%d\n", i2.nodeInfo[i]);
     }
}
