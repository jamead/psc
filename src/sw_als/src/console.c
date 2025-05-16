/********************************************************************
*  Menu Thread
*
*  This thread is responsible for all console menu related items
********************************************************************/

#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xiicps.h"


#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "lwipopts.h"
#include "xil_printf.h"
#include "FreeRTOS.h"
#include "task.h"

/* Hardware support includes */
#include "pl_regs.h"
#include "local.h"


typedef struct {
  u8 ipaddr[4];
  u8 ipmask[4];
  u8 ipgw[4];
} ip_t;


static ip_t ip_settings;


typedef struct {
  char entryCh;
  char *entryStr;
  void (* entryFunc)(void);
} menu_entry_t;



void exec_menu(const char *head, const menu_entry_t *m, size_t m_len);
void test_menu(void);




void menu_get_ipaddr(u8 *octets)
{
    char c; //ip_address[16];
    char ip_addr[40];
    u32 index=0;


    //xil_printf("Enter an IP address (format: x.x.x.x): ");
    while (1) {
       c = inbyte();
       xil_printf("%c",c);
       if (c == '\b')
    	   index--;
       else if (c == '\r')  {
    	   xil_printf("\r");
    	   ip_addr[index++] = '\n';
    	   break;
       }
       else
         ip_addr[index++] = c;
    }

    // TODO check if IP address is valid
    //xil_printf("\r\nStored IP Address: %s\r\n", ip_addr);
    //check if valid format
    sscanf(ip_addr, "%hhu.%hhu.%hhu.%hhu", &octets[0], &octets[1], &octets[2], &octets[3]);

}


u8 get_binary_input(void) {
    char c;

    c = inbyte();
    xil_printf("%c",c);
    if (c == '0') {
        return 0;
    } else if (c == '1') {
        return 1;
    } else {
       printf("\r\nInvalid input. Please enter 0 or 1.\r\n");
       return -1;
    }

}



void dump_eeprom(void)
{
  xil_printf("Reading EEPROM...\r\n");
  eeprom_dump();
}

void print_snapshot_stats(void)
{
  u32 ssbufptr, totaltrigs;

  ssbufptr = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_ADDRPTR);
  totaltrigs = Xil_In32(XPAR_M_AXI_BASEADDR + SNAPSHOT_TOTALTRIGS);
  xil_printf("BufPtr: %x\t TotalTrigs: %d\r\n",ssbufptr,totaltrigs);


}

void set_resolution(void)
{
  u8 val;

  xil_printf("\r\nSet Resolution of PSC: 0=MS (18bit), 1=HS (20bit)");
  if ((val = get_binary_input()) != -1) {
     i2c_eeprom_writeBytes(48, &val, 1);
     xil_printf("Reboot for settings to take effect\r\n");
  }
}


void program_ip(void)
{
  xil_printf("\r\nProgram IP address into EEPROM\r\n");
  xil_printf("\r\nEnter an IP address (format: x.x.x.x):  ");
  menu_get_ipaddr(ip_settings.ipaddr);
  xil_printf("\r\nEnter a Netmask (format: x.x.x.x):  ");
  menu_get_ipaddr(ip_settings.ipmask);
  xil_printf("\r\nEnter an Gateway address (format: x.x.x.x):  ");
  menu_get_ipaddr(ip_settings.ipgw);
  xil_printf("\r\n");
  xil_printf("IP Addr: %u.%u.%u.%u\r\n",ip_settings.ipaddr[0],ip_settings.ipaddr[1],ip_settings.ipaddr[2],ip_settings.ipaddr[3]);
  xil_printf("Netmask: %u.%u.%u.%u\r\n",ip_settings.ipmask[0],ip_settings.ipmask[1],ip_settings.ipmask[2],ip_settings.ipmask[3]);
  xil_printf("Gateway: %u.%u.%u.%u\r\n",ip_settings.ipgw[0],ip_settings.ipgw[1],ip_settings.ipgw[2],ip_settings.ipgw[3]);

  i2c_eeprom_writeBytes(0, ip_settings.ipaddr, 4);
  usleep(100000);
  i2c_eeprom_writeBytes(16, ip_settings.ipmask, 4);
  usleep(100000);
  i2c_eeprom_writeBytes(32, ip_settings.ipgw, 4);
  usleep(100000);
  xil_printf("Reboot for settings to take effect\r\n");

}




void exec_menu(const char *head, const menu_entry_t *m, size_t m_len)
{
  const char *defaultHead = "Select:";
  size_t i;
  char choice;
  int exit_flag = 0;

  if (head == NULL)
  {
    head = defaultHead;
  }

  while (!exit_flag)
  {
    printf("\r\n%s\r\n", head);
    for (i = 0; i < m_len; i++)
    {
      printf("  %c:  %s\r\n", m[i].entryCh, m[i].entryStr);
    }
    printf("  Q:  quit\r\n");

    choice = inbyte();
    if (isalpha(choice))
      choice = toupper(choice);
    printf("%c\r\n\r\n", choice);

    for (i = 0; i < m_len; i++) {
      if (m[i].entryCh == choice) {
        if (m[i].entryFunc != NULL)
          m[i].entryFunc();
        break;
      }
    }
    if (choice == 'Q')
    {
      exit_flag = 1;
    }
  }
}


void reboot() {

	u8 val;

	xil_printf("\r\nAre you sure you want to reboot?\r\n");
	xil_printf("Press 1 to continue, any other key to not reboot\r\n");
	if ((val = get_binary_input()) == 1) {
      Xil_Out32(XPS_SYS_CTRL_BASEADDR | 0x008, 0xDF0D); // SLCR SLCR_UNLOCK
      Xil_Out32(XPS_SYS_CTRL_BASEADDR | 0x200, 0x1); // SLCR PSS_RST_CTRL[SOFT_RST]
	}

}



void console_menu()
{

  while (1) {

    vTaskDelay(pdMS_TO_TICKS(100));

    static const menu_entry_t menu[] = {
	    {'A', "Dump EEPROM", dump_eeprom},
		{'B', "Program IP Settings", program_ip},
		{'C', "Set Resolution (HS or MS)", set_resolution},
		{'D', "Reboot", reboot},
	    {'E', "Display Snapshot Stats", print_snapshot_stats}
	};
	static const size_t menulen = sizeof(menu)/sizeof(menu_entry_t);

	xil_printf("Running PSC Menu (len = %ld)\r\n", menulen);

	exec_menu("Select an option:", menu, menulen);

	}



}


void console_setup(void)
{
    printf("INFO: Starting console daemon\n");

    sys_thread_new("console", console_menu, NULL, THREAD_STACKSIZE, 1);
}

