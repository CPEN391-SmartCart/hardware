

#ifndef REQUESTS_SECTIONS_REQUEST_H_
#define REQUESTS_SECTIONS_REQUEST_H_

#include "../common.h"

#define SECTIONS_SCRIPT_CMD_FORMAT "store_id = %d, dofile(requestSections.lua)"


static Section *getSectionsFromResponse(char *response);
Section *requestSections(int store_id);


#endif /* REQUESTS_SECTIONS_REQUEST_H_ */
