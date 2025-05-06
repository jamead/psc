
#include <stdio.h>

#include <lwip/sys.h>
#include <xparameters.h>
#include <xiicps.h>

#include "local.h"

/* 24AA025E48T-I/OT at i2c address 0x50 (0b1010000)
 *  reached through XPAR_IIC_0
 */
#define EE_ADDR (0x50)


int ee_read(uint8_t addr, uint8_t *dst, size_t count)
{
    if(count > EE_SIZE || addr+count > EE_SIZE)
        return -1;

    //if(1!=XIicPS_Send(XPAR_IIC_0_BASEADDR, EE_ADDR, &addr, 1, XIIC_REPEATED_START)) {
    //    fprintf(stderr, "%s(%02x,...) failed to set addr ptr\n", __func__, addr);
    //    return -1;
    //}
    //if(count!=XIicPS_Recv(XPAR_IIC_0_BASEADDR, EE_ADDR, dst, count, XIIC_STOP)) {
    //    return -1;
    // }
    return 0;
}



// TODO: test...
int ee_write(uint8_t addr, const uint8_t *src, size_t count)
{
    if(count > EE_SIZE || addr+count > EE_SIZE)
        return -1;

    // using single byte programing.  Slower than page program, but simpler.
    for(; count; addr++, src++, count--) {
        // chip doesn't ACK while a write is in progress.
        // So we must "ack. poll" to determine when it finishes.
        // Hopefully this doesn't hang up the bus...
        //while(1!=XIic_Send(XPAR_IIC_0_BASEADDR, EE_ADDR, &addr, 1, XIIC_STOP)) {
        //    sys_msleep(5); // documented write time is 5ms
        //}
        uint8_t msg[] = {addr, *src};
        //if(2!=XIic_Send(XPAR_IIC_0_BASEADDR, EE_ADDR, msg, 2, XIIC_STOP))
        //    return -1;
        sys_msleep(5); // documented write time is 5ms
    }
    return 0;
}

