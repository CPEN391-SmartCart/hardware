
#include "../delay/delay.h"
#include "../wifi/wifi.h"
#include <string.h>
#include <stdlib.h>

#include "item_request.h"

static Item getItemFromResponse(char *read){
	struct Item item;

	if(!read){
		strcpy(item.barcode, "DEADBEEF");
		item.cost = 0;
		strcpy(item.name, "DEADBEEF");
		item.section_id = 0;
		return item;
	}

	item.barcode = strtok(read, "|");
	item.section_id = atoi(strtok(NULL, "|"));
	item.name = strtok(NULL, "|");
	item.cost = atof(strtok(NULL, "|"));
	item.description = strtok(NULL, "|");
	item.requires_weighing = strtok(NULL, "|");
	item.x = atoi(strtok(NULL, "|"));
	item.y = atoi(strtok(NULL, "|"));
	item.aisleColor = 0;

	char* end = strtok(NULL, "|");

	if(end){
		printf("\nERROR parsing response: no end found. \n");
	}
	return item;
}

Item requestItem(char *barcode){
	char command[50];
	sprintf(command, BARCODE_SCRIPT_CMD_FORMAT, barcode);

	if(!command){
		printf("\nfailed to allocate space for item request\n");
		struct Item item;
		strcpy(item.barcode, "DEADBEEF");
		item.cost = 0;
		strcpy(item.name, "DEADBEEF");
		item.section_id = 0;
		return item;
	}

	char response[500];

	int status = writeAndReadResponse(BARCODE_SCRIPT_CMD_FORMAT, response);

	if(status != 0){
		printf("\n ERROR: Lua Script returned EXIT%c \n", status);
	}

	return getItemFromResponse(response);
}
