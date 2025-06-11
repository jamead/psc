#ifndef CONTROL_H_INC
#define CONTROL_H_INC

#include <xil_types.h>


//DAC modes
#define SMOOTH  0
#define RAMP    1
#define FOFB    2
#define JUMP    3



// Control Message Offsets
#define SOFT_TRIG_MSG          0
#define TEST_TRIG_MSG          4
#define FP_LED_MSG             8
#define EVR_RESET_MSG          16
#define EVR_INJ_EVENTNUM_MSG   20
#define EVR_PM_EVENTNUM_MSG    24
#define EVR_1HZ_EVENTNUM_MSG   28
#define EVR_10HZ_EVENTNUM_MSG  32
#define EVR_10KHZ_EVENTNUM_MSG 36

#define DAC_OPMODE_MSG       100
#define DAC_SETPT_MSG        104
#define DAC_RUNRAMP_MSG      108
#define DAC_RAMPLEN_MSG      112
#define DAC_SETPT_GAIN_MSG   116
#define DAC_SETPT_OFFSET_MSG 120

#define DCCT1_OFFSET_MSG     124
#define DCCT1_GAIN_MSG       128
#define DCCT2_OFFSET_MSG     132
#define DCCT2_GAIN_MSG       136
#define DACMON_OFFSET_MSG    140
#define DACMON_GAIN_MSG      144
#define VOLT_OFFSET_MSG      148
#define VOLT_GAIN_MSG        152
#define GND_OFFSET_MSG       156
#define GND_GAIN_MSG         160
#define SPARE_OFFSET_MSG     164
#define SPARE_GAIN_MSG       168
#define REG_OFFSET_MSG       172
#define REG_GAIN_MSG         176
#define ERR_OFFSET_MSG       180
#define ERR_GAIN_MSG         184

#define OVC1_THRESH_MSG      188
#define OVC2_THRESH_MSG      192
#define OVV_THRESH_MSG       196
#define ERR1_THRESH_MSG      200
#define ERR2_THRESH_MSG      204
#define IGND_THRESH_MSG      208
#define OVC1_CNTLIM_MSG      212
#define OVC2_CNTLIM_MSG      216
#define OVV_CNTLIM_MSG       220
#define ERR1_CNTLIM_MSG      224
#define ERR2_CNTLIM_MSG      228
#define IGND_CNTLIM_MSG      232
#define DCCT_CNTLIM_MSG      236
#define FLT1_CNTLIM_MSG      240
#define FLT2_CNTLIM_MSG      244
#define FLT3_CNTLIM_MSG      248
#define ON_CNTLIM_MSG        252
#define HEART_CNTLIM_MSG     256
#define FAULT_CLEAR_MSG      260
#define FAULT_MASK_MSG       264
#define DIGOUT_ON1_MSG       268
#define DIGOUT_ON2_MSG       272
#define DIGOUT_RESET_MSG     276
#define DIGOUT_SPARE_MSG     280
#define DIGOUT_PARK_MSG      284

#define SF_AMPS_PER_SEC_MSG  300
#define SF_DAC_DCCTS_MSG     304
#define SF_VOUT_MSG          308
#define SF_IGND_MSG          312
#define SF_SPARE_MSG         316
#define SF_REGULATOR_MSG     320
#define SF_ERROR_MSG         324

#define AVE_MODE_MSG         350
#define WRITE_QSPI_MSG       400
#define READ_QSPI_MSG        404

#define DUMP_ADCS_MSG        500

#define WRITE_RAMPTABLE_MSG  1000



void glob_settings(void *);
void chan_settings(u32, void *, u32);

#endif
