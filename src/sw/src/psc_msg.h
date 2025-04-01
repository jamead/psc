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
#define MSGSOFTLEN 16000000   //in bytes

#define MSGFLTCH1 52
#define MSGFLTCH1LEN 16000000


//Waveform Thread: Snapshot Statistics (pointers, etc)
// Updated at 10Hz, keeps waveform connection alive
#define MSGWFMSTATS 50
#define MSGWFMSTATSLEN 128




//global buffers
#define MAX_RAMP_TABLE 400000 //num bytes for 10s of ramp table
extern char ramp_buf[MAX_RAMP_TABLE];

extern char msgid30_buf[MSGID30LEN+MSGHDRLEN];
extern char msgStat10Hz_buf[MSGSTAT10HzLEN+MSGHDRLEN];

extern char msgSoft_buf[MSGSOFTLEN+MSGHDRLEN];
extern char msgFltCh1_buf[MSGFLTCH1LEN+MSGHDRLEN];
extern char msgWfmStats_buf[MSGWFMSTATSLEN+MSGHDRLEN];



// PSC Message ID 31
typedef struct SAdataMsg {
	u32 count;        // PSC Offset 0
	u32 evr_ts_ns;    // PSC Offset 4
	u32 evr_ts_s;     // PSC Offset 8
	u32 ps1_dcct[2];  // PSC Offset 12
	u32 ps1_mon[6];   // PSC Offset 20
    u32 ps2_dcct[2];  // PSC Offset 44
	u32 ps2_mon[6];   // PSC Offset 52
	u32 ps3_dcct[2];  // PSC Offset 76
    u32 ps3_mon[6];   // PSC Offset 84
	u32 ps4_dcct[2];  // PSC Offset 92
	u32 ps4_mon[6];   // PSC Offset 100
	u32 rsvd[10];
} SAdataMsg;



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
#define FP_LED_MSG 4
#define DAC_OPMODE 8
#define DAC_SETPT 12
#define DAC_RUNRAMP 16
#define DAC_RAMPLEN 20

#define TEST_TRIG_MSG 100




