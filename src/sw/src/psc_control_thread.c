
#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xil_cache.h"
#include "math.h"

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


typedef union {
    u32 u;
    float f;
    s32 i;
} MsgUnion;



#define PORT  7
#define CNTRL_PACKET_SIZE 16



void set_fpleds(u32 msgVal)  {
	Xil_Out32(XPAR_M_AXI_BASEADDR + LEDS, msgVal);
}


void soft_trig(u32 msgVal) {
	xil_printf("MsgVal = %d\r\n",msgVal);
	Xil_Out32(XPAR_M_AXI_BASEADDR + SOFTTRIG, msgVal);
	Xil_Out32(XPAR_M_AXI_BASEADDR + SOFTTRIG, 0);

}


void set_eventno(u32 msgVal) {
	//Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_TRIGNUM_REG, msgVal);
}

void Calc_WriteSmooth(u32 chan, s32 new_setpt) {

	s32 cur_setpt;
	u32 dpram_addr, dpram_data;
	u32 i;
	u32 smooth_len = 10000; //adjust to ramp rate later (Amps/sec)
	float val;
	float PI = 3.14;


    cur_setpt = Xil_In32(XPAR_M_AXI_BASEADDR + DAC_CURRSETPT_REG + chan*CHBASEADDR);
	dpram_addr = DAC_RAMPADDR_REG + chan*CHBASEADDR;
	dpram_data = DAC_RAMPDATA_REG + chan*CHBASEADDR;
	Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RAMPLEN_REG + chan*CHBASEADDR, smooth_len);


	xil_printf("Cur Setpt: %d     New Setpt: %d\r\n",cur_setpt, new_setpt);

    //update ramping table with smooth ramp
	//s1 + ((s2 - s1) * 0.5 * (1.0 - cos(ramp_step * M_PI / T)));
	for (i=0;i<smooth_len;i++) {
		val = cur_setpt + ((new_setpt - cur_setpt) * 0.5 * (1.0 - cosf(i*PI/smooth_len)));
	    //printf("%d: %f    %d\r\n",i,val,(s32)val);

		Xil_Out32(XPAR_M_AXI_BASEADDR + dpram_addr, i);
	    Xil_Out32(XPAR_M_AXI_BASEADDR + dpram_data, (s32)val);
	    //xil_printf("Addr: %d   Data: %d   Active: %d\r\n",dpram_addr,(s32)val,Xil_In32(XPAR_M_AXI_BASEADDR + PS1_DAC_RAMPACTIVE));

	}


    Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RAMPLEN_REG + chan*CHBASEADDR, smooth_len);
	Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RUNRAMP_REG + chan*CHBASEADDR, 1);




	//for (i=0;i<100;i++) {
    //  xil_printf("SetPt: %d  ", Xil_In32(XPAR_M_AXI_BASEADDR + PS1_DAC_CURRSETPT));
    //  xil_printf("RampActive: %d\r\n", Xil_In32(XPAR_M_AXI_BASEADDR + PS1_DAC_RAMPACTIVE));
    //	}
	//update dac setpt with last value from ramp, so whenever we switch
	// back to FOFB or JumpMode there is no change
	// Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_RAMPLEN, (s32)val);




}

