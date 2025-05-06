#include <stdlib.h>

#include <FreeRTOS.h>
#include <xil_cache_l.h>
#include <xil_io.h>

#include <lwip/init.h>
#include <lwip/sockets.h>
#include <lwip/sys.h>
#include <netif/xadapter.h>
#include <xparameters_ps.h>
//#include <lwipopts.h>

#include "local.h"

psc_key* the_server;

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
    if(0) {
        // TODO: placeholder for special handling of some message ID

    } else if(msgid==1024) {
        // request CPU reset
        Xil_Out32(XPS_SYS_CTRL_BASEADDR | 0x008, 0xDF0D); // SLCR SLCR_UNLOCK
        Xil_Out32(XPS_SYS_CTRL_BASEADDR | 0x200, 0x1); // SLCR PSS_RST_CTRL[SOFT_RST]
        // may be reached, but not for long...

    } else {
        // echo back unknown msgid
        psc_send_one(ckey, msgid | 0x8000, msglen, msg);
    }
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

int main(void) {
    // entry point from FSBL via freertos init

    // crutch until lack of thread sync. sorted out...
    Xil_L1DCacheDisable();
    Xil_L2CacheDisable();

    // show some signs of life...
    printf("PSC Demo Application\n");

    git_hash = Controller_read(GitHash);
    printf("---- Git ID: 0x%08lX\r\n", git_hash);

    sys_thread_new("main", realmain, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

    // Run threads.  Does not return.
    vTaskStartScheduler();
    // never reached
    return 42;
}
