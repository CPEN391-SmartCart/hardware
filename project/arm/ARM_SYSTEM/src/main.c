
#include "bluetooth/bluetooth.h"
#include "wifi/wifi.h"
#include "common.h"
#include "stdio.h"

#include "wifi/wifi.h"
#include "uart/uart.h"

#include "delay/delay.h"

#include "hx711/hx711.h"
#include "string.h"

#include "objectFactory.h"
#include "tests/tests.h"
#include "luaRequests/item_request.h"
#include "luaRequests/sections_request.h"
#include "luaRequests/legends_request.h"

#define PATH_GOAL_SET (volatile unsigned int *)(0xFF200200)
#define PATH_FINISHED (volatile unsigned int *)(0xFF200210)
#define ACTUAL_COORD (volatile unsigned int *)(0xFF200240)
#define GAVE_COORD (volatile unsigned int *)(0xFF20220)
#define RECEIVED_COORD (volatile unsigned int *)(0xFF200230)

#define GraphicsCommandReg              (*(volatile unsigned short int *)(0xFF210000))
#define GraphicsStatusReg               (*(volatile unsigned short int *)(0xFF210000))
#define GraphicsX1Reg                   (*(volatile unsigned short int *)(0xFF210002))
#define GraphicsY1Reg                   (*(volatile unsigned short int *)(0xFF210004))
#define GraphicsX2Reg                   (*(volatile unsigned short int *)(0xFF210006))
#define GraphicsY2Reg                   (*(volatile unsigned short int *)(0xFF210008))
#define GraphicsColourReg               (*(volatile unsigned short int *)(0xFF21000E))
#define GraphicsBackGroundColourReg     (*(volatile unsigned short int *)(0xFF210010))

#define PATH_LENGTH	(volatile unsigned short int *)(0xFF210100)
#define PATH_START	(volatile unsigned short int *)(0xFF210102)

#define PATH_WRITE (volatile unsigned short int *)(0xFF210398)
#define PATH_WRITE_START (volatile unsigned short int *)(0xFF210400)

#define SRAM (void *) (0xC8000000)

#define DEBUG 0

#define BETWEEN(a, b, c)  (((a) >= (b)) && ((a) <= (c)))

char* lastRequestedDestinationBarcode;
Item lastScannedItem;

void handleBTMessage(char*code, char*data);
void initSystem();
void displayStoreMap();
int getWeight();


int main(void)
{
	initSystem();
	displayStoreMap();

    if(DEBUG) printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

    char stringBT[1024];

    for(;;)
    {
    	//writeStringBT("Hi3!");
    	readStringBT(stringBT);
    	char stringTok[1024];
    	strcpy(stringTok,stringBT);
    	if(stringTok[0]!='\0'){
    		printf ("original: %s\n",stringTok);
    		char* code = strtok (stringTok,":");
    		char* data;
    		if (code != NULL)
    		{
    		  printf ("code: %s\n",code);
    		  data = strtok (NULL,":");
    		  if(data!=NULL){
    			  printf ("data: %s\n",data);
    			  handleBTMessage(code, data);
    		  }
    		}
    	}

    	delay_us(10000);
    }

	return 0;
}

