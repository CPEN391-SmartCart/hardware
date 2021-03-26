
#include <stdlib.h>
#include "sections_request.h"
#include "../delay/delay.h"
#include "../wifi/wifi.h"
#include <string.h>

static Section *getSectionsFromResponse(char *read){

	if(!read){
		return NULL;
	}


	int size = atoi(strtok(read, "|"));
	struct Section *sections = malloc(size * sizeof(struct Section));


	for(int i = 0; i < size; i++) {
		struct Section s;


		sections[i] = s;
	}


	char* end = strtok(NULL, "|");

	if(end){
		printf("\nERROR parsing response: no end found. \n");
	}
	return sections;
}

Section *requestSections(int store_id){
	char command[50];

	if(!command){
		return NULL;
	}

	sprintf(command, SECTIONS_SCRIPT_CMD_FORMAT, store_id);
	char response[500];

	int status = writeAndReadResponse(command, response);

	if(status != 0){
		printf("\n ERROR: Lua Script returned EXIT%c \n, status");
	}

	return getSectionsFromResponse(response);
}
