/********************************************************************
*  PSC Waveform Thread
*  J. Mead
*  4-17-24
*
*  This thread is responsible for sending all waveform data to the IOC.   It does
*  this over to message ID's (51 = Snapshot, )
*
*  It starts a listening server on
*  port 600.  Upon establishing a connection with a client, it begins to send out
*  packets.
********************************************************************/

#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xil_cache.h"
#include "xparameters.h"

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


#define PORT  20

extern u32 UptimeCounter;
extern ScaleFactorType scalefactors[4];

extern float CONVDACBITSTOVOLTS;


void Host2NetworkConvWvfm(char *inbuf, int len) {

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


// This information is send to the IOC at ~10Hz
void ReadSnapShotStats(char *msg, TriggerTypes *trig) {

   u32 *msg_u32ptr;
   struct SnapStatsMsg snapstats;
   u32 i;


   //write the PSC Header
   msg_u32ptr = (u32 *)msg;
   msg[0] = 'P';
   msg[1] = 'S';
   msg[2] = 0;
   msg[3] = (short int) MSGWFMSTATS;
   *++msg_u32ptr = htonl(MSGWFMSTATSLEN); //body length
	msg_u32ptr++;

   snapstats.cur_bufaddr = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_ADDRPTR);
   snapstats.totalfacnt = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_TOTALTRIGS);

   for (i=0;i<4;i++) {
       snapstats.usr[i].lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + USR1TRIG_BUFPTR + i*0x10);
       snapstats.usr[i].active  = trig->usr[i].active;
       snapstats.usr[i].ts_s    = Xil_In32(XPAR_M_AXI_BASEADDR + USR1TRIG_TS_S + i*0x10);
       snapstats.usr[i].ts_ns   = Xil_In32(XPAR_M_AXI_BASEADDR + USR1TRIG_TS_NS + i*0x10);

       snapstats.flt[i].lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_BUFPTR + i*0x10);
       snapstats.flt[i].active  = trig->flt[i].active;
       snapstats.flt[i].ts_s    = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_TS_S + i*0x10);
       snapstats.flt[i].ts_ns   = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_TS_NS + i*0x10);

       snapstats.err[i].lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_BUFPTR + i*0x10);
       snapstats.err[i].active  = trig->err[i].active;
       snapstats.err[i].ts_s    = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_TS_S + i*0x10);
       snapstats.err[i].ts_ns   = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_TS_NS + i*0x10);

       snapstats.inj[i].lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ1TRIG_BUFPTR + i*0x10);
       snapstats.inj[i].active  = trig->inj[i].active;
       snapstats.inj[i].ts_s    = Xil_In32(XPAR_M_AXI_BASEADDR + INJ1TRIG_TS_S + i*0x10);
       snapstats.inj[i].ts_ns   = Xil_In32(XPAR_M_AXI_BASEADDR + INJ1TRIG_TS_NS + i*0x10);

       snapstats.evr[i].lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_BUFPTR);
       snapstats.evr[i].active  = trig->evr[3].active;
       snapstats.evr[i].ts_s    = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_TS_S);
       snapstats.evr[i].ts_ns   = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_TS_NS);
   }


   //xil_printf("Inj1 TS_S: %d    TS_NS: %d\r\n",snapstats.inj1_ts_s, snapstats.inj1_ts_ns);
   //copy the structure to the PSC msg buffer
   memcpy(&msg[MSGHDRLEN],&snapstats,sizeof(snapstats));



}



void ProcessTrigger(TriggerInfo *trig, const char *trig_name) {


    if ((trig->addr != trig->addr_last) && (trig->active == 0)) {
        trig->active = 1;
        trig->addr_last = trig->addr; ;
        xil_printf("Got %s Trigger...\r\n", trig_name);
        xil_printf("Buffer Ptr at Trigger: %x\r\n", trig->addr);
        trig->postdlycnt = 0;
    }

    if (trig->active == 1) {
        if (trig->postdlycnt < (trig->posttrigpts/1000)) {
            (trig->postdlycnt)++;
            //xil_printf("Post Trig Cnt = %d\r\n",trig->postdlycnt);
        } else {
            trig->sendbuf = 1;
            xil_printf("\r\nSend Buf...\r\n");
        }
    }
}



