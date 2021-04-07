
#include <stdlib.h>
#include "sections_request.h"
#include "../delay/delay.h"
#include "../wifi/wifi.h"
#include <string.h>

static Section getSectionFromResponse(char *read){
	Section section_result;

	if(!read){
		return section_result;
	}

	section_result.originX = atoi(strtok(read, "|"));
	section_result.originY = atoi(strtok(NULL, "|"));
	section_result.sectionHeight = atoi(strtok(NULL, "|"));
	section_result.sectionWidth = atoi(strtok(NULL, "|"));
	section_result.aisleColor = atoi(strtok(NULL, "|"));


	char* end = strtok(NULL, "|");

	if(end){
		printf("\nERROR parsing response: no end found. \n");
	}

	return section_result;
}

static int getFirstSectionFromResponse(char *read, Section *section_result){

	if(!read){
		return NULL;
	}


	int size = atoi(strtok(read, "|"));

	section_result->originX = atoi(strtok(NULL, "|"));
	section_result->originY = atoi(strtok(NULL, "|"));
	section_result->sectionHeight = atoi(strtok(NULL, "|"));
	section_result->sectionWidth = atoi(strtok(NULL, "|"));
	section_result->aisleColor = atoi(strtok(NULL, "|"));


	char* end = strtok(NULL, "|");

	if(end){
		printf("\nERROR parsing response: no end found. \n");
	}
	return size;
}

/*
 * returns malloaced array of Sections created from response. pls free!
 */
SectionArr requestSections(int store_id){
	char command[50];
	Section first_section;

	SectionArr section_array;

	if(!command){
		section_array.sections = NULL;
		section_array.size = 0;
		return section_array;
	}

	sprintf(command, SECTIONS_SCRIPT_CMD_FORMAT, store_id);
	char response[100];

	int status = writeAndReadResponse(command, response);

	int size;

	if(status == LUA_RESPONSE_TBC){
		size = getFirstSectionFromResponse(response, &first_section);
	} else if (status == LUA_EXIT_SUCCESS){
		size = 1;
	} else{
		printf("\n ERROR: Lua Script returned EXIT%c \n", status);
		section_array.sections = NULL;
		section_array.size = 0;
		return section_array;
	}

	Section *sections = malloc((size+1) * sizeof(Section));

	sections[0] = first_section;

	sprintf(command, NEXT_SECTION_CMD);

	int index = 1;
	while(status == LUA_RESPONSE_TBC){
		status = writeAndReadResponse(command, response);
		sections[index++] = getSectionFromResponse(response);
	}

	if(status != LUA_EXIT_SUCCESS){
		printf("\n ERROR: Lua Script returned EXIT%c \n", status);
	}

	section_array.size = size;
	section_array.sections = sections;

	return section_array;
}

void freeSection(Section *section){
	free(section);
}

void freeSectionArr(SectionArr *section_list){
	free(section_list->sections);
	free(section_list);
}
