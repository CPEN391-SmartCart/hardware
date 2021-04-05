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

#define PATH_LENGTH	(volatile unsigned short int *)(0xFF210100)
#define PATH_START	(volatile unsigned short int *)(0xFF210102)

#define PATH_WRITE (volatile unsigned short int *)(0xFF210398)
#define PATH_WRITE_START (volatile unsigned short int *)(0xFF210400)



#define SRAM (void *) (0xC8000000)


int main(void)
{
	int i;
	int j;
	char test[512];

	*PATH_GOAL_SET = 0;

	char* SRAM_COPY = SRAM;

//	short start_node[] = {
//			0x0050,
//			0x0030,
//			0x0017,
//			0x0000,
//			0x0000,
//			0x0023,
//			0x000A,
//			0x0013,
//			0x0002,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000
//	};

//	short start_node[] = {
//			0x0010,
//			0x0010,
//			0x0013,
//			0x0000,
//			0x0000,
//			0x0016,
//			0x0004,
//			0x0017,
//			0x0002,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000
//	};

	short start_node[] = {
			0x0015,
			0x0012,
			0x003a,
			0x0000,
			0x0000,
			0x0039,
			0x001f,
			0x0001,
			0x0057,
			0x0000,
			0x0000,
			0x0000,
			0x0000,
			0x0000,
			0x0000,
			0x0000,
			0x0000
	};

	short goal_node[] = {0x0225,
			0x01bd,
			0x0051,
			0x0000,
			0x0000,
			0x0049,
			0x005f,
			0x0050,
			0x0028,
			0x0000,
			0x0000,
			0x0000,
			0x0000,
			0x0000,
			0x0000,
			0x0000,
			0x0000
	};

//	short start_node[] = {
//			0x0000,
//			0x0000,
//			0x0050,
//			0x0000,
//			0x0000,
//			0x000d,
//			0x0026,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000
//	};
//
//	short goal_node[] = {
//			0x0088,
//			0x015c,
//			0x0014,
//			0x0000,
//			0x0000,
//			0x0013,
//			0x0053,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000
//	};

//	short goal_node[] = {
//			0x0082,
//			0x0043,
//			0x0045,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000
//	};

	*PATH_WRITE = 1;

	for (i = 0, j = 0; i < 17; i++)
	{
		*(PATH_WRITE_START + i) = start_node[i];
	}

	for (i = 0, j = 0; i < 17; i++)
	{
		*(PATH_WRITE_START + 17 + i) = goal_node[i];
	}

	*PATH_GOAL_SET = 1;
//
//	int path_count = 0;
//
//	short x;
//	short y;
//

//    int length = *PATH_LENGTH;
//
//    for(i = 0, j = 0; j < length * 2 + 2; j++) {
//        // Get value from *address
//        printf("t: %x\n", *(PATH_START + i));
//
//        if (j % 2 == 0)
//        {
//
//        }
//
//        i++;
//    }

//	 short length = *PATH_LENGTH;
//
//	 while (length & 0x8000)
//	 {
//		 length = *PATH_LENGTH;
//	 }
//
//
//	 path_t coordinates[length + 1];
//
//     for(i = 0, j = 0; i <= 2 * length + 2; i++){
//
//         if(i % 2 == 0) {
//             coordinates[j].x = *(PATH_START + i) + 3;
//         }
//         else {
//             coordinates[j].y = *(PATH_START + i) + 5;
//             j++;
//         }
//     }
//
//     int sectionSize = sizeof(sections) / sizeof(Section);
//	 int legendSize = sizeof(legends) / sizeof(Legend);
//	 int listSize = sizeof(shoppingList) / sizeof(Item);
//
//	 printf("Clearing screen...\n");
//	 Reset();
//
//	 printf("Creating store map...\n");
//	 CreateStoreMap(sectionSize, sections, legendSize, legends);
//	 CreateSidePanel(legendSize, legends);
//
//	 path_t testw[1];
//
//	 DrawItemPath(0, testw, length + 1, coordinates, 0);
//
//	 short goal[] = {
//			0x0088,
//			0x00E6,
//			0x0008,
//			0x0000,
//			0x0000,
//			0x0009,
//			0x0027,
//			0x0007,
//			0x001C,
//			0x0014,
//			0x0061,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000,
//			0x0000
//	 };
//
//		*PATH_WRITE = 1;
//
//		for (i = 0, j = 0; i < 17; i++)
//		{
//			*(PATH_WRITE_START + i) = start_node[i];
//		}
//
//		for (i = 0, j = 0; i < 17; i++)
//		{
//			*(PATH_WRITE_START + 17 + i) = goal[i];
//		}
//
//		*PATH_GOAL_SET = 1;
//	//
//	//	int path_count = 0;
//	//
//	//	short x;
//	//	short y;
//	//
//
//	//    int length = *PATH_LENGTH;
//	//
//	//    for(i = 0, j = 0; j < length * 2 + 2; j++) {
//	//        // Get value from *address
//	//        printf("t: %x\n", *(PATH_START + i));
//	//
//	//        if (j % 2 == 0)
//	//        {
//	//
//	//        }
//	//
//	//        i++;
//	//    }
//
//		 short length2 = *PATH_LENGTH;
//
//		 while (length2 & 0x8000)
//		 {
//			 length2 = *PATH_LENGTH;
//		 }
//
//
//		 path_t coordinates2[length2 + 1];
//
//	     for(i = 0, j = 0; i <= 2 * length2 + 2; i++){
//
//	         if(i % 2 == 0) {
//	             coordinates2[j].x = *(PATH_START + i) + 3;
//	         }
//	         else {
//	             coordinates2[j].y = *(PATH_START + i) + 5;
//	             j++;
//	         }
//	     }
//
//		 DrawItemPath(0, testw, length2 + 1, coordinates2, 22);
	return 0;
}