void CheckforTriggers(TriggerTypes *trig) {


    if (trig->usr[0].active == 0)
       trig->usr[0].addr = Xil_In32(XPAR_M_AXI_BASEADDR + USR1TRIG_BUFPTR);
    ProcessTrigger(&trig->usr[0], "Usr1");

    if (trig->usr[1].active == 0)
       trig->usr[1].addr = Xil_In32(XPAR_M_AXI_BASEADDR + USR2TRIG_BUFPTR);
    ProcessTrigger(&trig->usr[1], "Usr2");

    if (trig->usr[2].active == 0)
       trig->usr[2].addr = Xil_In32(XPAR_M_AXI_BASEADDR + USR3TRIG_BUFPTR);
    ProcessTrigger(&trig->usr[2], "Usr3");

    if (trig->usr[3].active == 0)
       trig->usr[3].addr = Xil_In32(XPAR_M_AXI_BASEADDR + USR4TRIG_BUFPTR);
    ProcessTrigger(&trig->usr[3], "Usr4");


    if (trig->flt[0].active == 0)
       trig->flt[0].addr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_BUFPTR);
    ProcessTrigger(&trig->flt[0], "Flt1");

    if (trig->flt[1].active == 0)
       trig->flt[1].addr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT2TRIG_BUFPTR);
    ProcessTrigger(&trig->flt[1], "Flt2");

    if (trig->flt[2].active == 0)
       trig->flt[2].addr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT3TRIG_BUFPTR);
    ProcessTrigger(&trig->flt[2], "Flt3");

    if (trig->flt[3].active == 0)
       trig->flt[3].addr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT4TRIG_BUFPTR);
    ProcessTrigger(&trig->flt[3], "Flt4");


    if (trig->err[0].active == 0)
       trig->err[0].addr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_BUFPTR);
    ProcessTrigger(&trig->err[0], "Err1");

    if (trig->err[1].active == 0)
       trig->err[1].addr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR2TRIG_BUFPTR);
    ProcessTrigger(&trig->err[1], "Err2");

    if (trig->err[2].active == 0)
       trig->err[2].addr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR3TRIG_BUFPTR);
    ProcessTrigger(&trig->err[2], "Err3");

    if (trig->err[3].active == 0)
       trig->err[3].addr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR4TRIG_BUFPTR);
    ProcessTrigger(&trig->err[3], "Err4");


    if (trig->inj[0].active == 0)
       trig->inj[0].addr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ1TRIG_BUFPTR);
    ProcessTrigger(&trig->inj[0], "Inj1");

    if (trig->inj[1].active == 0)
       trig->inj[1].addr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ2TRIG_BUFPTR);
    ProcessTrigger(&trig->inj[1], "Inj2");

    if (trig->inj[2].active == 0)
       trig->inj[2].addr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ3TRIG_BUFPTR);
    ProcessTrigger(&trig->inj[2], "Inj3");

    if (trig->inj[3].active == 0)
       trig->inj[3].addr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ4TRIG_BUFPTR);
    ProcessTrigger(&trig->inj[3], "Inj4");


    if (trig->evr[0].active == 0)
       trig->evr[0].addr = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_BUFPTR);
    ProcessTrigger(&trig->evr[0], "Evr1");

    if (trig->evr[1].active == 0)
       trig->evr[1].addr = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_BUFPTR);
    ProcessTrigger(&trig->evr[1], "Evr2");

    if (trig->evr[2].active == 0)
       trig->evr[2].addr = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_BUFPTR);
    ProcessTrigger(&trig->evr[2], "Evr3");

    if (trig->evr[3].active == 0)
       trig->evr[3].addr = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_BUFPTR);
    ProcessTrigger(&trig->evr[3], "Evr4");

}



