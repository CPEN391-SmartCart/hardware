//Bluetooth address range 0xFF21_0200 - 0xFF21_020F 
#define WiFi_ReceiverFifo ((volatile unsigned char *)(0xFF210210))
#define WiFi_TransmitterFifo ((volatile unsigned char *)(0xFF210210))
#define WiFi_InterruptEnableReg ((volatile unsigned char *)(0xFF210212))
#define WiFi_InterruptIdentificationReg ((volatile unsigned char *)(0xFF210214))
#define WiFi_FifoControlReg ((volatile unsigned char *)(0xFF210214))
#define WiFi_LineControlReg ((volatile unsigned char *)(0xFF210216))
#define WiFi_ModemControlReg ((volatile unsigned char *)(0xFF210218))
#define WiFi_LineStatusReg ((volatile unsigned char *)(0xFF21021A))
#define WiFi_ModemStatusReg ((volatile unsigned char *)(0xFF21021C))
#define WiFi_ScratchReg ((volatile unsigned char *)(0xFF21021E))
#define WiFi_DivisorLatchLSB ((volatile unsigned char *)(0xFF210210))
#define WiFi_DivisorLatchMSB ((volatile unsigned char *)(0xFF210212))

#define WIFI_RST (volatile unsigned int *)(0xFF200060)
#define WIFI_CTS (volatile unsigned int *)(0xFF200070)

void initWiFi(int baud_rate);
void resetWiFi(void);
void writeStringWIFI(char *string);
void readStringWIFI(char string[32]);
void readStringTillSizeWIFI(char *string, int size);
