/**************************************************************************
* Subroutine to initialise the Bluetooth Port by writing some data
** to the internal registers.
** Call this function at the start of the program before you attempt
** to read or write to data via the Bluetooth port
**
** Refer to UART data sheet for details of registers and programming
***************************************************************************/

#include "../uart/uart.h"
#include "bluetooth.h"

void initBluetooth()
{
    initUART(115200, Bluetooth_LineControlReg, Bluetooth_DivisorLatchLSB, Bluetooth_DivisorLatchMSB, Bluetooth_FifoControlReg);
    flushUART(Bluetooth_LineStatusReg, Bluetooth_ReceiverFifo);
}

void writeStringBT(char *string)
{
    writeStringUART(string, Bluetooth_LineStatusReg, Bluetooth_TransmitterFifo);
}

void readStringBT(char string[32])
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
