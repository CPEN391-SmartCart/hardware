#ifndef UART_H__
#define UART_H__

void initUART(
    int baud_rate,
    volatile unsigned char *LineControlReg,
    volatile unsigned char *DivisorLatchLSB,
    volatile unsigned char *DivisorLatchMSB,
    volatile unsigned char *FifoControlReg);

void writeStringUART(char *string, volatile unsigned char *LineStatusReg, volatile unsigned char *TransmitterFifo);
void writeCharUART(char c, volatile unsigned char *LineStatusReg, volatile unsigned char *TransmitterFifo);
int readCharUART(volatile unsigned char *LineStatusReg, volatile unsigned char *ReceiverFifo);
void flushUART(volatile unsigned char *, volatile unsigned char *);
int dataReadyUART(volatile unsigned char *LineStatusReg);
void enableUARTInterrupt(volatile unsigned char *interruptEnableReg);

#endif
