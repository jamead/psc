

#define STRAIGHT 0
#define RING 1

//DAC modes
#define SMOOTH  0
#define RAMP    1
#define FOFB    2
#define JUMP    3

#define I2C_PORTEXP0_ADDR 0x70
#define I2C_PORTEXP1_ADDR 0x71



typedef struct TriggerInfo {
	u32 addr;
	u32 addr_last;
	u32 active;
	u32 postdlycnt;
	u32 sendbuf;
	u32 msgID;
} TriggerInfo;



typedef struct TriggerTypes {
	struct TriggerInfo soft;
	struct TriggerInfo flt1;
	struct TriggerInfo flt2;
	struct TriggerInfo flt3;
	struct TriggerInfo flt4;
	struct TriggerInfo err1;
	struct TriggerInfo err2;
	struct TriggerInfo err3;
	struct TriggerInfo err4;
	struct TriggerInfo evr;

} TriggerTypes;



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




