
#define GAIN20BITFRACT 1048575.0
#define GAIN16BITFRACT 65535.0


#define CONV16BITSTOVOLTS  3276.8   // 2^16/20.0
#define CONV18BITSTOVOLTS  1.0 //13107.2  // 2^20/20.0
#define CONV20BITSTOVOLTS  52428.8  // 2^20/20.0

#define SAMPLERATE 10000.0

//DAC modes
#define SMOOTH  0
#define RAMP    1
#define FOFB    2
#define JUMP    3



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
	float ampspervolt;
	float ampspersec;
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


//void i2c_sfp_get_stats(struct *, u8);




