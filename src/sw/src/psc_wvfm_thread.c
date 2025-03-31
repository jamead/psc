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
void ReadSnapShotStats(char *msg) {

   u32 *msg_u32ptr;
   u32 ssbufaddr, totaltrigs, latbufaddr_soft;


   //write the PSC Header
   msg_u32ptr = (u32 *)msg;
   msg[0] = 'P';
   msg[1] = 'S';
   msg[2] = 0;
   msg[3] = (short int) MSGWFMSTATS;
   *++msg_u32ptr = htonl(MSGWFMSTATSLEN); //body length
	msg_u32ptr++;

   ssbufaddr = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_ADDRPTR);
   latbufaddr_soft = Xil_In32(XPAR_M_AXI_BASEADDR + SOFTTRIG_BUFPTR);
   totaltrigs = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_TOTALTRIGS);
   msg_u32ptr[0] = ssbufaddr;
   msg_u32ptr[1] = totaltrigs;
   msg_u32ptr[2] = latbufaddr_soft;
   msg_u32ptr[3] = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_BUFPTR);
   msg_u32ptr[4] = Xil_In32(XPAR_M_AXI_BASEADDR + FLT2TRIG_BUFPTR);
   msg_u32ptr[5] = Xil_In32(XPAR_M_AXI_BASEADDR + FLT3TRIG_BUFPTR);
   msg_u32ptr[6] = Xil_In32(XPAR_M_AXI_BASEADDR + FLT4TRIG_BUFPTR);
   msg_u32ptr[7] = Xil_In32(XPAR_M_AXI_BASEADDR + ERR1TRIG_BUFPTR);
   msg_u32ptr[8] = Xil_In32(XPAR_M_AXI_BASEADDR + ERR2TRIG_BUFPTR);
   msg_u32ptr[9] = Xil_In32(XPAR_M_AXI_BASEADDR + ERR3TRIG_BUFPTR);
   msg_u32ptr[10] = Xil_In32(XPAR_M_AXI_BASEADDR + ERR4TRIG_BUFPTR);
   msg_u32ptr[11] = Xil_In32(XPAR_M_AXI_BASEADDR + EVRTRIG_BUFPTR);



}

void ProcessTrigger(u32 *trig_addr, u32 *trig_last_addr, u32 *got_trig,
                     u32 *post_dly_cnt, u32 *send_buf, const char *trig_name) {


    if ((*trig_addr != *trig_last_addr) && (*got_trig == 0)) {
        *got_trig = 1;
        *trig_last_addr = *trig_addr;
        xil_printf("Got %s Trigger...\r\n", trig_name);
        xil_printf("Buffer Ptr at Trigger: %x\r\n", *trig_addr);
        *post_dly_cnt = 0;
    }

    if (*got_trig == 1) {
        if (*post_dly_cnt < 51) {
            (*post_dly_cnt)++;
            xil_printf("Waiting Post Trigger Time... %d\r\n", *post_dly_cnt);
        } else {
            *send_buf = 1;
            xil_printf("Send Buf...\r\n");
        }
    }
}



void CheckforTriggers(TriggerInfo *trig) {

    trig->softtrigaddr = Xil_In32(XPAR_M_AXI_BASEADDR + SOFTTRIG_BUFPTR);
	ProcessTrigger(&trig->softtrigaddr, &trig->softtrigaddr_last, &trig->got_softtrig,
                   &trig->softtrig_postdlycnt, &trig->softtrig_sendbuf, "Soft");

    trig->flt1trigaddr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_BUFPTR);
    ProcessTrigger(&trig->flt1trigaddr, &trig->flt1trigaddr_last, &trig->got_flt1trig,
                   &trig->flt1trig_postdlycnt, &trig->flt1trig_sendbuf, "Flt1");


}


