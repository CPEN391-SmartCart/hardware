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

void initWiFi(int baud_rate)
{
    initUART(baud_rate, WiFi_LineControlReg, WiFi_DivisorLatchLSB, WiFi_DivisorLatchMSB, WiFi_FifoControlReg);
    flushUART(WiFi_LineStatusReg, WiFi_ReceiverFifo);
}

void resetWiFi(void)
{
    *WIFI_RST = 0;
    delay_us(50);
    *WIFI_RST = 1;
    delay_us(3 * 1000 * 1000);
}

void writeStringWIFI(char *string)
{
    writeStringUART(string, WiFi_LineStatusReg, WiFi_TransmitterFifo);
}

void readStringWIFI(char *string)
{
    int i;
    char c;

    i = 0;
    while (dataReadyUART(WiFi_LineStatusReg))
    {
        c = readCharUART(WiFi_LineStatusReg, WiFi_ReceiverFifo);
        string[i++] = c;
    }

    string[i] = '\0';
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