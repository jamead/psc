//The PSC interface defines many different MsgID's
//The PSC Header is always 8 bytes
#define MSGHDRLEN 8

//This message is for System Health
#define MSGID30 30
#define MSGID30LEN 1024 //748   //in bytes

//This message is for 10Hz data
#define MSGID31 31
#define MSGID31LEN 1024  //316   //in bytes

//This message is for system info
#define MSGID32 32
#define MSGID32LEN 1024  //400  //in bytes



//This message is for ADC Live waveform
//10000 pts * 4vals * 2bytes/val
#define MSGID51 51 
#define MSGID51LEN 80000   //in bytes

//This message is for TbT waveform
//1024 pts * 7vals * 4bytes/val (a,b,c,d,x,y,sum)
#define MSGID52 52 
#define MSGID52LEN 230000  //in bytes

//This message is for ADC DMA
//1e6 pts * 4vals * 2bytes/val
#define MSGID53 53
#define MSGID53LEN 8000000  //in bytes

//This message is for TBT DMA
//100e3 pts * 16vals * 4bytes/val
#define MSGID54 54
#define MSGID54LEN 6400000  //in bytes

//This message is for FA DMA
//20e3 pts * 10vals * 4bytes/val
#define MSGID55 55
#define MSGID55LEN 800000  //in bytes




//global buffers
extern char msgid30_buf[MSGID30LEN];
extern char msgid31_buf[MSGID31LEN];
extern char msgid32_buf[MSGID32LEN];

extern char msgid51_buf[MSGID51LEN];
extern char msgid52_buf[MSGID52LEN];
extern char msgid53_buf[MSGID53LEN];
extern char msgid54_buf[MSGID54LEN];
extern char msgid55_buf[MSGID55LEN];


// PSC Message ID 31
typedef struct SAdataMsg {
	u32 count;        // PSC Offset 0
	u32 evr_ts_ns;    // PSC Offset 4
	u32 evr_ts_s;     // PSC Offset 8
	u32 cha_mag;      // PSC Offset 12
	u32 chb_mag;      // PSC Offset 16
	u32 chc_mag;      // PSC Offset 20
	u32 chd_mag;      // PSC Offset 24
	u32 sum;          // PSC Offset 28
	s32 xpos_nm;      // PSC Offset 32
	s32 ypos_nm;      // PSC Offset 36
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

    float sfp_temp[2];   // PSC Offset 140
    float sfp_vcc[2];    // PSC Offset 164
    float sfp_txbias[2]; // PSC Offset 188
    float sfp_txpwr[2];  // PSC Offset 212
    float sfp_rxpwr[2];  // PSC Offset 236
    u32 rsvd3[5];        // PSC Offset 260

    float therm_temp[6]; // PSC Offset 324
} SysHealthMsg;


//PSC Message ID 31
typedef struct StatusMsg {
	u32 pll_locked;         //PSC Offset 0
	u32 cha_gain;           //PSC Offset 4
    u32 chb_gain;  		    //PSC Offset 8
    u32 chc_gain;           //PSC Offset 12
    u32 chd_gain;           //PSC Offset 16
    u32 rf_atten;           //PSC Offset 20
    u32 kx;				    //PSC Offset 24
    u32 ky; 			    //PSC Offset 28
    u32 bba_xoff;           //PSC Offset 32
    u32 bba_yoff;           //PSC Offset 36
    u32 evr_ts_s_triglat;   //PSC Offset 40
	u32 evr_ts_ns_triglat;  //PSC Offset 44
    u32 trig_eventno;       //PSC Offset 48
    u32 trig_dmacnt;        //PSC Offset 52
    u32 fine_trig_dly;      //PSC Offset 56
    u32 coarse_trig_dly;    //PSC Offset 60
    u32 trigtobeam_thresh;  //PSC Offset 64
	u32 trigtobeam_dly;     //PSC Offset 68
	u32 dma_adclen;         //PSC Offset 72
	u32 dma_tbtlen;         //PSC Offset 76
	u32 dma_falen;          //PSC Offset 80
	u32 dma_adc_active;     //PSC Offset 84
	u32 dma_tbt_active;     //PSC Offset 88
	u32 dma_fa_active;      //PSC Offset 92
	u32 dma_tx_active;      //PSC Offset 96
} StatusMsg;



// Control Message Offsets
#define SOFT_TRIG_MSG1 0
#define FP_LED_MSG1 4
#define PILOT_TONE_ENB_MSG1 8
#define ADC_IDLY_MSG1 12
#define ADC_MMCM0_MSG1 16
#define ADC_MMCM1_MSG1 20
#define ADC_SPI_MSG1 24
#define EVENT_SRC_SEL_MSG1 36 
#define DMA_TRIG_SRC_MSG1 52
#define DMA_ADCLEN_MSG1 56
#define DMA_TBTLEN_MSG1 60
#define DMA_FALEN_MSG1 64
#define MACHINE_SEL_MSG1 76
#define PILOT_TONE_SPI_MSG1 104
#define RF_ATTEN_MSG1 132
#define PT_ATTEN_MSG1 136
#define KX_MSG1 144
#define KY_MSG1 148
#define BBA_XOFF_MSG1 152
#define BBA_YOFF_MSG1 156
#define CHA_GAIN_MSG1 160
#define CHB_GAIN_MSG1 164
#define CHC_GAIN_MSG1 168
#define CHD_GAIN_MSG1 172
#define FINE_TRIG_DLY_MSG1 192  //Geo Delay
#define TBT_GATE_WIDTH_MSG1 196
#define COARSE_TRIG_DLY_MSG1 272
#define TRIGTOBEAM_THRESH_MSG1 276
#define EVENT_NO_MSG1 320




