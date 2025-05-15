#include <stdlib.h>

#include <FreeRTOS.h>
#include <xil_cache_l.h>
#include <xil_io.h>

#include <lwip/init.h>
#include <lwip/sockets.h>
#include <lwip/sys.h>
#include <netif/xadapter.h>
#include <xparameters_ps.h>

#include "xqspips.h"
//#include <lwipopts.h>

#include "local.h"
#include "control.h"
#include "pl_regs.h"
#include "qspi_flash.h"

psc_key* the_server;

struct ScaleFactorType scalefactors[4];
XQspiPs QspiInstance;
float CONVVOLTSTODACBITS;
float CONVDACBITSTOVOLTS;


uint32_t git_hash;

static
void client_event(void *pvt, psc_event evt, psc_client *ckey)
{
    if(evt!=PSC_CONN)
        return;
    // send some "static" information once when a new client connects.
    struct {
        uint32_t git_hash;
        uint32_t serial;
    } msg = {
        .git_hash = htonl(git_hash),
        .serial = 0, // TODO: read from EEPROM
    };
    (void)pvt;

    psc_send_one(ckey, 0x100, sizeof(msg), &msg);
}

static
void client_msg(void *pvt, psc_client *ckey, uint16_t msgid, uint32_t msglen, void *msg)
{
    (void)pvt;
    /*
    int i;
    u32 *words = (u32 *)msg;
    xil_printf("message len = %d\r\n",msglen);

    for (i=0;i<4;i++) {
    	printf("%d: %d\n",i,htonl(words[i]));
    }
    */
    switch(msgid) {
        case 0:
        	glob_settings(msg);
        	break;

        case 1:
        case 2:
        case 3:
        case 4:
         	chan_settings(msgid,msg);
            break;

    }

    /*
    //xil_printf("ClientMsg:   MsgID=%d\r\n",msgid);
    if (msgid==0) {
    	//xil_printf("Global Message\r\n");
    }
    else if (msgid==1) {
        //xil_printf("CH1  Message Len=%d\r\n",msglen);

    } else if(msgid==1024) {
        // request CPU reset
        Xil_Out32(XPS_SYS_CTRL_BASEADDR | 0x008, 0xDF0D); // SLCR SLCR_UNLOCK
        Xil_Out32(XPS_SYS_CTRL_BASEADDR | 0x200, 0x1); // SLCR PSS_RST_CTRL[SOFT_RST]
        // may be reached, but not for long...

    } else {
        // echo back unknown msgid
    	xil_printf("Send One...   MsgID=%d\r\n",msgid);
        psc_send_one(ckey, msgid | 0x8000, msglen, msg);
    }
    */

}

static
void on_startup(void *pvt, psc_key *key)
{
    (void)pvt;
    (void)key;
    lstats_setup();
}

static
void realmain(void *arg)
{
    (void)arg;

    printf("Main thread running\n");

    {
        net_config conf = {};
        sdcard_handle(&conf);
        net_setup(&conf);
    }

    discover_setup();
    tftp_setup();

    const psc_config conf = {
        .port = 3000,
        .start = on_startup,
        .conn = client_event,
        .recv = client_msg,
    };
    
    psc_run(&the_server, &conf);
    while(1) {
        fprintf(stderr, "ERROR: PSC server loop returns!\n");
        sys_msleep(1000);
    }
}

void print_firmware_version()
{

    time_t epoch_time;
    struct tm *human_time;
    char timebuf[80];

    xil_printf("Module ID Number: %x\r\n", Xil_In32(XPAR_M_AXI_BASEADDR + ID));
    xil_printf("Module Version Number: %x\r\n", Xil_In32(XPAR_M_AXI_BASEADDR + VERSION));
    xil_printf("Project ID Number: %x\r\n", Xil_In32(XPAR_M_AXI_BASEADDR + PRJ_ID));
    xil_printf("Project Version Number: %x\r\n", Xil_In32(XPAR_M_AXI_BASEADDR + PRJ_VERSION));
    //compare to git commit with command: git rev-parse --short HEAD
    xil_printf("Git Checksum: %x\r\n", Xil_In32(XPAR_M_AXI_BASEADDR + PRJ_SHASUM));
    epoch_time = Xil_In32(XPAR_M_AXI_BASEADDR + PRJ_TIMESTAMP);
    human_time = localtime(&epoch_time);
    strftime(timebuf, sizeof(timebuf), "%Y-%m-%d %H:%M:%S", human_time);
    xil_printf("Project Compilation Timestamp: %s\r\n", timebuf);
}






int main(void) {
    // entry point from FSBL via freertos init

    // crutch until lack of thread sync. sorted out...
    //Xil_L1DCacheDisable();
    //Xil_L2CacheDisable();

    // show some signs of life...
    xil_printf("Power Supply Controller\r\n");
    print_firmware_version();

	QspiFlashInit();


    git_hash = Controller_read(GitHash);
    printf("---- Git ID: 0x%08lX\r\n", git_hash);

    sys_thread_new("main", realmain, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

    // Run threads.  Does not return.
    vTaskStartScheduler();
    // never reached
    return 42;
}
