#define AXI_CIRBUFBASE 0x10000000



//PL AXI4 Bus Registers

#define FPGAVER               0X0       // FPGA Version
#define FPLEDS                0X4       // PS Leds
#define SOFTTRIG              0x8       // Soft Trigger from IOC
#define SOFTTRIG_BUFPTR       0xC       // Soft Trig Buffer Ptr.  Buffer Point latched value gets put here on soft trigger
#define EVR_TS_S              0X10      // EVR Timestamp (s)
#define EVR_TS_NS             0X14      // EVR Timestamp (ns)
#define EVR_RESET             0X18
#define PS1_DCCT0             0X20      // PS1 DCCT 0
#define PS1_DCCT1             0X24      // PS1 DCCT 1
#define PS1_DACSP             0X28      // PS1 DAC Setpoint Monitor
#define PS1_VOLT              0X2C      // PS1 Voltage Monitor
#define PS1_GND               0X30      // PS1 GND Monitor
#define PS1_SPARE             0X34      // PS1 Spare Monitor
#define PS1_REG               0X38      // PS1 Regulator Output Monitor
#define PS1_ERR               0X3C      // PS1 Error
#define PS2_DCCT0             0X40      // PS2 DCCT 0
#define PS2_DCCT1             0X44      // PS2 DCCT 1
#define PS2_DACSP             0X48      // PS2 DAC Setpoint Monitor
#define PS2_VOLT              0X4C      // PS2 Voltage Monitor
#define PS2_GND               0X50      // PS2 GND Monitor
#define PS2_SPARE             0X54      // PS2 Spare Monitor
#define PS2_REG               0X58      // PS2 Regulator Output Monitor
#define PS2_ERR               0X5C      // PS2 Error Monitor
#define PS3_DCCT0             0X60      // PS3 DCCT 0
#define PS3_DCCT1             0X64      // PS3 DCCT 1
#define PS3_DACSP             0X68      // PS3 DAC Setpoint Monitor
#define PS3_VOLT              0X6C      // PS3 Voltage Monitor
#define PS3_GND               0X70      // PS3 GND Monitor
#define PS3_SPARE             0X74      // PS3 Spare Monitor
#define PS3_REG               0X78      // PS3 Regulator Output Monitor
#define PS3_ERR               0X7C      // PS3 Error Monitor
#define PS4_DCCT0             0X80      // PS4 DCCT 0
#define PS4_DCCT1             0X84      // PS3 DCCT 1
#define PS4_DACSP             0X88      // PS4 DAC Setpoint Monitor
#define PS4_VOLT              0X8C      // PS4 Voltage Monitor
#define PS4_GND               0X90      // PS4 GND Monitor
#define PS4_SPARE             0X94      // PS4 Spare Monitor
#define PS4_REG               0X98      // PS4 Regulator Output
#define PS4_ERR               0X9C      // PS4 Error Monitor
#define PS1_DAC_OFFSET        0X100     // PS1 DAC Offset
#define PS1_DAC_GAIN          0X104     // PS1 DAC Gain
#define PS1_DAC_SETPT         0X108     // PS1 DAC SetPoint - when in jumpmode
#define PS1_DAC_JUMPMODE      0X10C     // PS1 DAC JumpMode
#define PS1_DAC_CNTRL         0X110     // PS1 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS1_DAC_RESET         0X114     // PS1 DAC Reset
#define PS1_DAC_RAMPLEN       0X118     // PS1 DAC Ramp Table Length
#define PS1_DAC_RAMPADDR      0X11C     // PS1 DAC Ramp Table Address
#define PS1_DAC_RAMPDATA      0X120     // PS1 DAC Ramp Table Data
#define PS1_DAC_RUNRAMP       0X124     // PS1 DAC Run RampTable
#define PS1_DAC_RAMPACTIVE    0X128     // PS1 DAC Ramptable Run Active
#define PS1_DAC_CURRAMPADDR   0X12C     // PS1 DAC Ramptable Run Current Address
#define PS1_DIGOUT            0X200     // PS1 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define PS1_DIGIN             0X204     // PS1 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare
#define PS2_DIGOUT            0X208     // PS2 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define PS2_DIGIN             0X20C     // PS2 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare
#define PS3_DIGOUT            0X210     // PS3 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define PS3_DIGIN             0X214     // PS3 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare
#define PS4_DIGOUT            0X218     // PS4 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define PS4_DIGIN             0X21C     // PS4 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare
#define SNAPSHOT_ADDRPTR      0X300     // Snapshot 20 sec circular buffer current address pointer
#define SNAPSHOT_TOTALTRIGS   0X304     // Snapshot 20 sec circular buffer total data points written




#define ID                    0X400     // Module Identification Number
#define VERSION               0X404     // Module Version Number
#define PRJ_ID                0X408     // Project Identification Number
#define PRJ_VERSION           0X40C     // Project Version Number
#define PRJ_SHASUM            0X410     // Project Repository check sum.
#define PRJ_TIMESTAMP         0X414     // Project compilation timestamp









