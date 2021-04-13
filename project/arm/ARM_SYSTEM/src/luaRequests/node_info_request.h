/*
 * node_item_request.h
 *
 *  Created on: Apr 4, 2021
 *      Author: Amr
 */

#ifndef LUAREQUESTS_NODE_INFO_REQUEST_H_
#define LUAREQUESTS_NODE_INFO_REQUEST_H_

#include "../common.h"

#define NODE_INFO_SCRIPT_CMD_FORMAT "args = {'%s'}\ndofile('getNodeInfo.lua')\r\n" //args={barcode}

/*
 * the structure used for node-info is an array wrapped in a struct. The array a
 * has the following specifications:
 *
 *  size = 17
 *  a [0] x;
    a [1] y;
    a [2] node_id;
    a [3] parent_node_id;
    a [4] current_cost;
    a [5] child_one_id;
    a [6] distance_child_one;
    a [7] child_two_id;
    a [8] distance_child_two;
    a [9] child_three_id;
    a [10] distance_child_three;
    a [11] child_four_id;
    a [12] distance_child_four;
    a [13] child_five_id;
    a [14] distance_child_five;
    a [15] child_six_id;
    a [16] distance_child_six;
 */

static NodeInfo getNodeInfoFromResponse(char *response);
NodeInfo requestNodeInfo(char* barcode);


#endif /* LUAREQUESTS_NODE_INFO_REQUEST_H_ */
