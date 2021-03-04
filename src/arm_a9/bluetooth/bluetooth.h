//Bluetooth address range 0xFF21_0200 - 0xFF21_020F 
#define Bluetooth_ReceiverFifo ((volatile unsigned char *)(0xFF210200))
#define Bluetooth_TransmitterFifo ((volatile unsigned char *)(0xFF210200))
#define Bluetooth_InterruptEnableReg ((volatile unsigned char *)(0xFF210202))
#define Bluetooth_InterruptIdentificationReg ((volatile unsigned char *)(0xFF210204))
#define Bluetooth_FifoControlReg ((volatile unsigned char *)(0xFF210204))
#define Bluetooth_LineControlReg ((volatile unsigned char *)(0xFF210206))
#define Bluetooth_ModemControlReg ((volatile unsigned char *)(0xFF210208))
#define Bluetooth_LineStatusReg ((volatile unsigned char *)(0xFF21020A))
#define Bluetooth_ModemStatusReg ((volatile unsigned char *)(0xFF21020C))
#define Bluetooth_ScratchReg ((volatile unsigned char *)(0xFF21020E))
#define Bluetooth_DivisorLatchLSB ((volatile unsigned char *)(0xFF210200))
#define Bluetooth_DivisorLatchMSB ((volatile unsigned char *)(0xFF210202))

void initBluetooth();
void writeString(char *string);
void readString(char string[32]);