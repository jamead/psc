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
#define MSGSTAT10HzLEN 1024  //316   //in bytes





//Waveform Thread: This message is for Snapshot 10KHz data
//10KS/s * 10sec *160bytes/sample = 16Mbytes
#define MSGSOFT 51
#define MSGFLTCH1 52
#define MSGFLTCH2 53
#define MSGFLTCH3 54
#define MSGFLTCH4 55
#define MSGERRCH1 56
#define MSGERRCH2 57
#define MSGERRCH3 58
#define MSGERRCH4 59
#define MSGEVR 60


#define MSGWFMLEN 16000000   //in bytes


//#define MSGFLTCH1LEN 16000000


//Waveform Thread: Snapshot Statistics (pointers, etc)
// Updated at 10Hz, keeps waveform connection alive
#define MSGWFMSTATS 50
#define MSGWFMSTATSLEN 256




//global buffers
#define MAX_RAMP_TABLE 400000 //num bytes for 10s of ramp table
extern char ramp_buf[MAX_RAMP_TABLE];

extern char msgid30_buf[MSGID30LEN+MSGHDRLEN];
extern char msgStat10Hz_buf[MSGSTAT10HzLEN+MSGHDRLEN];

extern char msgSoft_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgFltCh1_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgFltCh2_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgFltCh3_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgFltCh4_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgErrCh1_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgErrCh2_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgErrCh3_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgErrCh4_buf[MSGWFMLEN+MSGHDRLEN];
extern char msgEVR_buf[MSGWFMLEN+MSGHDRLEN];

extern char msgWfmStats_buf[MSGWFMSTATSLEN+MSGHDRLEN];



// PSC Message ID 31
typedef struct SAdataMsg {
	u32 count;              // PSC Offset 0
	u32 evr_ts_ns;          // PSC Offset 4
	u32 evr_ts_s;           // PSC Offset 8
	u32 ps1_dcct[2];        // PSC Offset 12
	u32 ps1_mon[6];         // PSC Offset 20
    u32 ps2_dcct[2];        // PSC Offset 44
	u32 ps2_mon[6];         // PSC Offset 52
	u32 ps3_dcct[2];        // PSC Offset 76
    u32 ps3_mon[6];         // PSC Offset 84
	u32 ps4_dcct[2];        // PSC Offset 92
	u32 ps4_mon[6];         // PSC Offset 100
    s32 ps1_dcct_offset[2]; // PSC Offset 140
	float ps1_dcct_gain[2];	// PSC Offset 148
	s32 ps1_mon_offset[6];  // PSC Offset 156
	float ps1_mon_gain[6];    // PSC Offset 180
	u32 ps1_dacsetpt;   // PSC Offset 204
	u32 ps1_rampactive; // PSC Offset 144
	u32 ps2_dacsetpt;   // PSC Offset 140
	u32 ps2_rampactive; // PSC Offset 144
	u32 ps3_dacsetpt;   // PSC Offset 140
	u32 ps3_rampactive; // PSC Offset 144
	u32 ps4_dacsetpt;   // PSC Offset 140
	u32 ps4_rampactive; // PSC Offset 144

	u32 rsvd[10];
} SAdataMsg;



// PSC Snapshot Stats Message ID 50
typedef struct SnapStatsMsg {
	u32 cur_bufaddr;     // PSC Offset 0
	u32 totalfacnt;      // PSC Offset 4
	u32 soft_lataddr;    // PSC Offset 8
	u32 soft_active;     // PSC Offset 12
	u32 soft_ts_s;       // PSC Offset 16
	u32 soft_ts_ns;      // PSC Offset 20
    u32 flt1_lataddr;    // PSC Offset 24
    u32 flt1_active;     // PSC Offset 28
    u32 flt1_ts_s;       // PSC Offset 32
    u32 flt1_ts_ns;      // PSC Offset 36
    u32 flt2_lataddr;    // PSC Offset 40
    u32 flt2_active;     // PSC Offset 44
    u32 flt2_ts_s;       // PSC Offset 48
    u32 flt2_ts_ns;      // PSC Offset 52
    u32 flt3_lataddr;    // PSC Offset 56
    u32 flt3_active;     // PSC Offset 60
    u32 flt3_ts_s;       // PSC Offset 64
    u32 flt3_ts_ns;      // PSC Offset 68
    u32 flt4_lataddr;    // PSC Offset 72
    u32 flt4_active;     // PSC Offset 76
    u32 flt4_ts_s;       // PSC Offset 80
    u32 flt4_ts_ns;      // PSC Offset 84
    u32 err1_lataddr;    // PSC Offset 88
    u32 err1_active;     // PSC Offset 92
    u32 err1_ts_s;       // PSC Offset 96
    u32 err1_ts_ns;      // PSC Offset 100
    u32 err2_lataddr;    // PSC Offset 104
    u32 err2_active;     // PSC Offset 108
    u32 err2_ts_s;       // PSC Offset 112
    u32 err2_ts_ns;      // PSC Offset 116
    u32 err3_lataddr;    // PSC Offset 120
    u32 err3_active;     // PSC Offset 124
    u32 err3_ts_s;       // PSC Offset 128
    u32 err3_ts_ns;      // PSC Offset 132
    u32 err4_lataddr;    // PSC Offset 136
    u32 err4_active;     // PSC Offset 140
    u32 err4_ts_s;       // PSC Offset 144
    u32 err4_ts_ns;      // PSC Offset 148
    u32 evr_lataddr;     // PSC Offset 152
    u32 evr_active;      // PSC Offset 156
    u32 evr_ts_s;        // PSC Offset 160
    u32 evr_ts_ns;       // PSC Offset 164



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
#define SOFT_TRIG_MSG 0
#define TEST_TRIG_MSG 4
#define FP_LED_MSG 8


#define DAC_OPMODE_MSG 100
#define DAC_SETPT_MSG 104
#define DAC_RUNRAMP_MSG 108
#define DAC_RAMPLEN_MSG 112
#define DAC_GAIN_MSG 116
#define DAC_OFFSET_MSG 120

#define DCCT1_GAIN_MSG 140
#define DCCT1_OFFSET_MSG 144
#define DCCT2_GAIN_MSG 148
#define DCCT2_OFFSET_MSG 152


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







