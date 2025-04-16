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
   snapstats.soft_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + SOFTTRIG_BUFPTR);
   snapstats.soft_active = trig->soft.active;
   snapstats.soft_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + SOFTTRIG_TS_S);
   snapstats.soft_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + SOFTTRIG_TS_NS);

   snapstats.flt1_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_BUFPTR);
   snapstats.flt1_active = trig->flt1.active;
   snapstats.flt1_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_TS_S);
   snapstats.flt1_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_TS_NS);
   snapstats.flt2_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT2TRIG_BUFPTR);
   snapstats.flt2_active = trig->flt2.active;
   snapstats.flt2_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + FLT2TRIG_TS_S);
   snapstats.flt2_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + FLT2TRIG_TS_NS);
   snapstats.flt3_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT3TRIG_BUFPTR);
   snapstats.flt3_active = trig->flt3.active;
   snapstats.flt3_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + FLT3TRIG_TS_S);
   snapstats.flt3_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + FLT3TRIG_TS_NS);
   snapstats.flt4_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT4TRIG_BUFPTR);
   snapstats.flt4_active = trig->flt4.active;
   snapstats.flt4_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + FLT4TRIG_TS_S);
   snapstats.flt4_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + FLT4TRIG_TS_NS);
   snapstats.err1_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_BUFPTR);
   snapstats.err1_active = trig->err1.active;
   snapstats.err1_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_TS_S);
   snapstats.err1_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_TS_NS);
   snapstats.err2_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR2TRIG_BUFPTR);
   snapstats.err2_active = trig->err2.active;
   snapstats.err2_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + ERR2TRIG_TS_S);
   snapstats.err2_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + ERR2TRIG_TS_NS);
   snapstats.err3_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR3TRIG_BUFPTR);
   snapstats.err3_active = trig->err3.active;
   snapstats.err3_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + ERR3TRIG_TS_S);
   snapstats.err3_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + ERR3TRIG_TS_NS);
   snapstats.err4_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR4TRIG_BUFPTR);
   snapstats.err4_active = trig->err4.active;
   snapstats.err4_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + ERR4TRIG_TS_S);
   snapstats.err4_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + ERR4TRIG_TS_NS);
   snapstats.inj1_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ1TRIG_BUFPTR);
   snapstats.inj1_active = trig->inj1.active;
   snapstats.inj1_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + INJ1TRIG_TS_S);
   snapstats.inj1_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + INJ1TRIG_TS_NS);
   snapstats.inj2_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ2TRIG_BUFPTR);
   snapstats.inj2_active = trig->inj2.active;
   snapstats.inj2_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + INJ2TRIG_TS_S);
   snapstats.inj2_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + INJ2TRIG_TS_NS);
   snapstats.inj3_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ3TRIG_BUFPTR);
   snapstats.inj3_active = trig->inj3.active;
   snapstats.inj3_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + INJ3TRIG_TS_S);
   snapstats.inj3_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + INJ3TRIG_TS_NS);
   snapstats.inj4_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ4TRIG_BUFPTR);
   snapstats.inj4_active = trig->inj4.active;
   snapstats.inj4_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + INJ4TRIG_TS_S);
   snapstats.inj4_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + INJ4TRIG_TS_NS);




   snapstats.evr_lataddr = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_BUFPTR);
   snapstats.evr_active = trig->evr.active;
   snapstats.evr_ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_TS_S);
   snapstats.evr_ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_TS_NS);

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
            xil_printf("Post Trig Cnt = %d\r\n",trig->postdlycnt);
        } else {
            trig->sendbuf = 1;
            xil_printf("\r\nSend Buf...\r\n");
        }
    }
}



