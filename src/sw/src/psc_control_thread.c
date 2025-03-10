
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
#include "zubpm_defs.h"
#include "pl_regs.h"
#include "psc_msg.h"





#define PORT  7



void set_fpleds(u32 msgVal)  {
	Xil_Out32(XPAR_M_AXI_BASEADDR + FP_LEDS_REG, msgVal);
}


void soft_trig(u32 msgVal) {
	Xil_Out32(XPAR_M_AXI_BASEADDR + FA_SOFT_TRIG_REG, msgVal);
}


void set_eventno(u32 msgVal) {
	Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_TRIGNUM_REG, msgVal);
}


void set_kxky(u32 axis, u32 msgVal) {

    if (axis == HOR)	{
       xil_printf("Setting Kx to %d nm\r\n",msgVal);
       Xil_Out32(XPAR_M_AXI_BASEADDR + KX_REG, msgVal);
    }
    else {
       xil_printf("Setting Ky to %d nm\r\n",msgVal);
       Xil_Out32(XPAR_M_AXI_BASEADDR + KY_REG, msgVal);

    }
}





void set_gain(u32 channel, u32 msgVal) {

switch(channel) {
    case CHA:
       Xil_Out32(XPAR_M_AXI_BASEADDR + CHA_GAIN_REG, msgVal);
       xil_printf("Setting ChA gain to %d \r\n",msgVal);
	   break;
	case CHB:
	   Xil_Out32(XPAR_M_AXI_BASEADDR + CHB_GAIN_REG, msgVal);
       xil_printf("Setting ChB gain to %d\r\n",msgVal);
	   break;
    case CHC:
       Xil_Out32(XPAR_M_AXI_BASEADDR + CHC_GAIN_REG, msgVal);
       xil_printf("Setting ChC gain to %d\r\n",msgVal);
	   break;
	case CHD:
	   Xil_Out32(XPAR_M_AXI_BASEADDR + CHD_GAIN_REG, msgVal);
       xil_printf("Setting ChD gain to %d\r\n",msgVal);
	   break;
    default:
       xil_printf("Invalid gain channel number\r\n");
	   break;
    }
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
			case SOFT_TRIG_MSG1:
				xil_printf("Soft Trigger Message:   Value=%d\r\n",MsgData);
                soft_trig(MsgData);
                break;


			case KX_MSG1:
				xil_printf("Kx Message:   Value=%d\r\n",MsgData);
                set_kxky(HOR,MsgData);
                break;

			case KY_MSG1:
				xil_printf("Ky Message:   Value=%d\r\n",MsgData);
                set_kxky(VERT,MsgData);
                break;

            case CHA_GAIN_MSG1:
            	xil_printf("ChA Gain Message:   Value=%d\r\n",MsgData);
                set_gain(CHA,MsgData);
                break;

            case CHB_GAIN_MSG1:
            	xil_printf("ChB Gain Message:   Value=%d\r\n",MsgData);
                set_gain(CHB,MsgData);
                break;

            case CHC_GAIN_MSG1:
            	xil_printf("ChC Gain Message:   Value=%d\r\n",MsgData);
                set_gain(CHC,MsgData);
                break;

            case CHD_GAIN_MSG1:
            	xil_printf("ChD Gain Message:   Value=%d\r\n",MsgData);
                set_gain(CHD,MsgData);
                break;

            case FINE_TRIG_DLY_MSG1:
            	xil_printf("Fine Trig Delay Message:   Value=%d\r\n",MsgData);
                //set_geo_dly(MsgData);
                break;

            case COARSE_TRIG_DLY_MSG1:
            	xil_printf("Coarse Trig Delay Message:   Value=%d\r\n",MsgData);
            	//set_coarse_dly(MsgData);
            	break;

            case TRIGTOBEAM_THRESH_MSG1:
            	xil_printf("Trigger to Beam Threshold Message:   Value=%d\r\n",MsgData);
            	//set_trigtobeam_thresh(MsgData);
            	break;


            case EVENT_NO_MSG1:
            	xil_printf("DMA Event Number Message:   Value=%d\r\n",MsgData);
                set_eventno(MsgData);
                break;


            case FP_LED_MSG1:
            	xil_printf("Setting FP LED:   Value=%d\r\n",MsgData);
            	//set_fpleds(MsgData);
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


