#define AXI_CIRBUFBASE 0x10000000


#define FPGAVER               0X0       // FPGA Version
#define LEDS                  0X4       // PS Leds
#define EVR_TS_S              0X10      // EVR Timestamp (s)
#define EVR_TS_NS             0X14      // EVR Timestamp (ns)
#define EVR_RESET             0X18      // EVR Reset


#define CHBASEADDR      0x100
#define CH1_BASE        0x100
#define CH2_BASE        0x200
#define CH3_BASE        0x300
#define CH4_BASE        0x400

#define DCCT1_REG                0X00     // PS1 DCCT 0
#define DCCT2_REG                0X04     // PS1 DCCT 1
#define DACMON_REG               0X08     // PS1 DAC Monitor
#define VOLT_REG                 0X0C     // PS1 Voltage Monitor
#define GND_REG                  0X10     // PS1 GND Monitor
#define SPARE_REG                0X14     // PS1 Spare Monitor
#define REG_REG                  0X18     // PS1 Regulator Output Monitor
#define ERR_REG                  0X1C     // PS1 Error
#define DAC_SETPT_OFFSET_REG     0X20     // PS1 DAC Offset
#define DAC_SETPT_GAIN_REG       0X24     // PS1 DAC Gain
#define DAC_SETPT_REG            0X28     // PS1 DAC SetPoint - when in jumpmode
#define DAC_OPMODE_REG           0X2C     // PS1 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define DAC_CNTRL_REG            0X30     // PS1 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define DAC_RESET_REG            0X34     // PS1 DAC Reset
#define DAC_RAMPLEN_REG          0X38     // PS1 DAC Ramp Table Length
#define DAC_RAMPADDR_REG         0X3C     // PS1 DAC Ramp Table Address
#define DAC_RAMPDATA_REG         0X40     // PS1 DAC Ramp Table Data
#define DAC_RUNRAMP_REG          0X44     // PS1 DAC Run RampTable
#define DAC_RAMPACTIVE_REG       0X48     // PS1 DAC Ramptable Run Active
#define DAC_CURRSETPT_REG        0X4C     // PS1 DAC Current SetPt
#define DCCT1_OFFSET_REG         0X50     // PS1 DCCT 0 Offset
#define DCCT1_GAIN_REG           0X54     // PS1 DCCT 0 Gain
#define DCCT2_OFFSET_REG         0X58     // PS1 DCCT 1 Offset
#define DCCT2_GAIN_REG           0X5C     // PS1 DCCT 1 Gain
#define DACMON_OFFSET_REG        0X60     // PS1 DAC Monitor Offset
#define DACMON_GAIN_REG          0X64     // PS1 DAC Monitor Gain
#define VOLT_OFFSET_REG          0X68     // PS1 Voltage Monitor Offset
#define VOLT_GAIN_REG            0X6C     // PS1 Voltage Monitor Gain
#define GND_OFFSET_REG           0X70     // PS1 GND Monitor Offset
#define GND_GAIN_REG             0X74     // PS1 GND Monitor Gain
#define SPARE_OFFSET_REG         0X78     // PS1 Spare Monitor Offset
#define SPARE_GAIN_REG           0X7C     // PS1 Spare Monitor Gain
#define REG_OFFSET_REG           0X80     // PS1 Regulator Output Offset
#define REG_GAIN_REG             0X84     // PS1 Regulator Output Gain
#define ERR_OFFSET_REG           0X88     // PS1 Error Monitor Offset
#define ERR_GAIN_REG             0X8C     // PS1 Error Monitor Gain
#define OVC1_THRESH_REG          0X90      // PS1 DCCT1 Over Current Fault Threshold
#define OVC2_THRESH_REG          0X94      // PS1 DCCT2 Over Current Fault Threshold
#define OVV_THRESH_REG           0X98      // PS1 Over Voltage Fault Threshold
#define ERR1_THRESH_REG          0X9C      // PS1 PID Error1 Fault Threshold
#define ERR2_THRESH_REG          0XA0      // PS1 PID Error2 Fault Threshold
#define IGND_THRESH_REG          0XA4      // PS1 Gnd Current Fault Threshold
#define OVC1_CNTLIM_REG          0XA8      // PS1 DCCT1 Over Current Fault Counter Limit
#define OVC2_CNTLIM_REG          0XAC      // PS1 DCCT2 Over Current Fault Counter Limit
#define OVV_CNTLIM_REG           0XB0      // PS1 Over Voltage Fault Counter Limit
#define ERR1_CNTLIM_REG          0XB4      // PS1 PID Error1 Fault Counter Limit
#define ERR2_CNTLIM_REG          0XB8      // PS1 PID Error2 Fault Counter Limit
#define IGND_CNTLIM_REG          0XBC      // PS1 Gnd Current Fault Counter Limit
#define DCCT_CNTLIM_REG          0XC0      // PS1 Digital DCCT Counter Limit
#define FLT1_CNTLIM_REG          0XC4      // PS1 Fault1 Counter Limit
#define FLT2_CNTLIM_REG          0XC8      // PS1 Fault2 Counter Limit
#define FLT3_CNTLIM_REG          0XCC      // PS1 Fault3 Counter Limit
#define ON_CNTLIM_REG            0XD0      // PS1 On Counter Limit
#define FAULT_CLEAR_REG          0XD4      // PS1 Fault Clear
#define FAULT_MASK_REG           0XD8      // PS1 Fault Mask
#define HEARTBEAT_CNTLIM_REG     0XDC      // PS1 HeartBeat Counter Limit
#define DIGOUT_ON1_REG           0XE0      // PS1 Digital Outputs bit0=On1
#define DIGOUT_ON2_REG           0XE4      // PS1 Digital Outputs bit1=On2
#define DIGOUT_RESET_REG         0XE8      // PS1 Digital Outputs bit2=Reset
#define DIGOUT_SPARE_REG         0XEC      // PS1 Digital Outputs bit3=spare
#define DIGOUT_PARK_REG          0XF0      // PS1 Digital Outputs bit4=Park
#define DIGIN_REG                0XF4      // PS1 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare, bit4=DCCTflt
#define FAULTS_LIVE_REG          0xF8      // Live Faults
#define FAULTS_LAT_REG           0xFC      // Latched Faults

