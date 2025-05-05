
#include <sleep.h>
#include "netif/xadapter.h"
//#include "platform_config.h"
#include "xil_printf.h"
#include "lwip/init.h"
#include "lwip/inet.h"
#include "FreeRTOS.h"

#include "xparameters.h"

#include "xiicps.h"
#include "xadcps.h"
#include "xqspips.h"
//#include "xsysmonps.h"

#include "xstatus.h"       // For XStatus

/* Hardware support includes */
#include "psc_defs.h"
#include "pl_regs.h"
#include "psc_msg.h"

#include "xil_cache.h"


#define PLATFORM_EMAC_BASEADDR XPAR_XEMACPS_0_BASEADDR
#define SYSMON_DEVICE_ID XPAR_XSYSMONPSU_0_DEVICE_ID


#define PLATFORM_ZYNQ

//#define DEFAULT_IP_ADDRESS "10.0.142.43"
//#define DEFAULT_IP_MASK "255.255.255.0"
//#define DEFAULT_GW_ADDRESS "10.0.142.1"



#define DELAY_100_MS            100UL
#define DELAY_1_SECOND          (10*DELAY_100_MS)



static sys_thread_t main_thread_handle;



#define THREAD_STACKSIZE 2048

struct netif server_netif;

XAdcPs XAdcInstance;

//global buffers
struct SAdataMsg sadata;
struct ScaleFactorType scalefactors[4];


//Ramping Buffer, 10s
char ramp_buf[400000];

//Status Thread Buffers
char msgid30_buf[MSGID30LEN+MSGHDRLEN];
char msgStat10Hz_buf[MSGSTAT10HzLEN+MSGHDRLEN];
char temp[1000];  //temp buffer, msgStat10Hz_buf was overwriting msgid51_buf sometimes



// Waveform Buffers for Snapshots
//char msgUsr_buf[4][MSGWFMLEN+MSGHDRLEN];
//char msgFlt_buf[4][MSGWFMLEN+MSGHDRLEN];
//char msgErr_buf[4][MSGWFMLEN+MSGHDRLEN];
//char msgInj_buf[4][MSGWFMLEN+MSGHDRLEN];
//char msgEvr_buf[4][MSGWFMLEN+MSGHDRLEN];


//char msgWfmStats_buf[MSGWFMSTATSLEN+MSGHDRLEN];




ip_t ip_settings;



XIicPs IicPsInstance0;	    // Instance of the IIC Device
XIicPs IicPsInstance1;


TimerHandle_t xUptimeTimer;  // Timer handle
u32 UptimeCounter = 0;  // Uptime counter


// Timer callback function
void vUptimeTimerCallback(TimerHandle_t xTimer) {
    UptimeCounter++;  // Increment uptime counter
}


static void print_ip(char *msg, ip_addr_t *ip)
{
	xil_printf(msg);
	xil_printf("%d.%d.%d.%d\n\r", ip4_addr1(ip), ip4_addr2(ip),
				ip4_addr3(ip), ip4_addr4(ip));
}


static void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	print_ip("Board IP:       ", ip);
	print_ip("Netmask :       ", mask);
	print_ip("Gateway :       ", gw);
}


