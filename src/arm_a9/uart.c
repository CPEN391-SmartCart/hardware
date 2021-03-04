/**************************************************************************
/* Subroutine to initialise the Bluetooth Port by writing some data
** to the internal registers.
** Call this function at the start of the program before you attempt
** to read or write to data via the Bluetooth port
**
** Refer to UART data sheet for details of registers and programming
***************************************************************************/

#include "uart.h"

void initUART(
    int baud_rate,
    volatile unsigned char *LineControlReg,
    volatile unsigned char *DivisorLatchLSB,
    volatile unsigned char *DivisorLatchMSB,
    volatile unsigned char *FifoControlReg)
{
    /************** Initialize Bluetooth UART registers **************/

    // set bit 7 of Line Control Register to 1, to gain access to the baud rate registers
    *LineControlReg = *LineControlReg | 0x80;

    // set Divisor latch (LSB and MSB) with correct value for required baud rate
    if (baud_rate == 9600)
    {
        *DivisorLatchLSB = 0x45;
        *DivisorLatchMSB = 0x01;
    }
    else if (baud_rate == 38400)
    {
        *DivisorLatchLSB = 0x51;
        *DivisorLatchMSB = 0x00;
    }
    else if (baud_rate == 115200)
    {
        *DivisorLatchLSB = 0x1B;
        *DivisorLatchMSB = 0x00;
    }

    // set bit 7 of Line control register back to 0 and
    // program other bits in that reg for 8 bit data,
    // 1 stop bit, no parity etc
    *LineControlReg = 0x03;

    // Reset the Fifo’s in the FiFo Control Reg by setting bits 1 & 2
    *FifoControlReg = *FifoControlReg | 0x06;

    // Now Clear all bits in the FiFo control registers
    *FifoControlReg = *FifoControlReg ^ 0x06;
}

void writeStringUART(char *string, volatile unsigned char *LineStatusReg, volatile unsigned char *TransmitterFifo)
{
    int i;
    char c;

    for (i = 0; ((c = string[i]) != '\0'); i++)
    {
        writeCharUART(c, LineStatusReg, TransmitterFifo);
    }
}

void writeCharUART(char c, volatile unsigned char *LineStatusReg, volatile unsigned char *TransmitterFifo)
{
    // wait for Transmitter Holding Register bit (5) of line status register to be '1'
    // indicating we can write to the device
    while ((*LineStatusReg & 0x20) != 0x20);

    // write character to Transmitter fifo register
    *TransmitterFifo = (unsigned char)c;
}

int dataReadyUART(volatile unsigned char *LineStatusReg)
{
    return (*LineStatusReg & 0x01 == 0x01) ? TRUE : FALSE;
}

int readCharUART(volatile unsigned char *LineStatusReg, volatile unsigned char *ReceiverFifo)
{
    // wait for Data Ready bit (0) of line status register to be '1'
    while ((*LineStatusReg & 0x01) != 0x01);

    // return new character from ReceiverFiFo register
    return (int)*ReceiverFifo;
}

void flushUART(volatile unsigned char *LineStatusReg, volatile unsigned char *ReceiverFifo)
{
    // while bit 0 of Line Status Register == ‘1’
    // read unwanted char out of fifo receiver buffer
    int unwanted_char;
    while ((*LineStatusReg & 0x01) == 0x01)
    {
        unwanted_char = *ReceiverFifo;
    }
}
