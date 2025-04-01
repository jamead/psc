
#include <sleep.h>
#include "netif/xadapter.h"
//#include "platform_config.h"
#include "xil_printf.h"
#include "lwip/init.h"
#include "lwip/inet.h"
#include "FreeRTOS.h"

#include "xparameters.h"

#include "xiicps.h"

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

//global buffers

//Ramping Buffer, 10s
char ramp_buf[400000];

//Status Thread Buffers
char msgid30_buf[MSGID30LEN+MSGHDRLEN];
char msgStat10Hz_buf[MSGSTAT10HzLEN+MSGHDRLEN];
char temp[1000];  //temp buffer, msgStat10Hz_buf was overwriting msgid51_buf sometimes


//Waveform Thread Buffers
char msgSoft_buf[MSGSOFTLEN+MSGHDRLEN];
char temp[1000];
char msgFltCh1_buf[MSGFLTCH1LEN+MSGHDRLEN];
char temp[1000];
char msgWfmStats_buf[MSGWFMSTATSLEN+MSGHDRLEN];
//char msgid52_buf[MSGID52LEN];
//char msgid53_buf[MSGID53LEN];
//char msgid54_buf[MSGID54LEN];
//char msgid55_buf[MSGID55LEN];



ip_t ip_settings;



XIicPs IicPsInstance;	    // Instance of the IIC Device



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

	//xil_printf("Getting IP Address from EEPROM\r\n");
	//IP address is stored in EEPROM locations 0,1,2,3
	//i2c_eeprom_readBytes(0, data, 4);
	//xil_printf("IP Addr: %u.%u.%u.%u\r\n",data[0],data[1],data[2],data[3]);
	data[0] = 10;
	data[1] = 0;
	data[2] = 142;
	data[3] = 43;
	IP4_ADDR(&server_netif.ip_addr, data[0],data[1],data[2],data[3]);

	//xil_printf("Getting IP Netmask from EEPROM\r\n");
	//IP netmask is stored in EEPROM locations 16,17,18,19
	//i2c_eeprom_readBytes(16, data, 4);
	//xil_printf("IP Netmask: %u.%u.%u.%u\r\n",data[0],data[1],data[2],data[3]);
	data[0] = 255;
	data[1] = 255;
	data[2] = 254;
	data[3] = 0;
	IP4_ADDR(&server_netif.netmask, data[0],data[1],data[2],data[3]);

	//xil_printf("Getting IP Netmask from EEPROM\r\n");
	//i2c_eeprom_readBytes(32, data, 4);
	//IP gw is stored in EEPROM locations 32,33,34,35
	//xil_printf("IP Gateway: %u.%u.%u.%u\r\n",data[0],data[1],data[2],data[3]);
	data[0] = 10;
	data[1] = 0;
	data[2] = 142;
	data[3] = 51;
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








int main()
{
    u32 i;
    u32 ts_s, ts_ns;


	xil_printf("BNL Power Supply Controller ...\r\n");
    print_firmware_version();
    
	init_i2c();
	//prog_si570();
	
    sleep(1);

	//EVR reset
    xil_printf("Resetting EVR GTX...\r\n");
	Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_RESET, 0xFF);
	Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_RESET, 0);
    usleep(1000);

    //read Timestamp
    /*
    for (i=0;i<5;i++) {
      ts_s = Xil_In32(XPAR_M_AXI_BASEADDR + EVR_TS_S);
      ts_ns = Xil_In32(XPAR_M_AXI_BASEADDR + EVR_TS_NS);
      xil_printf("ts= %d    %d\r\n",ts_s,ts_ns);
      sleep(1);
    }
    */

	main_thread_handle = sys_thread_new("main_thread", main_thread, 0, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);

	vTaskStartScheduler();

	while(1);

	return 0;
}
