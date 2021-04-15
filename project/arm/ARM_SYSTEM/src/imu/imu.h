
/*
 * Source: ftp://ftp.intel.com/pub/fpgaup/pub/Intel_Material/17.0/Tutorials/Using_DE_Series_Accelerometer.pdf
 */

#include <stdint.h>
#include <stdbool.h>

#define SYSMGR_I2C0USEFPGA (volatile unsigned int *)(0xFFD08704)
#define SYSMGR_GENERALIO7 (volatile unsigned int *)(0xFFD0849C)
#define SYSMGR_GENERALIO8 (volatile unsigned int *)(0xFFD084A0)

#define I2C0_CON (volatile unsigned int *)(0xFFC04000)
#define I2C0_TAR (volatile unsigned int *)(0xFFC04004)
#define I2C0_DATA_CMD (volatile unsigned int *)(0xFFC04010)
#define I2C0_FS_SCL_HCNT (volatile unsigned int *)(0xFFC0401C)
#define I2C0_FS_SCL_LCNT (volatile unsigned int *)(0xFFC04020)
#define I2C0_CLR_INTR (volatile unsigned int *)(0xFFC04040)
#define I2C0_ENABLE (volatile unsigned int *)(0xFFC0406C)
#define I2C0_TXFLR (volatile unsigned int *)(0xFFC04074)
#define I2C0_RXFLR (volatile unsigned int *)(0xFFC04078)
#define I2C0_ENABLE_STATUS (volatile unsigned int *)(0xFFC0409C)

//from https://github.com/jarzebski/Arduino-ADXL345/blob/master/ADXL345.h
#define ADXL345_ADDRESS              0x53
#define ADXL345_REG_DEVID            0x00
#define ADXL345_REG_THRESH_TAP       0x1D // 1
#define ADXL345_REG_OFSX             0x1E
#define ADXL345_REG_OFSY             0x1F
#define ADXL345_REG_OFSZ             0x20
#define ADXL345_REG_DUR              0x21 // 2
#define ADXL345_REG_LATENT           0x22 // 3
#define ADXL345_REG_WINDOW           0x23 // 4
#define ADXL345_REG_THRESH_ACT       0x24 // 5
#define ADXL345_REG_THRESH_INACT     0x25 // 6
#define ADXL345_REG_TIME_INACT       0x26 // 7
#define ADXL345_REG_ACT_INACT_CTL    0x27
#define ADXL345_REG_THRESH_FF        0x28 // 8
#define ADXL345_REG_TIME_FF          0x29 // 9
#define ADXL345_REG_TAP_AXES         0x2A
#define ADXL345_REG_ACT_TAP_STATUS   0x2B
#define ADXL345_REG_BW_RATE          0x2C
#define ADXL345_REG_POWER_CTL        0x2D
#define ADXL345_REG_INT_ENABLE       0x2E
#define ADXL345_REG_INT_MAP          0x2F
#define ADXL345_REG_INT_SOURCE       0x30 // A
#define ADXL345_REG_DATA_FORMAT      0x31
#define ADXL345_REG_DATAX0           0x32
#define ADXL345_REG_DATAX1           0x33
#define ADXL345_REG_DATAY0           0x34
#define ADXL345_REG_DATAY1           0x35
#define ADXL345_REG_DATAZ0           0x36
#define ADXL345_REG_DATAZ1           0x37
#define ADXL345_REG_FIFO_CTL         0x38
#define ADXL345_REG_FIFO_STATUS      0x39

/* Bit values in BW_RATE                                                */
/* Expresed as output data rate */
#define XL345_RATE_3200       0x0f
#define XL345_RATE_1600       0x0e
#define XL345_RATE_800        0x0d
#define XL345_RATE_400        0x0c
#define XL345_RATE_200        0x0b
#define XL345_RATE_100        0x0a
#define XL345_RATE_50         0x09
#define XL345_RATE_25         0x08
#define XL345_RATE_12_5       0x07
#define XL345_RATE_6_25       0x06
#define XL345_RATE_3_125      0x05
#define XL345_RATE_1_563      0x04
#define XL345_RATE__782       0x03
#define XL345_RATE__39        0x02
#define XL345_RATE__195       0x01
#define XL345_RATE__098       0x00

