//The PSC interface defines many different MsgID's
//The PSC Header is always 8 bytes
#define MSGHDRLEN 8

//Status Thread: This message is for System Health
#define MSGID30 30
#define MSGID30LEN 1024 //748   //in bytes


//Status Thread: This message is for 10Hz data
//#define MSGID31 31
//#define MSGID31LEN 1024  //316   //in bytes
#define MSGSTAT10Hz 31
#define MSGSTAT10HzLEN 5000  //316   //in bytes





//Waveform Thread: Snapshot Statistics (pointers, etc)
// Updated at 10Hz, keeps waveform connection alive
#define MSGWFMSTATS 50
#define MSGWFMSTATSLEN 500


//Waveform Thread: This message is for Snapshot 10KHz data
//10KS/s * 10sec *40bytes/sample = 4Mbytes
#define MSGUSRCH1 60
#define MSGUSRCH2 61
#define MSGUSRCH3 62
#define MSGUSRCH4 63

#define MSGFLTCH1 70
#define MSGFLTCH2 71
#define MSGFLTCH3 72
#define MSGFLTCH4 73

#define MSGERRCH1 80
#define MSGERRCH2 81
#define MSGERRCH3 82
#define MSGERRCH4 83

#define MSGINJCH1 90
#define MSGINJCH2 91
#define MSGINJCH3 92
#define MSGINJCH4 93

#define MSGEVRCH1 100
#define MSGEVRCH2 101
#define MSGEVRCH3 102
#define MSGEVRCH4 103




#define MSGWFMLEN 4000000   //in bytes




//global buffers

#define MAX_RAMP_TABLE 400000 //num bytes for 10s of ramp table
extern char ramp_buf[MAX_RAMP_TABLE];

extern char msgid30_buf[MSGID30LEN+MSGHDRLEN];
extern char msgStat10Hz_buf[MSGSTAT10HzLEN+MSGHDRLEN];




typedef struct SAdataChan {
	float dcct1;
	float dcct1_offset;
	float dcct1_gain;
    float dcct2;
	float dcct2_offset;
	float dcct2_gain;
	float dacmon;
	float dacmon_offset;
	float dacmon_gain;
	float volt;
	float volt_offset;
	float volt_gain;
	float gnd;
	float gnd_offset;
	float gnd_gain;
	float spare;
	float spare_offset;
	float spare_gain;
	float reg;
	float reg_offset;
	float reg_gain;
	float error;
	float error_offset;
	float error_gain;
    float dac_setpt;
    float dac_setpt_offset;
    float dac_setpt_gain;
    s32 dac_rampactive;
    float ovc1_thresh;
    float ovc2_thresh;
    float ovv_thresh;
    float err1_thresh;
    float err2_thresh;
    float ignd_thresh;
    float ovc1_cntlim;
    float ovc2_cntlim;
    float ovv_cntlim;
    float err1_cntlim;
    float err2_cntlim;
    float ignd_cntlim;
    float dcct_cntlim;
    float flt1_cntlim;
    float flt2_cntlim;
    float flt3_cntlim;
    float on_cntlim;
    float heartbeat_cntlim;
    u32 fault_clear;
    u32 fault_mask;
    u32 digout_on1;
    u32 digout_on2;
    u32 digout_reset;
    u32 digout_spare;
    u32 digout_park;
    u32 digin;
    u32 faults_live;
    u32 faults_latched;
    float sf_ampspersec;
    float sf_dac_dccts;
    float sf_vout;
    float sf_ignd;
    float sf_spare;
    float sf_regulator;
    float sf_error;
    u32 rsvd[12];
} SAdataChan;


// PSC Message ID 31
typedef struct SAdataMsg {
	u32 count;                // PSC Offset 0
	u32 evr_ts_ns;            // PSC Offset 4
	u32 evr_ts_s;             // PSC Offset 8
	u32 resolution;           // PSC Offset 12
	u32 git_shasum;           // PSC Offset 16
	float die_temp;           // PSC Offset 20
	float vccint;             // PSC Offset 24
	float vccaux;             // PSC Offset 28
	u32 rsvd[17];
    struct SAdataChan ps[4];  // PSC Offset 100
} SAdataMsg;




typedef struct SnapTrigData {
	u32 lataddr;
	u32 active;
	u32 ts_s;
	u32 ts_ns;
} SnapTrigData;


typedef struct SnapStatsMsg {
	u32 cur_bufaddr;     // PSC Offset 0
	u32 totalfacnt;      // PSC Offset 4
    SnapTrigData usr[4]; // PSC Offset 8
    SnapTrigData flt[4]; // PSC Offset 72
    SnapTrigData err[4]; // PSC Offset 136
    SnapTrigData inj[4]; // PSC Offset 200
    SnapTrigData evr[4]; // PSC OFfset 264
} SnapStatsMsg;






// PSC Message ID 30
typedef struct SysHealthMsg {
	u32   git_shasum;    // PSC Offset 0   Firmware Version (git checksum)
	float dfe_temp[2];   // PSC Offset 4   ADT7410 Temperature Sensors
	float pwr_vin;       // PSS Offset 8
	float pwr_iin;       // PSC Offset 12
    float fpga_dietemp;  // PSC Offset 28
    u32   uptime;        // PSC Offset 32
	u32   rsvd;          // PSC Offset 36
    float sfp_temp[4];   // PSC Offset 140
    float sfp_vcc[4];    // PSC Offset 164
    float sfp_txbias[4]; // PSC Offset 188
    float sfp_txpwr[4];  // PSC Offset 212
    float sfp_rxpwr[4];  // PSC Offset 236
    u32 rsvd3[5];        // PSC Offset 260
} SysHealthMsg;




// Control Message Offsets
#define SOFT_TRIG_MSG        0
#define TEST_TRIG_MSG        4
#define FP_LED_MSG           8
#define EVR_INJ_EVENTNUM_MSG 20
#define EVR_PM_EVENTNUM_MSG  24

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



/*
#define DAC_CH2_OPMODE 140
#define DAC_CH2_SETPT 144
#define DAC_CH2_RUNRAMP 148
#define DAC_CH2_RAMPLEN 152
#define DAC_CH2_GAIN 156
#define DAC_CH2_OFFSET 160

#define DAC_CH3_OPMODE 180
#define DAC_CH3_SETPT 184
#define DAC_CH3_RUNRAMP 188
#define DAC_CH3_RAMPLEN 192
#define DAC_CH3_GAIN 196
#define DAC_CH3_OFFSET 200

#define DAC_CH4_OPMODE 220
#define DAC_CH4_SETPT 224
#define DAC_CH4_RUNRAMP 228
#define DAC_CH4_RAMPLEN 232
#define DAC_CH4_GAIN 236
#define DAC_CH4_OFFSET 240
*/







