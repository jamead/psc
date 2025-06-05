#include "xparameters.h"
#include "xiicps.h"
#include <sleep.h>
#include "xil_printf.h"
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"


extern XIicPs IicPsInstance0;			/* Instance of the IIC Device */
extern XIicPs IicPsInstance1;			/* Instance of the IIC Device */

#define IIC0_DEVICE_ID    XPAR_XIICPS_0_DEVICE_ID
#define IIC1_DEVICE_ID    XPAR_XIICPS_1_DEVICE_ID




// Registers to program si570 to 312.3MHz.
static const uint8_t si570_values[][2] = {
	{137, 0x10}, //Freeze DCO
	{7, 0x00},
    {8, 0xC2},
    {9, 0xBB},
    {10, 0xBE},
    {11, 0x6E},
    {12, 0x69},
    {137, 0x0},  //Unfreeze DCO
	{135, 0x40}  //Enable New Frequency
};






void init_i2c() {
    s32 Status;
    XIicPs_Config *ConfigPtr;


    // Look up the configuration in the config table
    ConfigPtr = XIicPs_LookupConfig(0);
    if(ConfigPtr == NULL) {
    	xil_printf("I2C Bus 0 Lookup failed!\r\n");
    	//return XST_FAILURE;
    }

    // Initialize the I2C driver configuration
    Status = XIicPs_CfgInitialize(&IicPsInstance0, ConfigPtr, ConfigPtr->BaseAddress);
    if(Status != XST_SUCCESS) {
    	xil_printf("I2C Bus 0 initialization failed!\r\n");
    	//return XST_FAILURE;
    }


    // Look up the configuration in the config table
    ConfigPtr = XIicPs_LookupConfig(1);
    if(ConfigPtr == NULL) {
    	xil_printf("I2C Bus 1 Lookup failed!\r\n");
    	//return XST_FAILURE;
    }

    Status = XIicPs_CfgInitialize(&IicPsInstance1, ConfigPtr, ConfigPtr->BaseAddress);
     if(Status != XST_SUCCESS) {
     	xil_printf("I2C Bus 1 initialization failed!\r\n");
     	//return XST_FAILURE;
     }

    //set i2c clock rate to 100KHz
    XIicPs_SetSClk(&IicPsInstance0, 100000);
    XIicPs_SetSClk(&IicPsInstance1, 100000);
}



s32 i2c0_write(u8 *buf, u8 len, u8 addr) {

	s32 status;

	while (XIicPs_BusIsBusy(&IicPsInstance0));
	status = XIicPs_MasterSendPolled(&IicPsInstance0, buf, len, addr);
	return status;
}

s32 i2c0_read(u8 *buf, u8 len, u8 addr) {

	s32 status;

    while (XIicPs_BusIsBusy(&IicPsInstance0)) {};
    status = XIicPs_MasterRecvPolled(&IicPsInstance0, buf, len, addr);
    return status;
}


s32 i2c1_write(u8 *buf, u8 len, u8 addr) {

	s32 status;

	while (XIicPs_BusIsBusy(&IicPsInstance1));
	status = XIicPs_MasterSendPolled(&IicPsInstance1, buf, len, addr);
	return status;
}

s32 i2c1_read(u8 *buf, u8 len, u8 addr) {

	s32 status;

    while (XIicPs_BusIsBusy(&IicPsInstance1)) {};
    status = XIicPs_MasterRecvPolled(&IicPsInstance1, buf, len, addr);
    return status;
}




void read_si570() {
   u8 i, buf[2], stat;

   xil_printf("Read si570 registers\r\n");
   for (i=0;i<6;i++) {
       buf[0] = i+7;
       i2c0_write(buf,1,0x55);
       stat = i2c0_read(buf, 1, 0x55);
       xil_printf("Stat: %d:   val0:%x  \r\n",stat, buf[0]);
	}
	xil_printf("\r\n");
}



void prog_si570() {
	u8 buf[2];

	xil_printf("Si570 Registers before re-programming...\r\n");
	read_si570();
	//Program New Registers
	for (size_t i = 0; i < sizeof(si570_values) / sizeof(si570_values[0]); i++) {
	    buf[0] = si570_values[i][0];
	    buf[1] = si570_values[i][1];
	    i2c0_write(buf, 2, 0x55);
	}
	xil_printf("Si570 Registers after re-programming...\r\n");
    read_si570();
}




// 24AA025E48 EEPROM  --------------------------------------
#define IIC_EEPROM_ADDR 0x50
#define IIC_MAC_REG 0xFA


void i2c_get_mac_address(u8 *mac){
	//i2c_set_port_expander(I2C_PORTEXP1_ADDR,0x80);
    u8 buf[6] = {0};
    buf[0] = IIC_MAC_REG;
    i2c1_write(buf,1,IIC_EEPROM_ADDR);
    i2c1_read(mac,6,IIC_EEPROM_ADDR);
    xil_printf("EEPROM MAC ADDR = %2x %2x %2x %2x %2x %2x\r\n",mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
    //iic_chp_recv_repeated_start(buf, 1, mac, 6, IIC_EEPROM_ADDR);
}




void i2c_eeprom_writeBytes(u8 startAddr, u8 *data, u8 len){
	//i2c_set_port_expander(I2C_PORTEXP1_ADDR,0x80);
    u8 buf[len + 1];
    buf[0] = startAddr;
    for(int i = 0; i < len; i++) buf[i+1] = data[i];
    i2c1_write(buf, len + 1, IIC_EEPROM_ADDR);
}


void i2c_eeprom_readBytes(u8 startAddr, u8 *data, u8 len){
	u8 buf[] = {startAddr};
	//i2c_set_port_expander(I2C_PORTEXP1_ADDR,0x80);
    i2c1_write(buf,1,IIC_EEPROM_ADDR);
    i2c1_read(data,len,IIC_EEPROM_ADDR);
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






/*
void i2c_set_port_expander(u32 addr, u32 port)  {

    u8 buf[3];
    u32 len=1;

    buf[0] = port;
    buf[1] = 0;
    buf[2] = 0;

	while (XIicPs_BusIsBusy(&IicPsInstance0));
    XIicPs_MasterSendPolled(&IicPsInstance0, buf, len, addr);
}
*/




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