#define SNAPSHOT_ADDRPTR      0X500     // Snapshot 20 sec circular buffer current address pointer
#define SNAPSHOT_TOTALTRIGS   0X504     // Snapshot 20 sec circular buffer total data points written
#define SOFTTRIG              0X508     // Soft Trig
#define TESTTRIG              0X50C     // Test Trig - Test the 4-Fault, 4-Error and EVR Trigger
#define SOFTTRIG_BUFPTR       0X520     // Soft Trig Buffer Ptr.  Buffer Point latched value gets put here on soft trigger
#define SOFTTRIG_TS_S         0X524     // Soft Trig Timestamp (s)
#define SOFTTRIG_TS_NS        0X528     // Soft Trig Timestamp (ns)
#define FLT1TRIG_BUFPTR       0X530     // Fault1 Buffer Ptr.  Buffer Point latched value gets put here on Fault1 trigger
#define FLT1TRIG_TS_S         0X534     // Fault1 Trig Timestamp (s)
#define FLT1TRIG_TS_NS        0X538     // Fault1 Trig Timestamp (ns)
#define FLT2TRIG_BUFPTR       0X540     // Fault2 Buffer Ptr.  Buffer Point latched value gets put here on Fault2 trigger
#define FLT2TRIG_TS_S         0X544     // Fault2 Trig Timestamp (s)
#define FLT2TRIG_TS_NS        0X548     // Fault2 Trig Timestamp (ns)
#define FLT3TRIG_BUFPTR       0X550     // Fault3 Buffer Ptr.  Buffer Point latched value gets put here on Fault3 trigger
#define FLT3TRIG_TS_S         0X554     // Fault3 Trig Timestamp (s)
#define FLT3TRIG_TS_NS        0X558     // Fault3 Trig Timestamp (ns)
#define FLT4TRIG_BUFPTR       0X560     // Fault4 Buffer Ptr.  Buffer Point latched value gets put here on Fault4 trigger
#define FLT4TRIG_TS_S         0X564     // Fault4 Trig Timestamp (s)
#define FLT4TRIG_TS_NS        0X568     // Fault4 Trig Timestamp (ns)
#define ERR1TRIG_BUFPTR       0X570     // Err1 Buffer Ptr.  Buffer Point latched value gets put here on Err1 trigger
#define ERR1TRIG_TS_S         0X574     // Err1 Trig Timestamp (s)
#define ERR1TRIG_TS_NS        0X578     // Err1 Trig Timestamp (ns)
#define ERR2TRIG_BUFPTR       0X580     // Err2 Buffer Ptr.  Buffer Point latched value gets put here on Err2 trigger
#define ERR2TRIG_TS_S         0X584     // Err2 Trig Timestamp (s)
#define ERR2TRIG_TS_NS        0X588     // Err2 Trig Timestamp (ns)
#define ERR3TRIG_BUFPTR       0X590     // Err3 Buffer Ptr.  Buffer Point latched value gets put here on Err3 trigger
#define ERR3TRIG_TS_S         0X594     // Err3 Trig Timestamp (s)
#define ERR3TRIG_TS_NS        0X598     // Err3 Trig Timestamp (ns)
#define ERR4TRIG_BUFPTR       0X5A0     // Err4 Buffer Ptr.  Buffer Point latched value gets put here on Err4 trigger
#define ERR4TRIG_TS_S         0X5A4     // Err4 Trig Timestamp (s)
#define ERR4TRIG_TS_NS        0X5A8     // Err4 Trig Timestamp (ns)
#define EVRTRIG_BUFPTR        0X5B0     // EVR Buffer Ptr.  Buffer Point latched value gets put here on EVR trigger
#define EVRTRIG_TS_S          0X5B4     // EVR Trig Timestamp (s)
#define EVRTRIG_TS_NS         0X5B8     // EVR Trig Timestamp (ns)
#define ID                    0X800     // Module Identification Number
#define VERSION               0X804     // Module Version Number
#define PRJ_ID                0X808     // Project Identification Number
#define PRJ_VERSION           0X80C     // Project Version Number
#define PRJ_SHASUM            0X810     // Project Repository check sum.
#define PRJ_TIMESTAMP         0X814     // Project compilation timestamp