static void assign_ip_settings()
{
	u8 data[4];

	xil_printf("Getting IP Address from EEPROM\r\n");
	//IP address is stored in EEPROM locations 0,1,2,3
	i2c_eeprom_readBytes(0, data, 4);
	xil_printf("IP Addr: %u.%u.%u.%u\r\n",data[0],data[1],data[2],data[3]);
	//data[0] = 10;
	//data[1] = 0;
	//data[2] = 142;
	//data[3] = 43;
	IP4_ADDR(&server_netif.ip_addr, data[0],data[1],data[2],data[3]);

	xil_printf("Getting IP Netmask from EEPROM\r\n");
	//IP netmask is stored in EEPROM locations 16,17,18,19
	i2c_eeprom_readBytes(16, data, 4);
	xil_printf("IP Netmask: %u.%u.%u.%u\r\n",data[0],data[1],data[2],data[3]);
	//data[0] = 255;
	//data[1] = 255;
	//data[2] = 254;
	//data[3] = 0;
	IP4_ADDR(&server_netif.netmask, data[0],data[1],data[2],data[3]);

	xil_printf("Getting IP Netmask from EEPROM\r\n");
	i2c_eeprom_readBytes(32, data, 4);
	//IP gw is stored in EEPROM locations 32,33,34,35
	xil_printf("IP Gateway: %u.%u.%u.%u\r\n",data[0],data[1],data[2],data[3]);
	//data[0] = 10;
	//data[1] = 0;
	//data[2] = 142;
	//data[3] = 51;
	IP4_ADDR(&server_netif.gw, data[0],data[1],data[2],data[3]);

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





void main_thread(void *p)
{
    xil_printf("In Main Thread\r\n");
	// the mac address of the board. this should be unique per board
	u8_t mac_ethernet_address[] = { 0x00, 0x0a, 0x35, 0x11, 0x11, 0x12 };
    //i2c_get_mac_address(mac_ethernet_address);
    xil_printf("Calling Lwip Init\r\n");

	// initialize lwIP before calling sys_thread_new
	lwip_init();
	xil_printf("Lwip Init Complete\r\n");

	// Add network interface to the netif_list, and set it as default
	if (!xemac_add(&server_netif, NULL, NULL, NULL, mac_ethernet_address,
		PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\r\n");
		return;
	}

	netif_set_default(&server_netif);

	// specify that the network if is up
	netif_set_up(&server_netif);

	// start packet receive thread - required for lwIP operation
	sys_thread_new("xemacif_input_thread",
			(void(*)(void*))xemacif_input_thread, &server_netif,
			THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

	//IP address are read in from EEPROM
	assign_ip_settings(&(server_netif.ip_addr),&(server_netif.netmask),&(server_netif.gw));
	print_ip_settings(&(server_netif.ip_addr),&(server_netif.netmask),&(server_netif.gw));


    //Delay for 100ms
	vTaskDelay(pdMS_TO_TICKS(100));

    // Start the Menu Thread.  Handles all Console Printing and Menu control
    xil_printf("\r\n");
    sys_thread_new("menu_thread", menu_thread, 0,THREAD_STACKSIZE, 0);


    // Start the PSC Status Thread.  Handles incoming commands from IOC
    vTaskDelay(pdMS_TO_TICKS(100));
    xil_printf("\r\n");
    sys_thread_new("psc_status_thread", psc_status_thread, 0,THREAD_STACKSIZE, 1);


    // Delay for 100ms
    vTaskDelay(pdMS_TO_TICKS(100));
    // Start the PSC Waveform Thread.  Handles incoming commands from IOC
    xil_printf("\r\n");
    sys_thread_new("psc_wvfm_thread", psc_wvfm_thread, 0, THREAD_STACKSIZE, 1);

    // Start the PSC Ramping Thread.  Handles incoming commands from IOC
    vTaskDelay(pdMS_TO_TICKS(100));
    xil_printf("\r\n");
    sys_thread_new("psc_ramping_thread", psc_ramping_thread, 0,THREAD_STACKSIZE, 1);

    // Delay for 100 ms
    vTaskDelay(pdMS_TO_TICKS(100));
    // Start the PSC Control Thread.  Handles incoming commands from IOC
    xil_printf("\r\n");
    sys_thread_new("psc_cntrl_thread", psc_control_thread, 0, THREAD_STACKSIZE, 1);

	//setup an Uptime Timer
	xUptimeTimer = xTimerCreate("UptimeTimer", pdMS_TO_TICKS(1000), pdTRUE, (void *)0, vUptimeTimerCallback);
	// Check if the timer was created successfully
	if (xUptimeTimer == NULL)
	    // Handle error (e.g., log, assert, etc.)
	    printf("Failed to create uptime timer.\n");
	else
	    // Start the timer with a block time of 0 (non-blocking)
	    if (xTimerStart(xUptimeTimer, 0) != pdPASS)
	       // Handle error (e.g., log, assert, etc.)
	       printf("Failed to start uptime timer.\n");



	vTaskDelete(NULL);
	return;
}


void InitSettings() {

    u32 base, chan;

    // global values
    Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_INJ_EVENTNUM_REG, 10);
    Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_PM_EVENTNUM_REG, 10);

    //channel values
    for (chan=0; chan<4; chan++) {
       base = XPAR_M_AXI_BASEADDR + (chan + 1) * CHBASEADDR;

       scalefactors[chan].ampspersec = 1.0;
       scalefactors[chan].dac_dccts = 1.0;
       scalefactors[chan].vout = 1.0;
       scalefactors[chan].ignd = 1.0;
       scalefactors[chan].spare = 1.0;
       scalefactors[chan].regulator = 1.0;
       scalefactors[chan].error = 1.0;

       Xil_Out32(base + DCCT1_OFFSET_REG, 0);
       Xil_Out32(base + DCCT2_OFFSET_REG, 0);
       Xil_Out32(base + DACMON_OFFSET_REG, 0);
       Xil_Out32(base + VOLT_OFFSET_REG, 0);
       Xil_Out32(base + GND_OFFSET_REG, 0);
       Xil_Out32(base + SPARE_OFFSET_REG, 0);
       Xil_Out32(base + REG_OFFSET_REG, 0);
       Xil_Out32(base + ERR_OFFSET_REG, 0);
       Xil_Out32(base + DAC_SETPT_OFFSET_REG, 0);
       Xil_Out32(base + DCCT1_GAIN_REG, 1.0 * GAIN20BITFRACT);
       Xil_Out32(base + DCCT2_GAIN_REG, 1.0 * GAIN20BITFRACT);
       Xil_Out32(base + DACMON_GAIN_REG, 1.0 * GAIN20BITFRACT);
       Xil_Out32(base + VOLT_GAIN_REG, 1.0 * GAIN20BITFRACT);
       Xil_Out32(base + GND_GAIN_REG, 1.0 * GAIN20BITFRACT);
       Xil_Out32(base + SPARE_GAIN_REG, 1.0 * GAIN20BITFRACT);
       Xil_Out32(base + REG_GAIN_REG, 1.0 * GAIN20BITFRACT);
       Xil_Out32(base + ERR_GAIN_REG, 1.0 * GAIN20BITFRACT);
       Xil_Out32(base + DAC_SETPT_GAIN_REG, 1.0 * GAIN20BITFRACT);

       Xil_Out32(base + OVC1_THRESH_REG, 5.0 * CONVVOLTSTO20BITS);
       Xil_Out32(base + OVC2_THRESH_REG, 5.0 * CONVVOLTSTO20BITS);
       Xil_Out32(base + OVV_THRESH_REG, 5.0 * CONVVOLTSTO16BITS);
       Xil_Out32(base + ERR1_THRESH_REG, 5.0 * CONVVOLTSTO16BITS);
       Xil_Out32(base + ERR2_THRESH_REG, 5.0 * CONVVOLTSTO16BITS);
       Xil_Out32(base + IGND_THRESH_REG, 5.0 * CONVVOLTSTO16BITS);

       Xil_Out32(base + OVC1_CNTLIM_REG, 0.005 * SAMPLERATE);
       Xil_Out32(base + OVC2_CNTLIM_REG, 0.005 * SAMPLERATE);
       Xil_Out32(base + OVV_CNTLIM_REG, 0.005 * SAMPLERATE);
       Xil_Out32(base + ERR1_CNTLIM_REG, 0.1 * SAMPLERATE);
       Xil_Out32(base + ERR2_CNTLIM_REG, 0.1 * SAMPLERATE);
       Xil_Out32(base + IGND_CNTLIM_REG, 0.1 * SAMPLERATE);
       Xil_Out32(base + DCCT_CNTLIM_REG, 1.0 * SAMPLERATE);
       Xil_Out32(base + FLT1_CNTLIM_REG, 1.0 * SAMPLERATE);
       Xil_Out32(base + FLT2_CNTLIM_REG, 2.0 * SAMPLERATE);
       Xil_Out32(base + FLT3_CNTLIM_REG, 3.0 * SAMPLERATE);
       Xil_Out32(base + ON_CNTLIM_REG, 3.0 * SAMPLERATE);

    }



}

void XadcInit() {

    XAdcPs_Config *ConfigPtr;

    ConfigPtr = XAdcPs_LookupConfig(XPAR_XADC_WIZ_0_DEVICE_ID);
    XAdcPs_CfgInitialize(&XAdcInstance, ConfigPtr, ConfigPtr->BaseAddress);

    // Enable Sequencer for Temp/VCCINT/etc
    //XAdcPs_SetSequencerMode(&XAdcInstance, XADCPS_SEQ_MODE_SINGCHAN);
    XAdcPs_SetSequencerMode(&XAdcInstance, XADCPS_SEQ_MODE_CONTINPASS);

    u32 Mask;
    Mask = XAdcPs_GetSeqChEnables(&XAdcInstance);
    Mask |= XADCPS_CH_TEMP | XADCPS_CH_VCCINT | XADCPS_CH_VCCAUX;
    XAdcPs_SetSeqChEnables(&XAdcInstance, Mask);

}






int main()
{

	xil_printf("BNL Power Supply Controller ...\r\n");
    print_firmware_version();
    
	init_i2c();
	XadcInit();
	prog_si570();
    sleep(1);

	// the mac address of the board. this should be unique per board
	u8_t mac_ethernet_address[] = { 0x00, 0x0B, 0x35, 0x11, 0x11, 0x12 };
    i2c_get_mac_address(mac_ethernet_address);

    xil_printf("%02x:%02x:%02x:%02x:%02x:%02x\r\n",
          mac_ethernet_address[0], mac_ethernet_address[1], mac_ethernet_address[2],
          mac_ethernet_address[3], mac_ethernet_address[4], mac_ethernet_address[5]);

 
	//EVR reset
    xil_printf("Resetting EVR GTX...\r\n");
	Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_RESET_REG, 0xFF);
	Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_RESET_REG, 0);
    usleep(1000);

    //Set Resolution
	Xil_Out32(XPAR_M_AXI_BASEADDR + RESOLUTION, 1);


    InitSettings();
    

	main_thread_handle = sys_thread_new("main_thread", main_thread, 0, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

	vTaskStartScheduler();

	while(1);

	return 0;
}
