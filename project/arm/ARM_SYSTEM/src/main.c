/*
 * main.c
 *
 *  Created on: Feb 21, 2021
 *      Author: jared
 */

#include "bluetooth/bluetooth.h"
#include "wifi/wifi.h"
#include "common.h"
#include "stdio.h"

#include "wifi/wifi.h"
#include "uart/uart.h"

#include "delay/delay.h"

#include "hx711/hx711.h"
#include "string.h"

#include "objectFactory.h"

#include "imu/imu.h"

#include "pathfinding/dijsktra.h"

#define PATH_GOAL_SET (volatile unsigned int *)(0xFF200200)
#define PATH_FINISHED (volatile unsigned int *)(0xFF200210)
#define ACTUAL_COORD (volatile unsigned int *)(0xFF200240)
#define GAVE_COORD (volatile unsigned int *)(0xFF20220)
#define RECEIVED_COORD (volatile unsigned int *)(0xFF200230)

#define GraphicsCommandReg              (*(volatile unsigned short int *)(0xFF210000))
#define GraphicsStatusReg               (*(volatile unsigned short int *)(0xFF210000))
#define GraphicsX1Reg                   (*(volatile unsigned short int *)(0xFF210002))
#define GraphicsY1Reg                   (*(volatile unsigned short int *)(0xFF210004))
#define GraphicsX2Reg                   (*(volatile unsigned short int *)(0xFF210006))
#define GraphicsY2Reg                   (*(volatile unsigned short int *)(0xFF210008))
#define GraphicsColourReg               (*(volatile unsigned short int *)(0xFF21000E))
#define GraphicsBackGroundColourReg     (*(volatile unsigned short int *)(0xFF210010))

#define MAP_INIT_NODE (volatile unsigned int *)(0xFF210100)
#define MAP_INIT_WRITE (volatile unsigned int *)(0xFF210402)

#define START_NODE_ID (volatile unsigned int *)(0xFF200210)
#define NEIGHBOUR_ID (volatile unsigned int *)(0xFF200230)
#define NEIGHBOUR (volatile unsigned int *)(0xFF200220)
#define PATH_FINISHED (volatile unsigned int *)(0xFF200240)

int main(void)
{
	int i;
	int j;
	char test[512];

	int start_node_id = 83;
	int goal_node_id = 95;
	coord_t path[10];

	int length = generate_path(start_node_id, goal_node_id, path);

	for (i = 0; i < length; i++)
	{
		printf("nicea!: x: %d, y: %d\n", path[i].x, path[i].y);
	}

//	uint8_t devid;
//	int16_t mg_per_lsb = 4;
//	int16_t XYZ[3];
//
//	pinmux_config();
//	I2C0_init();
//
//	ADXL345_REG_READ(0x00, &devid);
//
//	if (devid == 0xE5) {
//		ADXL345_init();
//
//		while (TRUE)
//		{
//			if (ADXL345_is_data_ready())
//			{
//				ADXL345_XYZ_read(XYZ);
//				printf("X=%d mg, Y=%d mg, Z=%d mg\n", XYZ[0]*mg_per_lsb, XYZ[1]*mg_per_lsb, XYZ[2]*mg_per_lsb);
//			}
//		}
//	}
//	else
//	{
//		printf("Incorrect device ID\n");
//	}

     int sectionSize = sizeof(sections) / sizeof(Section);
	 int legendSize = sizeof(legends) / sizeof(Legend);
	 int listSize = sizeof(shoppingList) / sizeof(Item);

	 printf("Clearing screen...\n");
	 Reset();

	 printf("Creating store map...\n");
	 CreateStoreMap(sectionSize, sections, legendSize, legends);
	 CreateSidePanel(legendSize, legends);

	 coord_t old[10];

	 DrawItemPath(0, old, length, path, 0);
	 while (TRUE)
	 {

	 }

	return 0;
}

