/********************************************************************
*  Menu Thread
*  J. Mead
*  4-17-24
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
#include "zubpm_defs.h"


extern ip_t ip_settings;


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
    //if (sscanf(ip_addr, "%hhu.%hhu.%hhu.%hhu", &octets[0], &octets[1], &octets[2], &octets[3]) == 4) {
    //    xil_printf("Parsed IP Address:\r\n");
        //for (int i = 0; i < 4; i++)
        //    xil_printf("\tOctet %d: %u\r\n", i + 1, octets[i]);
    //} else {
    //    xil_printf("Error: Invalid IP address format.\r\n");
    // }

}


void dump_eeprom(void)
{
  xil_printf("Reading EEPROM...\r\n");
  eeprom_dump();
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






void menu_thread()
{
  xil_printf("Starting Menu Thread...\r\n");

  while (1) {

    static const menu_entry_t menu[] = {
	    {'A', "Dump EEPROM", dump_eeprom},
		{'B', "Program IP Settings", program_ip}
	};
	static const size_t menulen = sizeof(menu)/sizeof(menu_entry_t);

	printf("Running zuBPM Menu (len = %ld)\r\n", menulen);

	exec_menu("Select an option:", menu, menulen);

	}



}


