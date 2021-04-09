#ifndef WIFI_WIFI_H_
#define WIFI_WIFI_H_

#include  <stdio.h>
#include  "hwlib.h"
#include  "socal/socal.h"
#include  "socal/hps.h"
#include  "alt_interrupt.h"
#include "alt_int_device.h"
#include "../common.h"

#define WiFi_ReceiverFifo ((volatile unsigned char *)(0xFF211010))
#define WiFi_TransmitterFifo ((volatile unsigned char *)(0xFF211010))
#define WiFi_InterruptEnableReg ((volatile unsigned char *)(0xFF211012))
#define WiFi_InterruptIdentificationReg ((volatile unsigned char *)(0xFF211014))
#define WiFi_FifoControlReg ((volatile unsigned char *)(0xFF211014))
#define WiFi_LineControlReg ((volatile unsigned char *)(0xFF211016))
#define WiFi_ModemControlReg ((volatile unsigned char *)(0xFF211018))
#define WiFi_LineStatusReg ((volatile unsigned char *)(0xFF21101A))
#define WiFi_ModemStatusReg ((volatile unsigned char *)(0xFF21101C))
#define WiFi_ScratchReg ((volatile unsigned char *)(0xFF21101E))
#define WiFi_DivisorLatchLSB ((volatile unsigned char *)(0xFF211010))
#define WiFi_DivisorLatchMSB ((volatile unsigned char *)(0xFF211012))

#define WIFI_RST (volatile unsigned int *)(0xFF200060)
#define WIFI_CTS (volatile unsigned int *)(0xFF200070)

#define LUA_MSG_START "STRT\n"
#define LUA_MSG_END_SUCCESS "EXIT0\0" //lua will explicitly send a null terminated character at the end, which is included here


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
