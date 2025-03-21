/********************************************************************
*  PSC Waveform Thread
*  J. Mead
*  4-17-24
*
*  This thread is responsible for sending all waveform data to the IOC.   It does
*  this over to message ID's (51 = ADC Data, 52 = TbT data)
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
#include "zubpm_defs.h"
#include "pl_regs.h"
#include "psc_msg.h"


#define PORT  20

    //Xil_DCacheFlush();
	//Xil_DCacheInvalidateRange(0x10000000,1e6);


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



void ReadDMABuf(char *msg) {

    u32 *buf_data;
    u32 *msg_u32ptr;
    u32 i,j;


	xil_printf("\r\nReading Snapshot Data from DDR...\r\n");

    //write the PSC Header
    msg_u32ptr = (u32 *)msg;
    msg[0] = 'P';
    msg[1] = 'S';
    msg[2] = 0;
    msg[3] = (short int) MSGID51;
    *++msg_u32ptr = htonl(MSGID51LEN); //body length
	msg_u32ptr++;

	/* For testing, initialize array
	xil_printf("Initializing DDR...\r\n");
    buf_data = (u32 *) AXI_CIRBUFBASE;
    for (i=0;i<100000;i++)
    	for (j=0;j<40;j++)
    	   *buf_data++ = i;
    */
	// Invalidate cache for the area we are going to read from
	Xil_DCacheInvalidateRange(0x10000000,16e6);
    xil_printf("Copying DMA data to PSC Buffer\r\n");
    //copy the DMA'd ADC data into the msgid53 buffer
    buf_data = (u32 *) AXI_CIRBUFBASE;
	for (i=0;i<MSGID51LEN/4;i++) {
	    *msg_u32ptr++ = *buf_data++;
	     }

    /* print buffer (debug)
    msg_u32ptr = (u32 *)msg;
    msg_u32ptr++;
    msg_u32ptr++;
    for (i=0;i<125000;i=i+1000) {
    	xil_printf("%6d: ",i);
    	msg_u32ptr = msg_u32ptr + 1000;
    	for (j=0;j<40;j++)
    	   xil_printf("%8d",*msg_u32ptr++);
    	xil_printf("\r\n");
    }
    */


	xil_printf("Done Reading ADC Data\r\n");





}







void psc_wvfm_thread()
{

	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;
    u32 loopcnt=0;
    s32 n;
    u32 ssbufptr, ssbufptr_softtrig, ssbufptr_softtrig_prev;



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


    ssbufptr_softtrig_prev = 0;

	while (1) {

		//xil_printf("Wvfm: In main waveform loop...\r\n");
		loopcnt++;
		//vTaskDelay(pdMS_TO_TICKS(1000));


		do {
		   ssbufptr_softtrig = Xil_In32(XPAR_M_AXI_BASEADDR + SOFTTRIG_BUFPTR);
		   //ssbufptr = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_ADDRPTR);
		   //xil_printf("Buffer Ptr: %x\r\n", ssbufptr);
		   vTaskDelay(pdMS_TO_TICKS(10));
		}
		while (ssbufptr_softtrig == ssbufptr_softtrig_prev);

		xil_printf("Buffer Ptr at Trigger: %x\r\n", ssbufptr_softtrig);
		ssbufptr = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_ADDRPTR);
		xil_printf("Current Buffer Ptr   : %x\r\n", ssbufptr);
		ssbufptr_softtrig_prev = ssbufptr_softtrig;

		xil_printf("Triggered... Calling ReadDMABuf...\r\n");
		ReadDMABuf(msgid51_buf);

        //write out Snapshot data (msg51)
		xil_printf("Tx 10 sec of Snapshot Data\r\n");
        Host2NetworkConvWvfm(msgid51_buf,sizeof(msgid51_buf)+MSGHDRLEN);
        n = write(newsockfd,msgid51_buf,MSGID51LEN+MSGHDRLEN);
        xil_printf("Transferred %d bytes\r\n", n);

        if (n < 0) {
        	printf("PSC Waveform: ERROR writing MSG 51 - ADC Waveform\n");
        	close(newsockfd);
        	goto reconnect;
        }
        else
            xil_printf("Tx Success...\r\n");



    }

	/* close connection */
	close(newsockfd);
	vTaskDelete(NULL);
}


