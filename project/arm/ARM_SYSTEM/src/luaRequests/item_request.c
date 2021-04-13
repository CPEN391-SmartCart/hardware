
#include "../delay/delay.h"
#include "../wifi/wifi.h"
#include <string.h>
#include <stdlib.h>

#include "item_request.h"

static Item getItemFromResponse(char *read){
	struct Item item;

	if(!read){
		strcpy(item.barcode, "DEADBEEF");
		strcpy(item.name, "DEADBEEF");
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
	item.node_id = atoi(strtok(NULL, "|"));
	item.aisleColor = 0;



	char* optional_weight = strtok(NULL, "|");

	item.weight_g = atoi(optional_weight);

	return item;
}

/*
 * ec = 0 means success
 */
Item requestItem(char *barcode, int* ec){
	char command[50];
	sprintf(command, BARCODE_SCRIPT_CMD_FORMAT, barcode);

	if(!command){
		printf("\nfailed to allocate space for item request\n");
		struct Item item;
		strcpy(item.barcode, "DEADBEEF");
		strcpy(item.name, "DEADBEEF");
		return item;
	}

	char response[500];

	int status = writeAndReadResponse(command, response);

	*ec = status;
	if(status != 0){
		printf("\n ERROR: Lua Script returned EXIT%c \n", status);
		struct Item item;
		strcpy(item.barcode, "DEADBEEF");
		strcpy(item.name, "DEADBEEF");
		return item;
	}


	printf("\n SUCCESS: item retrieved successfully (EXIT%d) \n", status);


	Item ret_val= getItemFromResponse(response);
	return ret_val;
}

