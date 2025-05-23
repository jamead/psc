/********************************************************************
*  PSC Status Thread
*  J. Mead
*  4-17-24
*
*  This thread is responsible for sending all slow data (10Hz) to the IOC.   It does
*  this over to message ID's
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
#include "xadcps.h"
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
extern XAdcPs XAdcInstance;

extern u32 UptimeCounter;
extern struct SAdataMsg sadata;
extern ScaleFactorType scalefactors[4];

extern float CONVDACBITSTOVOLTS;



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


void ReadXadc(float *dietemp, float *vccint, float *vccaux) {


  u32 TempRaw, VccIntRaw, VccAuxRaw;

  // Read VCCINT (Core Voltage)
  VccIntRaw = XAdcPs_GetAdcData(&XAdcInstance, XADCPS_CH_VCCINT);
  *vccint = XAdcPs_RawToVoltage(VccIntRaw);

  // Read VCCAUX (Auxiliary Voltage)
  VccAuxRaw = XAdcPs_GetAdcData(&XAdcInstance, XADCPS_CH_VCCAUX);
  *vccaux = XAdcPs_RawToVoltage(VccAuxRaw);

  // Read raw temperature data
  TempRaw = XAdcPs_GetAdcData(&XAdcInstance, XADCPS_CH_TEMP);
  *dietemp = XAdcPs_RawToTemperature(TempRaw);


}

float ReadAccumSA(u32 reg_addr, u32 ave_mode) {

	s32 raw;
	float averaged;

    raw = (s32)Xil_In32(reg_addr);
    //xil_printf("Raw: %d  ",raw);
    if (ave_mode == 0)
 	   averaged = (float) raw;
    else if (ave_mode == 1)
 	   averaged = raw / 167.0;
    else if (ave_mode == 2)
 	   averaged = raw / 500.0;

   // printf("Raw: %d    Ave%f  \r\n",(int)raw, averaged);
    return averaged;
}



void ReadSAData(char *msg) {

    u32 *msg_u32ptr;
    u32 chan;
    u32 base;
    u32 ave_mode;


    //write the PSC header
    msg_u32ptr = (u32 *)msg;
    msg[0] = 'P';
    msg[1] = 'S';
    msg[2] = 0;
    msg[3] = (short int) MSGSTAT10Hz;
    *++msg_u32ptr = htonl(MSGSTAT10HzLEN); //body length

    sadata.count = UptimeCounter;


    ReadXadc(&sadata.die_temp, &sadata.vccint, &sadata.vccaux);

    //read FPGA version (git checksum) from PL register
    sadata.git_shasum = Xil_In32(XPAR_M_AXI_BASEADDR + PRJ_SHASUM);
    //xil_printf("Git : %x\r\n",sadata.git_shasum);


    sadata.evr_ts_s =  Xil_In32(XPAR_M_AXI_BASEADDR + EVR_TS_S_REG);
    sadata.evr_ts_ns =  Xil_In32(XPAR_M_AXI_BASEADDR + EVR_TS_NS_REG);
    sadata.resolution =  Xil_In32(XPAR_M_AXI_BASEADDR + RESOLUTION);
    //xil_printf("%d  %d\r\n",sadata.evr_ts_s, sadata.evr_ts_ns);



    for (chan=0; chan<4; chan++) {
       base = XPAR_M_AXI_BASEADDR + (chan + 1) * CHBASEADDR;
       ave_mode = Xil_In32(base + AVEMODE_REG);

       sadata.ps[chan].dcct1 = ReadAccumSA(base+DCCT1_REG, ave_mode) * CONVDACBITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].dcct1_offset = (s32)Xil_In32(base + DCCT1_OFFSET_REG) * CONVDACBITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].dcct1_gain = (s32)Xil_In32(base + DCCT1_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].dcct2 = ReadAccumSA(base + DCCT2_REG, ave_mode) * CONVDACBITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].dcct2_offset = (s32)Xil_In32(base + DCCT2_OFFSET_REG) * CONVDACBITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].dcct2_gain = (s32)Xil_In32(base + DCCT2_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].dacmon = ReadAccumSA(base + DACMON_REG, ave_mode) * CONV16BITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].dacmon_offset = (s32)Xil_In32(base + DACMON_OFFSET_REG) * CONV16BITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].dacmon_gain = (s32)Xil_In32(base + DACMON_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].volt = ReadAccumSA(base + VOLT_REG, ave_mode) * CONV16BITSTOVOLTS * scalefactors[chan].vout;
       sadata.ps[chan].volt_offset = (s32)Xil_In32(base + VOLT_OFFSET_REG) * CONV16BITSTOVOLTS * scalefactors[chan].vout;
       sadata.ps[chan].volt_gain = (s32)Xil_In32(base + VOLT_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].gnd = ReadAccumSA(base + GND_REG, ave_mode) * CONV16BITSTOVOLTS * scalefactors[chan].ignd;
       sadata.ps[chan].gnd_offset = (s32)Xil_In32(base + GND_OFFSET_REG) * CONV16BITSTOVOLTS * scalefactors[chan].ignd;
       sadata.ps[chan].gnd_gain = (s32)Xil_In32(base + GND_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].spare = ReadAccumSA(base + SPARE_REG, ave_mode) * CONV16BITSTOVOLTS * scalefactors[chan].spare;
       sadata.ps[chan].spare_offset = (s32)Xil_In32(base + SPARE_OFFSET_REG) * CONV16BITSTOVOLTS * scalefactors[chan].spare;
       sadata.ps[chan].spare_gain = (s32)Xil_In32(base + SPARE_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].reg = ReadAccumSA(base + REG_REG, ave_mode) * CONV16BITSTOVOLTS * scalefactors[chan].regulator;
       sadata.ps[chan].reg_offset = (s32)Xil_In32(base + REG_OFFSET_REG) * CONV16BITSTOVOLTS * scalefactors[chan].regulator;
       sadata.ps[chan].reg_gain = (s32)Xil_In32(base + REG_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].error = ReadAccumSA(base + ERR_REG, ave_mode) * CONV16BITSTOVOLTS * scalefactors[chan].error;
       sadata.ps[chan].error_offset = (s32)Xil_In32(base + ERR_OFFSET_REG) * CONV16BITSTOVOLTS * scalefactors[chan].error;
       sadata.ps[chan].error_gain = (s32)Xil_In32(base + ERR_GAIN_REG) / GAIN20BITFRACT;

       //DAC
       sadata.ps[chan].dac_setpt = (s32)Xil_In32(base + DAC_CURRSETPT_REG) * CONVDACBITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].dac_setpt_offset = (s32)Xil_In32(base + DAC_SETPT_OFFSET_REG) * CONVDACBITSTOVOLTS;
       sadata.ps[chan].dac_setpt_gain = (s32)Xil_In32(base + DAC_SETPT_GAIN_REG) / GAIN20BITFRACT;
       sadata.ps[chan].dac_rampactive = Xil_In32(base + DAC_RAMPACTIVE_REG);


       //Faults
       sadata.ps[chan].ovc1_thresh = (s32)Xil_In32(base + OVC1_THRESH_REG) * CONVDACBITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].ovc2_thresh = (s32)Xil_In32(base + OVC2_THRESH_REG) * CONVDACBITSTOVOLTS * scalefactors[chan].dac_dccts;
       sadata.ps[chan].ovv_thresh = Xil_In32(base + OVV_THRESH_REG) * CONV16BITSTOVOLTS * scalefactors[chan].vout;
       sadata.ps[chan].err1_thresh = Xil_In32(base + ERR1_THRESH_REG) * CONV16BITSTOVOLTS * scalefactors[chan].error;
       sadata.ps[chan].err2_thresh = Xil_In32(base + ERR2_THRESH_REG) * CONV16BITSTOVOLTS * scalefactors[chan].error;
       sadata.ps[chan].ignd_thresh = Xil_In32(base + IGND_THRESH_REG) * CONV16BITSTOVOLTS * scalefactors[chan].ignd;

       sadata.ps[chan].ovc1_cntlim = Xil_In32(base + OVC1_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].ovc2_cntlim = Xil_In32(base + OVC2_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].ovv_cntlim = Xil_In32(base + OVV_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].err1_cntlim = Xil_In32(base + ERR1_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].err2_cntlim = Xil_In32(base + ERR2_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].ignd_cntlim = Xil_In32(base + IGND_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].dcct_cntlim = Xil_In32(base + DCCT_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].flt1_cntlim = Xil_In32(base + FLT1_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].flt2_cntlim = Xil_In32(base + FLT2_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].flt3_cntlim = Xil_In32(base + FLT3_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].on_cntlim = Xil_In32(base + ON_CNTLIM_REG) / SAMPLERATE;
       sadata.ps[chan].heartbeat_cntlim = Xil_In32(base + HEARTBEAT_CNTLIM_REG) / SAMPLERATE;

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

       sadata.ps[chan].sf_ampspersec = scalefactors[chan].ampspersec;
       sadata.ps[chan].sf_dac_dccts = scalefactors[chan].dac_dccts;
       sadata.ps[chan].sf_vout = scalefactors[chan].vout;
       sadata.ps[chan].sf_ignd = scalefactors[chan].ignd;
       sadata.ps[chan].sf_spare = scalefactors[chan].spare;
       sadata.ps[chan].sf_regulator = scalefactors[chan].regulator;
       sadata.ps[chan].sf_error = scalefactors[chan].error;

    }



    //copy the structure to the PSC msg buffer
    memcpy(&msg[MSGHDRLEN],&sadata,sizeof(sadata));

}







void psc_status_thread()
{

	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;
    int n,loop=0;


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