void CheckforTriggers(TriggerTypes *trig) {

    if (trig->soft.active == 0)
        trig->soft.addr = Xil_In32(XPAR_M_AXI_BASEADDR + SOFTTRIG_BUFPTR);
    ProcessTrigger(&trig->soft, "Soft");

    if (trig->flt1.active == 0)
       trig->flt1.addr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_BUFPTR);
    ProcessTrigger(&trig->flt1, "Flt1");

    if (trig->flt2.active == 0)
       trig->flt2.addr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT2TRIG_BUFPTR);
    ProcessTrigger(&trig->flt2, "Flt2");

    if (trig->flt3.active == 0)
       trig->flt3.addr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT3TRIG_BUFPTR);
    ProcessTrigger(&trig->flt3, "Flt3");

    if (trig->flt4.active == 0)
       trig->flt4.addr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT4TRIG_BUFPTR);
    ProcessTrigger(&trig->flt4, "Flt4");

    if (trig->err1.active == 0)
       trig->err1.addr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_BUFPTR);
    ProcessTrigger(&trig->err1, "Err1");

    if (trig->err2.active == 0)
       trig->err2.addr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR2TRIG_BUFPTR);
    ProcessTrigger(&trig->err2, "Err2");

    if (trig->err3.active == 0)
       trig->err3.addr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR3TRIG_BUFPTR);
    ProcessTrigger(&trig->err3, "Err3");

    if (trig->err4.active == 0)
       trig->err4.addr = Xil_In32(XPAR_M_AXI_BASEADDR + ERR4TRIG_BUFPTR);
    ProcessTrigger(&trig->err4, "Err4");


    if (trig->inj1.active == 0)
       trig->inj1.addr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ1TRIG_BUFPTR);
    ProcessTrigger(&trig->inj1, "Inj1");

    if (trig->inj2.active == 0)
       trig->inj2.addr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ2TRIG_BUFPTR);
    ProcessTrigger(&trig->inj2, "Inj2");

    if (trig->inj3.active == 0)
       trig->inj3.addr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ3TRIG_BUFPTR);
    ProcessTrigger(&trig->inj3, "Inj3");

    if (trig->inj4.active == 0)
       trig->inj4.addr = Xil_In32(XPAR_M_AXI_BASEADDR + INJ4TRIG_BUFPTR);
    ProcessTrigger(&trig->inj4, "Inj4");

    if (trig->evr.active == 0)
       trig->evr.addr = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_BUFPTR);
    ProcessTrigger(&trig->evr, "EVR");




    //debug messages
    /*
    if (trig->soft.active == 1)
        xil_printf("Soft: Addr: %x    Active: %d   SendBuf: %d   Posttrigcnt: %d\r\n",
    		 trig->soft.addr, trig->soft.active, trig->soft.sendbuf, trig->soft.postdlycnt);
    if (trig->flt1.active == 1)
       xil_printf("Flt1: Addr: %x    Active: %d   SendBuf: %d   Posttrigcnt: %d\r\n",
    		 trig->flt1.addr, trig->flt1.active, trig->flt1.sendbuf, trig->flt1.postdlycnt);
    if (trig->flt2.active == 1)
       xil_printf("Flt2: Addr: %x    Active: %d   SendBuf: %d   Posttrigcnt: %d\r\n",
    		 trig->flt2.addr, trig->flt2.active, trig->flt2.sendbuf, trig->flt2.postdlycnt);
    if (trig->flt3.active == 1)
       xil_printf("Flt3: Addr: %x    Active: %d   SendBuf: %d   Posttrigcnt: %d\r\n",
    		 trig->flt3.addr, trig->flt3.active, trig->flt3.sendbuf, trig->flt3.postdlycnt);
    if (trig->flt4.active == 1)
       xil_printf("Flt4: Addr: %x    Active: %d   SendBuf: %d   Posttrigcnt: %d\r\n",
    		 trig->flt4.addr, trig->flt4.active, trig->flt4.sendbuf, trig->flt4.postdlycnt);

    */
}






