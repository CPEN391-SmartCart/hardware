#include "dijsktra.h"
#include "../delay/delay.h"
#include <stdio.h>

//void initialize_map(char *nodes)
//{
//	char *node_split_token = strtok(nodes, "|");
//
//	while (node_split_token != NULL)
//	{
//		char *value_token = strtok(node_split_token, ",");
//
//		while (value_token != NULL)
//		{
//
//
//
//			value_token = strtok(NULL, ",");
//		}
//
//		node_split_token = strtok(NULL, "|");
//	}
//}


int generate_path(int start_node_id, int goal_node_id, coord_t *path)
{
	coord_t nodes[] = {
			{21, 18},
			{107, 18},
			{107, 49},
			{107, 85},
			{107, 120},
			{107, 157},
			{107, 193},
			{107, 229},
			{137, 229},
			{137, 267},
			{75, 267},
			{75, 311},
			{137, 311},
			{137, 348},
			{128, 380},
			{128, 414},
			{128, 446},
			{128, 348},
			{21, 49},
			{21, 85},
			{21, 120},
			{21, 157},
			{21, 193},
			{21, 229},
			{21, 267},
			{21, 311},
			{21, 348},
			{21, 380},
			{21, 414},
			{21, 446},
			{231, 18},
			{231, 49},
			{231, 85},
			{231, 120},
			{231, 157},
			{231, 193},
			{231, 229},
			{231, 267},
			{231, 311},
			{231, 348},
			{231, 380},
			{231, 414},
			{231, 446},
			{277, 427},
			{306, 427},
			{334, 427},
			{277, 244},
			{306, 244},
			{334, 244},
			{365, 244},
			{365, 348},
			{365, 427},
			{371, 445},
			{413, 445},
			{460, 445},
			{509, 445},
			{548, 445},
			{548, 348},
			{509, 348},
			{460, 348},
			{413, 348},
			{413, 244},
			{460, 244},
			{509, 244},
			{548, 244},
			{548, 197},
			{508, 197},
			{459, 197},
			{411, 197},
			{366, 197},
			{286, 197},
			{286, 150},
			{366, 150},
			{366, 102},
			{286, 102},
			{286, 55},
			{366, 55},
			{366, 18},
			{286, 18},
			{411, 18},
			{459, 18},
			{508, 18},
			{548, 18},
			{59, 41},
			{177, 113},
			{60, 290},
			{48, 150},
			{189, 375},
			{313, 293},
			{299, 209},
			{336, 42},
			{521, 91},
			{543, 153},
			{497, 229},
			{398, 405},
			{521, 294},
			{48, 441},
			{254, 65},
			{252, 292}
	};

	*START_NODE_ID = start_node_id;
	*PATH_GOAL_SET = 1;
	*PATH_GOAL_SET = 0;

	while (*PATH_FINISHED == 0);

	*(path++) = nodes[goal_node_id];
	int length = 0;
	while (goal_node_id != start_node_id)
	{
		*NEIGHBOUR_ID = goal_node_id;
		goal_node_id = *NEIGHBOUR;
		*(path++) = nodes[goal_node_id];
		length++;
	}
	*path = nodes[start_node_id];

	return length + 1;
}

//short GeneratePath(short start_node[], short goal_node[], coord_t *path)
//{
//	int i, j;
//
//	*PATH_GOAL_SET = 0;
//
//	*PATH_WRITE = 1;
//
//	for (i = 0, j = 0; i < 17; i++)
//	{
//		*(PATH_WRITE_START + i) = start_node[i];
//	}
//
//	for (i = 0, j = 0; i < 17; i++)
//	{
//		*(PATH_WRITE_START + 17 + i) = goal_node[i];
//	}
//
//	*PATH_GOAL_SET = 1;
//
//	short length = *PATH_LENGTH;
//
//	//wait for the path to be generated, == FFFF doesnt work for some reason
//	while (length & 0x8000)
//	{
//		length = *PATH_LENGTH;
//	}
//
//    for(i = 0, j = 0; i <= 2 * length + 2; i++)
//    {
//
//        if(i % 2 == 0)
//        {
//            path[j].x = *(PATH_START + i) + 3; //pixel offset of 3
//        }
//        else
//        {
//            path[j].y = *(PATH_START + i) + 5; //pixel offset of 5
//            j++;
//        }
//    }
//
//	return length;
//}
