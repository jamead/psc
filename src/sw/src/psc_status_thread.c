/********************************************************************
*  PSC Status Thread
*  J. Mead
*  4-17-24
*
*  This thread is responsible for sending all slow data (10Hz) to the IOC.   It does
*  this over to message ID's (30 = slow status, 31 = 10Hz data)
*
*  It starts a listening server on
*  port 600.  Upon establishing a connection with a client, it begins to send out
*  packets containing all 10Hz updated data.
********************************************************************/

#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xiicps.h"


#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "lwipopts.h"
#include "xil_printf.h"
#include "FreeRTOS.h"
#include "task.h"

/* Hardware support includes */
#include "psc_defs.h"
#include "pl_regs.h"
#include "psc_msg.h"


#define PORT  600

extern XIicPs IicPsInstance;

extern u32 UptimeCounter;
extern struct SAdataMsg sadata;



float power(float base, int exponent) {
    float result = 1.0;
    int i;

    // Handle negative exponents by inverting the base and using positive exponent
    if (exponent < 0) {
        base = 1.0 / base;
        exponent = -exponent;
    }
    for (i = 0; i < exponent; i++) {
        result *= base;
    }
    return result;
}







void i2c_sfp_get_stats(struct SysHealthMsg *p, u8 sfp_slot) {

	const float TEMP_SCALE = 256;   //Temp is a 16bit signed 2's comp integer in increments of 1/256 degree C
	const float VCC_SCALE = 10000;  //VCC is a 16bit unsigned int in increments of 100uV
	const float TXBIAS_SCALE = 2000; //TxBias is a 16 bit unsigned integer in increments of 2uA
	const float PWR_SCALE = 10000;  //Tx and Rx Pwr is 16 bit unsigned integer in increments of 0.1uW

	s32 status;
    u8 addr = 0x51;  //SFP A2 address space
    u8 txBuf[3] = {96};
    u8 rxBuf[10] = {0,0,0,0,0,0,0,0,0,0};

	i2c_set_port_expander(I2C_PORTEXP0_ADDR,(1 << sfp_slot));
	i2c_set_port_expander(I2C_PORTEXP1_ADDR,0);
	//read 10 bytes starting at address 96 (see data sheet)
    i2c_write(txBuf,1,addr);
    status = i2c_read(rxBuf,10,addr);
    if (status != XST_SUCCESS) {
    	//No SFP module was found, read error, set all values to zero
    	p->sfp_temp[sfp_slot] = 0;
        p->sfp_vcc[sfp_slot] = 0;
        p->sfp_txbias[sfp_slot] = 0;
        p->sfp_txpwr[sfp_slot] = 0;
        p->sfp_rxpwr[sfp_slot] = 0;
    }
    else {
    	p->sfp_temp[sfp_slot]   = (float) ((rxBuf[0] << 8) | (rxBuf[1])) / TEMP_SCALE;
    	p->sfp_vcc[sfp_slot]    = (float) ((rxBuf[2] << 8) | (rxBuf[3])) / VCC_SCALE;
    	p->sfp_txbias[sfp_slot] = (float) ((rxBuf[4] << 8) | (rxBuf[5])) / TXBIAS_SCALE;
    	p->sfp_txpwr[sfp_slot]  = (float) ((rxBuf[6] << 8) | (rxBuf[7])) / PWR_SCALE;
    	p->sfp_rxpwr[sfp_slot]  = (float) ((rxBuf[8] << 8) | (rxBuf[9])) / PWR_SCALE;
    }
   /*
    xil_printf("SFP Slot : %d\r\n",sfp_slot);
    printf("SFP Temp = %f\r\n", p->sfp_temp[sfp_slot]);
    printf("SFP VCC = %f\r\n", p->sfp_vcc[sfp_slot]);
    printf("SFP txbias = %f\r\n", p->sfp_txbias[sfp_slot]);
    printf("SFP Tx Pwr = %f\r\n", p->sfp_txpwr[sfp_slot]);
    printf("SFP Rx Pwr = %f\r\n", p->sfp_rxpwr[sfp_slot]);
    xil_printf("\r\n");
    */

}





void Host2NetworkConvStatus(char *inbuf, int len) {

    int i;
    u8 temp;
    //Swap bytes to reverse the order within the 4-byte segment
    //Start at byte 8 (skip the PSC Header)
    for (i=8;i<len;i=i+4) {
    	temp = inbuf[i];
    	inbuf[i] = inbuf[i + 3];
    	inbuf[i + 3] = temp;
    	temp = inbuf[i + 1];
    	inbuf[i + 1] = inbuf[i + 2];
    	inbuf[i + 2] = temp;
    }

}





