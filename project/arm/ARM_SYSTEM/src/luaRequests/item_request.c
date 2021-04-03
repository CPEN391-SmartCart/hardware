
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

	strncpy(item.barcode, strtok(read, "|"), MAX_CHARS);
	item.barcode[MAX_CHARS-1] = '\0';
	item.section_id = atoi(strtok(NULL, "|"));
	strncpy(item.name, strtok(NULL, "|"), MAX_CHARS);
	item.name[MAX_CHARS-1] = '\0';
	item.cost = atof(strtok(NULL, "|"));
	strncpy(item.description, strtok(NULL, "|"), MAX_CHARS);
	item.description[MAX_CHARS-1] = '\0';
	item.requires_weighing = atoi(strtok(NULL, "|"));
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

	int status = writeAndReadResponse(command, response);

	if(status != 0){
		printf("\n ERROR: Lua Script returned EXIT%c \n, status");
	}

	return getItemFromResponse(response);
}
