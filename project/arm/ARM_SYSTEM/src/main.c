
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


char* lastRequestedDestinationBarcode;
Item lastScannedItem;

void handleBTMessage(char*code, char*data);
void initSystem();
void displayStoreMap();



int main(void)
{
	initSystem();
	displayStoreMap();

    char stringBT[1024];

    for(;;)
    {
    	//writeStringBT("Hi3!");
    	readStringBT(stringBT);
    	char* stringTok = stringBT;
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
	if(!strcmp(code,scanCode)){

		lastScannedItem = requestItem(data);
		char* itemName = lastScannedItem.name;
		char itemPrice[6];
		sprintf(itemPrice, "%d",lastScannedItem.cost);
		int isByWeight = lastScannedItem.requires_weighing;
		if(isByWeight)
		{
			char itemMessage[16] = "in:";
			strcat(itemMessage,itemName);

			char priceMessage[16] = "pw:";
			strcat(priceMessage,itemPrice);

			printf("WriteBT: %s\n", itemMessage);
			writeStringBT(itemMessage);
			printf("WriteBT: %s\n", priceMessage);
			writeStringBT(priceMessage);

			// TODO: call a function to get the scale weight
			for(unsigned int i = 0;i<100;i++)
			{
				delay_us(10000);

				char* weightInGrams = "5500"; // weight in grams
				char weightMessage[16] = "sw:";
				strcat(weightMessage, weightInGrams);

				writeStringBT(weightMessage);
			}
		}
		else
		{
			char itemMessage[16] = "in:";
			strcat(itemMessage,itemName);
			writeStringBT(itemMessage);

			char priceMessage[16] = "pq:";
			strcat(priceMessage,itemPrice);

			writeStringBT(priceMessage);
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


}

void initSystem()
{
	initBluetooth();

    initWiFi(115200);
    resetWiFi();

    printf("Bluetooth, Wifi initialized");
}

void displayStoreMap()
{
    SectionArr ss = requestSections(1);
    Section *sections = ss.sections;

    LegendArr l = requestLegends(1);
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