/*
void CheckforTriggers(TriggerInfo *trig) {

    //Check if new soft trigger
    trig->softtrigaddr = Xil_In32(XPAR_M_AXI_BASEADDR + SOFTTRIG_BUFPTR);



    if ((trig->softtrigaddr != trig->softtrigaddr_last) && (trig->got_softtrig == 0))  {
    	trig->got_softtrig = 1;
    	trig->softtrigaddr_last = trig->softtrigaddr;
    	xil_printf("Got Soft Trigger...\r\n");
    	trig->softtrig_postdlycnt = 0;
	    xil_printf("Buffer Ptr at Trigger: %x\r\n", trig->softtrigaddr);
    }

    if (trig->got_softtrig == 1) {
    	if (trig->softtrig_postdlycnt < 51) {
    	   trig->softtrig_postdlycnt++;
    	   xil_printf("Waiting Post Trigger Time... %d\r\n",trig->softtrig_postdlycnt);
    	}
    	else {
    	   trig->softtrig_sendbuf = 1;
    	   xil_printf("Send Buf...\r\n");
    	}
    }

    // check if flt1 trigger
    trig->flt1trigaddr = Xil_In32(XPAR_M_AXI_BASEADDR + FLT1TRIG_BUFPTR);
    if ((trig->flt1trigaddr != trig->flt1trigaddr_last) && (trig->got_flt1trig == 0))  {
    	trig->got_flt1trig = 1;
    	trig->flt1trigaddr_last = trig->flt1trigaddr;
    	xil_printf("Got Flt1 Trigger...\r\n");
    	trig->flt1trig_postdlycnt = 0;
	    xil_printf("Buffer Ptr at Trigger: %x\r\n", trig->flt1trigaddr);
    }

    if (trig->got_flt1trig == 1) {
    	if (trig->flt1trig_postdlycnt < 51) {
    	   trig->flt1trig_postdlycnt++;
    	   xil_printf("Waiting Post Trigger Time... %d\r\n",trig->flt1trig_postdlycnt);
    	}
    	else {
    	   trig->flt1trig_sendbuf = 1;
    	   xil_printf("Send Buf...\r\n");
    	}
    }

}
*/





void ReadDMABuf(char *msg, u32 lataddr) {

	u32 BUFSTART = 0x10000000;
	u32 BUFLEN   = 0x01E84800;
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
    msg_u32ptr = (u32 *)msg;
    msg[0] = 'P';
    msg[1] = 'S';
    msg[2] = 0;
    msg[3] = (short int) MSGSOFT;
    *++msg_u32ptr = htonl(MSGSOFTLEN); //body length
	msg_u32ptr++;


	xil_printf("Copying Snapshot Data from CircBuf to PSC Message...\r\n");

	// Invalidate cache of entire circular buffer
	Xil_DCacheInvalidateRange(0x10000000,32e6);

    //find start and stop addresses for snapshot dump
    //start with 2 sec pretrigger
    //each trigger is 10kHz
    //Each point is 160 bytes
    startaddr = lataddr - 50000*BUFSTEPBYTES;
    stopaddr = lataddr + 50000*BUFSTEPBYTES;
    xil_printf("LatAddr: 0x%x    StartAddr: 0x%x    StopAddr: 0x%x\r\n",lataddr,startaddr,stopaddr);
    if (startaddr < 0x10000000) {
	   xil_printf("    Pretrigger wraps\r\n");
	   presecnumwords = (lataddr - BUFSTART) >> 2;
	   presecnumpts   = presecnumwords / WORDSPERSAMPLE;
	   prefirstnumwords   = 50000*WORDSPERSAMPLE - presecnumwords;
	   prefirstnumpts = prefirstnumwords / BUFSTEPWORDS;
	   startaddr = BUFSTART+BUFLEN - prefirstnumwords*4;
	   xil_printf("    Start Addr          : %9d   0x%x\r\n", startaddr,startaddr);
	   xil_printf("    Latch Addr          : %9d   0x%x\r\n", lataddr, lataddr);
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
  	   buf_data = (u32 *) lataddr;
       for (i=0;i<50000*BUFSTEPWORDS;i++) {
		 //if ((i % 4000) == 1)
		 //  xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
    	 *msg_u32ptr++ = buf_data[i];
       }




    }
    else if (stopaddr > BUFSTART+BUFLEN) {
	   xil_printf("    Postrigger wraps\r\n");

	   postfirstnumwords = (BUFSTART+BUFLEN - lataddr) >> 2;
	   postfirstnumpts   = postfirstnumwords / WORDSPERSAMPLE;
	   postsecnumwords   = 50000*WORDSPERSAMPLE - postfirstnumwords;
	   postsecnumpts = postsecnumwords / BUFSTEPWORDS;
	   xil_printf("    Latch Addr          : %9d   0x%x\r\n", lataddr, lataddr);
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
       for (i=0;i<50000*BUFSTEPWORDS;i++) {
		 //if ((i % 4000) == 1)
		 //  xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
		 *msg_u32ptr++ = buf_data[i];
       }
		//copy first postbuf
	   xil_printf("    Copying 1st part of post-trigger points\r\n");
	   buf_data = (u32 *) lataddr;
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
		 for (i=0;i<100000*BUFSTEPWORDS;i++) {
			//if (i<50)
			//   xil_printf("      %d: 0x%x\r\n",i,buf_data[i]);
		    *msg_u32ptr++ = buf_data[i];
		 }

       xil_printf("    TotalLen: %d\r\n", stopaddr-startaddr);
    }

	xil_printf("Done Copying Snapshot Data from CircBuf to PSC Message...\r\n");




}







