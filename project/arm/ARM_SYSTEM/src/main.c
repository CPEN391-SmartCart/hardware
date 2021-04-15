
#include "bluetooth/bluetooth.h"
#include "wifi/wifi.h"
#include "common.h"
#include "stdio.h"
#include "wifi/wifi.h"
#include "uart/uart.h"
#include "delay/delay.h"
#include "hx711/hx711.h"
#include "string.h"
#include "pathfinding/dijsktra.h"
#include "vga/map.h"
#include "tests/tests.h"
#include "luaRequests/item_request.h"
#include "luaRequests/sections_request.h"
#include "luaRequests/legends_request.h"

#define GraphicsCommandReg              (*(volatile unsigned short int *)(0xFF210000))
#define GraphicsStatusReg               (*(volatile unsigned short int *)(0xFF210000))
#define GraphicsX1Reg                   (*(volatile unsigned short int *)(0xFF210002))
#define GraphicsY1Reg                   (*(volatile unsigned short int *)(0xFF210004))
#define GraphicsX2Reg                   (*(volatile unsigned short int *)(0xFF210006))
#define GraphicsY2Reg                   (*(volatile unsigned short int *)(0xFF210008))
#define GraphicsColourReg               (*(volatile unsigned short int *)(0xFF21000E))
#define GraphicsBackGroundColourReg     (*(volatile unsigned short int *)(0xFF210010))

#define DEBUG 0

#define BETWEEN(a, b, c)  (((a) >= (b)) && ((a) <= (c)))

char* lastRequestedDestinationBarcode;
Item lastScannedItem;
SectionArr ss;
Section *sections;
LegendArr l;
Legend *legends;
coord_t old_path[20];
int old_path_length;
int current_expected_weight = 0;

void loadMapData();
void handleBTMessage(char*code, char*data);
void initSystem();
void displayStoreMap();
double getWeight(double min, double max);
void handleBTMessageALTERNATIVE(char*code, char*data);

int goal_node_id;
int start_node_id;

int main(void)
{
	initSystem();
	loadMapData();

	hx711_set_scale(72.61);
	hx711_tare(20);
	printf("Scale calibration done!\n");
	
	displayStoreMap();

    if(DEBUG) printf("buffer * location in mem = 0x%p\n", (void *) BUFFER);

    char stringBT[1024];
    int times = 0;

    for(;;)
    {
		readStringUsingProtocol(stringBT);
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
    }

	return 0;
}


