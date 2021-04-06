//Bluetooth address range 0xFF21_0200 - 0xFF21_020F 
#define Bluetooth_ReceiverFifo ((volatile unsigned char *)(0xFF211000))
#define Bluetooth_TransmitterFifo ((volatile unsigned char *)(0xFF211000))
#define Bluetooth_InterruptEnableReg ((volatile unsigned char *)(0xFF211002))
#define Bluetooth_InterruptIdentificationReg ((volatile unsigned char *)(0xFF211004))
#define Bluetooth_FifoControlReg ((volatile unsigned char *)(0xFF211004))
#define Bluetooth_LineControlReg ((volatile unsigned char *)(0xFF211006))
#define Bluetooth_ModemControlReg ((volatile unsigned char *)(0xFF211008))
#define Bluetooth_LineStatusReg ((volatile unsigned char *)(0xFF21100A))
#define Bluetooth_ModemStatusReg ((volatile unsigned char *)(0xFF21100C))
#define Bluetooth_ScratchReg ((volatile unsigned char *)(0xFF21100E))
#define Bluetooth_DivisorLatchLSB ((volatile unsigned char *)(0xFF211000))
#define Bluetooth_DivisorLatchMSB ((volatile unsigned char *)(0xFF211002))

void initBluetooth(void);
void writeStringBT(char *string);
void readStringBT(char string[32]);
