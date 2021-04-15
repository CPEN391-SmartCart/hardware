

#ifndef REQUESTS_SECTIONS_REQUEST_H_
#define REQUESTS_SECTIONS_REQUEST_H_

#include "../common.h"

#define SECTIONS_SCRIPT_CMD_FORMAT "args = {'%d'}\ndofile('getSections.lua')\r\n" //args={store_id}
#define NEXT_SECTION_CMD "print_iter()\r\n"

/**
 * sends command to rfs board to retrieve sections via wifi and parses it
 * store_id: the id of the store containing the requested sections
 * ec: error code
 * returns SectionArr representing the array of sections of the store
 */
SectionArr requestSections(int store_id, int *ec);

/**
 * parses string delimited by '|' to get one section
 * response: string to be parsed
 * returns Section representing the parsed section
 */
static Section getSectionFromResponse(char *response);

/**
 * parses string delimited by '|' to get first section and size of sections response
 * read: string to be parsed, which is the response from lua
 * section_result: pointer to first section
 * returns the number of sections contained in the read variable
 */
static int getFirstSectionFromResponse(char *read, Section *section_result);



#endif /* REQUESTS_SECTIONS_REQUEST_H_ */
