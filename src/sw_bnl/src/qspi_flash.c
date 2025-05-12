


/***************************** Include Files *********************************/

#include "xparameters.h"	/* SDK generated parameters */
#include "xqspips.h"		/* QSPI device driver */
#include "xil_printf.h"



#define FLASH_WRITE_CMD		        0x02
#define FLASH_READ_CMD              0x03
#define FLASH_SECTOR_ERASE_CMD      0xD8
#define FLASH_SECTOR_ERASE_SIZE		4
#define FLASH_WRITE_ENABLE_CMD      0x06
#define FLASH_READ_STATUS_CMD       0x05
#define FLASH_READ_FLAG_STATUS_CMD  0x70
#define FLASH_SECTOR_SIZE           0x10000  // 64KB per sector for Micron flash
#define FLASH_PAGE_SIZE             256      // Typical for Micron/N25Q flash

extern XQspiPs QspiInstance;




int QspiFlashInit()
{
    XQspiPs_Config *QspiConfig;
    int Status;

    QspiConfig = XQspiPs_LookupConfig(XPAR_XQSPIPS_0_DEVICE_ID);
    if (NULL == QspiConfig) {
        return XST_FAILURE;
    }

    Status = XQspiPs_CfgInitialize(&QspiInstance, QspiConfig, QspiConfig->BaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    XQspiPs_SetOptions(&QspiInstance, XQSPIPS_MANUAL_START_OPTION | XQSPIPS_FORCE_SSELECT_OPTION);
    XQspiPs_SetClkPrescaler(&QspiInstance, XQSPIPS_CLK_PRESCALE_8);

    XQspiPs_SetSlaveSelect(&QspiInstance);

    return XST_SUCCESS;
}





void QspiFlashRead(u32 Address, u32 ByteCount, u8 *ReadBuf)
{

    u8 WriteBuf[4];

    WriteBuf[0] =  FLASH_READ_CMD;
    WriteBuf[1] = (u8)((Address & 0xFF0000) >> 16);
    WriteBuf[2] = (u8)((Address & 0xFF00) >> 8);
    WriteBuf[3] = (u8)(Address & 0xFF);

    //first 4 bytes are garbage, ignore them.
    XQspiPs_PolledTransfer(&QspiInstance, WriteBuf, ReadBuf, ByteCount);

}




void QspiFlashWrite(u32 Address, u32 ByteCount, u8 *WriteBuf)
{
    // First 4 bytes are for the command, overwrites WriteBuf
	
    u8 WriteEnableCmd = { FLASH_WRITE_ENABLE_CMD };
    u8 ReadStatusCmd[] = { FLASH_READ_STATUS_CMD, 0 };  /* Must send 2 bytes */
    u8 FlashStatus[2];

    // Send the write enable command to the Flash so that it can be
    // written to, this needs to be sent as a separate transfer before the write
    XQspiPs_PolledTransfer(&QspiInstance, &WriteEnableCmd, NULL, sizeof(WriteEnableCmd));

    // Setup the write command with the specified address and data for the Flash
    WriteBuf[0] = FLASH_WRITE_CMD;
    WriteBuf[1] = (u8)((Address & 0xFF0000) >> 16);
    WriteBuf[2] = (u8)((Address & 0xFF00) >> 8);
    WriteBuf[3] = (u8)(Address & 0xFF);

	
    // Send the write command, address, and data to the Flash to be
    // written, no receive buffer is specified since there is nothing to receive
    XQspiPs_PolledTransfer(&QspiInstance, WriteBuf, NULL, ByteCount);



    // Wait for the write command to the Flash to be completed, it takes
    // some time for the data to be written
    while (1) {		
        // Poll the status register of the Flash to determine when it
        // completes, by sending a read status command and receiving the
        // status byte
        XQspiPs_PolledTransfer(&QspiInstance, ReadStatusCmd, FlashStatus,sizeof(ReadStatusCmd));
        if ((FlashStatus[1] & 0x01) == 0) {
            break;
	}
    }

}



void QspiFlashEraseSect(u32 sector)
{
    u8 WriteEnableCmd = { FLASH_WRITE_ENABLE_CMD };
    u8 ReadStatusCmd[] = { FLASH_READ_STATUS_CMD, 0 };  /* Must send 2 bytes */
    u8 FlashStatus[2];
    u8 WriteBuf[4];
    u32 Address;

    Address = sector * FLASH_SECTOR_SIZE;
    // Send the write enable command to the EEPROM so that it can be
    // written to, this needs to be sent as a separate transfer
    // before the write
    XQspiPs_PolledTransfer(&QspiInstance, &WriteEnableCmd, NULL, sizeof(WriteEnableCmd));

    // Setup the write command with the specified address and data for the Flash
    WriteBuf[0] = FLASH_SECTOR_ERASE_CMD;
    WriteBuf[1] = (u8)((Address >> 16) & 0xFF);
    WriteBuf[2] = (u8)((Address >> 8) & 0xFF);
    WriteBuf[3] = (u8)(Address & 0xFF);


    // Send the sector erase command and address; no receive buffer
    // is specified since there is nothing to receive
    XQspiPs_PolledTransfer(&QspiInstance, WriteBuf, NULL, FLASH_SECTOR_ERASE_SIZE);


    // Wait for the sector erase command to the Flash to be competed
    while (1) {
        // Poll the status register of the device to determine
        // when it completes, by sending a read status command
        // and receiving the status byte
        XQspiPs_PolledTransfer(&QspiInstance, ReadStatusCmd,FlashStatus,sizeof(ReadStatusCmd));
        if ((FlashStatus[1] & 0x01) == 0)
           break;
    }
}