void ReadDMABuf(char *msg, TriggerInfo *trig) {

	u32 BUFSTART = 0x10000000;
	u32 BUFLEN   = 0x01E84800;
	//u32 pretriglen = 20000;
	//u32 posttriglen = 20000;
	//u32 BUFEND   = 0x11E84800;
	u32 const BUFSTEPBYTES  = 0xA0; //160 bytes
    u32 const BUFSTEPWORDS = BUFSTEPBYTES/4;
    u32 const WORDSPERSAMPLE = 40;
	u32 *buf_data;
    u32 *msg_u32ptr;
    u32 i;
    u32 startaddr, stopaddr;
    u32 postfirstnumwords, postsecnumwords, postfirstnumpts, postsecnumpts;
    u32 prefirstnumwords, presecnumwords, prefirstnumpts, presecnumpts;

    //write the PSC Header
    xil_printf("In ReadDMABuf Message ID: %d\r\n",trig->msgID);
    msg_u32ptr = (u32 *)msg;
    msg[0] = 'P';
    msg[1] = 'S';
    msg[2] = 0;
    msg[3] = (short int) trig->msgID; //MSGSOFT;
    *++msg_u32ptr = htonl(MSGWFMLEN); //body length
	msg_u32ptr++;


	xil_printf("Copying Snapshot Data from CircBuf to PSC Message...\r\n");

	// Invalidate cache of entire circular buffer
	Xil_DCacheInvalidateRange(0x10000000,32e6);

    //find start and stop addresses for snapshot dump
    //start with 2 sec pretrigger
    //each trigger is 10kHz
    //Each point is 160 bytes
    startaddr = trig->addr - trig->pretrigpts*BUFSTEPBYTES;
    stopaddr = trig->addr + trig->posttrigpts*BUFSTEPBYTES;
    xil_printf("LatAddr: 0x%x    StartAddr: 0x%x    StopAddr: 0x%x\r\n",trig->addr,startaddr,stopaddr);
    if (startaddr < 0x10000000) {
	   xil_printf("    Pretrigger wraps\r\n");
	   presecnumwords = (trig->addr - BUFSTART) >> 2;
	   presecnumpts   = presecnumwords / WORDSPERSAMPLE;
	   prefirstnumwords   = trig->pretrigpts*WORDSPERSAMPLE - presecnumwords;
	   prefirstnumpts = prefirstnumwords / BUFSTEPWORDS;
	   startaddr = BUFSTART+BUFLEN - prefirstnumwords*4;
	   xil_printf("    Start Addr          : %9d   0x%x\r\n", startaddr,startaddr);
	   xil_printf("    Latch Addr          : %9d   0x%x\r\n", trig->addr, trig->addr);
	   xil_printf("    BUFSTART+BUFLEN     : %9d   0x%x\r\n", BUFSTART+BUFLEN,BUFSTART+BUFLEN);
	   xil_printf("    SecPreNumWords      : %9d   0x%x\r\n", presecnumwords, presecnumwords);
	   xil_printf("    SecPreNumPts        : %9d\r\n", presecnumpts);
	   xil_printf("    FirstPreLen         : %9d   0x%x\r\n", prefirstnumwords, prefirstnumwords);
	   xil_printf("    FirstPreNumPts      : %9d\r\n", prefirstnumpts);
	   xil_printf("    TotalPreLen         : %9d   0x%x\r\n", prefirstnumwords+presecnumwords, prefirstnumwords+presecnumwords);
	   xil_printf("    TotalPrePts         : %9d\r\n", prefirstnumpts+presecnumpts);
	   //Now that we have all the lengths, copy to the message buffer
	   //copy pre-trigger
	   xil_printf("    Copying 1st part of pre-trigger points\r\n");
	   buf_data = (u32 *) startaddr;
       for (i=0;i<prefirstnumwords;i++) {
		 //if ((i % 4000) == 1)
		 //  xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
		 *msg_u32ptr++ = buf_data[i];
       }
		//copy first postbuf
	   xil_printf("    Copying 2nd part of pre-trigger points\r\n");
	   buf_data = (u32 *) BUFSTART;
       for (i=0;i<presecnumwords;i++) {
         //if ((i % 4000) == 1)
 		 //  xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
		 *msg_u32ptr++ = buf_data[i];  // why doesn't *buf_data++ work?
       }
  	   //copy second postbuf
  	   xil_printf("    Copying post-trigger points\r\n");
  	   buf_data = (u32 *) trig->addr;
       for (i=0;i<trig->posttrigpts*BUFSTEPWORDS;i++) {
		 //if ((i % 4000) == 1)
		 //  xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
    	 *msg_u32ptr++ = buf_data[i];
       }




    }
    else if (stopaddr > BUFSTART+BUFLEN) {
	   xil_printf("    Postrigger wraps\r\n");

	   postfirstnumwords = (BUFSTART+BUFLEN - trig->addr) >> 2;
	   postfirstnumpts   = postfirstnumwords / WORDSPERSAMPLE;
	   postsecnumwords   = trig->posttrigpts*WORDSPERSAMPLE - postfirstnumwords;
	   postsecnumpts = postsecnumwords / BUFSTEPWORDS;
	   xil_printf("    Latch Addr          : %9d   0x%x\r\n", trig->addr, trig->addr);
	   xil_printf("    BUFSTART+BUFLEN     : %9d   0x%x\r\n", BUFSTART+BUFLEN,BUFSTART+BUFLEN);
	   xil_printf("    FirstPostNumWords   : %9d   0x%x\r\n", postfirstnumwords, postfirstnumwords);
	   xil_printf("    FirstPostNumPts     : %9d\r\n", postfirstnumpts);
	   xil_printf("    SecPostLen          : %9d   0x%x\r\n", postsecnumwords, postsecnumwords);
	   xil_printf("    SecPostNumPts       : %9d\r\n", postsecnumpts);
	   xil_printf("    TotalPostLen        : %9d   0x%x\r\n", postfirstnumwords+postsecnumwords, postfirstnumwords+postsecnumwords);
	   xil_printf("    TotalPostPts        : %9d\r\n", postfirstnumpts+postsecnumpts);
	   //Now that we have all the lengths, copy to the message buffer
	   //copy pre-trigger
	   xil_printf("    Copying pre-trigger points\r\n");
	   buf_data = (u32 *) startaddr;
       for (i=0;i<trig->pretrigpts*BUFSTEPWORDS;i++) {
		 //if ((i % 4000) == 1)
		 //  xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
		 *msg_u32ptr++ = buf_data[i];
       }
		//copy first postbuf
	   xil_printf("    Copying 1st part of post-trigger points\r\n");
	   buf_data = (u32 *) trig->addr;
       for (i=0;i<postfirstnumwords;i++) {
         //if ((i % 4000) == 1)
 		 //  xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
		 *msg_u32ptr++ = buf_data[i];  // why doesn't *buf_data++ work?
       }
  	   //copy second postbuf
  	   xil_printf("    Copying 2nd part of post-trigger points\r\n");
  	   buf_data = (u32 *) BUFSTART;
       for (i=0;i<postsecnumwords;i++) {
		 //if ((i % 4000) == 1)
		 //  xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
    	 *msg_u32ptr++ = buf_data[i];
       }
    }
    else {
       xil_printf("    No Wraps\r\n");
	   xil_printf("    Copying Buffer\r\n");
	   buf_data = (u32 *) startaddr;
	   xil_printf("    Buf_data : %x\r\n",buf_data);
		 for (i=0;i<(trig->pretrigpts+trig->posttrigpts)*BUFSTEPWORDS;i++) {
			//if (i<50)
			//   xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
		    *msg_u32ptr++ = buf_data[i];
		 }

       xil_printf("    TotalLen: %d\r\n", stopaddr-startaddr);
    }

	xil_printf("Done Copying Snapshot Data from CircBuf to PSC Message...\r\n");




}