void handleBTMessage(char*code, char*data)
{

    int16_t XYZ[3];
	char scanCode[] = "sc";
	char itemCostCode[] = "ic";
	char pathPlanningCode[] = "pp";
	char startPlanningCode[] = "ps";
	char clearPlanningCode[] = "pc";
	char successfulPayment[] = "sp";
	char reset[] = "rs";
	char sendMessage[1024] = "";
	int *error_code; //see common.h for description of errors

	if(!strcmp(code,scanCode)){
		lastScannedItem = requestItem(data, error_code);

		if(*error_code != LUA_EXIT_SUCCESS){
			printf("could not find item \n");
			return;
		}

		char* itemName = lastScannedItem.name;
		char itemPrice[6];

		FloatToString(lastScannedItem.cost, itemPrice, 2, 0);
		int isByWeight = lastScannedItem.requires_weighing;
		if(isByWeight)
		{
			double weight = getWeight(current_expected_weight + 40, current_expected_weight + 1000);


			if(weight == -1){
			}
			else
			{
				weight -= current_expected_weight;
				double item_cost = (lastScannedItem.cost * weight) / 1000;
				lastScannedItem.cost = item_cost;
				FloatToString(item_cost, itemPrice, 2, 0);

				strcat(sendMessage, itemName);
				strcat(sendMessage, " | ");
				strcat(sendMessage, itemPrice);

				printf("WriteBT: %s\n", sendMessage);

				writeStringBT(sendMessage);

				char weight_str[30];
				FloatToString(weight / 1000, weight_str, 2, 0);
				strcat(weight_str, " kg");
				ShowItemWeight(weight_str);
				current_expected_weight += weight;
			}
		}
		else
		{
			//theft protection
			delay_us(10 * 1000 * 1000);
			current_expected_weight += lastScannedItem.weight_g;

			int times = 0;

			for (int i = 0; i < 10; i++)
			{
				double current_weight = hx711_get_units(10);
				ADXL345_XYZ_read(XYZ);
				if (XYZ[2]*4 < 2000) //change in Z is less than 2000
				{
					if (current_weight < current_expected_weight - 200 || current_weight > current_expected_weight + 200)
					{
						times++;
						if (times >= 6)
						{
							//ALERTS STORE
							printf("STEALING!\n");
						}
					}
					else
					{
						times = 0;
					}
				}
			}

			strcat(sendMessage, itemName);
			strcat(sendMessage, " | ");
			strcat(sendMessage, itemPrice);
			writeStringBT(sendMessage);
		}
	}

	if(!strcmp(code,itemCostCode)){
		AddItemToCart(lastScannedItem);

		writeStringBT("acked");
	}

	if(!strcmp(code,pathPlanningCode)){
		Item next_item = requestItem(data, error_code);

		coord_t new_path[20];
		int new_path_length = generate_path(lastScannedItem.node_id, next_item.node_id, new_path);


		DrawItemPath(old_path_length, old_path, new_path_length, new_path, 0);
		ShowNextItem(next_item.name);

		for (int i = 0; i < new_path_length; i++)
		{
			old_path[i] = new_path[i];
		}

		old_path_length = new_path_length;
	}

	if (!strcmp(code, startPlanningCode))
	{
		int node_id = 42;

		if (lastScannedItem.node_id != 0)
		{
			node_id = lastScannedItem.node_id;
		}

		Item next_item = requestItem(data, error_code);

		coord_t new_path[20];
		int new_path_length = generate_path(node_id, next_item.node_id, new_path);


		coord_t old_path_start[1];
		DrawItemPath(0, old_path_start, new_path_length, new_path, 0);
		ShowNextItem(next_item.name);

		for (int i = 0; i < new_path_length; i++)
		{
			old_path[i] = new_path[i];
		}

		old_path_length = new_path_length;
	}

	if (!strcmp(code, clearPlanningCode))
	{
		coord_t new_path_clear[1];
		DrawItemPath(old_path_length, old_path, 0, new_path_clear, 0);
		ShowNextItem("");
	}

	if(!strcmp(code,successfulPayment)){
		//theft protection
		current_expected_weight += lastScannedItem.weight_g;

		int times = 0;

		for (int i = 0; i < 10; i++)
		{
			double current_weight = hx711_get_units(10);
			ADXL345_XYZ_read(XYZ);
			if (XYZ[2]*4 < 2000) //change in Z is less than 2000
			{
				if (current_weight < current_expected_weight - 200 || current_weight > current_expected_weight + 200)
				{
					times++;
					if (times >= 6)
					{
						//ALERTS STORE
						printf("STEALING!\n");
					}
				}
				else
				{
					times = 0;
				}
			}
		}

		DisplayPaymentConfirmation();
	}

	if(!strcmp(code,reset)){
		displayStoreMap();

		writeStringBT("resetdone");
	}
}

void initSystem()
{
	initBluetooth();

    initWiFi(115200);
    resetWiFi();

    //needs to be after wifi reset
    enableUARTInterrupt(WiFi_InterruptEnableReg);


    printf("Bluetooth, Wifi initialized\n");


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
}

void loadMapData(){
	int *error_code; //see common.h for description of errors

	ss = requestSections(1, error_code);
	sections = ss.sections;

	l = requestLegends(1, error_code);
	legends = l.legends;
}

void displayStoreMap()
{
	int sectionSize = ss.size;
	int legendSize = l.size;

    if(DEBUG){
        printf("   x      y    height width colour\n");
        for(int i = 0; i < sectionSize; i++){
            printf("%5d %5d %5d %5d %5d \n", sections[i].originX, sections[i].originY, sections[i].sectionWidth, sections[i].sectionHeight, sections[i].aisleColor);
        }
    }

	printf("Creating store map...\n");
	SetupMap(sectionSize, sections, legendSize, legends);
}

/*
 * returns the weight in grams, a return value of -1 means that no weight above the tolerance level was found
 */
double getWeight(double min, double max){
	int retVal = -1;
	double weight = -1;

	DisplayWeighCommand(0);
	delay_us(5 * 1000 * 1000);

	for(unsigned int i = 0; i < 1; i++){

		//1-2 seconds between attempts to read weight
		for(unsigned int j = 0; j<1; j++) {
			weight = hx711_get_units(10);
			if(BETWEEN(weight, min, max)){
				delay_us(1 * 1000 * 1000);
				weight = hx711_get_units(10);
				break;
			}
		}

		if(!BETWEEN(weight, min, max)){
			delay_us(2000000);
		} else {
			break;
		}
	}

	if(BETWEEN(weight, min, max)){
		printf("weight found, final calculated weight is %d\n", weight);
		retVal = weight;
	} else {
		DisplayWeighCommand(1);
		printf("weight could not be determined, Expected something between %d and %d, but final calculated weight was %d\n", min, max, weight);
	}
	return retVal;
}