void CopyDataChan(float **msg_ptr, u32 *buf_data, u32 numwords, int chan) {

	u32 i;


	//inject some errors at sample 30000 for DCCT1 & DCCT2 for testing
    //buf_data[30000*40+2] = 0;
    //buf_data[30000*40+3] = 0;
    xil_printf("Start CopyDataChan...\r\n");
	vTaskSuspendAll();

    switch (chan) {
        case 1:  // Copy elements 0-9
            for (i=0; i<numwords; i=i+40) {
                **msg_ptr = buf_data[i+0];   //header
                (*msg_ptr)++;
                **msg_ptr = buf_data[i+1];   //data pt. counter
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+2]) * CONVDACBITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DCCT1
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+3]) * CONVDACBITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DCCT2
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+4]) * CONV16BITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DAC Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+5]) * CONV16BITSTOVOLTS * scalefactors[chan-1].vout;   //Voltage Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+6]) * CONV16BITSTOVOLTS * scalefactors[chan-1].ignd;   //iGND Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+7]) * CONV16BITSTOVOLTS * scalefactors[chan-1].spare;   //Spare Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+8]) * CONV16BITSTOVOLTS * scalefactors[chan-1].regulator;   //Regulator
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+9]) * CONV16BITSTOVOLTS * scalefactors[chan-1].error;   //Error
                (*msg_ptr)++;
                // check for any zeros
                //for (j=0; j<39; j++) {
          		//  if (buf_data[i+j] == 0)
          		//	xil_printf("BufData=%d    i=%d, j=%d\r\n",buf_data[i+j], i, j);
                //}

            }
            break;


        case 2: // Copy elements 0, 1, 10-17
            for (i=0; i<numwords; i=i+40) {
                **msg_ptr = buf_data[i+0];   //header
                (*msg_ptr)++;
                **msg_ptr = buf_data[i+1];   //data pt. counter
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+10]) * CONVDACBITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DCCT1
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+11]) * CONVDACBITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DCCT2
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+12]) * CONV16BITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DAC Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+13]) * CONV16BITSTOVOLTS * scalefactors[chan-1].vout;   //Voltage Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+14]) * CONV16BITSTOVOLTS * scalefactors[chan-1].ignd;   //iGND Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+15]) * CONV16BITSTOVOLTS * scalefactors[chan-1].spare;   //Spare Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+16]) * CONV16BITSTOVOLTS * scalefactors[chan-1].regulator;   //Regulator
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+17]) * CONV16BITSTOVOLTS * scalefactors[chan-1].error;   //Error
                (*msg_ptr)++;
            }
            break;

        case 3: // Copy elements 0, 1, 18-25
            for (i=0; i<numwords; i=i+40) {
                 **msg_ptr = buf_data[i+0];   //header
                (*msg_ptr)++;
                **msg_ptr = buf_data[i+1];   //data pt. counter
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+18]) * CONVDACBITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DCCT1
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+19]) * CONVDACBITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DCCT2
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+20]) * CONV16BITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DAC Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+21]) * CONV16BITSTOVOLTS * scalefactors[chan-1].vout;   //Voltage Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+22]) * CONV16BITSTOVOLTS * scalefactors[chan-1].ignd;   //iGND Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+23]) * CONV16BITSTOVOLTS * scalefactors[chan-1].spare;   //Spare Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+24]) * CONV16BITSTOVOLTS * scalefactors[chan-1].regulator;   //Regulator
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+25]) * CONV16BITSTOVOLTS * scalefactors[chan-1].error;   //Error
                (*msg_ptr)++;
            }
            break;

        case 4: // Copy elements 0, 1, 26-33
            for (i=0; i<numwords; i=i+40) {
                **msg_ptr = buf_data[i+0];   //header
                (*msg_ptr)++;
                **msg_ptr = buf_data[i+1];   //data pt. counter
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+26]) * CONVDACBITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DCCT1
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+27]) * CONVDACBITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DCCT2
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+28]) * CONV16BITSTOVOLTS * scalefactors[chan-1].dac_dccts;   //DAC Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+29]) * CONV16BITSTOVOLTS * scalefactors[chan-1].vout;   //Voltage Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+30]) * CONV16BITSTOVOLTS * scalefactors[chan-1].ignd;   //iGND Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+31]) * CONV16BITSTOVOLTS * scalefactors[chan-1].spare;   //Spare Monitor
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+32]) * CONV16BITSTOVOLTS * scalefactors[chan-1].regulator;   //Regulator
                (*msg_ptr)++;
                **msg_ptr = (float)(s32)(buf_data[i+33]) * CONV16BITSTOVOLTS * scalefactors[chan-1].error;   //Error
                (*msg_ptr)++;
             }
            break;

        default:
            xil_printf("Error: Invalid chan value: %d\n", chan);
            break;
    }
    xil_printf("Finish CopyDataChan...\r\n");
    xTaskResumeAll();

}





