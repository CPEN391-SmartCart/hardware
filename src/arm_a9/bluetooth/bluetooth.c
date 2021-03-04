/**************************************************************************
/* Subroutine to initialise the Bluetooth Port by writing some data
** to the internal registers.
** Call this function at the start of the program before you attempt
** to read or write to data via the Bluetooth port
**
** Refer to UART data sheet for details of registers and programming
***************************************************************************/

#include "../uart.h"
#include "bluetooth.h"

int main()
{
    // initialize the serial port;
    // needs to be done according to the chip
    // to use just change the Bluetooth PART, same idea for put char and get char for the arguments
    initBluetooth();
    flushUART(Bluetooth_LineStatusReg, Bluetooth_ReceiverFifo);

    char string[32];
    while (TRUE)
    {
        readString(string);
        printf("%s", string);
    }
}

void initBluetooth()
{
    initUART(115200, Bluetooth_LineControlReg, Bluetooth_DivisorLatchLSB, Bluetooth_DivisorLatchMSB, Bluetooth_FifoControlReg);
}

void writeString(char *string)
{
    writeStringUART(string, Bluetooth_LineStatusReg, Bluetooth_TransmitterFifo);
}

void readString(char string[32])
{
    int i;
    char c;

    i = 0;
    while (dataReadyUART(Bluetooth_LineStatusReg))
    {
        c = readCharUART(Bluetooth_LineStatusReg, Bluetooth_ReceiverFifo);
        string[i++] = c;
    }

    string[i] = '\0';
}