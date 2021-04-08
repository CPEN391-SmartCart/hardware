
#include "imu.h"

void pinmux_config()
{
	*SYSMGR_I2C0USEFPGA = 0;
	*SYSMGR_GENERALIO7 = 1;
	*SYSMGR_GENERALIO8 = 1;
}

void I2C0_init()
{

	*I2C0_ENABLE = 2;

	while (((*I2C0_ENABLE_STATUS) & 0x1) == 1);

	*I2C0_CON = 0x65;

	*I2C0_TAR = 0x53;

	*I2C0_FS_SCL_HCNT = 60 + 30;
	*I2C0_FS_SCL_LCNT = 130 + 30;

	*I2C0_ENABLE = 1;

	while (((*I2C0_ENABLE_STATUS) & 0x1) == 0);
}

void ADXL345_REG_READ(uint8_t address, uint8_t *value)
{
	*I2C0_DATA_CMD = address + 0x400;

	*I2C0_DATA_CMD = 0x100;

	while (*I2C0_RXFLR == 0);
	*value = *I2C0_DATA_CMD;
}

void ADXL345_REG_WRITE(uint8_t address, uint8_t value)
{
	*I2C0_DATA_CMD = address + 0x400;

	*I2C0_DATA_CMD = value;
}

void ADXL345_REG_MULTI_READ(uint8_t address, uint8_t values[], uint8_t len)
{
	*I2C0_DATA_CMD = address + 0x400;

	int i;
	for (i = 0; i < len; i++)
	{
		*I2C0_DATA_CMD = 0x100;
	}

	int nth_byte = 0;
	while (len)
	{
		if ((*I2C0_RXFLR) > 0)
		{
			values[nth_byte] = *I2C0_DATA_CMD;
			nth_byte++;
			len--;
		}
	}
}

void ADXL345_init()
{
	ADXL345_REG_WRITE(ADXL345_REG_DATA_FORMAT, XL345_RANGE_16G |XL345_FULL_RESOLUTION);

	ADXL345_REG_WRITE(ADXL345_REG_BW_RATE, XL345_RATE_200);

	ADXL345_REG_WRITE(ADXL345_REG_THRESH_ACT, 0x04);
	ADXL345_REG_WRITE(ADXL345_REG_THRESH_INACT, 0x02);

	ADXL345_REG_WRITE(ADXL345_REG_TIME_INACT, 0x02);
	ADXL345_REG_WRITE(ADXL345_REG_ACT_INACT_CTL, 0xFF);

	ADXL345_REG_WRITE(ADXL345_REG_INT_ENABLE, XL345_ACTIVITY | XL345_INACTIVITY);
	ADXL345_REG_WRITE(ADXL345_REG_POWER_CTL, XL345_STANDBY);

	ADXL345_REG_WRITE(ADXL345_REG_POWER_CTL, XL345_MEASURE);
}

void ADXL345_XYZ_read(int16_t szData16[3])
{
	uint8_t szData8[6];
	ADXL345_REG_MULTI_READ(0x32, (uint8_t*)&szData8,sizeof(szData8));

	szData16[0] = (szData8[1] << 8) | szData8[0];
	szData16[1] = (szData8[3] << 8) | szData8[2];
	szData16[2] = (szData8[5] << 8) | szData8[4];
}

bool ADXL345_is_data_ready()
{
	bool bReady = false;
	uint8_t data8;

	ADXL345_REG_READ(ADXL345_REG_INT_SOURCE, &data8);
	if (data8 & XL345_ACTIVITY)
	{
		bReady = true;
	}

	return bReady;
}

