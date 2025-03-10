
#define RFATTEN 0
#define PTATTEN 1
#define HOR 0
#define VERT 1
#define CHA 0
#define CHB 1
#define CHC 2
#define CHD 3

#define ADC 0
#define TBT 1
#define FA 2

#define STRAIGHT 0
#define RING 1

#define BRDTEMP0_ADDR 0x48
#define BRDTEMP1_ADDR 0x49
#define BRDTEMP2_ADDR 0x4A
#define BRDTEMP3_ADDR 0x4B

#define I2C_PORTEXP0_ADDR 0x70
#define I2C_PORTEXP1_ADDR 0x71


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

void prog_ad9510();
void ltc2195_init();

void dma_arm();
void menu_thread();
void psc_control_thread();
void psc_status_thread();
void psc_wvfm_thread();

void init_i2c();
s32 i2c_read(u8 *, u8, u8);
s32 i2c_write(u8 *, u8, u8);
void i2c_set_port_expander(u32, u32);
float read_i2c_temp(u8);
void write_lmk61e2();

float L11_to_float(s32);

void i2c_configure_ltc2991();


//void i2c_sfp_get_stats(struct *, u8);




