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

void btTest(){
	for(;;){
		delay_us(10000);
		char readval[64];
		int res = readStringUsingProtocol(readval);
		printf("readval = %s", readval);
	}
}


void delayTest(){
	printf("statement 1\n");
	delay_us(1000);
	printf("statement 2\n");
}

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
		"604059000075",
		"628233883209",
		"064200160001",
		"065302000271",
		"NTSN6378",
		"065333001100",
		"667888310661",
		"628233229540",
		"068100058925",
		"068400662709",
		"068100895971"
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

void wifiItemRoutine(){
	int *ec;

     initWiFi(115200);
     resetWiFi();

     printf("hi\n");
     enableUARTInterrupt(WiFi_InterruptEnableReg);

     printf("\n 2setup interrupt complete \n");
     printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

     delay_us(100000);

     Item bc = requestItem("604059000075", ec);
     Item bc2 = requestItem("628233883209", ec);


     printf(" barcode barcode,name,sectionid = %s, name = %s, section = %d\n", bc.barcode, bc.name, bc.section_id);
     printf(" barcode2 barcode,name,sectionid = %s, name = %s, section = %d", bc2.barcode, bc2.name, bc2.section_id);

}

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


     NodeInfo i1 = requestNodeInfo("604059000075");
     NodeInfo i2 = requestNodeInfo("628233883209");


     printf("node info 1:\n");
     for(int i = 0; i < NODE_INFO_ARRAY_SIZE; i++){
    	 printf("%d\n", i1.nodeInfo[i]);
     }

     printf("\nnode info 2:\n");

     for(int i = 0; i < NODE_INFO_ARRAY_SIZE; i++){
    	 printf("%d\n", i2.nodeInfo[i]);
     }
}


void pathfindingTestNodeToNode()
{
    int start_node_id = 0;
    int goal_node_id = 82; //last node ID that isn't an item

    coord_t path[100];
    int path_length = generate_path(start_node_id, goal_node_id, path);

    for (int i = 0; i < path_length; i++)
    {
        printf("X: %d, Y: %d\n", path[i].x, path[i].y);
    }

    printf("DONE!\n");
}

void pathfindingTestNodeToItem()
{
    int start_node_id = 0;
    int goal_node_id = 83; //first node ID that is an item

    coord_t path[100];
    int path_length = generate_path(start_node_id, goal_node_id, path);

    for (int i = 0; i < path_length; i++)
    {
        printf("X: %d, Y: %d\n", path[i].x, path[i].y);
    }

    printf("DONE!\n");
}

void pathfindingTestItemToItem()
{
    int start_node_id = 83; //first node ID that is an item
    int goal_node_id = 96; //last node ID that is an item

    coord_t path[100];
    int path_length = generate_path(start_node_id, goal_node_id, path);

    for (int i = 0; i < path_length; i++)
    {
        printf("X: %d, Y: %d\n", path[i].x, path[i].y);
    }

    printf("DONE!\n");
}


void weightScaleTestSpaghetti(void)
{
    hx711_set_scale(72.61); //precalibrated scale
    hx711_tare(20); //zeroing
    printf("Scale calibration done!\n");

    printf("Place spaghetti on scale\n");

    int i = 0;
    while (i < 10)
    {
        char weight[20];
        FloatToString(hx711_get_units(10), weight, 2, 0);
        i++;
    }
}

void weightScaleTestTuna(void)
{
    hx711_set_scale(72.61); //precalibrated scale
    hx711_tare(20); //zeroing
    printf("Scale calibration done!\n");

    printf("Place tuna on scale\n");

    int i = 0;
    while (i < 10)
    {
        char weight[20];
        FloatToString(hx711_get_units(10), weight, 2, 0);
        i++;
    }
}

void weightScaleTestOnion(void)
{
    hx711_set_scale(72.61); //precalibrated scale
    hx711_tare(20); //zeroing
    printf("Scale calibration done!\n");

    printf("Place onion on scale\n");

    int i = 0;
    while (i < 10)
    {
        char weight[20];
        FloatToString(hx711_get_units(10), weight, 2, 0);
        i++;
    }
}

void weightScaleTestCocoa(void)
{
    hx711_set_scale(72.61); //precalibrated scale
    hx711_tare(20); //zeroing
    printf("Scale calibration done!\n");

    printf("Place cocoa on scale\n");

    int i = 0;
    while (i < 10)
    {
        char weight[20];
        FloatToString(hx711_get_units(10), weight, 2, 0);
        i++;
    }
}

void imuTestX(void)
{
    uint8_t devid;

    pinmux_config();
    I2C0_init();
    ADXL345_REG_READ(0x00, &devid);

    if (devid == 0xE5)
    {
        ADXL345_init();
    }
    else
    {
        printf("Incorrect device ID!!\n");
    }


    int16_t XYZ[3];
    ADXL345_XYZ_read(XYZ);

    int i = 0;
    while (i < 50)
    {
        printf("change in X: %d", XYZ[0] * 4);
        i++;
    }
}

void imuTestY(void)
{
    uint8_t devid;

    pinmux_config();
    I2C0_init();
    ADXL345_REG_READ(0x00, &devid);

    if (devid == 0xE5)
    {
        ADXL345_init();
    }
    else
    {
        printf("Incorrect device ID!!\n");
    }


    int16_t XYZ[3];
    ADXL345_XYZ_read(XYZ);

    int i = 0;
    while (i < 50)
    {
        printf("change in Y: %d", XYZ[1] * 4);
        i++;
    }
}

void imuTestZ(void)
{
    uint8_t devid;

    pinmux_config();
    I2C0_init();
    ADXL345_REG_READ(0x00, &devid);

    if (devid == 0xE5)
    {
        ADXL345_init();
    }
    else
    {
        printf("Incorrect device ID!!\n");
    }


    int16_t XYZ[3];
    ADXL345_XYZ_read(XYZ);

    int i = 0;
    while (i < 50)
    {
        printf("change in Z: %d", XYZ[2] * 4);
        i++;
    }
}