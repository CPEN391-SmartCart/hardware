/*
 * barcode_request.h
 *
 *  Created on: Mar 23, 2021
 *      Author: Amr
 */

#ifndef REQUESTS_ITEM_REQUEST_H_
#define REQUESTS_ITEM_REQUEST_H_

#include "../vga/map.h"

#define BARCODE_SCRIPT_CMD_FORMAT "dofile('getBarcodeMsg.lua')\r\n" //TODO : add args

Item getItemFromResponse(char *response);
Item requestItem(char *barcode);

#endif /* REQUESTS_ITEM_REQUEST_H_ */