void psc_wvfm_thread()
{

	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;
	struct TriggerInfo trig;
    u32 loopcnt=0;
    s32 n;
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


	trig.softtrigaddr_last = trig.softtrigaddr = trig.got_softtrig = trig.softtrig_sendbuf = 0;
	trig.flt1trigaddr_last = trig.flt1trigaddr = trig.got_flt1trig = trig.flt1trig_sendbuf = 0;


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


		if (trig.flt1trig_sendbuf == 1) {
	       trig.flt1trig_sendbuf = 0;
	       trig.got_flt1trig = 0;
		}

        if (trig.softtrig_sendbuf == 1)	{
           trig.softtrig_sendbuf = 0;
           trig.got_softtrig = 0;
		   xil_printf("Calling ReadDMABuf...\r\n");
		   ReadDMABuf(msgSoft_buf,trig.softtrigaddr);

           //write out Snapshot data (msg51)
		   xil_printf("Tx 10 sec of Snapshot Data\r\n");
           Host2NetworkConvWvfm(msgSoft_buf,sizeof(msgSoft_buf)+MSGHDRLEN);
           n = write(newsockfd,msgSoft_buf,MSGSOFTLEN+MSGHDRLEN);
           xil_printf("Transferred %d bytes\r\n", n);
           if (n < 0) {
        	printf("PSC Waveform: ERROR writing MSG 51 - ADC Waveform\n");
        	close(newsockfd);
        	goto reconnect;
           }
           else
            xil_printf("Tx Success...\r\n");
        }




        // Send out Wfm Stats
		//xil_printf("Sending SnapShot Stats...\r\n");
		ReadSnapShotStats(msgWfmStats_buf);
	    Host2NetworkConvWvfm(msgWfmStats_buf,sizeof(msgWfmStats_buf)+MSGHDRLEN);
	    n = write(newsockfd,msgWfmStats_buf,MSGWFMSTATSLEN+MSGHDRLEN);
	    //xil_printf("Sent %d bytes\r\n",n);
	    if (n < 0) {
	      xil_printf("PSC Waveform: ERROR writing WfmStats...\r\n");
	      close(newsockfd);
	      goto reconnect;
	    }


    }

	/* close connection */
	close(newsockfd);
	vTaskDelete(NULL);
}


