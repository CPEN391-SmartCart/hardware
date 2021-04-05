
#include "../delay/delay.h"
#include "../wifi/wifi.h"
#include <string.h>
#include <stdlib.h>

#include "node_info_request.h"

static NodeInfo getnodeInfoFromResponse(char *read){
	struct NodeInfo nodeInfo;

	if(!read){
		return nodeInfo;
	}

	short *nodeInfoArray = nodeInfo.nodeInfo;
	nodeInfoArray[0] = atoi(strtok(read, "|"));

	for(int i = 1; i <= 16; i++){
		nodeInfoArray[i] = atoi(strtok(NULL, "|"));
	}

	char* end = strtok(NULL, "|");

	if(end){
		printf("\nERROR parsing response: no end found. \n");
	}
	return nodeInfo;
}

NodeInfo requestNodeInfo(char *barcode){
	char command[50];
	sprintf(command, NODE_INFO_SCRIPT_CMD_FORMAT, barcode);

	if(!command){
		printf("\nfailed to allocate space for nodeInfo request\n");
		struct NodeInfo nodeInfo;
		return nodeInfo;
	}

	char response[500];

	int status = writeAndReadResponse(command, response);

	if(status != 0){
		printf("\n ERROR: Lua Script returned EXIT%c \n, status");
	}

	return getnodeInfoFromResponse(response);
}
