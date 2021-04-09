

#ifndef REQUESTS_ITEM_REQUEST_H_
#define REQUESTS_ITEM_REQUEST_H_

#include "../common.h"

#define BARCODE_SCRIPT_CMD_FORMAT "args={'%s'}\ndofile('getItem.lua')\r\n" //args={barcode}

static Item getItemFromResponse(char *response);
Item requestItem(char *barcode, int *ec);

#endif /* REQUESTS_ITEM_REQUEST_H_ */
