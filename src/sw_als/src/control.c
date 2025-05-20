
#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xil_cache.h"
#include "math.h"


#include "lwip/sockets.h"
//#include "netif/xadapter.h"
//#include "lwipopts.h"
#include "xil_printf.h"
#include "FreeRTOS.h"
#include "task.h"

/* Hardware support includes */
#include "control.h"
#include "pl_regs.h"
#include "local.h"
#include "qspi_flash.h"


typedef union {
    u32 u;
    float f;
    s32 i;
} MsgUnion;



extern ScaleFactorType scalefactors[4];
extern float CONVVOLTSTODACBITS;



void set_fpleds(u32 msgVal)  {
	Xil_Out32(XPAR_M_AXI_BASEADDR + LEDS_REG, msgVal);
}


void soft_trig(u32 msgVal) {
	Xil_Out32(XPAR_M_AXI_BASEADDR + SOFTTRIG, msgVal);
	Xil_Out32(XPAR_M_AXI_BASEADDR + SOFTTRIG, 0);

}


void set_eventno(u32 msgVal) {
	//Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_TRIGNUM_REG, msgVal);
}

void Calc_WriteSmooth(u32 chan, s32 new_setpt) {

	s32 cur_setpt;
	u32 dpram_addr, dpram_data;
	u32 i;
	u32 smooth_len;
	float ramp_rate;
	float val;
	float PI = 3.14;

    cur_setpt = Xil_In32(XPAR_M_AXI_BASEADDR + DAC_CURRSETPT_REG + chan*CHBASEADDR);

	//calculate the length of the smooth length using the ramp rate scale factor
	ramp_rate = (scalefactors[chan-1].ampspersec / scalefactors[chan-1].dac_dccts) * CONVVOLTSTODACBITS;  // in bits/sec
	smooth_len = (u32)(abs(new_setpt - cur_setpt) / ramp_rate * SAMPLERATE);
	xil_printf("Smooth Length: %d\r\n",smooth_len);
	if (smooth_len >= 50000) {
		xil_printf("C'mon Smooth Length too long... Ignoring Request...\r\n");
		return;
	}

    //Set up DPRAM
	dpram_addr = DAC_RAMPADDR_REG + chan*CHBASEADDR;
	dpram_data = DAC_RAMPDATA_REG + chan*CHBASEADDR;

    //update ramping table with smooth ramp
	//s1 + ((s2 - s1) * 0.5 * (1.0 - cos(ramp_step * M_PI / T)));
	for (i=0;i<smooth_len;i++) {
		val = cur_setpt + ((new_setpt - cur_setpt) * 0.5 * (1.0 - cosf(i*PI/smooth_len)));
	    //printf("%d: %f    %d\r\n",i,val,(s32)val);

		Xil_Out32(XPAR_M_AXI_BASEADDR + dpram_addr, i);
	    Xil_Out32(XPAR_M_AXI_BASEADDR + dpram_data, (s32)val);
	    //xil_printf("Addr: %d   Data: %d   Active: %d\r\n",dpram_addr,(s32)val,Xil_In32(XPAR_M_AXI_BASEADDR + PS1_DAC_RAMPACTIVE));

	}

    // Run it
    Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RAMPLEN_REG + chan*CHBASEADDR, smooth_len);
	Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RUNRAMP_REG + chan*CHBASEADDR, 1);

}





//When changing modes between Smooth/Ramp and Jump, need to smoothly
//transition
//In Smooth/Ramp mode the dac_setpt comes from the DPRAM
//In Jump Mode the dac_setpt comes from the register
void Set_dacOpmode(u32 chan, s32 new_opmode) {
	u32 dac_mode;

	dac_mode = Xil_In32(XPAR_M_AXI_BASEADDR + DAC_OPMODE_REG + chan*CHBASEADDR);


	//if changing from smooth/ramp to jump mode first ramp to 0
	if (((dac_mode == SMOOTH) || (dac_mode == RAMP)) && new_opmode == JUMP) {
		xil_printf("Switching from Smooth/Ramp to Jump Mode\r\n");
		//Set the DAC to 0
		Calc_WriteSmooth(chan, 0);
		//Set the Jump set point to 0 too
		Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_SETPT_REG  + chan*CHBASEADDR, 0);
		//Now safe to switch to jumpmode
		Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_OPMODE_REG + chan*CHBASEADDR, JUMP);
	}

	//if changing from jump mode to smooth/ramp mode
	if ((dac_mode == JUMP) && ((new_opmode == SMOOTH) || (new_opmode == RAMP))) {
		xil_printf("Switching from Jump to Smooth/Ramp Mode\r\n");
		// Smooth the DAC to 0
		Calc_WriteSmooth(chan, 0);
		//Set the Jump set point to 0 too
		Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_SETPT_REG + chan*CHBASEADDR, 0);
		//Now safe to switch to smooth/ramp
		Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_OPMODE_REG + chan*CHBASEADDR, new_opmode);
	}


}






