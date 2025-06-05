/********************************************************************
*  Menu Thread
*
*  This thread is responsible for all console menu related items
********************************************************************/

#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xiicps.h"
#include "xuartps_hw.h"


#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "lwipopts.h"
#include "xil_printf.h"
#include "FreeRTOS.h"
#include "task.h"

/* Hardware support includes */
#include "pl_regs.h"
#include "local.h"

#define MAX_INPUT_LEN      64

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
  if ((val = get_binary_input()) != (u8)-1) {
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

// Read a line (blocking) from UART into buffer
void uart_read_line(char *buffer, int max_len) {
    int idx = 0;
    char c;

    while (idx < max_len - 1) {
        // Wait for data from UART
        while (!XUartPs_IsReceiveData(XPAR_XUARTPS_0_BASEADDR)) {
            vTaskDelay(pdMS_TO_TICKS(1)); // Yield to other tasks
        }

        c = XUartPs_ReadReg(XPAR_XUARTPS_0_BASEADDR, XUARTPS_FIFO_OFFSET) & 0xFF;

        // Echo the character back if needed
        XUartPs_SendByte(XPAR_XUARTPS_0_BASEADDR, c);

        if (c == '\r' || c == '\n') {
            break;  // End of line
        }

        buffer[idx++] = c;
    }

    buffer[idx] = '\0';  // Null-terminate

    // Optionally send newline
    xil_printf("\r\n");
}



// This function reads channel, address, and value (int or float) from console
static
void receive_console_cmd(void) {
    char input[100];
    u32 chan;
    u32 addr;
    MsgUnion data;
    MsgUnion msg_buf[2];  // [0] = addr, [1] = data
    char val_str[32];

    printf("Enter:  <channel> <command> <value> \n");
    uart_read_line(input, MAX_INPUT_LEN);

    if (sscanf(input, "%u %u %31s", (unsigned int *)&chan, (unsigned int *)&addr, val_str) != 3) {
        printf("Invalid input.\n");
        return;
    }


    // Try float conversion if value contains '.'
    if (strchr(val_str, '.')) {
        data.f = strtof(val_str, NULL);
    } else {
        data.u = strtoul(val_str, NULL, 10);
    }

    msg_buf[0].u = htonl(addr);      // network byte order
    msg_buf[1].u = htonl(data.u);    // send raw bits of float/int

    // Call your handler
    chan_settings(chan, msg_buf, sizeof(msg_buf));

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
	//play nice, don't use all the cpu resources.
	vTaskDelay(pdMS_TO_TICKS(100));

    printf("\r\n%s\r\n", head);
    for (i = 0; i < m_len; i++)
    {
      printf("  %c:  %s\r\n", m[i].entryCh, m[i].entryStr);
    }
    printf("  Q:  quit\r\n");


    while (!XUartPs_IsReceiveData(XPAR_XUARTPS_0_BASEADDR)) {
        vTaskDelay(pdMS_TO_TICKS(10)); // Yield to other tasks
    }
    choice = XUartPs_ReadReg(XPAR_XUARTPS_0_BASEADDR, XUARTPS_FIFO_OFFSET) & 0xFF;


    if (isalpha((int)choice))
      choice = toupper((int)choice);
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


static
void printTaskStats(void)
{
    TaskStatus_t taskStatusArray[MAX_TASKS];
    UBaseType_t taskCount;
    uint32_t totalRunTime;

    taskCount = uxTaskGetSystemState(taskStatusArray, MAX_TASKS, &totalRunTime);

    printf("\n%-16s %-6s %-5s %-12s %-12s %-8s\n",
           "Task", "State", "Prio", "Stack Free", "Runtime", "%%CPU");

    for (UBaseType_t i = 0; i < taskCount; i++) {
        char stateChar;
        switch (taskStatusArray[i].eCurrentState) {
            case eRunning:    stateChar = 'R'; break;
            case eReady:      stateChar = 'Y'; break;
            case eBlocked:    stateChar = 'B'; break;
            case eSuspended:  stateChar = 'S'; break;
            case eDeleted:    stateChar = 'D'; break;
            default:          stateChar = '?'; break;
        }

        float cpuPercent = totalRunTime > 0
                           ? (taskStatusArray[i].ulRunTimeCounter * 100.0f) / totalRunTime
                           : 0.0f;

        printf("%-16s %-6c %-5lu %-12lu %-12lu %6.2f%%\n",
               taskStatusArray[i].pcTaskName,
               stateChar,
               (unsigned long)taskStatusArray[i].uxCurrentPriority,
               taskStatusArray[i].usStackHighWaterMark,
               (unsigned long)taskStatusArray[i].ulRunTimeCounter,
               cpuPercent);
    }
}









void console_menu()
{

  while (1) {

    vTaskDelay(pdMS_TO_TICKS(10));

    static const menu_entry_t menu[] = {
	    {'A', "Dump EEPROM", dump_eeprom},
		{'B', "Program IP Settings", program_ip},
		{'C', "Set Resolution (HS or MS)", set_resolution},
		{'D', "Reboot", reboot},
	    {'E', "Display Snapshot Stats", print_snapshot_stats},
	    {'F', "Print FreeRTOS Stats",  printTaskStats},
	    {'G', "Dave Bergman Calibration Mode", receive_console_cmd}
	};
	static const size_t menulen = sizeof(menu)/sizeof(menu_entry_t);

	xil_printf("Running PSC Menu (len = %ld)\r\n", menulen);

	exec_menu("Select an option:", menu, menulen);

	}



}


void console_setup(void)
{
    printf("INFO: Starting console daemon\n");

    sys_thread_new("console", console_menu, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO-1);
}

