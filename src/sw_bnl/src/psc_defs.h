#include "xqspips.h"


#define GAIN20BITFRACT 1048575.0
#define GAIN16BITFRACT 65535.0


#define CONVVOLTSTO16BITS  3276.8   // 2^16/20.0
#define CONV16BITSTOVOLTS  1/CONVVOLTSTO16BITS

#define CONVVOLTSTO18BITS  13107.2  // 2^20/20.0
#define CONV18BITSTOVOLTS  1/CONVVOLTSTO18BITS

#define CONVVOLTSTO20BITS  52428.8   // 2^20/20.0
#define CONV20BITSTOVOLTS  1/CONVVOLTSTO20BITS

//#define CONVVOLTSTODACBITS  52428.8   // 2^20/20.0
//#define CONVDACBITSTOVOLTS  1/CONVVOLTSTODACBITS


#define SAMPLERATE 10000.0

#define MS_RES 0  //medium resolution, 18bits
#define HS_RES 1  //high resolution, 20bits


//DAC modes
#define SMOOTH  0
#define RAMP    1
#define FOFB    2
#define JUMP    3

#define FLASH_WRITE_CMD		        0x02
#define FLASH_READ_CMD              0x03
#define FLASH_SECTOR_ERASE_CMD      0xD8
#define FLASH_SECTOR_ERASE_SIZE		4
#define FLASH_WRITE_ENABLE_CMD      0x06
#define FLASH_READ_STATUS_CMD       0x05
#define FLASH_READ_FLAG_STATUS_CMD  0x70
#define FLASH_SECTOR_SIZE           0x10000  // 64KB per sector for Micron flash
#define FLASH_PAGE_SIZE             256      // Typical for Micron/N25Q flash




typedef struct QspiData {
	u32 header;
    s32 dac_setpt_offset;
    s32 dac_setpt_gain;
	u32 dcct1_offset;
	u32 dcct1_gain;
	u32 dcct2_offset;
	u32 dcct2_gain;
	s32 dacmon_offset;
	s32 dacmon_gain;
	s32 volt_offset;
	s32 volt_gain;
	s32 gnd_offset;
	s32 gnd_gain;
	s32 spare_offset;
	s32 spare_gain;
	s32 reg_offset;
	s32 reg_gain;
	s32 error_offset;
	s32 error_gain;
    u32 ovc1_thresh;
    u32 ovc2_thresh;
    u32 ovv_thresh;
    u32 err1_thresh;
    u32 err2_thresh;
    u32 ignd_thresh;
    u32 ovc1_cntlim;
    u32 ovc2_cntlim;
    u32 ovv_cntlim;
    u32 err1_cntlim;
    u32 err2_cntlim;
    u32 ignd_cntlim;
    u32 dcct_cntlim;
    u32 flt1_cntlim;
    u32 flt2_cntlim;
    u32 flt3_cntlim;
    u32 on_cntlim;
    u32 heartbeat_cntlim;
    u32 fault_mask;
    float sf_ampspersec;
    float sf_dac_dccts;
    float sf_vout;
    float sf_ignd;
    float sf_spare;
    float sf_regulator;
    float sf_error;
} QspiData_t;


typedef struct TriggerInfo {
	u32 addr;
	u32 addr_last;
	u32 pretrigpts;
	u32 posttrigpts;
	u32 active;
	u32 postdlycnt;
	u32 sendbuf;
	u32 msgID;
	u32 channum;
} TriggerInfo;



typedef struct TriggerTypes {
	struct TriggerInfo usr[4];
	struct TriggerInfo flt[4];
	struct TriggerInfo err[4];
	struct TriggerInfo inj[4];
	struct TriggerInfo evr[4];
} TriggerTypes;



typedef struct ScaleFactorType {
	float ampspersec;
	float dac_dccts;
	float vout;
	float ignd;
	float spare;
	float regulator;
	float error;
} ScaleFactorType;



typedef struct {
  u8 ipaddr[4];
  u8 ipmask[4];
  u8 ipgw[4];
} ip_t;


void setup_thermistors(u8);
void read_thermistors(u8, float *, float *);


void i2c_get_mac_address();
void i2c_eeprom_readBytes(u8, u8 *, u8);
void i2c_eeprom_writeBytes(u8, u8 *, u8);
void eeprom_dump();
void menu_get_ipaddr();
void prog_si570();



void dma_arm();
void menu_thread();
void psc_control_thread();
void psc_status_thread();
void psc_wvfm_thread();
void psc_ramping_thread();

void init_i2c();
s32 i2c_read(u8 *, u8, u8);
s32 i2c_write(u8 *, u8, u8);
void i2c_set_port_expander(u32, u32);
float read_i2c_temp(u8);
void write_lmk61e2();

float L11_to_float(s32);

void i2c_configure_ltc2991();

int QspiFlashInit();
void QspiFlashEraseSect(u32);
void QspiFlashWrite(u32, u32, u8 *);
void QspiFlashRead(u32, u32, u8 *);
void QspiGatherData(u32, u8 *);
void QspiDisperseData(u32, u8 *);
void QspiPrintData(QspiData_t *, u32 );



//void i2c_sfp_get_stats(struct *, u8);




