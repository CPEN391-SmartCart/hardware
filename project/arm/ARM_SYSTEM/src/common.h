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

typedef struct Item
{
	char *barcode;
	int section_id;
    char *name;
	double cost;
    char *description;
    char *requires_weighing;
    int x;
    int y;
    int aisleColor;
} Item;

typedef struct Legend
{
    char *key;
    int color;
} Legend;

typedef struct Section
{
	int id;
    int originX;
    int originY;
    int sectionWidth;
    int sectionHeight;
    int aisleColor;
    char* key;
} Section;

typedef struct Coord
{
    short x;
    short y;
} coord_t;


#endif /* COMMON_H_ */
