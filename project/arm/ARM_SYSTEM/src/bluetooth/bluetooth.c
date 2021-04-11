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
#include "stdlib.h"
#include "stdint.h"
#include "alt_clock_manager.h"
#include "alt_globaltmr.h"
#include "../delay/delay.h"
#include "string.h"
#include "stdio.h"


void initBluetooth()
{
    initUART(115200, Bluetooth_LineControlReg, Bluetooth_DivisorLatchLSB, Bluetooth_DivisorLatchMSB, Bluetooth_FifoControlReg);
    flushUART(Bluetooth_LineStatusReg, Bluetooth_ReceiverFifo);
}

void writeStringBT(char *string)
{
    writeStringUART(string, Bluetooth_LineStatusReg, Bluetooth_TransmitterFifo);
}

/*
 * returns number of bytes read
 */
int readStringBT(char string[32])
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
    return i;
}

int readStringUsingProtocol(char string[64]){
	char buffer[64];
	int bytes_read = 0;
	memset(string, 0, sizeof(string));
	memset(buffer, 0, sizeof(string));


	while(bytes_read<MESSAGE_STRING_BEGIN){
		char s[32];
		bytes_read += readStringBT(s);
		strcat(buffer, s);
	}

	char stringSize[MESSAGE_STRING_BEGIN];
	memcpy(stringSize, buffer, MESSAGE_STRING_BEGIN*sizeof(char));

	int full_string_size = atoi(stringSize);

	int remaining_string_size = full_string_size - (bytes_read - MESSAGE_STRING_BEGIN);

	int remaining_bytes_read = 0;

	if(remaining_string_size < 0){
		printf(" ERROR: received string larger than given size \n");
		flushUART(Bluetooth_LineStatusReg, Bluetooth_ReceiverFifo);
		return -1;
	}
	uint64_t end_time;

	end_time = getEndTimeFromCurr(5000000);

	while(remaining_bytes_read < remaining_string_size) {
		char s[32];
		remaining_bytes_read += readStringBT(s);
		strcat(buffer, s);

		if(alt_globaltmr_get64()> end_time){
			printf("ERROR READING BLUETOOTH: TIMEOUT, COULD NOT READ STRING PAYLOAD\n");
			flushUART(Bluetooth_LineStatusReg, Bluetooth_ReceiverFifo);
			return -1;
		}
	}

	memcpy(string, buffer+MESSAGE_STRING_BEGIN,full_string_size);
	string[full_string_size] = '\0';
	flushUART(Bluetooth_LineStatusReg, Bluetooth_ReceiverFifo);
	return 0;
}
