void handleBTMessage(char*code, char*data)
{
	char scanCode[] = "sc";
	char itemCostCode[] = "ic";
	char pathPlanningCode[] = "pp";
	char sendMessage[1024] = "in:";
	//TODO setup payment confirmation code
	char paymentConfirmationCode[] = "pc:";

	int absolute_weight_min = 10;
	double relative_weight_tolerance = 0.1;

	int *request_error_code; //see error code descriptions in common.h


	if(!strcmp(code,scanCode)){

		//Temporarily here to test around barcode data bug
		lastScannedItem = requestItem("NTSN6378", request_error_code);

		if(request_error_code != LUA_EXIT_SUCCESS){
			//todo : handle retrieivng item error
		}

//		lastScannedItem = requestItem(data);
		char* itemName = lastScannedItem.name;
		char itemPrice[6];

		FloatToCostString(lastScannedItem.cost, itemPrice, 2);
		int isByWeight = lastScannedItem.requires_weighing;

		if(isByWeight)
		{

			//uncomment when loadcell available
			//int weight = getWeight(absolute_weight_min, 1000000);
			int weight = 200;

			if(weight == -1){
				//TODO: handle weight could not be calculated
			}

			strcat(sendMessage, itemName);
			strcat(sendMessage, " | pw:");
			strcat(sendMessage, itemPrice);
			strcat(sendMessage, " | sw:");
			char weightString[8];
			sprintf(weightString, "%d", weight);
			strcat(sendMessage, weightString);

			printf("WriteBT: %s\n", sendMessage);

			writeStringBT(sendMessage);
		}
		else
		{

			int expected_weight = lastScannedItem.weight_g;
			int weight_min = expected_weight - (int) (expected_weight * relative_weight_tolerance);
			int weight_max = expected_weight + (int) (expected_weight * relative_weight_tolerance);

			//uncomment when loadcell available
			//int weight = getWeight(weight_min, weight_max);
			int weight = 200;

			if(weight == -1){
				//TODO: handle weight could not be calculated
			}

			strcat(sendMessage, itemName);
			strcat(sendMessage, " | pq:");
			strcat(sendMessage, itemPrice);
			printf("WriteBT: %s\n", sendMessage);
			writeStringBT(sendMessage);
		}

		// TODO: Path plan with the barcodes
		// pathPlan(lastScannedBarcode,lastRequestedDestinationBarcode);
	}

	if(!strcmp(code,itemCostCode)){
		AddItemToCart(lastScannedItem);
	}

	if(!strcmp(code,pathPlanningCode)){
		lastRequestedDestinationBarcode = data;
		// TODO: Path plan with the barcodes
		// pathPlan(lastScannedBarcode,lastRequestedDestinationBarcode);
	}

	if(!strcmp(code,paymentConfirmationCode)){
		DisplayPaymentConfirmation();
	}


}

/*
 * returns the weight in grams, a return value of -1 means that no weight above the tolerance level was found
 */
int getWeight(double min, double max){
	int retVal = -1;
	int weight = -1;

	DisplayWeighCommand(0);
	delay_us(5000000);

	for(unsigned int i = 0; i < 5; i++){
		DisplayWeighCommand(0);
		delay_us(2000000);

		//0.1 seconds between attempts to read weight
		for(unsigned int j = 0; j<100; i++) {
			delay_us(100000);
			weight = hx711_read_average(5000);
			if(BETWEEN(weight, min, max)){
				break;
			}
		}

		if(BETWEEN(weight, min, max)){
			DisplayWeighCommand(1);
			delay_us(2000000);
		} else {
			break;
		}
	}

	if(BETWEEN(weight, min, max)){
		printf("weight found, final calculated weight is %d\n", weight);
		retVal = weight;
	} else {
		printf("weight could not be determined, Expected something between %d and %d, but final calculated weight was %d\n", min, max, weight);
		weight = -1;
	}
	return retVal;
}

void initSystem()
{
	initBluetooth();

    initWiFi(115200);
    resetWiFi();

    //needs to be after wifi reset
    enableUARTInterrupt(WiFi_InterruptEnableReg);


    printf("Bluetooth, Wifi initialized\n");
}

void displayStoreMap()
{
	int *request_ec;
    SectionArr ss = requestSections(1, request_ec);
    Section *sections = ss.sections;

    LegendArr l = requestLegends(1, request_ec);
    Legend *legends = l.legends;

	int sectionSize = ss.size;
	int legendSize = l.size;


    if(DEBUG){
        printf("   x      y    height width colour\n");
        for(int i = 0; i < sectionSize; i++){
            printf("%5d %5d %5d %5d %5d \n", sections[i].originX, sections[i].originY, sections[i].sectionWidth, sections[i].sectionHeight, sections[i].aisleColor);
        }
    }


	printf("Clearing screen...\n");
	Reset();

	printf("Creating store map...\n");
	CreateStoreMap(sectionSize, sections, legendSize, legends);
	CreateSidePanel(legendSize, legends);

}
