
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
#include "tests/tests.h"

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
	addToCart();
	return 0;
}

