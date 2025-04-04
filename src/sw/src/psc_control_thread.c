
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





#define PORT  7



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












void psc_control_thread()
{
	int sockfd, newsockfd;
	int clilen;
	struct sockaddr_in serv_addr, cli_addr;
	int RECV_BUF_SIZE = 1024;
	char buffer[RECV_BUF_SIZE];
	int n, *bufptr, numpackets=0;
    u32 MsgAddr, MsgData;




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
		/* read a max of RECV_BUF_SIZE bytes from socket */
		n = read(newsockfd, buffer, RECV_BUF_SIZE);
        if (n <= 0) {
            xil_printf("PSC Control: ERROR reading from socket..  Reconnecting...\r\n");
            close(newsockfd);
	        goto reconnect;
        }

        bufptr = (int *) buffer;
        xil_printf("\nPacket %d Received : NumBytes = %d\r\n",++numpackets,n);
        xil_printf("Header: %c%c \t",buffer[0],buffer[1]);
        xil_printf("Message ID : %d\t",(ntohl(*bufptr++)&0xFFFF));
        xil_printf("Body Length : %d\t",ntohl(*bufptr++));
        MsgAddr = ntohl(*bufptr++);
        xil_printf("Msg Addr : %d\t",MsgAddr);
	    MsgData = ntohl(*bufptr);
        xil_printf("Data : %d\r\n",MsgData);
        //blink fp_led on message received
        set_fpleds(1);
        set_fpleds(0);


        switch(MsgAddr) {
			case SOFT_TRIG_MSG:
				xil_printf("Soft Trigger Message:   Value=%d\r\n",MsgData);
				soft_trig(MsgData);
                break;

			case TEST_TRIG_MSG:
				xil_printf("Test Trigger Message:   Value=%d\r\n",MsgData);
				Xil_Out32(XPAR_M_AXI_BASEADDR + TESTTRIG, MsgData);
				Xil_Out32(XPAR_M_AXI_BASEADDR + TESTTRIG, 0);
                break;


            case FP_LED_MSG:
            	xil_printf("Setting FP LED:   Value=%d\r\n",MsgData);
            	set_fpleds(MsgData);
            	break;



            case DAC_CH1_OPMODE:
            	xil_printf("Setting DAC CH1 Operating Mode:   Value=%d\r\n",MsgData);
            	Xil_Out32(XPAR_M_AXI_BASEADDR + PS1_DAC_JUMPMODE, MsgData);
            	break;

            case DAC_CH1_SETPT:
            	xil_printf("Setting DAC CH1 SetPoint:   Value=%d\r\n",MsgData);
            	Xil_Out32(XPAR_M_AXI_BASEADDR + PS1_DAC_SETPT, MsgData);
            	break;

            case DAC_CH1_RAMPLEN:
             	xil_printf("Setting DAC CH1 RampTable Length:   Value=%d\r\n",MsgData);
             	Xil_Out32(XPAR_M_AXI_BASEADDR + PS1_DAC_RAMPLEN, MsgData);
             	break;

            case DAC_CH1_RUNRAMP:
            	xil_printf("Running DAC CH1 Ramptable:   Value=%d\r\n",MsgData);
            	Xil_Out32(XPAR_M_AXI_BASEADDR + PS1_DAC_RUNRAMP, MsgData);
            	break;

            case DAC_CH1_GAIN:
            	xil_printf("Setting DAC CH1 Gain:   Value=%d\r\n",MsgData);
            	Xil_Out32(XPAR_M_AXI_BASEADDR + PS1_DAC_GAIN, MsgData);
            	break;

            case DAC_CH1_OFFSET:
            	xil_printf("Setting DAC CH1 Offset:   Value=%d\r\n",MsgData);
            	Xil_Out32(XPAR_M_AXI_BASEADDR + PS1_DAC_OFFSET, MsgData);
            	break;



            case DAC_CH2_OPMODE:
             	xil_printf("Setting DAC CH2 Operating Mode:   Value=%d\r\n",MsgData);
             	Xil_Out32(XPAR_M_AXI_BASEADDR + PS2_DAC_JUMPMODE, MsgData);
             	break;

             case DAC_CH2_SETPT:
             	xil_printf("Setting DAC CH2 SetPoint:   Value=%d\r\n",MsgData);
             	Xil_Out32(XPAR_M_AXI_BASEADDR + PS2_DAC_SETPT, MsgData);
             	break;

             case DAC_CH2_RAMPLEN:
              	xil_printf("Setting DAC CH2 RampTable Length:   Value=%d\r\n",MsgData);
              	Xil_Out32(XPAR_M_AXI_BASEADDR + PS2_DAC_RAMPLEN, MsgData);
              	break;

             case DAC_CH2_RUNRAMP:
             	xil_printf("Running DAC CH2 Ramptable:   Value=%d\r\n",MsgData);
             	Xil_Out32(XPAR_M_AXI_BASEADDR + PS2_DAC_RUNRAMP, MsgData);
             	break;

             case DAC_CH2_GAIN:
              	xil_printf("Setting DAC CH2 Gain:   Value=%d\r\n",MsgData);
              	Xil_Out32(XPAR_M_AXI_BASEADDR + PS2_DAC_GAIN, MsgData);
              	break;

              case DAC_CH2_OFFSET:
              	xil_printf("Setting DAC CH2 Offset:   Value=%d\r\n",MsgData);
              	Xil_Out32(XPAR_M_AXI_BASEADDR + PS2_DAC_OFFSET, MsgData);
              	break;




             case DAC_CH3_OPMODE:
               	xil_printf("Setting DAC CH3 Operating Mode:   Value=%d\r\n",MsgData);
               	Xil_Out32(XPAR_M_AXI_BASEADDR + PS3_DAC_JUMPMODE, MsgData);
               	break;

             case DAC_CH3_SETPT:
               	xil_printf("Setting DAC CH3 SetPoint:   Value=%d\r\n",MsgData);
               	Xil_Out32(XPAR_M_AXI_BASEADDR + PS3_DAC_SETPT, MsgData);
               	break;

             case DAC_CH3_RAMPLEN:
               	xil_printf("Setting DAC CH3 RampTable Length:   Value=%d\r\n",MsgData);
               	Xil_Out32(XPAR_M_AXI_BASEADDR + PS3_DAC_RAMPLEN, MsgData);
               	break;

             case DAC_CH3_RUNRAMP:
               	xil_printf("Running DAC CH3 Ramptable:   Value=%d\r\n",MsgData);
               	Xil_Out32(XPAR_M_AXI_BASEADDR + PS3_DAC_RUNRAMP, MsgData);
               	break;

             case DAC_CH3_GAIN:
              	xil_printf("Setting DAC CH3 Gain:   Value=%d\r\n",MsgData);
              	Xil_Out32(XPAR_M_AXI_BASEADDR + PS3_DAC_GAIN, MsgData);
              	break;

              case DAC_CH3_OFFSET:
              	xil_printf("Setting DAC CH3 Offset:   Value=%d\r\n",MsgData);
              	Xil_Out32(XPAR_M_AXI_BASEADDR + PS3_DAC_OFFSET, MsgData);
              	break;



             case DAC_CH4_OPMODE:
               	xil_printf("Setting DAC CH4 Operating Mode:   Value=%d\r\n",MsgData);
               	Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_JUMPMODE, MsgData);
               	break;

             case DAC_CH4_SETPT:
               	xil_printf("Setting DAC CH4 SetPoint:   Value=%d\r\n",MsgData);
               	Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_SETPT, MsgData);
               	break;

             case DAC_CH4_RAMPLEN:
               	xil_printf("Setting DAC CH4 RampTable Length:   Value=%d\r\n",MsgData);
               	Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_RAMPLEN, MsgData);
               	break;

             case DAC_CH4_RUNRAMP:
               	xil_printf("Running DAC CH4 Ramptable:   Value=%d\r\n",MsgData);
               	Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_RUNRAMP, MsgData);
               	break;

             case DAC_CH4_GAIN:
              	xil_printf("Setting DAC CH4 Gain:   Value=%d\r\n",MsgData);
              	Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_GAIN, MsgData);
              	break;

              case DAC_CH4_OFFSET:
              	xil_printf("Setting DAC CH4 Offset:   Value=%d\r\n",MsgData);
              	Xil_Out32(XPAR_M_AXI_BASEADDR + PS4_DAC_OFFSET, MsgData);
              	break;




            default:
            	xil_printf("Msg not supported yet...\r\n");
            	break;
        }

	}

	/* close connection */
	close(newsockfd);
	vTaskDelete(NULL);
}


