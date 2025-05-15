
// remote reporting of select LwIP statistics

#include <stdio.h>

#include <xsysmon.h>
#include <xparameters.h>

#include <FreeRTOS.h>
#include <lwip/sys.h>
#include <lwip/stats.h>

#include "local.h"

static XSysMon xmon;

static
void lstats_push(void *unused)
{
    (void)unused;

    while(1) {
        vTaskDelay(pdMS_TO_TICKS(1000));

        struct {
            uint32_t uptime;  // 0
            uint32_t nthread; // 4
            // 8 - LINK_STATS
            struct {
                uint32_t xmit; // 8
                uint32_t recv; // 12
                uint32_t drop; // 16
                uint32_t chkerr; // 20
                uint32_t memerr; // 24
                uint32_t proterr; // 28
                uint32_t err; // 32
            } link;
            // MEM_STATS
            struct {
                uint32_t err; // 36
                uint32_t avail; // 40
                uint32_t used; // 48
                uint32_t max; // 52
                uint32_t illegal; // 56
            } mem;
            struct {
                uint32_t temp; // 60
            } sensors;
            // for backwards compatibility, must only append new values.
        } msg = {};


        // uptime as float32
        msg.uptime = htonf((xTaskGetTickCount() * 1.0f) / configTICK_RATE_HZ);
        msg.nthread = htonl(uxTaskGetNumberOfTasks());

#if LWIP_STATS
#define MV(MEM) msg.MEM = htonl(lwip_stats.MEM)
#if LINK_STATS
        MV(link.xmit);
        MV(link.recv);
        MV(link.drop);
        MV(link.chkerr);
        MV(link.memerr);
        MV(link.proterr);
        MV(link.err);
#endif

#if MEM_STATS
        MV(mem.err);
        MV(mem.avail);
        MV(mem.used);
        MV(mem.max);
        MV(mem.illegal);
#endif
#undef MV
#endif // LWIP_STATS


        if(xmon.IsReady)
            msg.sensors.temp = htonf(XSysMon_RawToTemperature(XSysMon_GetAdcData(&xmon, XSM_CH_TEMP)));

        psc_send(the_server, 101, sizeof(msg), &msg);
    }
}

void lstats_setup(void)
{
    printf("INFO: Starting stats daemon\n");

    {
        XSysMon_Config *conf = XSysMon_LookupConfig(XPAR_SYSMON_0_DEVICE_ID);
        if(conf) {
            (void)XSysMon_CfgInitialize(&xmon, conf, conf->BaseAddress);
            XSysMon_SetSequencerMode(&xmon, XSM_SEQ_MODE_SAFE);
            XSysMon_SetAvg(&xmon, XSM_AVG_256_SAMPLES);
            (void)XSysMon_SetSeqAvgEnables(&xmon, XSM_SEQ_CH_TEMP);
            (void)XSysMon_SetSeqChEnables(&xmon, XSM_SEQ_CH_TEMP);
            XSysMon_SetAdcClkDivisor(&xmon, 32); // TODO: should set based on ADC ref clock frequency.  Which is...?
            XSysMon_SetSequencerMode(&xmon, XSM_SEQ_MODE_CONTINPASS);
        }
    }

    sys_thread_new("lstats", lstats_push, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
}