void Set_dac(u32 chan, float new_setpt_amps) {

	u32 dac_mode;
	s32 new_setpt;

	//first get the DAC opmode
	dac_mode = Xil_In32(XPAR_M_AXI_BASEADDR + DAC_OPMODE_REG + chan*CHBASEADDR);

	//check boundary conditions (firmware only checking if setpt*gain is above limits, need to fix)
	if (new_setpt_amps > (9.9999 * scalefactors[chan-1].dac_dccts)) {
	    xil_printf("Saturated High\r\n");
	    new_setpt_amps = 9.9999 * scalefactors[chan-1].dac_dccts;
	}
	else if (new_setpt_amps < (-10 * scalefactors[chan-1].dac_dccts)) {
	    xil_printf("Saturated Low\r\n");
	    new_setpt_amps = -10 * scalefactors[chan-1].dac_dccts;
	}


	new_setpt = (s32)(new_setpt_amps * CONVVOLTSTODACBITS / scalefactors[chan-1].dac_dccts);
	printf("New DAC Setpt: %f    %d\r\n",new_setpt_amps, (int)new_setpt);


	if (dac_mode == SMOOTH) {
        xil_printf("In Smooth Mode\r\n");
        Calc_WriteSmooth(chan, new_setpt);
	}

	else if (dac_mode == JUMP) {
        xil_printf("In Jump Mode\r\n");
		  Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_SETPT_REG + chan*CHBASEADDR, new_setpt);
	}
}




void glob_settings(void *msg) {

	u32 *msgptr = (u32 *)msg;
	u32 addr;
	MsgUnion data;

	addr = htonl(msgptr[0]);
	data.u = htonl(msgptr[1]);
	//xil_printf("Addr: %d    Data: %d\r\n",addr,data.u);


    //xil_printf("In Global Settings...\r\n");
    switch(addr) {
		case SOFT_TRIG_MSG:
			xil_printf("Soft Trigger Message:   Value=%d\r\n",data.u);
			soft_trig(data.u);
            break;

		case TEST_TRIG_MSG:
			xil_printf("Test Trigger Message:   Value=%d\r\n",data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + TESTTRIG, data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + TESTTRIG, 0);
            break;

        case FP_LED_MSG:
         	xil_printf("Setting FP LED:   Value=%d\r\n",data.u);
         	set_fpleds(data.u);
         	break;

		case EVR_RESET_MSG:
			xil_printf("Resetting EVR:   Value=%d\r\n",data.u);
			if (data.u == 1) Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_RESET_REG, 0xFF);
			else Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_RESET_REG, 0);
            break;

		case EVR_INJ_EVENTNUM_MSG:
			xil_printf("Setting INJ Event Number:   Value=%d\r\n",data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_INJ_EVENTNUM_REG, data.u);
			break;

		case EVR_PM_EVENTNUM_MSG:
			xil_printf("Setting Post Mortem Event Number:   Value=%d\r\n",data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_PM_EVENTNUM_REG, data.u);
            break;

		case EVR_1HZ_EVENTNUM_MSG:
			xil_printf("Setting 1Hz Event Number:   Value=%d\r\n",data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_1HZ_EVENTNUM_REG, data.u);
            break;

		case EVR_10HZ_EVENTNUM_MSG:
			xil_printf("Setting 10Hz Event Number:   Value=%d\r\n",data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_10HZ_EVENTNUM_REG, data.u);
            break;

		case EVR_10KHZ_EVENTNUM_MSG:
			xil_printf("Setting 10KHz Event Number:   Value=%d\r\n",data.u);
			Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_10KHZ_EVENTNUM_REG, data.u);
            break;




    }

}


