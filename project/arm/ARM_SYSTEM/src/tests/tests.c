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


/*
 * to be used in conjunction with bluetooth serial terminal app
 * sending any message that followed the protocol should be displayed correctly
 * by this test.
 * verify by inspection.
 */
void btTest(){
	for(;;){
		delay_us(10000);
		char readval[64];
		int res = readStringUsingProtocol(readval);
		printf("readval = %s", readval);
	}
}


/*
 * integration test.
 * results displayed on vga, verified by inspection
 */
void addToCart(){

	int *ec;
    initWiFi(115200);
    resetWiFi();

    enableUARTInterrupt(WiFi_InterruptEnableReg);

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

/*
 * integration test.
 * Results are displayed on vga and can be verified by inspection
 */
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
	char *test = "wifiItemRoutine";

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

     testInt(test, 105,bc.weight_g);
     testString(test, "604059000075",bc.barcode);
     testInt(test, 83,bc.node_id);

     testInt(test, 175,bc2.weight_g);
     testString(test, "628233883209",bc2.barcode);
     testInt(test, 87,bc2.node_id);


}

void wifiSectionsRoutine(){
	int *ec;
	char *test = "wifiSectionRoutine";


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

     testInt(test, 52,size);

     Section s1 = ss.sections[0];
     Section s2 = ss.sections[51];

     testInt(test, 319,s1.originX);
     testInt(test, 12,s1.sectionWidth);

     testInt(test, 132,s2.originX);
     testInt(test, 81,s2.sectionWidth);

}

void wifiLegendsRoutine(){
	int *ec;
	char *test = "wifiLegendsRoutine";


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

     testInt(test, 10, size);

     Legend l1 = ss.legends[0];
     Legend l2 = ss.legends[9];

     testInt(test, 15,l1.color);
     testString(test, "FROZEN FOOD", l1.key);

     testInt(test, 4,l2.color);
     testString(test, "UTENSILS AND CUTLERY", l2.key);
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

/*
 * verify by inspection
 */
void delayTest(){
	printf("statement 1\n");
	delay_us(10000);
	printf("statement 2\n");
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

int testInt(char* test, int expected, int actual){
	if(expected!=actual){
		printf("error in %s: expected %d, got %d", test, expected, actual);
		return 0;
	}

	return 1;
}

int testDouble(char* test, double expected, double actual){
	if(expected!=actual){
		printf("error in %s comparing doubles", test);
		return 0;
	}

	return 1;
}

int testString(char* test, char* expected, char* actual){
	if(strcmp(expected, actual) != 0){
		printf("error in %s: expected %s, got %s", test, expected, actual);
		return 0;
	}

	return 1;
}

