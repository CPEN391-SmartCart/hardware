#ifndef WIFI_WIFI_H_
#define WIFI_WIFI_H_

#include  <stdio.h>
#include  "hwlib.h"
#include  "socal/socal.h"
#include  "socal/hps.h"
#include  "alt_interrupt.h"
#include "alt_int_device.h"

//Bluetooth address range 0xFF21_0200 - 0xFF21_020F 
#define WiFi_ReceiverFifo ((volatile unsigned char *)(0xFF210210))
#define WiFi_TransmitterFifo ((volatile unsigned char *)(0xFF210210))
#define WiFi_InterruptEnableReg ((volatile unsigned char *)(0xFF210212))
#define WiFi_InterruptIdentificationReg ((volatile unsigned char *)(0xFF210214))
#define WiFi_FifoControlReg ((volatile unsigned char *)(0xFF210214))
#define WiFi_LineControlReg ((volatile unsigned char *)(0xFF210216))
#define WiFi_ModemControlReg ((volatile unsigned char *)(0xFF210218))
#define WiFi_LineStatusReg ((volatile unsigned char *)(0xFF21021A))
#define WiFi_ModemStatusReg ((volatile unsigned char *)(0xFF21021C))
#define WiFi_ScratchReg ((volatile unsigned char *)(0xFF21021E))
#define WiFi_DivisorLatchLSB ((volatile unsigned char *)(0xFF210210))
#define WiFi_DivisorLatchMSB ((volatile unsigned char *)(0xFF210212))

#define WIFI_RST (volatile unsigned int *)(0xFF200060)
#define WIFI_CTS (volatile unsigned int *)(0xFF200070)

#define LUA_MSG_START "STRT\n"
#define LUA_MSG_END_SUCCESS "EXIT0\0" //lua will explicitly send a null terminated character at the end, which is included here

#define LUA_EXIT_SUCCESS 0
#define LUA_HTTP_ERROR 1
#define LUA_RESPONSE_ITERATION_OVERFLOW 2
#define LUA_RESPONSE_TBC 9

typedef struct wifi_context {
	char *BUFFER;
	int index;
	char doneRead;
	 char status;
}wifi_context ;


extern ALT_INT_INTERRUPT_t WIFI_INTERRUPT;
extern volatile struct wifi_context *WIFI_ISR_CONTEXT;
extern char BUFFER[1024];

void initWiFi(int baud_rate);
void resetWiFi(void);
void writeStringWIFI(char *string);
void readStringWIFI(char string[32]);
void readStringTillSizeWIFI(char *string, int size);
int writeAndReadResponse(char *write, char *response);
void  wifi_isr_callback ( uint32_t icciar, void * context) ;
void resetWifiIsrContext(void);


#endif