/* Bit values in DATA_FORMAT                                            */

/* Register values read in DATAX0 through DATAZ1 are dependant on the
   value specified in data format.  Customer code will need to interpret
   the data as desired.                                                 */
#define XL345_RANGE_2G             0x00
#define XL345_RANGE_4G             0x01
#define XL345_RANGE_8G             0x02
#define XL345_RANGE_16G            0x03
#define XL345_DATA_JUST_RIGHT      0x00
#define XL345_DATA_JUST_LEFT       0x04
#define XL345_10BIT                0x00
#define XL345_FULL_RESOLUTION      0x08
#define XL345_INT_LOW              0x20
#define XL345_INT_HIGH             0x00
#define XL345_SPI3WIRE             0x40
#define XL345_SPI4WIRE             0x00
#define XL345_SELFTEST             0x80

/* Bit values in INT_ENABLE, INT_MAP, and INT_SOURCE are identical
   use these bit values to read or write any of these registers.        */
#define XL345_OVERRUN              0x01
#define XL345_WATERMARK            0x02
#define XL345_FREEFALL             0x04
#define XL345_INACTIVITY           0x08
#define XL345_ACTIVITY             0x10
#define XL345_DOUBLETAP            0x20
#define XL345_SINGLETAP            0x40
#define XL345_DATAREADY            0x80

/* Bit values in POWER_CTL                                              */
#define XL345_WAKEUP_8HZ           0x00
#define XL345_WAKEUP_4HZ           0x01
#define XL345_WAKEUP_2HZ           0x02
#define XL345_WAKEUP_1HZ           0x03
#define XL345_SLEEP                0x04
#define XL345_MEASURE              0x08
#define XL345_STANDBY              0x00
#define XL345_AUTO_SLEEP           0x10
#define XL345_ACT_INACT_SERIAL     0x20
#define XL345_ACT_INACT_CONCURRENT 0x00

// Register List
#define ADXL345_REG_DEVID       0x00
#define ADXL345_REG_POWER_CTL   0x2D
#define ADXL345_REG_DATA_FORMAT 0x31
#define ADXL345_REG_FIFO_CTL    0x38
#define ADXL345_REG_BW_RATE     0x2C
#define ADXL345_REG_INT_ENALBE  0x2E  // default value: 0x00
#define ADXL345_REG_INT_MAP     0x2F  // default value: 0x00
#define ADXL345_REG_INT_SOURCE  0x30  // default value: 0x02
#define ADXL345_REG_DATA_FORMAT 0x31  // defuault value: 0x00
#define ADXL345_REG_DATAX0      0x32  // read only
#define ADXL345_REG_DATAX1      0x33  // read only
#define ADXL345_REG_DATAY0      0x34  // read only
#define ADXL345_REG_DATAY1      0x35  // read only
#define ADXL345_REG_DATAZ0      0x36  // read only
#define ADXL345_REG_DATAZ1      0x37  // read only

/**
 * Configures the Pin Mux to connect the ADXL345 I2C wires to I2C0
 */
void pinmux_config();

/**
 * Initializes/configures I2C0
 */
void I2C0_init();

/**
 * Reads from the ADXL345 internal registers
 */
void ADXL345_REG_READ(uint8_t address, uint8_t *value);

/**
 * Writes to the ADXL345 internal registers
 */
void ADXL345_REG_WRITE(uint8_t address, uint8_t value);

/**
 * Reads len consecutive internal registers of the ADXL345
 */
void ADXL345_REG_MULTI_READ(uint8_t address, uint8_t values[], uint8_t len);

/**
 * Initializes/configures the ADXL345 mode of operation
 */
void ADXL345_init();

/**
 * Reads the acceleration data for the x, y, and z axes
 */
void ADXL345_XYZ_read(int16_t szData16[3]);

/**
 * Checks if there is new acceleration data
 */
bool ADXL345_is_data_ready();
