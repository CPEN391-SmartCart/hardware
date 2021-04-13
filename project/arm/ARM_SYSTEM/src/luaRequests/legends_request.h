/*
 * legends_request.h
 *
 *  Created on: Apr 2, 2021
 *      Author: Amr
 */

#ifndef LUAREQUESTS_LEGENDS_REQUEST_H_
#define LUAREQUESTS_LEGENDS_REQUEST_H_

#include "../common.h"

#define LEGENDS_SCRIPT_CMD_FORMAT "args = {'%d'}\ndofile('getLegends.lua')\r\n" //args={store_id}
#define NEXT_LEGEND_CMD "print_iter()\r\n"


static Legend getLegendFromResponse(char *response);
static int getFirstLegendFromResponse(char *read, Legend *Legend_result);
LegendArr requestLegends(int store_id, int* ec);


#endif /* LUAREQUESTS_LEGENDS_REQUEST_H_ */