s32 SendWfmData(int newsockfd, char *msg, TriggerInfo *trig) {

    int n;

    xil_printf("In SendWfmData...\r\n");
    trig->sendbuf = 0;
    trig->active = 0;

	xil_printf("Calling ReadDMABuf...\r\n");
	ReadDMABuf(msg,trig);

    //write out Snapshot data (msg51)
	xil_printf("Tx 10 sec of Snapshot Data\r\n");
    Host2NetworkConvWvfm(msg,sizeof(msgSoft_buf)+MSGHDRLEN);

    n = write(newsockfd,msg,MSGWFMLEN+MSGHDRLEN);
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

	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;
	struct TriggerTypes trig;
    u32 loopcnt=0;
    s32 n, statbytes;
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
	trig.soft.addr_last = trig.soft.addr = trig.soft.active = trig.soft.sendbuf = trig.soft.postdlycnt = 0;
	trig.flt1.addr_last = trig.flt1.addr = trig.flt1.active = trig.flt1.sendbuf = trig.flt1.postdlycnt = 0;
	trig.flt2.addr_last = trig.flt2.addr = trig.flt2.active = trig.flt2.sendbuf = trig.flt2.postdlycnt = 0;
	trig.flt3.addr_last = trig.flt3.addr = trig.flt3.active = trig.flt3.sendbuf = trig.flt3.postdlycnt = 0;
	trig.flt4.addr_last = trig.flt4.addr = trig.flt4.active = trig.flt4.sendbuf = trig.flt4.postdlycnt = 0;
	trig.err1.addr_last = trig.err1.addr = trig.err1.active = trig.err1.sendbuf = trig.err1.postdlycnt = 0;
	trig.err2.addr_last = trig.err2.addr = trig.err2.active = trig.err2.sendbuf = trig.err2.postdlycnt = 0;
	trig.err3.addr_last = trig.err3.addr = trig.err3.active = trig.err3.sendbuf = trig.err3.postdlycnt = 0;
	trig.err4.addr_last = trig.err4.addr = trig.err4.active = trig.err4.sendbuf = trig.err4.postdlycnt = 0;
	trig.inj1.addr_last = trig.inj1.addr = trig.inj1.active = trig.inj1.sendbuf = trig.inj1.postdlycnt = 0;
	trig.inj2.addr_last = trig.inj2.addr = trig.inj2.active = trig.inj2.sendbuf = trig.inj2.postdlycnt = 0;
	trig.inj3.addr_last = trig.inj3.addr = trig.inj3.active = trig.inj3.sendbuf = trig.inj3.postdlycnt = 0;
	trig.inj4.addr_last = trig.inj4.addr = trig.inj4.active = trig.inj4.sendbuf = trig.inj4.postdlycnt = 0;
	trig.evr.addr_last  = trig.evr.addr  = trig.evr.active  = trig.evr.sendbuf  = trig.evr.postdlycnt  = 0;

	trig.soft.pretrigpts = trig.soft.posttrigpts = 50000;
	trig.flt1.pretrigpts = trig.flt1.posttrigpts = 50000;
	trig.flt2.pretrigpts = trig.flt2.posttrigpts = 50000;
	trig.flt3.pretrigpts = trig.flt3.posttrigpts = 50000;
	trig.flt4.pretrigpts = trig.flt4.posttrigpts = 50000;
	trig.err1.pretrigpts = trig.err1.posttrigpts = 50000;
	trig.err2.pretrigpts = trig.err2.posttrigpts = 50000;
	trig.err3.pretrigpts = trig.err3.posttrigpts = 50000;
	trig.err4.pretrigpts = trig.err4.posttrigpts = 50000;
	trig.inj1.pretrigpts = trig.inj1.posttrigpts = 50000;
	trig.inj2.pretrigpts = trig.inj2.posttrigpts = 50000;
	trig.inj3.pretrigpts = trig.inj3.posttrigpts = 50000;
	trig.inj4.pretrigpts = trig.inj4.posttrigpts = 50000;


	trig.evr.pretrigpts = trig.evr.posttrigpts = 50000;


	trig.soft.msgID = MSGSOFT;
    trig.flt1.msgID = MSGFLTCH1;
    trig.flt2.msgID = MSGFLTCH2;
    trig.flt3.msgID = MSGFLTCH3;
    trig.flt4.msgID = MSGFLTCH4;
    trig.err1.msgID = MSGERRCH1;
    trig.err2.msgID = MSGERRCH2;
    trig.err3.msgID = MSGERRCH3;
    trig.err4.msgID = MSGERRCH4;
    trig.inj1.msgID = MSGINJCH1;
    trig.inj2.msgID = MSGINJCH2;
    trig.inj3.msgID = MSGINJCH3;
    trig.inj4.msgID = MSGINJCH4;
    trig.evr.msgID  = MSGEVR;

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

        if (trig.soft.sendbuf == 1)
        	if ((n = SendWfmData(newsockfd,msgSoft_buf,&trig.soft)) < 0) goto reconnect;

        if (trig.flt1.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgFltCh1_buf,&trig.flt1)) < 0) goto reconnect;

        if (trig.flt2.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgFltCh2_buf,&trig.flt2)) < 0) goto reconnect;

        if (trig.flt3.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgFltCh3_buf,&trig.flt3)) < 0) goto reconnect;

        if (trig.flt4.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgFltCh4_buf,&trig.flt4)) < 0) goto reconnect;

        if (trig.err1.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgErrCh1_buf,&trig.err1)) < 0) goto reconnect;

        if (trig.err2.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgErrCh2_buf,&trig.err2)) < 0) goto reconnect;

        if (trig.err3.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgErrCh3_buf,&trig.err3)) < 0) goto reconnect;

        if (trig.err4.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgErrCh4_buf,&trig.err4)) < 0) goto reconnect;

        if (trig.inj1.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgInjCh1_buf,&trig.inj1)) < 0) goto reconnect;

        if (trig.inj2.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgInjCh2_buf,&trig.inj2)) < 0) goto reconnect;

        if (trig.inj3.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgInjCh3_buf,&trig.inj3)) < 0) goto reconnect;

        if (trig.inj4.sendbuf == 1)
         	if ((n = SendWfmData(newsockfd,msgInjCh4_buf,&trig.inj4)) < 0) goto reconnect;

        if (trig.evr.sendbuf == 1)
          	if ((n = SendWfmData(newsockfd,msgErrCh4_buf,&trig.evr)) < 0) goto reconnect;



        // Send out Wfm Stats
		//xil_printf("Sending SnapShot Stats...\r\n");
		ReadSnapShotStats(msgWfmStats_buf,&trig);
	    Host2NetworkConvWvfm(msgWfmStats_buf,sizeof(msgWfmStats_buf)+MSGHDRLEN);
	    statbytes = write(newsockfd,msgWfmStats_buf,MSGWFMSTATSLEN+MSGHDRLEN);
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


