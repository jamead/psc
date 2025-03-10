#include "xparameters.h"
#include "xiicps.h"
#include "zubpm_defs.h"
#include <sleep.h>
#include "xil_printf.h"
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"


extern XIicPs IicPsInstance;			/* Instance of the IIC Device */


static const u32 lmk61e2_values [] = {
		0x0010, 0x010B, 0x0233, 0x08B0, 0x0901, 0x1000, 0x1180, 0x1502,
		0x1600, 0x170F, 0x1900, 0x1A2E, 0x1B00, 0x1C00, 0x1DA9, 0x1E00,
		0x1F00, 0x20C8, 0x2103, 0x2224, 0x2327, 0x2422, 0x2502, 0x2600,
		0x2707, 0x2F00, 0x3000, 0x3110, 0x3200, 0x3300, 0x3400, 0x3500,
		0x3800, 0x4802,
};



void init_i2c() {
    //s32 Status;
    XIicPs_Config *ConfigPtr;


    // Look up the configuration in the config table
    ConfigPtr = XIicPs_LookupConfig(0);
    //if(ConfigPtr == NULL) return XST_FAILURE;

    // Initialize the II2 driver configuration
    XIicPs_CfgInitialize(&IicPsInstance, ConfigPtr, ConfigPtr->BaseAddress);
    //if(Status != XST_SUCCESS) return XST_FAILURE;

    //set i2c clock rate to 100KHz
    XIicPs_SetSClk(&IicPsInstance, 100000);
}


s32 i2c_write(u8 *buf, u8 len, u8 addr) {

	s32 status;

	while (XIicPs_BusIsBusy(&IicPsInstance));
	status = XIicPs_MasterSendPolled(&IicPsInstance, buf, len, addr);
	return status;
}

s32 i2c_read(u8 *buf, u8 len, u8 addr) {

	s32 status;

	while (XIicPs_BusIsBusy(&IicPsInstance));
    status = XIicPs_MasterRecvPolled(&IicPsInstance, buf, len, addr);
    return status;

}



// 24AA025E48 EEPROM  --------------------------------------
#define IIC_EEPROM_ADDR 0x50
#define IIC_MAC_REG 0xFA

void i2c_get_mac_address(u8 *mac){
	i2c_set_port_expander(I2C_PORTEXP1_ADDR,0x80);
    u8 buf[6] = {0};
    buf[0] = IIC_MAC_REG;
    i2c_write(buf,1,IIC_EEPROM_ADDR);
    i2c_read(mac,6,IIC_EEPROM_ADDR);
    xil_printf("EEPROM MAC ADDR = %2x %2x %2x %2x %2x %2x\r\n",mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
    //iic_chp_recv_repeated_start(buf, 1, mac, 6, IIC_EEPROM_ADDR);
}




void i2c_eeprom_writeBytes(u8 startAddr, u8 *data, u8 len){
	i2c_set_port_expander(I2C_PORTEXP1_ADDR,0x80);
    u8 buf[len + 1];
    buf[0] = startAddr;
    for(int i = 0; i < len; i++) buf[i+1] = data[i];
    i2c_write(buf, len + 1, IIC_EEPROM_ADDR);
}


void i2c_eeprom_readBytes(u8 startAddr, u8 *data, u8 len){
	u8 buf[] = {startAddr};
	i2c_set_port_expander(I2C_PORTEXP1_ADDR,0x80);
    i2c_write(buf,1,IIC_EEPROM_ADDR);
    i2c_read(data,len,IIC_EEPROM_ADDR);
    //u8 buf[] = {startAddr};
    //iic_chp_recv_repeated_start(buf, 1, data, len, IIC_EEPROM_ADDR);
    //iic_pe_disable(2, 0);
}



void eeprom_dump()
{
  u8 rdBuf[129];
  memset(rdBuf, 0xFF, sizeof(rdBuf));
  rdBuf[128] = 0;
  i2c_eeprom_readBytes(0, rdBuf, 128);

  printf("Read EEPROM:\r\n\r\n");
  printf("%s\r\n", rdBuf);

  for (int i = 0; i < 128; i++)
  {
    if ((i % 16) == 0)
      printf("\r\n0x%02x:  ", i);
    printf("%02x  ", rdBuf[i]);
  }
  printf("\r\n");
}







void i2c_set_port_expander(u32 addr, u32 port)  {

    u8 buf[3];
    u32 len=1;

    buf[0] = port;
    buf[1] = 0;
    buf[2] = 0;

	while (XIicPs_BusIsBusy(&IicPsInstance));
    XIicPs_MasterSendPolled(&IicPsInstance, buf, len, addr);
}


void write_lmk61e2()
{
   u8 buf[4] = {0};
   u32 regval, i;


   u32 num_values = sizeof(lmk61e2_values) / sizeof(lmk61e2_values[0]);  // Get the number of elements in the array

   i2c_set_port_expander(I2C_PORTEXP1_ADDR,0x20);
   for (i=0; i<num_values; i++) {
	  regval = lmk61e2_values[i];
      buf[0] = (char) ((regval & 0x00FF00) >> 8);
      buf[1] = (char) (regval & 0xFF);
      i2c_write(buf,2,0x5A);
      printf("LMK61e2 Write = 0x%x\t    B0 = %x    B1 = %x\n",regval, buf[0], buf[1]);
   };




}




/*
void i2c_sfp_get_stats(struct SysHealthStatsMsg *p, u8 sfp_slot) {

    u8 addr = 0x51;  //SFP A2 address space
    u8 buf[10];
    u32 temp;
    float tempflt;

    buf[0] = 96;  //offset location


	i2c_set_port_expander(I2C_PORTEXP0_ADDR,1);
	i2c_set_port_expander(I2C_PORTEXP1_ADDR,0);
	//read 10 bytes starting at address 96 (see data sheet)
    i2c_write(buf,1,addr);
    i2c_read(buf,10,addr);
    temp = (buf[0] << 8) | (buf[1]);
    p->sfp_temp[0] = (float)temp/256.0;
    printf("SFP Temp = %f\r\n", p->sfp_temp[sfp_slot]);

    temp = (buf[2] << 8) | (buf[3]);
    tempflt = (float)temp/10000.0;

    printf("SFP VCC = %f\r\n", tempflt);
    temp = (buf[4] << 8) | (buf[5]);
    tempflt = (float)temp/200.0;
    printf("SFP Tx Laser Bias = %f\r\n", tempflt);
    temp = (buf[6] << 8) | (buf[7]);
    tempflt = (float)temp/10000.0;
    printf("SFP Tx Pwr = %f\r\n", tempflt);
    temp = (buf[8] << 8) | (buf[9]);
    tempflt = (float)temp/10000.0;
    printf("SFP Rx Pwr = %f\r\n", tempflt);

}
*/