void ReadSAData(char *msg) {

    u32 *msg_u32ptr;
    //struct SAdataMsg sadata;
    u32 chan;
    u32 base;



    //write the PSC header
    msg_u32ptr = (u32 *)msg;
    msg[0] = 'P';
    msg[1] = 'S';
    msg[2] = 0;
    msg[3] = (short int) MSGSTAT10Hz;
    *++msg_u32ptr = htonl(MSGSTAT10HzLEN); //body length

    sadata.count = UptimeCounter;

    sadata.evr_ts_s =  Xil_In32(XPAR_M_AXI_BASEADDR + EVR_TS_S);
    sadata.evr_ts_ns =  Xil_In32(XPAR_M_AXI_BASEADDR + EVR_TS_NS);
    //xil_printf("%d  %d\r\n",sadata.evr_ts_s, sadata.evr_ts_ns);


    for (chan=0; chan<4; chan++) {
       base = XPAR_M_AXI_BASEADDR + (chan + 1) * CHBASEADDR;
       //ADC's
       sadata.ps[chan].dcct1 = Xil_In32(base + DCCT1_REG);
       sadata.ps[chan].dcct1_offset = Xil_In32(base + DCCT1_OFFSET_REG);
       sadata.ps[chan].dcct1_gain = Xil_In32(base + DCCT1_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].dcct2 = Xil_In32(base + DCCT2_REG);
       sadata.ps[chan].dcct2_offset = Xil_In32(base + DCCT2_OFFSET_REG);
       sadata.ps[chan].dcct2_gain = Xil_In32(base + DCCT2_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].dacmon = Xil_In32(base + DACMON_REG);
       sadata.ps[chan].dacmon_offset = Xil_In32(base + DACMON_OFFSET_REG);
       sadata.ps[chan].dacmon_gain = Xil_In32(base + DACMON_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].volt = Xil_In32(base + VOLT_REG);
       sadata.ps[chan].volt_offset = Xil_In32(base + VOLT_OFFSET_REG);
       sadata.ps[chan].volt_gain = Xil_In32(base + VOLT_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].gnd = Xil_In32(base + GND_REG);
       sadata.ps[chan].gnd_offset = Xil_In32(base + GND_OFFSET_REG);
       sadata.ps[chan].gnd_gain = Xil_In32(base + GND_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].spare = Xil_In32(base + SPARE_REG);
       sadata.ps[chan].spare_offset = Xil_In32(base + SPARE_OFFSET_REG);
       sadata.ps[chan].spare_gain = Xil_In32(base + SPARE_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].reg = Xil_In32(base + REG_REG);
       sadata.ps[chan].reg_offset = Xil_In32(base + REG_OFFSET_REG);
       sadata.ps[chan].reg_gain = Xil_In32(base + REG_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].error = Xil_In32(base + ERR_REG);
       sadata.ps[chan].error_offset = Xil_In32(base + ERR_OFFSET_REG);
       sadata.ps[chan].error_gain = Xil_In32(base + ERR_GAIN_REG) / GAIN20BITFRACT;

       //DAC
       sadata.ps[chan].dac_setpt = Xil_In32(base + DAC_CURRSETPT_REG);
       sadata.ps[chan].dac_setpt_offset = Xil_In32(base + DAC_SETPT_OFFSET_REG);
       sadata.ps[chan].dac_setpt_gain = Xil_In32(base + DAC_SETPT_GAIN_REG) / GAIN20BITFRACT;
       printf("Chan: %d   DAC Gain: %f\r\n",chan,sadata.ps[chan].dac_setpt_gain);
       sadata.ps[chan].dac_rampactive = Xil_In32(base + DAC_RAMPACTIVE_REG);


       //Faults
       sadata.ps[chan].ovc1_thresh = Xil_In32(base + OVC1_THRESH_REG);
       sadata.ps[chan].ovc2_thresh = Xil_In32(base + OVC2_THRESH_REG);
       sadata.ps[chan].ovv_thresh = Xil_In32(base + OVV_THRESH_REG);
       sadata.ps[chan].err1_thresh = Xil_In32(base + ERR1_THRESH_REG);
       sadata.ps[chan].err2_thresh = Xil_In32(base + ERR2_THRESH_REG);
       sadata.ps[chan].ignd_thresh = Xil_In32(base + IGND_THRESH_REG);
       sadata.ps[chan].ovc1_cntlim = Xil_In32(base + OVC1_CNTLIM_REG);
       sadata.ps[chan].ovc2_cntlim = Xil_In32(base + OVC2_CNTLIM_REG);
       sadata.ps[chan].ovv_cntlim = Xil_In32(base + OVV_CNTLIM_REG);
       sadata.ps[chan].err1_cntlim = Xil_In32(base + ERR1_CNTLIM_REG);
       sadata.ps[chan].err2_cntlim = Xil_In32(base + ERR2_CNTLIM_REG);
       sadata.ps[chan].ignd_cntlim = Xil_In32(base + IGND_CNTLIM_REG);

       sadata.ps[chan].dcct_cntlim = Xil_In32(base + DCCT_CNTLIM_REG);
       sadata.ps[chan].flt1_cntlim = Xil_In32(base + FLT1_CNTLIM_REG);
       sadata.ps[chan].flt2_cntlim = Xil_In32(base + FLT2_CNTLIM_REG);
       sadata.ps[chan].flt3_cntlim = Xil_In32(base + FLT3_CNTLIM_REG);
       sadata.ps[chan].on_cntlim = Xil_In32(base + ON_CNTLIM_REG);
       sadata.ps[chan].heartbeat_cntlim = Xil_In32(base + HEARTBEAT_CNTLIM_REG);

       sadata.ps[chan].fault_clear = Xil_In32(base + FAULT_CLEAR_REG);
       sadata.ps[chan].fault_mask = Xil_In32(base + FAULT_MASK_REG);
       sadata.ps[chan].digout_on1 = Xil_In32(base + DIGOUT_ON1_REG);
       sadata.ps[chan].digout_on2 = Xil_In32(base + DIGOUT_ON1_REG);
       sadata.ps[chan].digout_reset = Xil_In32(base + DIGOUT_ON1_REG);
       sadata.ps[chan].digout_spare = Xil_In32(base + DIGOUT_RESET_REG);
       sadata.ps[chan].digout_park = Xil_In32(base + DIGOUT_PARK_REG);
       sadata.ps[chan].digin = Xil_In32(base + DIGIN_REG);

       sadata.ps[chan].faults_live = Xil_In32(base + FAULTS_LIVE_REG);
       sadata.ps[chan].faults_latched = Xil_In32(base + FAULTS_LAT_REG);

    }



    //copy the structure to the PSC msg buffer
    memcpy(&msg[MSGHDRLEN],&sadata,sizeof(sadata));

}




