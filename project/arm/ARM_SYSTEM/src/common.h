/*
 * common.h
 *
 *  Created on: Feb 21, 2021
 *      Author: jared
 */

#ifndef COMMON_H_
#define COMMON_H_

#define TRUE 1
#define FALSE 0

#define MAX_CHARS 30

#define NODE_INFO_ARRAY_SIZE 17


#define LUA_EXIT_SUCCESS 0
#define LUA_HTTP_ERROR 1
#define LUA_RESPONSE_ITERATION_OVERFLOW 2
#define LUA_RESPONSE_TIMEOUT 4
#define LUA_RESPONSE_TBC 9

typedef struct NodeInfo {
	short nodeInfo[NODE_INFO_ARRAY_SIZE];
} NodeInfo;


typedef struct Item
{
	char barcode[MAX_CHARS];
	int section_id;
    char name[MAX_CHARS];
	double cost;
    char description[MAX_CHARS];
    int requires_weighing;
    int x;
    int y;
    int aisleColor;
    double weight_g;
    int node_id;
} Item;

typedef struct Legend
{
    char key[MAX_CHARS];
    int color;
} Legend;

typedef struct LegendArr
{
	int size;
    Legend *legends;
} LegendArr;

typedef struct Section
{
    int originX;
    int originY;
    int sectionWidth;
    int sectionHeight;
    int aisleColor;
} Section;

typedef struct SectionArr
{
    int size;
    Section* sections;
} SectionArr;

#endif /* COMMON_H_ */
