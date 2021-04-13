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
			{107, 84},
			{107, 119},
			{107, 156},
			{107, 192},
			{107, 228},
			{137, 228},
			{137, 267},
			{75, 267},
			{75, 311},
			{137, 310},
			{137, 348},
			{127, 380},
			{127, 414},
			{127, 445},
			{128, 348},
			{21, 49},
			{21, 85},
			{21, 120},
			{20, 157},
			{20, 193},
			{21, 229},
			{20, 267},
			{20, 311},
			{20, 348},
			{20, 381},
			{20, 415},
			{21, 446},
			{231, 18},
			{231, 48},
			{231, 85},
			{231, 120},
			{231, 156},
			{231, 193},
			{231, 227},
			{231, 266},
			{231, 310},
			{231, 347},
			{231, 380},
			{231, 414},
			{231, 444},
			{277, 427},
			{306, 427},
			{334, 427},
			{277, 244},
			{306, 244},
			{335, 244},
			{367, 244},
			{366, 348},
			{365, 427},
			{371, 445},
			{411, 445},
			{460, 445},
			{508, 445},
			{548, 445},
			{548, 348},
			{509, 348},
			{460, 347},
			{412, 347},
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
			{287, 55},
			{366, 54},
			{366, 18},
			{287, 17},
			{411, 18},
			{459, 18},
			{508, 18},
			{548, 18},
			{317, 42},
			{334, 42},
			{543, 97},
			{495, 71},
			{495, 295},
			{481, 208},
			{447, 286},
			{180, 341},
			{170, 78},
			{167, 387},
			{397, 67},
			{398, 395},
			{270, 292},
			{494, 401}
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