/*

void ReadSysInfo(char *msg) {

    u32 *msg_u32ptr;
    u8 i;
    struct SysHealthMsg syshealth;

    //write the PSC header
    msg_u32ptr = (u32 *)msg;
    msg[0] = 'P';
    msg[1] = 'S';
    msg[2] = 0;
    msg[3] = (short int) MSGID32;
    *++msg_u32ptr = htonl(MSGID32LEN); //body length

    //write the PSC message

    //read FPGA version (git checksum) from PL register
    syshealth.git_shasum = Xil_In32(XPAR_M_AXI_BASEADDR + GIT_SHASUM);


    // read board temps, power V,I
    syshealth.dfe_temp[0] = (float) Xil_In32(XPAR_M_AXI_BASEADDR + TEMP_SENSE0_REG) / 128;
    syshealth.dfe_temp[1] = (float) Xil_In32(XPAR_M_AXI_BASEADDR + TEMP_SENSE1_REG) / 128;
    syshealth.pwr_vin = (float) Xil_In32(XPAR_M_AXI_BASEADDR + PWR_VIN_REG) * 0.00125;
    syshealth.pwr_iin = (float) Xil_In32(XPAR_M_AXI_BASEADDR + PWR_IIN_REG) * 0.1;



    // read SFP status information from i2c bus
    for (i=0;i<=5;i++)
       i2c_sfp_get_stats(&syshealth, i);


    // Read the Uptime counter
    syshealth.uptime = UptimeCounter;
    //xil_printf("Uptime: %d\r\n",UptimeCounter);

    //copy the syshealth structure to the PSC msg buffer
    memcpy(&msg[MSGHDRLEN],&syshealth,sizeof(syshealth));

}

*/


void psc_status_thread()
{

	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;
    int n,loop=0;
    //u32 ssbufptr, totaltrigs;



    xil_printf("Starting PSC Status Server...\r\n");

	// Initialize socket structure
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(PORT);
	serv_addr.sin_addr.s_addr = INADDR_ANY;

    // First call to socket() function
	if ((sockfd = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		xil_printf("Error: PSC Status : Creating Socket");
	}


    // Bind to the host address using bind()
	if (lwip_bind(sockfd, (struct sockaddr *)&serv_addr, sizeof (serv_addr)) < 0) {
		xil_printf("Error: PSC Status : Creating Socket");
		//vTaskDelete(NULL);
	}


    // Now start listening for the clients
	lwip_listen(sockfd, 0);


    xil_printf("PSC Status Server listening on port %d...\r\n",PORT);


reconnect:

	clilen = sizeof(cli_addr);

	newsockfd = lwip_accept(sockfd, (struct sockaddr *)&cli_addr, (socklen_t *)&clilen);
	if (newsockfd < 0) {
	    xil_printf("PSC Status: ERROR on accept\r\n");
	}
	/* If connection is established then start communicating */
	xil_printf("PSC Status: Connected Accepted...\r\n");




	while (1) {

		//xil_printf("In Status main loop...\r\n");
		vTaskDelay(pdMS_TO_TICKS(100));
		//ssbufptr = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_ADDRPTR);
		//totaltrigs = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_TOTALTRIGS);
		//xil_printf("BufPtr: %x\t TotalTrigs: %d\r\n",ssbufptr,totaltrigs);


        ReadSAData(msgStat10Hz_buf);
        //write 10Hz msg31 packet
        Host2NetworkConvStatus(msgStat10Hz_buf,sizeof(msgStat10Hz_buf)+MSGHDRLEN);
	    n = write(newsockfd,msgStat10Hz_buf,MSGSTAT10HzLEN+MSGHDRLEN);
        if (n < 0) {
          printf("Status socket: ERROR writing MSG 31 - Pos Info\n");
          close(newsockfd);
          goto reconnect;
        }


		loop++;



	}

	/* close connection */
	close(newsockfd);
	vTaskDelete(NULL);
}