void chan_settings(u32 chan, void *msg) {

    s32 scaled_val;
    u8 qspibuf[FLASH_PAGE_SIZE];

	u32 *msgptr = (u32 *)msg;
	u32 addr;
	MsgUnion data;

	addr = htonl(msgptr[0]);
	data.u = htonl(msgptr[1]);
	//xil_printf("Addr: %d    Data: %d\r\n",addr,data.u);




    switch(addr) {

        case DAC_OPMODE_MSG:
	        xil_printf("Setting DAC CH%d Operating Mode:   Value=%d\r\n",chan,data.u);
	        Set_dacOpmode(chan,data.u);
	        break;

        case DAC_SETPT_MSG:
        	scaled_val = data.f*CONVVOLTSTODACBITS / scalefactors[chan-1].dac_dccts;
	        printf("Setting DAC CH%d SetPoint:   Value=%f   Bits=%d\r\n", (int)chan, data.f, (int)scaled_val);
	        Set_dac(chan, data.f);
	        break;

        case DAC_RAMPLEN_MSG:
 	        xil_printf("Setting DAC CH%d RampTable Length:   Value=%d\r\n",chan,data.u);
 	        Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RAMPLEN_REG + chan*CHBASEADDR, data.u);
 	        break;

        case DAC_RUNRAMP_MSG:
	        xil_printf("Running DAC CH%d Ramptable:   Value=%d\r\n",chan,data.u);
	        Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_RUNRAMP_REG + chan*CHBASEADDR, data.u);
	        break;

        case DAC_SETPT_GAIN_MSG:
	        printf("Setting DAC SetPt CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
	        Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_SETPT_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
	        break;

        case DAC_SETPT_OFFSET_MSG:
	        printf("Setting DAC SetPt CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
	        scaled_val = data.f * CONVVOLTSTODACBITS / scalefactors[chan-1].dac_dccts;
	        Xil_Out32(XPAR_M_AXI_BASEADDR + DAC_SETPT_OFFSET_REG + chan*CHBASEADDR, scaled_val);
	        break;

        case DCCT1_GAIN_MSG:
 	        printf("Setting DAC CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
 	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT1_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
 	        break;

        case DCCT1_OFFSET_MSG:
 	        printf("Setting DCCT1 CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
 	        scaled_val = data.f*CONVVOLTSTODACBITS / scalefactors[chan-1].dac_dccts;
 	        xil_printf("ScaledVal: %d\r\n",scaled_val);
 	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT1_OFFSET_REG + chan*CHBASEADDR, scaled_val);
 	        break;

        case DCCT2_GAIN_MSG:
  	        printf("Setting DCCT1 CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT2_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
  	        break;

        case DCCT2_OFFSET_MSG:
  	        printf("Setting DCCT2 CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
  	        scaled_val = data.f*CONVVOLTSTODACBITS / scalefactors[chan-1].dac_dccts;
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT2_OFFSET_REG + chan*CHBASEADDR, scaled_val);
  	        break;

        case DACMON_GAIN_MSG:
  	        printf("Setting DAC Mon CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + DACMON_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
  	        break;

        case DACMON_OFFSET_MSG:
  	        printf("Setting DAC Mon CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
  	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].dac_dccts;
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + DACMON_OFFSET_REG + chan*CHBASEADDR, scaled_val);
  	        break;

        case VOLT_GAIN_MSG:
  	        printf("Setting Voltage CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + VOLT_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
  	        break;

        case VOLT_OFFSET_MSG:
  	        printf("Setting Voltage CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
  	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].vout;
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + VOLT_OFFSET_REG + chan*CHBASEADDR, scaled_val);
  	        break;

        case GND_GAIN_MSG:
  	        printf("Setting iGND CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + GND_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
  	        break;

        case GND_OFFSET_MSG:
  	        printf("Setting iGND CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
  	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].ignd;
  	        Xil_Out32(XPAR_M_AXI_BASEADDR + GND_OFFSET_REG + chan*CHBASEADDR, scaled_val);
  	        break;

        case SPARE_GAIN_MSG:
   	        printf("Setting Spare CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + SPARE_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
   	        break;

        case SPARE_OFFSET_MSG:
   	        printf("Setting Spare CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
  	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].spare;
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + SPARE_OFFSET_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case REG_GAIN_MSG:
   	        printf("Setting Regulator CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + REG_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
   	        break;

        case REG_OFFSET_MSG:
   	        printf("Setting Regulator CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
  	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].regulator;
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + REG_OFFSET_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case ERR_GAIN_MSG:
   	        printf("Setting Error CH%d Gain:   Value=%f\r\n",(int)chan,data.f);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR_GAIN_REG + chan*CHBASEADDR, data.f*GAIN20BITFRACT);
   	        break;

        case ERR_OFFSET_MSG:
   	        printf("Setting Error CH%d Offset:   Value=%f\r\n",(int)chan,data.f);
  	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].error;
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR_OFFSET_REG + chan*CHBASEADDR, scaled_val);
   	        break;


        case OVC1_THRESH_MSG:
   	        printf("Setting OVC1 Threshold CH%d :   Value=%f\r\n",(int)chan,data.f);
   	        scaled_val = data.f*CONVVOLTSTODACBITS / scalefactors[chan-1].dac_dccts;
   	        xil_printf("ScaledVal: %d\r\n", scaled_val);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVC1_THRESH_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case OVC2_THRESH_MSG:
   	        printf("Setting OVC2 Threshold CH%d :   Value=%f\r\n",(int)chan,data.f);
   	        scaled_val = data.f*CONVVOLTSTODACBITS / scalefactors[chan-1].dac_dccts;
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVC2_THRESH_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case OVV_THRESH_MSG:
   	        printf("Setting OVV Threshold CH%d :   Value=%f\r\n",(int)chan,data.f);
   	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].vout;
   	        xil_printf("OVV=%d\r\n",scaled_val);
   	        if (scaled_val >= 32767) scaled_val = 32767;
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVV_THRESH_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case ERR1_THRESH_MSG:
   	        printf("Setting Err1 Threshold CH%d :   Value=%f\r\n",(int)chan,data.f);
   	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].error;
   	        if (scaled_val >= 32767) scaled_val = 32767;
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR1_THRESH_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case ERR2_THRESH_MSG:
   	        printf("Setting Err2 Threshold CH%d :   Value=%f\r\n",(int)chan,data.f);
   	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].error;
   	        if (scaled_val >= 32767) scaled_val = 32767;
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR2_THRESH_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case IGND_THRESH_MSG:
   	        printf("Setting Ignd Threshold CH%d :   Value=%f\r\n",(int)chan,data.f);
   	        scaled_val = data.f*CONVVOLTSTO16BITS / scalefactors[chan-1].error;
   	        if (scaled_val >= 32767) scaled_val = 32767;
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + IGND_THRESH_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case OVC1_CNTLIM_MSG:
   	        printf("Setting OVC1 Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
   	        printf("Scaled Val: %d\r\n",(int)scaled_val);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVC1_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case OVC2_CNTLIM_MSG:
   	        printf("Setting OVC2 Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVC2_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case OVV_CNTLIM_MSG:
   	        printf("Setting OVV Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + OVV_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case ERR1_CNTLIM_MSG:
   	        printf("Setting Err1 Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR1_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case ERR2_CNTLIM_MSG:
   	        printf("Setting Err2 Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + ERR2_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case IGND_CNTLIM_MSG:
   	        printf("Setting Ignd Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + IGND_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case DCCT_CNTLIM_MSG:
   	        printf("Setting DCCT Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
   	        Xil_Out32(XPAR_M_AXI_BASEADDR + DCCT_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
   	        break;

        case FLT1_CNTLIM_MSG:
    	    printf("Setting Fault1 Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + FLT1_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
    	    break;

        case FLT2_CNTLIM_MSG:
    	    printf("Setting Fault2 Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + FLT2_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
    	    break;

        case FLT3_CNTLIM_MSG:
    	    printf("Setting Fault3 Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + FLT3_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
    	    break;

        case ON_CNTLIM_MSG:
    	    printf("Setting On Count Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + ON_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
    	    break;

        case HEART_CNTLIM_MSG:
    	    printf("Setting Heart Beat Limit CH%d :   Value=%f sec\r\n",(int)chan,data.f);
   	        scaled_val = (s32)(data.f * SAMPLERATE);
    	    Xil_Out32(XPAR_M_AXI_BASEADDR + HEARTBEAT_CNTLIM_REG + chan*CHBASEADDR, scaled_val);
    	    break;

        case FAULT_CLEAR_MSG:
     	    xil_printf("Setting Fault Clear CH%d :   Value=%d\r\n",chan,data.u);
     	    Xil_Out32(XPAR_M_AXI_BASEADDR + FAULT_CLEAR_REG + chan*CHBASEADDR, data.u);
     	    break;

        case FAULT_MASK_MSG:
      	    xil_printf("Setting Fault Mask CH%d :   Value=%d\r\n",chan,data.u);
      	    Xil_Out32(XPAR_M_AXI_BASEADDR + FAULT_MASK_REG + chan*CHBASEADDR, data.u);
      	    break;

        case DIGOUT_ON1_MSG:
       	    xil_printf("Setting DigOut On1 CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_ON1_REG + chan*CHBASEADDR, data.u);
       	    break;

        case DIGOUT_ON2_MSG:
       	    xil_printf("Setting DigOut On2 CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_ON2_REG + chan*CHBASEADDR, data.u);
       	    break;

        case DIGOUT_RESET_MSG:
       	    xil_printf("Setting DigOut Reset CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_RESET_REG + chan*CHBASEADDR, data.u);
       	    break;

        case DIGOUT_SPARE_MSG:
       	    xil_printf("Setting DigOut Spare CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_SPARE_REG + chan*CHBASEADDR, data.u);
       	    break;

        case DIGOUT_PARK_MSG:
       	    xil_printf("Setting DigOut Park CH%d :   Value=%d\r\n",chan,data.u);
       	    Xil_Out32(XPAR_M_AXI_BASEADDR + DIGOUT_PARK_REG + chan*CHBASEADDR, data.u);
       	    break;

         case SF_AMPS_PER_SEC_MSG:
       	    printf("Setting Amps/Sec CH%d :   Value=%f\r\n",(int)chan,data.f);
       	    scalefactors[chan-1].ampspersec = data.f;
       	    break;

        case SF_DAC_DCCTS_MSG:
       	    printf("Setting ScaleFactor DAC DCCT's Amps/Volt CH%d :   Value=%f\r\n",(int)chan,data.f);
       	    scalefactors[chan-1].dac_dccts = data.f;
       	    break;

        case SF_VOUT_MSG:
       	    printf("Setting ScaleFactor Vout CH%d :   Value=%f\r\n",(int)chan,data.f);
       	    scalefactors[chan-1].vout = data.f;
       	    break;

        case SF_IGND_MSG:
        	printf("Setting ScaleFactor Ignd CH%d :   Value=%f\r\n",(int)chan,data.f);
        	scalefactors[chan-1].ignd = data.f;
        	break;

        case SF_SPARE_MSG:
        	printf("Setting ScaleFactor Spare CH%d :   Value=%f\r\n",(int)chan,data.f);
        	scalefactors[chan-1].spare = data.f;
        	break;

        case SF_REGULATOR_MSG:
        	printf("Setting ScaleFactor Regulator CH%d :   Value=%f\r\n",(int)chan,data.f);
        	scalefactors[chan-1].regulator = data.f;
        	break;

        case SF_ERROR_MSG:
        	printf("Setting ScaleFactor Error CH%d :   Value=%f\r\n",(int)chan,data.f);
        	scalefactors[chan-1].error = data.f;
        	break;

        case AVE_MODE_MSG:
        	xil_printf("Setting 10Hz Average Mode CH%d : Value=%d\r\n",chan,data.u);
        	Xil_Out32(XPAR_M_AXI_BASEADDR + AVEMODE_REG + chan*CHBASEADDR, data.u);
        	break;

        case WRITE_QSPI_MSG:
        	xil_printf("Write Qspi Message..\r\n");
        	if (data.u == 1) {
        	   xil_printf("Writing current values for CH%dto QSPI FLASH..\r\n",chan);
           	   QspiFlashEraseSect(chan);
        	   QspiGatherData(chan, qspibuf);
        	   QspiFlashWrite(chan*FLASH_SECTOR_SIZE, FLASH_PAGE_SIZE, qspibuf);
        	   //read it back out from qspi, just for kicks
        	   QspiFlashRead(chan*FLASH_SECTOR_SIZE, FLASH_PAGE_SIZE, qspibuf);
               QspiDisperseData(chan,qspibuf);
        	}
        	break;


        default:
        	xil_printf("Unsupported Message\r\n");

    }



}


