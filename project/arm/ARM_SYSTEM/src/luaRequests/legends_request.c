
#include <stdlib.h>
#include "legends_request.h"
#include "../delay/delay.h"
#include "../wifi/wifi.h"
#include <string.h>

static Legend getLegendFromResponse(char *read){
	Legend legend_result;

	if(!read){
		return legend_result;
	}

	strncpy(legend_result.key, strtok(read, "|"), MAX_CHARS);
	legend_result.key[MAX_CHARS-1] = '\0';
	legend_result.color = atoi(strtok(NULL, "|"));


	char* end = strtok(NULL, "|");

	if(end){
		printf("\nERROR parsing response: no end found. \n");
	}

	return legend_result;
}

static int getFirstLegendFromResponse(char *read, Legend *legend_result){

	if(!read){
		return NULL;
	}

	int size = atoi(strtok(read, "|"));

	strncpy(legend_result->key, strtok(NULL, "|"), MAX_CHARS);
	legend_result->key[MAX_CHARS-1] = '\0';
	legend_result->color = atoi(strtok(NULL, "|"));


	char* end = strtok(NULL, "|");

	if(end){
		printf("\nERROR parsing response: no end found. \n");
	}
	return size;
}

/*
 * returns malloaced array of Legends created from response. pls free!
 */
LegendArr requestLegends(int store_id){
	char command[50];
	Legend first_legend;

	LegendArr legend_array;

	if(!command){
		legend_array.legends = NULL;
		legend_array.size = 0;
		return legend_array;
	}

	sprintf(command, LEGENDS_SCRIPT_CMD_FORMAT, store_id);
	char first_response[100];

	int status = writeAndReadResponse(command, first_response);

	int size;

	if(status == LUA_RESPONSE_TBC){
		size = getFirstLegendFromResponse(first_response, &first_legend);
	} else if (status == LUA_EXIT_SUCCESS){
		size = 1;
	} else{
		printf("\n ERROR: Lua Script returned EXIT%c \n", status);
		legend_array.legends = NULL;
		legend_array.size = 0;
		return legend_array;
	}

	Legend *legends = malloc((size) * sizeof(Legend));

	legends[0] = first_legend;

	sprintf(command, NEXT_LEGEND_CMD);

	int index = 1;
	while(status == LUA_RESPONSE_TBC){
		char response[100];
		status = writeAndReadResponse(command, response);
		Legend l = getLegendFromResponse(response);
		legends[index++] = l;

	}


	if(status != LUA_EXIT_SUCCESS){
		printf("\n ERROR: Lua Script returned EXIT%c \n", status);
	}

	legend_array.size = size;
	legend_array.legends = legends;

	return legend_array;
}

void freeLegend(Legend *legend){
	free(legend);
}

void freeLegendArr(LegendArr *legend_list){
	free(legend_list->legends);
	free(legend_list);
}