//When changing modes between Smooth/Ramp and Jump, need to smoothly
//transition
//In Smooth/Ramp mode the dac_setpt comes from the DPRAM
//In Jump Mode the dac_setpt comes from the register
void Set_dacOpmode(u32 chan, s32 new_opmode) {
	u32 dac_mode;

	dac_mode = Xil_In32(XPAR_M_AXI_BASEADDR + DAC_OPMODE_REG + chan*CHBASEADDR);


	//if changing from smooth/ramp to jump mode first ramp to 0
	if (((dac_mode == SMOOTH) || (dac_mode == RAMP)) && new_opmode == JUMP) {
		xil_printf("Switching from Smooth/Ramp to Jump Mode\r\n");
		//Set the DAC to 0
		Calc_WriteSmooth(chan, 0);
		//Set the Jump set point to 0 too
		Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_SETPT_REG  + chan*CHBASEADDR, 0);
		//Now safe to switch to jumpmode
		Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_OPMODE_REG + chan*CHBASEADDR, JUMP);
	}

	//if changing from jump mode to smooth/ramp mode
	if ((dac_mode == JUMP) && ((new_opmode == SMOOTH) || (new_opmode == RAMP))) {
		xil_printf("Switching from Jump to Smooth/Ramp Mode\r\n");
		// Smooth the DAC to 0
		Calc_WriteSmooth(chan, 0);
		//Set the Jump set point to 0 too
		Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_SETPT_REG + chan*CHBASEADDR, 0);
		//Now safe to switch to smooth/ramp
		Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_OPMODE_REG + chan*CHBASEADDR, new_opmode);
	}


}






void Set_dac(u32 chan, s32 new_setpt) {

	u32 dac_mode;

	//first get the DAC opmode
	dac_mode = Xil_In32(XPAR_M_AXI_BASEADDR + DAC_OPMODE_REG + chan*CHBASEADDR);

	if (dac_mode == SMOOTH) {
        xil_printf("In Smooth Mode\r\n");
        Calc_WriteSmooth(chan, new_setpt);
	}

	else if (dac_mode == JUMP) {
        xil_printf("In Jump Mode\r\n");
		  Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_SETPT_REG + chan*CHBASEADDR, new_setpt);
	}
}




void GlobSetting(u32 addr, MsgUnion data) {

    xil_printf("In Global Settings...\r\n");
    switch(addr) {
		case SOFT_TRIG_MSG:
			xil_printf("Soft Trigger Message:   Value=%d\r\n",data.u);
			soft_trig(data.u);
            break;

		case TEST_TRIG_MSG:
			xil_printf("Test Trigger Message:   Value=%d\r\n",data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + TESTTRIG, data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + TESTTRIG, 0);
            break;


        case FP_LED_MSG:
         	xil_printf("Setting FP LED:   Value=%d\r\n",data.u);
         	set_fpleds(data.u);
         	break;
    }

}


