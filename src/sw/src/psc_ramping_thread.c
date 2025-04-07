
#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xil_cache.h"

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




#define PORT  17

// Writes Ramptable to Fabric, currently using DPRAM for storage
// Will switch to DDR in future to support longer tables
void write_ramptable(u32 chan_num, u32 ramp_len, u32 ramp_table[])
{
  u32 i,dpram_addr, dpram_data;

  // set dac to ramp mode
  //Xil_Out32(XPAR_M_AXI_BASEADDR + PS1_DAC_JUMPMODE, 1);

  if (ramp_len > 50000) {
	  xil_printf("Max Ramp Table is 50,000 pts\r\n");
	  return;
  }

  switch (chan_num) {
     case 1:
    	 dpram_addr = PS1_DAC_RAMPADDR;
    	 dpram_data = PS1_DAC_RAMPDATA;
    	 Xil_Out32(XPAR_M_AXI_BASEADDR + PS1_DAC_RAMPLEN, ramp_len);
    	 break;

     case 2:
    	 dpram_addr = PS2_DAC_RAMPADDR;
    	 dpram_data = PS2_DAC_RAMPDATA;
    	 Xil_Out32(XPAR_M_AXI_BASEADDR + PS2_DAC_RAMPLEN, ramp_len);
    	 break;
     case 3:
    	 dpram_addr = PS3_DAC_RAMPADDR;
    	 dpram_data = PS3_DAC_RAMPDATA;
    	 Xil_Out32(XPAR_M_AXI_BASEADDR + PS3_DAC_RAMPLEN, ramp_len);
    	 break;
     case 4:
    	 dpram_addr = PS4_DAC_RAMPADDR;
    	 dpram_data = PS4_DAC_RAMPDATA;
    	 Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_RAMPLEN, ramp_len);
    	 break;

     default :
    	 xil_printf("Invalid PS Number\r\n");
    	 return;
  }

  for (i=0;i<ramp_len;i++) {
	if (i < 10)
      xil_printf("%d: %d\r\n",i,ntohl(ramp_table[i]));
	Xil_Out32(XPAR_M_AXI_BASEADDR + dpram_addr, i);
    Xil_Out32(XPAR_M_AXI_BASEADDR + dpram_data, ntohl(ramp_table[i]));
  }

	//update dac setpt with last value from ramp, so whenever we switch
	// back to FOFB or JumpMode there is no change
	//Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_RAMPLEN, (s32)val);

}



void psc_ramping_thread()
{
	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;

	u32  *bufptr, numpackets=0;
    //u32 MsgAddr, MsgData;
    u32 ps_num, ramp_len;

    ssize_t total_bytes = 0;
    ssize_t n;

    xil_printf("Starting PSC Ramping Server...\r\n");

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
	    xil_printf("PSC Ramping: ERROR on accept\r\n");

	}
	/* If connection is established then start communicating */
	xil_printf("PSC Ramping: Connected Accepted...\r\n");

	total_bytes = 0;
	while (1) {

		while (total_bytes < MAX_RAMP_TABLE) {
		  n = read(newsockfd, ramp_buf + total_bytes, MAX_RAMP_TABLE - total_bytes);
		  total_bytes += n;
		  //xil_printf("Bytes Rcvd: %d  Total Bytes Rcvd: %d \r\n", n, total_bytes);

		  if (n < 0) {
            xil_printf("PSC Ramping: Read Error..  Reconnecting...\r\n");
            close(newsockfd);
	        goto reconnect;
          }

		  if (n == 0) {
	        xil_printf("PSC Ramping: Socket Closed by Peer..  Reconnecting...\r\n");
	        close(newsockfd);
		    goto reconnect;
		  }
		}

        xil_printf("\nPacket %d Received : NumBytes = %d\r\n",++numpackets,total_bytes);
		total_bytes = 0;
        bufptr = (u32 *) ramp_buf;
        xil_printf("Header: %c%c \t",ramp_buf[0],ramp_buf[1]);
        ps_num = ntohl(*bufptr++) & 0xFFFF;
        xil_printf("Message ID : %d\t",ps_num);
        ramp_len = ntohl(*bufptr++);
        xil_printf("Body Length : %d\r\n",ramp_len);
		total_bytes = 0;  //clear total_bytes for enabling reception of next table

		xil_printf("Writing Ramp Table for PS%d with length %d\r\n",ps_num,ramp_len);
        write_ramptable(ps_num,ramp_len,bufptr);
        xil_printf("Finished Writing Ramp Table\r\n");


	}

	/* close connection */
	close(newsockfd);
	vTaskDelete(NULL);
}


