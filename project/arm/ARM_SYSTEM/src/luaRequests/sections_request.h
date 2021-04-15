

#ifndef REQUESTS_SECTIONS_REQUEST_H_
#define REQUESTS_SECTIONS_REQUEST_H_

#include "../common.h"

#define SECTIONS_SCRIPT_CMD_FORMAT "args = {'%d'}\ndofile('getSections.lua')\r\n" //args={store_id}
#define NEXT_SECTION_CMD "print_iter()\r\n"


static Section getSectionFromResponse(char *response);
static int getFirstSectionFromResponse(char *read, Section *section_result);
SectionArr requestSections(int store_id, int *ec);


#endif /* REQUESTS_SECTIONS_REQUEST_H_ */