void ReadDMABuf(char *msg, TriggerInfo *trig) {

	u32 BUFSTART = 0x10000000;
	u32 BUFLEN   = 0x01E84800;
	u32 const BUFSTEPBYTES  = 0xA0; //160 bytes
    u32 const BUFSTEPWORDS = BUFSTEPBYTES/4;
    u32 const WORDSPERSAMPLE = 40;
	u32 *buf_data;
    u32 *msg_u32ptr;
    float *msg_fltptr;
    //u32 i;
    u32 startaddr, stopaddr;
    u32 prefirstnumwords, presecnumwords, postfirstnumwords, postsecnumwords;
    //u32 prefirstnumpts, presecnumpts, postfirstnumpts, postsecnumpts;

    //write the PSC Header
    xil_printf("In ReadDMABuf Message ID: %d\r\n",trig->msgID);
    msg_u32ptr = (u32 *)msg;
    msg_fltptr = (float *)msg;
    msg[0] = 'P';
    msg[1] = 'S';
    msg[2] = 0;
    msg[3] = (short int) trig->msgID; //MSGSOFT;
    *++msg_u32ptr = htonl(MSGWFMLEN); //body length

	msg_u32ptr++;
	msg_fltptr++;
	msg_fltptr++;
	//xil_printf("U32: %d    FLT: %d\r\n",msg_u32ptr, msg_fltptr);


	xil_printf("Copying Snapshot Data from CircBuf to PSC Message...\r\n");

	// Invalidate cache of entire circular buffer
	Xil_DCacheInvalidateRange(0x10000000,16e6);

    //find start and stop addresses for snapshot dump
    //each trigger is 10kHz
    //Each point is 160 bytes
    startaddr = trig->addr - trig->pretrigpts*BUFSTEPBYTES;
    stopaddr = trig->addr + trig->posttrigpts*BUFSTEPBYTES;
    xil_printf("LatAddr: 0x%x    StartAddr: 0x%x    StopAddr: 0x%x\r\n",trig->addr,startaddr,stopaddr);
    if (startaddr < 0x10000000) {
	   xil_printf("    Pretrigger wraps\r\n");
	   presecnumwords = (trig->addr - BUFSTART) >> 2;
	   //presecnumpts   = presecnumwords / WORDSPERSAMPLE;
	   prefirstnumwords   = trig->pretrigpts*WORDSPERSAMPLE - presecnumwords;
	   //prefirstnumpts = prefirstnumwords / BUFSTEPWORDS;
	   startaddr = BUFSTART+BUFLEN - prefirstnumwords*4;
	   //xil_printf("    Start Addr          : %9d   0x%x\r\n", startaddr,startaddr);
	   //xil_printf("    Latch Addr          : %9d   0x%x\r\n", trig->addr, trig->addr);
	   //xil_printf("    BUFSTART+BUFLEN     : %9d   0x%x\r\n", BUFSTART+BUFLEN,BUFSTART+BUFLEN);
	   //xil_printf("    SecPreNumWords      : %9d   0x%x\r\n", presecnumwords, presecnumwords);
	   //xil_printf("    SecPreNumPts        : %9d\r\n", presecnumpts);
	   //xil_printf("    FirstPreLen         : %9d   0x%x\r\n", prefirstnumwords, prefirstnumwords);
	   //xil_printf("    FirstPreNumPts      : %9d\r\n", prefirstnumpts);
	   //xil_printf("    TotalPreLen         : %9d   0x%x\r\n", prefirstnumwords+presecnumwords, prefirstnumwords+presecnumwords);
	   //xil_printf("    TotalPrePts         : %9d\r\n", prefirstnumpts+presecnumpts);
	   //Now that we have all the lengths, copy to the message buffer

	   //copy pre-trigger
	   //xil_printf("    Copying 1st part of pre-trigger points\r\n");
	   buf_data = (u32 *) startaddr;
	   CopyDataChan(&msg_fltptr, buf_data, prefirstnumwords, trig->channum);

	   //copy first postbuf
	   //xil_printf("    Copying 2nd part of pre-trigger points\r\n");
	   buf_data = (u32 *) BUFSTART;
	   //xil_printf("Msg_u32ptr = %d\r\n",msg_u32ptr);
	   CopyDataChan(&msg_fltptr, buf_data, presecnumwords, trig->channum);

	   //copy second postbuf
  	   //xil_printf("    Copying post-trigger points\r\n");
  	   buf_data = (u32 *) trig->addr;
	   CopyDataChan(&msg_fltptr, buf_data, trig->posttrigpts*BUFSTEPWORDS, trig->channum);


    }
    else if (stopaddr > BUFSTART+BUFLEN) {
	   xil_printf("    Postrigger wraps\r\n");

	   postfirstnumwords = (BUFSTART+BUFLEN - trig->addr) >> 2;
	   //postfirstnumpts   = postfirstnumwords / WORDSPERSAMPLE;
	   postsecnumwords   = trig->posttrigpts*WORDSPERSAMPLE - postfirstnumwords;
	   //postsecnumpts = postsecnumwords / BUFSTEPWORDS;
	   //xil_printf("    Latch Addr          : %9d   0x%x\r\n", trig->addr, trig->addr);
	   //xil_printf("    BUFSTART+BUFLEN     : %9d   0x%x\r\n", BUFSTART+BUFLEN,BUFSTART+BUFLEN);
	   //xil_printf("    FirstPostNumWords   : %9d   0x%x\r\n", postfirstnumwords, postfirstnumwords);
	   //xil_printf("    FirstPostNumPts     : %9d\r\n", postfirstnumpts);
	   //xil_printf("    SecPostLen          : %9d   0x%x\r\n", postsecnumwords, postsecnumwords);
	   //xil_printf("    SecPostNumPts       : %9d\r\n", postsecnumpts);
	   //xil_printf("    TotalPostLen        : %9d   0x%x\r\n", postfirstnumwords+postsecnumwords, postfirstnumwords+postsecnumwords);
	   //xil_printf("    TotalPostPts        : %9d\r\n", postfirstnumpts+postsecnumpts);
	   //Now that we have all the lengths, copy to the message buffer

	   //copy pre-trigger
	   //xil_printf("    Copying pre-trigger points\r\n");
	   buf_data = (u32 *) startaddr;
	   CopyDataChan(&msg_fltptr, buf_data, trig->pretrigpts*BUFSTEPWORDS, trig->channum);

		//copy first postbuf
	   //xil_printf("    Copying 1st part of post-trigger points\r\n");
	   buf_data = (u32 *) trig->addr;
	   CopyDataChan(&msg_fltptr, buf_data, postfirstnumwords, trig->channum);

  	   //copy second postbuf
  	   //xil_printf("    Copying 2nd part of post-trigger points\r\n");
  	   buf_data = (u32 *) BUFSTART;
	   //xil_printf("Msg_u32ptr = %d\r\n",msg_u32ptr);
	   CopyDataChan(&msg_fltptr, buf_data, postsecnumwords, trig->channum);

    }

    else {
       xil_printf("    No Wraps\r\n");
	   //xil_printf("    Copying Buffer\r\n");
	   buf_data = (u32 *) startaddr;
	   CopyDataChan(&msg_fltptr, buf_data, (trig->pretrigpts+trig->posttrigpts)*BUFSTEPWORDS, trig->channum);
    }

	xil_printf("Done Copying Snapshot Data from CircBuf to PSC Message...\r\n");




}



