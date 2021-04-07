/**************************************************************************
/* Subroutine to initialise the WiFi Port by writing some data
** to the internal registers.
** Call this function at the start of the program before you attempt
** to read or write to data via the WiFi port
**
** Refer to UART data sheet for details of registers and programming
***************************************************************************/

#include "../uart/uart.h"
#include "../delay/delay.h"
#include "wifi.h"
#include "../interrupt/interrupt.h"
#include "stdlib.h"
#include "string.h"

volatile wifi_context *WIFI_ISR_CONTEXT;
char BUFFER[1024];

void initWiFi(int baud_rate)
{
    initUART(baud_rate, WiFi_LineControlReg, WiFi_DivisorLatchLSB, WiFi_DivisorLatchMSB, WiFi_FifoControlReg);
    flushUART(WiFi_LineStatusReg, WiFi_ReceiverFifo);

    WIFI_ISR_CONTEXT = (struct wifi_context *) malloc(sizeof(struct wifi_context));
    WIFI_ISR_CONTEXT->BUFFER = BUFFER;
    WIFI_ISR_CONTEXT->doneRead = 0;
    WIFI_ISR_CONTEXT->index = 0;
    WIFI_ISR_CONTEXT->status = 0;

    ALT_STATUS_CODE status = setup_interrupt(WIFI_INTERRUPT, wifi_isr_callback, (void *) WIFI_ISR_CONTEXT);

    if(status!=ALT_E_SUCCESS){
    	printf("\nERROR: Could not setup WiFi Interrupt, status code %d", status);
    }
}

void resetWiFi(void)
{
	disableInterrupt(WIFI_INTERRUPT);

    *WIFI_RST = 0;
    delay_us(50);
    *WIFI_RST = 1;
    delay_us(3 * 1000 * 1000);

    //send a bunch of new lines to initialize
	char string[32];
	int i;
	for(i = 0; i < 5; i++) {
		writeStringWIFI("\r\n");
		delay_us(1000);
	    readStringWIFI(string);
		delay_us(1000);
	}

	enableInterrupt(WIFI_INTERRUPT);

}

void writeStringWIFI(char *string)
{
    writeStringUART(string, WiFi_LineStatusReg, WiFi_TransmitterFifo);
}

void readStringTillSizeWIFI(char *string, int size)
{
    int i;
    int j;
    char c;

    i = 0;
    j = 0;
    while (j < size)
    {
		if (dataReadyUART(WiFi_LineStatusReg))
		{
			c = readCharUART(WiFi_LineStatusReg, WiFi_ReceiverFifo);
			string[i++] = c;
		}
		j++;
    }

    string[i] = '\0';
}

//traditional read string. you might not want to use this if wifi interrupts are enabled.
void readStringWIFI(char *string)
{
    int i;
    char c = ' ';

    i = 0;
    int nodata = 0;
    while (c != '\r' && nodata < 100)
    {
		if (dataReadyUART(WiFi_LineStatusReg))
		{
			c = readCharUART(WiFi_LineStatusReg, WiFi_ReceiverFifo);
			string[i++] = c;
			nodata = 0;
		} else{
			nodata++;
		}
    }

    string[i] = '\0';
}

/*
 * writes lua command and waits for response. Copys response into read argument
 */
int writeAndReadResponse(char *write, char *read) {
	resetWifiIsrContext();
	writeStringWIFI(write);
	delay_us(1000);

	//wait for itnerrupt to signal that read is complete

	int done_or_timeout = 0;
	int num_waits = 0;
	while(!done_or_timeout){
		delay_us(100000);
		if(WIFI_ISR_CONTEXT->doneRead == 1) {
			done_or_timeout = 1;
		} else if (num_waits++ >= 500) {
			printf("\n TIMEOUT ON RECEIVING RESPONSE\n");
			done_or_timeout = 1;
			char error_resp[50];
			memcpy(error_resp, WIFI_ISR_CONTEXT->BUFFER, 49);
			error_resp[49]='\0';
			printf("Received in Buffer (note this could be incomplete): %s", error_resp);
			return -1;
		}
	}

	char *start = strstr(WIFI_ISR_CONTEXT->BUFFER, LUA_MSG_START);

	if(start==""){
		printf("\nERROR: Response had no start\n");

	} else{
		start+= strlen(LUA_MSG_START);
		strcpy(read, start);
	}

	char c = WIFI_ISR_CONTEXT->status;
	int exit_status = atoi(&c);
	return exit_status;
}


void  wifi_isr_callback ( uint32_t icciar, void * context)
{

	disableInterrupt(WIFI_INTERRUPT);
	static int BUFFER_INT = 0;

	//unsigned char *buffer = (unsigned char *) context;
	struct wifi_context *wcontext = (struct wifi_context * ) context;

	char *buffer = wcontext->BUFFER;
	char c;

    while (dataReadyUART(WiFi_LineStatusReg))
    {
	   c = readCharUART(WiFi_LineStatusReg, WiFi_ReceiverFifo);
	  (buffer)[(wcontext->index)++] = c;
	  if(c == '\0'){
		  break;
	  }
    }

	  // uses convention between our LUA scripts and ARM to know when response is over
	  if(wcontext->index >= 6){
		  int start_index = (wcontext->index) - 6;
		  char exit_result[6];
		  memcpy(exit_result, buffer+start_index, 6);
		  if(strncmp(exit_result, "EXIT", 4) == 0){
			  (buffer)[start_index] = '\0';
			  wcontext->doneRead = 1;
			  wcontext->status = exit_result[4];
			  flushUART(WiFi_LineStatusReg, WiFi_ReceiverFifo);
		  }
	  }

   enableInterrupt(WIFI_INTERRUPT);
}

void resetWifiIsrContext(void) {
	WIFI_ISR_CONTEXT->index = 0;
	WIFI_ISR_CONTEXT->doneRead = 0;
	WIFI_ISR_CONTEXT->status = 0;
}

void freeWifi(){
	free(WIFI_ISR_CONTEXT);
}
