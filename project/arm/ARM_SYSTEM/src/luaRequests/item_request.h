

#ifndef REQUESTS_ITEM_REQUEST_H_
#define REQUESTS_ITEM_REQUEST_H_

#include "../common.h"

#define BARCODE_SCRIPT_CMD_FORMAT "args={'%s'}\ndofile('getItem.lua')\r\n" //args={barcode}



/**
 * sends command to rfs board to retrieve item info via wifi and parses response
 * barcode: the barcode of the item whose node info we are querying
 * returns Item representing the scanned item
 */
Item requestItem(char *barcode, int *ec);

/**
 * parses string delimited by '|' to get one Item struct
 * response: string to be parsed
 * returns Item representing a node
 */
static Item getItemFromResponse(char *response);

#endif /* REQUESTS_ITEM_REQUEST_H_ */