s32 SendWfmData(int newsockfd, char *msg, TriggerInfo *trig) {

    int n;
    //float *msg_fltptr;


    xil_printf("In SendWfmData...\r\n");
    trig->sendbuf = 0;
    trig->active = 0;

	xil_printf("Calling ReadDMABuf...\r\n");
	ReadDMABuf(msg,trig);

	/*

    msg_fltptr = (float *)msg;
    xil_printf("Header\r\n");
    for(i=0;i<8;i++) {
    	xil_printf("%d: %d\r\n",i,msg[i]);
    }
    xil_printf("Data\r\n");
	for(i=2;i<22;i++) {
	    printf("%d: %f\r\n",i,msg_fltptr[i]);
	}
    */
    //write out Snapshot data (msg51)
	xil_printf("Tx 10 sec of Snapshot Data\r\n");
	/*
	xil_printf("Checking Msg for Zeros\r\n");
	msg_fltptr = (float *)msg;
	for (i=2;i<100000*10;i++) {
		if (msg_fltptr[i] == 0) {
			printf("msg=%f    i=%d\r\n",msg_fltptr[i], i);
		}
	}
	*/

    //Host2NetworkConvWvfm(msg,sizeof(msgUsr_buf[0])+MSGHDRLEN);
    Host2NetworkConvWvfm(msg,MSGWFMLEN+MSGHDRLEN);

    n = lwip_write(newsockfd,msg,MSGWFMLEN+MSGHDRLEN);
    xil_printf("Transferred %d bytes\r\n", n);
    if (n < 0) {
  	   printf("PSC Waveform: ERROR writing Snapshot Waveform\n");
  	   close(newsockfd);
  	   return -1; //goto reconnect;
    }
    else
       xil_printf("Tx Success...\r\n");

    return n;
}