void ChanSettings(u32 chan, u32 addr, MsgUnion data) {



    switch(addr) {

        case DAC_OPMODE_MSG:
	        xil_printf("Setting DAC CH%d Operating Mode:   Value=%d\r\n",chan,data.u);
	        Set_dacOpmode(chan,data.u);
	        break;

        case DAC_SETPT_MSG:
	        xil_printf("Setting DAC CH%d SetPoint:   Value=%d\r\n",chan,data.i);
	        Set_dac(chan, data.i);
	        break;

        case DAC_RAMPLEN_MSG:
 	        xil_printf("Setting DAC CH%d RampTable Length:   Value=%d\r\n",chan,data.u);
 	        Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RAMPLEN_REG + chan*CHBASEADDR, data.u);
 	        break;

        case DAC_RUNRAMP_MSG:
	        xil_printf("Running DAC CH%d Ramptable:   Value=%d\r\n",chan,data.u);
	        Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RUNRAMP_REG + chan*CHBASEADDR, data.u);
	        break;

        case DAC_GAIN_MSG:
	        printf("Setting DAC CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
	        Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_GAIN_REG + chan*CHBASEADDR, data.f);
	        break;

        case DAC_OFFSET_MSG:
	        xil_printf("Setting DAC CH%d Offset:   Value=%d\r\n",chan,data.i);
	        Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_OFFSET_REG + chan*CHBASEADDR, data.i);
	        break;

        case DCCT1_GAIN_MSG:
 	        printf("Setting DAC CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
 	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT1_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
 	        break;

        case DCCT1_OFFSET_MSG:
 	        xil_printf("Setting DCCT1 CH%d Offset:   Value=%d\r\n",chan,data.i);
 	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT1_OFFSET_REG + chan*CHBASEADDR, data.i);
 	        break;

        case DCCT2_GAIN_MSG:
  	        printf("Setting DCCT1 CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT2_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
  	        break;

        case DCCT2_OFFSET_MSG:
  	        xil_printf("Setting DCCT2 CH%d Offset:   Value=%d\r\n",chan,data.i);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT2_OFFSET_REG + chan*CHBASEADDR, data.i);
  	        break;

        case DACSP_GAIN_MSG:
  	        printf("Setting DACSP CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + DACSP_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
  	        break;

        case DACSP_OFFSET_MSG:
  	        xil_printf("Setting DACSP CH%d Offset:   Value=%d\r\n",chan,data.i);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + DACSP_OFFSET_REG + chan*CHBASEADDR, data.i);
  	        break;

        case VOLT_GAIN_MSG:
  	        printf("Setting Voltage CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + VOLT_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
  	        break;

        case VOLT_OFFSET_MSG:
  	        xil_printf("Setting Voltage CH%d Offset:   Value=%d\r\n",chan,data.i);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + VOLT_OFFSET_REG + chan*CHBASEADDR, data.i);
  	        break;

        case GND_GAIN_MSG:
  	        printf("Setting iGND CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + GND_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
  	        break;

        case GND_OFFSET_MSG:
  	        xil_printf("Setting iGND CH%d Offset:   Value=%d\r\n",chan,data.i);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + GND_OFFSET_REG + chan*CHBASEADDR, data.i);
  	        break;

        case SPARE_GAIN_MSG:
   	        printf("Setting Spare CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + SPARE_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
   	        break;

        case SPARE_OFFSET_MSG:
   	        xil_printf("Setting Spare CH%d Offset:   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + SPARE_OFFSET_REG + chan*CHBASEADDR, data.i);
   	        break;

        case REG_GAIN_MSG:
   	        printf("Setting Regulator CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + REG_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
   	        break;

        case REG_OFFSET_MSG:
   	        xil_printf("Setting Regulator CH%d Offset:   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + REG_OFFSET_REG + chan*CHBASEADDR, data.i);
   	        break;

        case ERR_GAIN_MSG:
   	        printf("Setting Error CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
   	        break;

        case ERR_OFFSET_MSG:
   	        xil_printf("Setting Error CH%d Offset:   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR_OFFSET_REG + chan*CHBASEADDR, data.i);
   	        break;


        case OVC1_THRESH_MSG:
   	        xil_printf("Setting OVC1 Threshold CH%d :   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVC1_THRESH_REG + chan*CHBASEADDR, data.i);
   	        break;

        case OVC2_THRESH_MSG:
   	        xil_printf("Setting OVC2 Threshold CH%d :   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVC2_THRESH_REG + chan*CHBASEADDR, data.i);
   	        break;

        case OVV_THRESH_MSG:
   	        xil_printf("Setting OVV Threshold CH%d :   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVV_THRESH_REG + chan*CHBASEADDR, data.i);
   	        break;

        case ERR1_THRESH_MSG:
   	        xil_printf("Setting Err1 Threshold CH%d :   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR1_THRESH_REG + chan*CHBASEADDR, data.i);
   	        break;

        case ERR2_THRESH_MSG:
   	        xil_printf("Setting Err2 Threshold CH%d :   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR2_THRESH_REG + chan*CHBASEADDR, data.i);
   	        break;

        case IGND_THRESH_MSG:
   	        xil_printf("Setting Ignd Threshold CH%d :   Value=%d\r\n",chan,data.i);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + IGND_THRESH_REG + chan*CHBASEADDR, data.i);
   	        break;

        case OVC1_CNTLIM_MSG:
   	        xil_printf("Setting OVC1 Count Limit CH%d :   Value=%d\r\n",chan,data.u);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVC1_CNTLIM_REG + chan*CHBASEADDR, data.u);
   	        break;

        case OVC2_CNTLIM_MSG:
   	        xil_printf("Setting OVC2 Count Limit CH%d :   Value=%d\r\n",chan,data.u);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVC2_CNTLIM_REG + chan*CHBASEADDR, data.u);
   	        break;

        case OVV_CNTLIM_MSG:
   	        xil_printf("Setting OVV Count Limit CH%d :   Value=%d\r\n",chan,data.u);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVV_CNTLIM_REG + chan*CHBASEADDR, data.u);
   	        break;

        case ERR1_CNTLIM_MSG:
   	        xil_printf("Setting Err1 Count Limit CH%d :   Value=%d\r\n",chan,data.u);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR1_CNTLIM_REG + chan*CHBASEADDR, data.u);
   	        break;

        case ERR2_CNTLIM_MSG:
   	        xil_printf("Setting Err2 Count Limit CH%d :   Value=%d\r\n",chan,data.u);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR2_CNTLIM_REG + chan*CHBASEADDR, data.u);
   	        break;

        case IGND_CNTLIM_MSG:
   	        xil_printf("Setting Ignd Count Limit CH%d :   Value=%d\r\n",chan,data.u);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + IGND_CNTLIM_REG + chan*CHBASEADDR, data.u);
   	        break;

        case DCCT_CNTLIM_MSG:
   	        xil_printf("Setting DCCT Count Limit CH%d :   Value=%d\r\n",chan,data.u);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT_CNTLIM_REG + chan*CHBASEADDR, data.u);
   	        break;

        case FLT1_CNTLIM_MSG:
    	    xil_printf("Setting Fault1 Count Limit CH%d :   Value=%d\r\n",chan,data.u);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + FLT1_CNTLIM_REG + chan*CHBASEADDR, data.u);
    	    break;

        case FLT2_CNTLIM_MSG:
    	    xil_printf("Setting Fault2 Count Limit CH%d :   Value=%d\r\n",chan,data.u);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + FLT2_CNTLIM_REG + chan*CHBASEADDR, data.u);
    	    break;

        case FLT3_CNTLIM_MSG:
    	    xil_printf("Setting Fault3 Count Limit CH%d :   Value=%d\r\n",chan,data.u);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + FLT3_CNTLIM_REG + chan*CHBASEADDR, data.u);
    	    break;

        case ON_CNTLIM_MSG:
    	    xil_printf("Setting On Count Limit CH%d :   Value=%d\r\n",chan,data.u);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + ON_CNTLIM_REG + chan*CHBASEADDR, data.u);
    	    break;

        case HEART_CNTLIM_MSG:
    	    xil_printf("Setting Heart Beat Limit CH%d :   Value=%d\r\n",chan,data.u);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + HEARTBEAT_CNTLIM_REG + chan*CHBASEADDR, data.u);
    	    break;

        case FAULT_CLEAR_MSG:
     	    xil_printf("Setting Fault Clear CH%d :   Value=%d\r\n",chan,data.u);
     	    Xil_Out32(XPAR_M_AXI_BASEADDR + FAULT_CLEAR_REG + chan*CHBASEADDR, data.u);
     	    break;

        case FAULT_MASK_MSG:
      	    xil_printf("Setting Fault Mask CH%d :   Value=%d\r\n",chan,data.u);
      	    Xil_Out32(XPAR_M_AXI_BASEADDR + FAULT_MASK_REG + chan*CHBASEADDR, data.u);
      	    break;

        case DIGOUT_ON1_MSG:
       	    xil_printf("Setting DigOut On1 CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_ON1_REG + chan*CHBASEADDR, data.u);
       	    break;

        case DIGOUT_ON2_MSG:
       	    xil_printf("Setting DigOut On2 CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_ON2_REG + chan*CHBASEADDR, data.u);
       	    break;

        case DIGOUT_RESET_MSG:
       	    xil_printf("Setting DigOut Reset CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_RESET_REG + chan*CHBASEADDR, data.u);
       	    break;

        case DIGOUT_SPARE_MSG:
       	    xil_printf("Setting DigOut Spare CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_SPARE_REG + chan*CHBASEADDR, data.u);
       	    break;

        case DIGOUT_PARK_MSG:
       	    xil_printf("Setting DigOut Park CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_PARK_REG + chan*CHBASEADDR, data.u);
       	    break;

        default:
        	xil_printf("Unsupported Message\r\n");

    }



}



void psc_control_thread()
{
	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;
	int RECV_BUF_SIZE = 1024;
	char buffer[RECV_BUF_SIZE];
	int n=0, *bufptr, numpackets=0;
    u32 MsgId, MsgLen, MsgAddr;
    //s32 MsgData;
    MsgUnion MsgData;




    xil_printf("Starting PSC Control Server...\r\n");

	// Initialize socket structure
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(PORT);
	serv_addr.sin_addr.s_addr = INADDR_ANY;

    // First call to socket() function
	if ((sockfd = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0)
		xil_printf("PSC Control : Error Creating Socket\r\n");

    // Bind to the host address using bind()
	if (lwip_bind(sockfd, (struct sockaddr *)&serv_addr, sizeof (serv_addr)) < 0)
		xil_printf("PSC Control : Error Creating Socket\r\n");

    // Now start listening for the clients
	lwip_listen(sockfd, 0);


    xil_printf("PSC Control: Server listening on port %d...\r\n",PORT);


reconnect:

	clilen = sizeof(cli_addr);

	newsockfd = lwip_accept(sockfd, (struct sockaddr *)&cli_addr, (socklen_t *)&clilen);
	if (newsockfd < 0) {
	    xil_printf("PSC Control: ERROR on accept\r\n");

	}
	/* If connection is established then start communicating */
	xil_printf("PSC Control: Connected Accepted...\r\n");

	while (1) {
	    int received = 0;
	    while (received < CNTRL_PACKET_SIZE) {
	        int n = read(newsockfd, buffer + received, CNTRL_PACKET_SIZE - received);
		    //n = read(newsockfd, buffer, RECV_BUF_SIZE);
	        xil_printf("N=%d\r\n",n);
			if (n < 0) {
	           xil_printf("PSC Control: Read Error..  Reconnecting...\r\n");
	           close(newsockfd);
		       goto reconnect;
	        }

			if (n == 0) {
		       xil_printf("PSC Control: Socket Closed by Peer..  Reconnecting...\r\n");
		       close(newsockfd);
			   goto reconnect;
			}
	        received += n;
	    }


        bufptr = (int *) buffer;
        xil_printf("Packet %d Received : NumBytes = %d\r\n",++numpackets,n);
        xil_printf("Header: %c%c \t",buffer[0],buffer[1]);
        MsgId = (ntohl(*bufptr++)&0xFFFF);
        xil_printf("Message ID : %d\t",MsgId);
        MsgLen = ntohl(*bufptr++);
        xil_printf("Body Length : %d\t",MsgLen);
        MsgAddr = ntohl(*bufptr++);
        xil_printf("Msg Addr : %d\r\n",MsgAddr);
	    //MsgData = ntohl(*bufptr);
        MsgData.u = ntohl(*(uint32_t*)bufptr);
        xil_printf("Data (int)  : %d\r\n", MsgData.i);
        printf("Data (float): %f\r\n", MsgData.f);

        //xil_printf("Data : %d\r\n",MsgData);
        //blink fp_led on message received
        //set_fpleds(1);
        //set_fpleds(0);

        switch(MsgId) {
            case 0:
            	GlobSetting(MsgAddr,MsgData);
            	break;

            case 1:
            case 2:
            case 3:
            case 4:
             	ChanSettings(MsgId,MsgAddr,MsgData);
                break;

        }




	}

	/* close connection */
	close(newsockfd);
	vTaskDelete(NULL);
}


