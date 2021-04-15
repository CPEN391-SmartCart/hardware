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

/*
 * Possible exit statuses that can be received from running a lua script on rfs
 */
#define LUA_EXIT_SUCCESS 0
#define LUA_HTTP_ERROR 1
#define LUA_RESPONSE_ITERATION_OVERFLOW 2
#define LUA_RESPONSE_TIMEOUT 4
#define ITEM_NOT_FOUND 5
#define LUA_RESPONSE_TBC 9

/*
 * represents a node on the map and its related info
 */
typedef struct NodeInfo {
	short nodeInfo[NODE_INFO_ARRAY_SIZE];
} NodeInfo;

/*
 * represents an Item that can be scanned
 */
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
    int weight_g;
    int node_id;
} Item;

/*
 * represents a legend on the store map
 */
typedef struct Legend
{
    char key[MAX_CHARS];
    int color;
} Legend;

/*
 * represents a list of legends with a given size
 */
typedef struct LegendArr
{
	int size;
    Legend *legends;
} LegendArr;

/*
 * represents a section on the store map
 */
typedef struct Section
{
    int originX;
    int originY;
    int sectionWidth;
    int sectionHeight;
    int aisleColor;
} Section;

/*
 * represents a list of Sections with a given size
 */
typedef struct SectionArr
{
    int size;
    Section* sections;
} SectionArr;

/*
 * represents a (x,y) coordinate pair
 */
typedef struct coord_t
{
    short x;
    short y;
} coord_t;

#endif /* COMMON_H_ */
