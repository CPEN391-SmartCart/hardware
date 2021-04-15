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


/**
 * sends command to rfs board to retrieve legends via wifi and parses the response
 * store_id: the id of the store containing the requested sections
 * ec: error code
 * returns LegendArr representing the array of legends of the store
 */
LegendArr requestLegends(int store_id, int* ec);


/**
 * parses string delimited by '|' to get one legend
 * response: string to be parsed
 * returns legend representing the parsed legend
 */
static Legend getLegendFromResponse(char *response);

/**
 * parses string delimited by '|' to get first legend and size of legend response
 * read: string to be parsed, which is the response from lua
 * legend_response: pointer to first legend
 * returns the number of legends contained in the read parameter
 */
static int getFirstLegendFromResponse(char *read, Legend *Legend_result);




#endif /* LUAREQUESTS_LEGENDS_REQUEST_H_ */