void psc_wvfm_thread()
{

	// Waveform Buffers for Snapshots
	static char msgUsr_buf[4][MSGWFMLEN+MSGHDRLEN];
	static char msgFlt_buf[4][MSGWFMLEN+MSGHDRLEN];
	static char msgErr_buf[4][MSGWFMLEN+MSGHDRLEN];
	static char msgInj_buf[4][MSGWFMLEN+MSGHDRLEN];
	static char msgEvr_buf[4][MSGWFMLEN+MSGHDRLEN];

	static char msgWfmStats_buf[MSGWFMSTATSLEN+MSGHDRLEN];

	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;
	struct TriggerTypes trig;
    u32 loopcnt=0, i;
    s32 statbytes;
    //u32 ssbufptr, ssbufptr_softtrig, ssbufptr_softtrig_prev;
    //u32 got_trig=0, post_trig_cnt, send_buf;




    xil_printf("Starting PSC Waveform Server...\r\n");

	// Initialize socket structure
	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_port = htons(PORT);
	serv_addr.sin_addr.s_addr = INADDR_ANY;

    // First call to socket() function
	if ((sockfd = lwip_socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		xil_printf("PSC Waveform : Error Creating Socket\r\n");
		//vTaskDelete(NULL);
	}

    // Bind to the host address using bind()
	if (lwip_bind(sockfd, (struct sockaddr *)&serv_addr, sizeof (serv_addr)) < 0) {
		xil_printf("PSC Waveform : Error Creating Socket\r\n");
		//vTaskDelete(NULL);
	}

    // Now start listening for the clients
	lwip_listen(sockfd, 0);

    xil_printf("PSC Waveform:  Server listening on port %d...\r\n",PORT);

    //initialize data structures
    for (i=0;i<=3;i++) {
	  trig.usr[i].addr_last = trig.usr[i].addr = trig.usr[i].active = trig.usr[i].sendbuf = trig.usr[i].postdlycnt = 0;
      trig.usr[i].pretrigpts = trig.usr[i].posttrigpts = 50000;
	  trig.usr[i].channum = i+1;
	  trig.usr[i].msgID = MSGUSRCH1+i;

	  trig.flt[i].addr_last = trig.flt[i].addr = trig.flt[i].active = trig.flt[i].sendbuf = trig.flt[i].postdlycnt = 0;
      trig.flt[i].pretrigpts = trig.flt[i].posttrigpts = 50000;
	  trig.flt[i].channum = i+1;
	  trig.flt[i].msgID = MSGFLTCH1+i;

	  trig.err[i].addr_last = trig.err[i].addr = trig.err[i].active = trig.err[i].sendbuf = trig.err[i].postdlycnt = 0;
      trig.err[i].pretrigpts = trig.err[i].posttrigpts = 50000;
	  trig.err[i].channum = i+1;
	  trig.err[i].msgID = MSGERRCH1+i;

	  trig.inj[i].addr_last = trig.inj[i].addr = trig.inj[i].active = trig.inj[i].sendbuf = trig.inj[i].postdlycnt = 0;
      trig.inj[i].pretrigpts = 0;
      trig.inj[i].posttrigpts = 8000;
	  trig.inj[i].channum = i+1;
	  trig.inj[i].msgID = MSGINJCH1+i;

	  trig.evr[i].addr_last = trig.evr[i].addr = trig.evr[i].active = trig.evr[i].sendbuf = trig.evr[i].postdlycnt = 0;
      trig.evr[i].pretrigpts = trig.evr[i].posttrigpts = 50000;
	  trig.evr[i].channum = i+1;
	  trig.evr[i].msgID = MSGEVRCH1+i;
    }







reconnect:

	clilen = sizeof(cli_addr);

	newsockfd = lwip_accept(sockfd, (struct sockaddr *)&cli_addr, (socklen_t *)&clilen);
	if (newsockfd < 0) {
	    xil_printf("PSC Waveform: ERROR on accept\r\n");
	    //vTaskDelete(NULL);
	}
	/* If connection is established then start communicating */
	xil_printf("PSC Waveform: Connected Accepted...\r\n");
    xil_printf("PSC Waveform: Entering while loop...\r\n");



	while (1) {

		//xil_printf("Wvfm: In main waveform loop...\r\n");
		loopcnt++;
		vTaskDelay(pdMS_TO_TICKS(100));

		CheckforTriggers(&trig);

        // Scan through all the trigger types, send waveform if there was a trigger
		for (int i = 0; i < 4; ++i) {
		    if (trig.usr[i].sendbuf == 1) {
		        if (SendWfmData(newsockfd, msgUsr_buf[i], &trig.usr[i]) < 0) goto reconnect;
		    }
		    if (trig.flt[i].sendbuf == 1) {
		        if (SendWfmData(newsockfd, msgFlt_buf[i], &trig.flt[i]) < 0) goto reconnect;
		    }
		    if (trig.err[i].sendbuf == 1) {
		        if (SendWfmData(newsockfd, msgErr_buf[i], &trig.err[i]) < 0) goto reconnect;
		    }
		    if (trig.inj[i].sendbuf == 1) {
		        if (SendWfmData(newsockfd, msgInj_buf[i], &trig.inj[i]) < 0) goto reconnect;
		    }
		    if (trig.evr[i].sendbuf == 1) {
		        if (SendWfmData(newsockfd, msgEvr_buf[i], &trig.evr[i]) < 0) goto reconnect;
		    }

		}



        // Send out Wfm Stats
		//xil_printf("Sending SnapShot Stats...\r\n");
		ReadSnapShotStats(msgWfmStats_buf,&trig);
	    Host2NetworkConvWvfm(msgWfmStats_buf,sizeof(msgWfmStats_buf)+MSGHDRLEN);
	    statbytes = lwip_write(newsockfd,msgWfmStats_buf,MSGWFMSTATSLEN+MSGHDRLEN);
	    //xil_printf("Sent %d bytes\r\n",n);
	    if (statbytes < 0) {
	      xil_printf("PSC Waveform: ERROR writing WfmStats...\r\n");
	      close(newsockfd);
	      goto reconnect;
	    }


    }

	/* close connection */
	close(newsockfd);
	vTaskDelete(NULL);
}


