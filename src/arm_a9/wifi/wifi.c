/**************************************************************************
/* Subroutine to initialise the WiFi Port by writing some data
** to the internal registers.
** Call this function at the start of the program before you attempt
** to read or write to data via the WiFi port
**
** Refer to UART data sheet for details of registers and programming
***************************************************************************/

#include "../uart.h"
#include "wifi.h"

int main()
{
        int i;
    // initialize the serial port;
    // needs to be done according to the chip
    // to use just change the WiFi PART, same idea for put char and get char for the arguments
    initWiFi();
    flushUART(WiFi_LineStatusReg, WiFi_ReceiverFifo);

    *WIFI_RST = 0;

    for (i = 0; i < 1000000; i++);

    *WIFI_RST = 1;

    for (i = 0; i < 100000000; i++);

    char string[32];
    printf("Starting WiFi Test:\n");

    while (TRUE)
    {
        writeString("AT\r\n");

        for (i = 0; i < 1000000; i++);

        readString(string);
        printf("%s\n", string);

        for (i = 0; i < 1000000; i++);
    }
}

void initWiFi()
{
    initUART(115200, WiFi_LineControlReg, WiFi_DivisorLatchLSB, WiFi_DivisorLatchMSB, WiFi_FifoControlReg);
}

void writeString(char *string)
{
    writeStringUART(string, WiFi_LineStatusReg, WiFi_TransmitterFifo);
}

void readString(char string[32])
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