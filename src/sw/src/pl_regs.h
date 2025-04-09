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

#define DCCT0_REG             0X00     // PS1 DCCT 0
#define DCCT1_REG             0X04     // PS1 DCCT 1
#define DACSP_REG             0X08     // PS1 DAC Setpoint Monitor
#define VOLT_REG              0X0C     // PS1 Voltage Monitor
#define GND_REG               0X10     // PS1 GND Monitor
#define SPARE_REG             0X14     // PS1 Spare Monitor
#define REG_REG               0X18     // PS1 Regulator Output Monitor
#define ERR_REG               0X1C     // PS1 Error
#define DAC_OFFSET_REG        0X20     // PS1 DAC Offset
#define DAC_GAIN_REG          0X24     // PS1 DAC Gain
#define DAC_SETPT_REG         0X28     // PS1 DAC SetPoint - when in jumpmode
#define DAC_OPMODE_REG        0X2C     // PS1 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define DAC_CNTRL_REG         0X30     // PS1 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define DAC_RESET_REG         0X34     // PS1 DAC Reset
#define DAC_RAMPLEN_REG       0X38     // PS1 DAC Ramp Table Length
#define DAC_RAMPADDR_REG      0X3C     // PS1 DAC Ramp Table Address
#define DAC_RAMPDATA_REG      0X40     // PS1 DAC Ramp Table Data
#define DAC_RUNRAMP_REG       0X44     // PS1 DAC Run RampTable
#define DAC_RAMPACTIVE_REG    0X48     // PS1 DAC Ramptable Run Active
#define DAC_CURRSETPT_REG     0X4C     // PS1 DAC Current SetPt
#define DCCT0_OFFSET_REG      0X50     // PS1 DCCT 0 Offset
#define DCCT0_GAIN_REG        0X54     // PS1 DCCT 0 Gain
#define DCCT1_OFFSET_REG      0X58     // PS1 DCCT 1 Offset
#define DCCT1_GAIN_REG        0X5C     // PS1 DCCT 1 Gain
#define DACSP_OFFSET_REG      0X60     // PS1 DAC Setpoint Monitor Offset
#define DACSP_GAIN_REG        0X64     // PS1 DAC Setpoint Monitor Gain
#define VOLT_OFFSET_REG       0X68     // PS1 Voltage Monitor Offset
#define VOLT_GAIN_REG         0X6C     // PS1 Voltage Monitor Gain
#define GND_OFFSET_REG        0X70     // PS1 GND Monitor Offset
#define GND_GAIN_REG          0X74     // PS1 GND Monitor Gain
#define SPARE_OFFSET_REG      0X78     // PS1 Spare Monitor Offset
#define SPARE_GAIN_REG        0X7C     // PS1 Spare Monitor Gain
#define REG_OFFSET_REG        0X80     // PS1 Regulator Output Offset
#define REG_GAIN_REG          0X84     // PS1 Regulator Output Gain
#define ERR_OFFSET_REG        0X88     // PS1 Error Monitor Offset
#define ERR_GAIN_REG          0X8C     // PS1 Error Monitor Gain
#define DIGOUT_REG            0X90     // PS1 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define DIGIN_REG             0X94     // PS1 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare





#define PS1_DCCT0             0X100     // PS1 DCCT 0
#define PS1_DCCT1             0X104     // PS1 DCCT 1
#define PS1_DACSP             0X108     // PS1 DAC Setpoint Monitor
#define PS1_VOLT              0X10C     // PS1 Voltage Monitor
#define PS1_GND               0X110     // PS1 GND Monitor
#define PS1_SPARE             0X114     // PS1 Spare Monitor
#define PS1_REG               0X118     // PS1 Regulator Output Monitor
#define PS1_ERR               0X11C     // PS1 Error
#define PS1_DAC_OFFSET        0X120     // PS1 DAC Offset
#define PS1_DAC_GAIN          0X124     // PS1 DAC Gain
#define PS1_DAC_SETPT         0X128     // PS1 DAC SetPoint - when in jumpmode
#define PS1_DAC_OPMODE        0X12C     // PS1 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define PS1_DAC_CNTRL         0X130     // PS1 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS1_DAC_RESET         0X134     // PS1 DAC Reset
#define PS1_DAC_RAMPLEN       0X138     // PS1 DAC Ramp Table Length
#define PS1_DAC_RAMPADDR      0X13C     // PS1 DAC Ramp Table Address
#define PS1_DAC_RAMPDATA      0X140     // PS1 DAC Ramp Table Data
#define PS1_DAC_RUNRAMP       0X144     // PS1 DAC Run RampTable
#define PS1_DAC_RAMPACTIVE    0X148     // PS1 DAC Ramptable Run Active
#define PS1_DAC_CURRSETPT     0X14C     // PS1 DAC Current SetPt
#define PS1_DCCT0_OFFSET      0X150     // PS1 DCCT 0 Offset
#define PS1_DCCT0_GAIN        0X154     // PS1 DCCT 0 Gain
#define PS1_DCCT1_OFFSET      0X158     // PS1 DCCT 1 Offset
#define PS1_DCCT1_GAIN        0X15C     // PS1 DCCT 1 Gain
#define PS1_DACSP_OFFSET      0X160     // PS1 DAC Setpoint Monitor Offset
#define PS1_DACSP_GAIN        0X164     // PS1 DAC Setpoint Monitor Gain
#define PS1_VOLT_OFFSET       0X168     // PS1 Voltage Monitor Offset
#define PS1_VOLT_GAIN         0X16C     // PS1 Voltage Monitor Gain
#define PS1_GND_OFFSET        0X170     // PS1 GND Monitor Offset
#define PS1_GND_GAIN          0X174     // PS1 GND Monitor Gain
#define PS1_SPARE_OFFSET      0X178     // PS1 Spare Monitor Offset
#define PS1_SPARE_GAIN        0X17C     // PS1 Spare Monitor Gain
#define PS1_REG_OFFSET        0X180     // PS1 Regulator Output Offset
#define PS1_REG_GAIN          0X184     // PS1 Regulator Output Gain
#define PS1_ERR_OFFSET        0X188     // PS1 Error Monitor Offset
#define PS1_ERR_GAIN          0X18C     // PS1 Error Monitor Gain
#define PS1_DIGOUT            0X190     // PS1 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define PS1_DIGIN             0X194     // PS1 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare

#define PS2_DCCT0             0X200     // PS2 DCCT 0
#define PS2_DCCT1             0X204     // PS2 DCCT 1
#define PS2_DACSP             0X208     // PS2 DAC Setpoint Monitor
#define PS2_VOLT              0X20C     // PS2 Voltage Monitor
#define PS2_GND               0X210     // PS2 GND Monitor
#define PS2_SPARE             0X214     // PS2 Spare Monitor
#define PS2_REG               0X218     // PS2 Regulator Output Monitor
#define PS2_ERR               0X21C     // PS2 Error Monitor
#define PS2_DAC_OFFSET        0X220     // PS2 DAC Offset
#define PS2_DAC_GAIN          0X224     // PS2 DAC Gain
#define PS2_DAC_SETPT         0X228     // PS2 DAC SetPoint - when in jumpmode
#define PS2_DAC_OPMODE        0X22C     // PS2 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define PS2_DAC_CNTRL         0X230     // PS2 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS2_DAC_RESET         0X234     // PS2 DAC Reset
#define PS2_DAC_RAMPLEN       0X238     // PS2 DAC Ramp Table Length
#define PS2_DAC_RAMPADDR      0X23C     // PS2 DAC Ramp Table Address
#define PS2_DAC_RAMPDATA      0X240     // PS2 DAC Ramp Table Data
#define PS2_DAC_RUNRAMP       0X244     // PS2 DAC Run RampTable
#define PS2_DAC_RAMPACTIVE    0X248     // PS2 DAC Ramptable Run Active
#define PS2_DAC_CURRSETPT     0X24C     // PS2 DAC Current SetPt
#define PS2_DCCT0_OFFSET      0X250     // PS2 DCCT 0 Offset
#define PS2_DCCT0_GAIN        0X254     // PS2 DCCT 0 Gain
#define PS2_DCCT1_OFFSET      0X258     // PS2 DCCT 1 Offset
#define PS2_DCCT1_GAIN        0X25C     // PS2 DCCT 1 Gain
#define PS2_DACSP_OFFSET      0X260     // PS2 DAC Setpoint Monitor Offset
#define PS2_DACSP_GAIN        0X264     // PS2 DAC Setpoint Monitor Gain
#define PS2_VOLT_OFFSET       0X268     // PS2 Voltage Monitor Offset
#define PS2_VOLT_GAIN         0X26C     // PS2 Voltage Monitor Gain
#define PS2_GND_OFFSET        0X270     // PS2 GND Monitor Offset
#define PS2_GND_GAIN          0X274     // PS2 GND Monitor Gain
#define PS2_SPARE_OFFSET      0X278     // PS2 Spare Monitor Offset
#define PS2_SPARE_GAIN        0X27C     // PS2 Spare Monitor Gain
#define PS2_REG_OFFSET        0X280     // PS2 Regulator Output Offset
#define PS2_REG_GAIN          0X284     // PS2 Regulator Output Gain
#define PS2_ERR_OFFSET        0X288     // PS2 Error Monitor Offset
#define PS2_ERR_GAIN          0X28C     // PS2 Error Monitor Gain
#define PS2_DIGOUT            0X290     // PS2 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define PS2_DIGIN             0X294     // PS2 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare

#define PS3_DCCT0             0X300     // PS3 DCCT 0
#define PS3_DCCT1             0X304     // PS3 DCCT 1
#define PS3_DACSP             0X308     // PS3 DAC Setpoint Monitor
#define PS3_VOLT              0X30C     // PS3 Voltage Monitor
#define PS3_GND               0X310     // PS3 GND Monitor
#define PS3_SPARE             0X314     // PS3 Spare Monitor
#define PS3_REG               0X318     // PS3 Regulator Output Monitor
#define PS3_ERR               0X31C     // PS3 Error Monitor
#define PS3_DAC_OFFSET        0X320     // PS3 DAC Offset
#define PS3_DAC_GAIN          0X324     // PS3 DAC Gain
#define PS3_DAC_SETPT         0X328     // PS3 DAC SetPoint - when in jumpmode
#define PS3_DAC_OPMODE        0X32C     // PS3 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define PS3_DAC_CNTRL         0X330     // PS3 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS3_DAC_RESET         0X334     // PS3 DAC Reset
#define PS3_DAC_RAMPLEN       0X338     // PS3 DAC Ramp Table Length
#define PS3_DAC_RAMPADDR      0X33C     // PS3 DAC Ramp Table Address
#define PS3_DAC_RAMPDATA      0X340     // PS3 DAC Ramp Table Data
#define PS3_DAC_RUNRAMP       0X344     // PS3 DAC Run RampTable
#define PS3_DAC_RAMPACTIVE    0X348     // PS3 DAC Ramptable Run Active
#define PS3_DAC_CURRSETPT     0X34C     // PS3 DAC Current SetPt
#define PS3_DCCT0_OFFSET      0X350     // PS3 DCCT 0 Offset
#define PS3_DCCT0_GAIN        0X354     // PS3 DCCT 0 Gain
#define PS3_DCCT1_OFFSET      0X358     // PS3 DCCT 1 Offset
#define PS3_DCCT1_GAIN        0X35C     // PS3 DCCT 1 Gain
#define PS3_DACSP_OFFSET      0X360     // PS3 DAC Setpoint Monitor Offset
#define PS3_DACSP_GAIN        0X364     // PS3 DAC Setpoint Monitor Gain
#define PS3_VOLT_OFFSET       0X368     // PS3 Voltage Monitor Offset
#define PS3_VOLT_GAIN         0X36C     // PS3 Voltage Monitor Gain
#define PS3_GND_OFFSET        0X370     // PS3 GND Monitor Offset
#define PS3_GND_GAIN          0X374     // PS3 GND Monitor Gain
#define PS3_SPARE_OFFSET      0X378     // PS3 Spare Monitor Offset
#define PS3_SPARE_GAIN        0X37C     // PS3 Spare Monitor Gain
#define PS3_REG_OFFSET        0X380     // PS3 Regulator Output Offset
#define PS3_REG_GAIN          0X384     // PS3 Regulator Output Gain
#define PS3_ERR_OFFSET        0X388     // PS3 Error Monitor Offset
#define PS3_ERR_GAIN          0X38C     // PS3 Error Monitor Gain
#define PS3_DIGOUT            0X390     // PS3 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define PS3_DIGIN             0X394     // PS3 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare

#define PS4_DCCT0             0X400     // PS4 DCCT 0
#define PS4_DCCT1             0X404     // PS3 DCCT 1
#define PS4_DACSP             0X408     // PS4 DAC Setpoint Monitor
#define PS4_VOLT              0X40C     // PS4 Voltage Monitor
#define PS4_GND               0X410     // PS4 GND Monitor
#define PS4_SPARE             0X414     // PS4 Spare Monitor
#define PS4_REG               0X418     // PS4 Regulator Output
#define PS4_ERR               0X41C     // PS4 Error Monitor
#define PS4_DAC_OFFSET        0X420     // PS4 DAC Offset
#define PS4_DAC_GAIN          0X424     // PS4 DAC Gain
#define PS4_DAC_SETPT         0X428     // PS4 DAC SetPoint - when in jumpmode
#define PS4_DAC_OPMODE        0X42C     // PS4 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define PS4_DAC_CNTRL         0X430     // PS4 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS4_DAC_RESET         0X434     // PS4 DAC Reset
#define PS4_DAC_RAMPLEN       0X438     // PS4 DAC Ramp Table Length
#define PS4_DAC_RAMPADDR      0X43C     // PS4 DAC Ramp Table Address
#define PS4_DAC_RAMPDATA      0X440     // PS4 DAC Ramp Table Data
#define PS4_DAC_RUNRAMP       0X444     // PS4 DAC Run RampTable
#define PS4_DAC_RAMPACTIVE    0X448     // PS4 DAC Ramptable Run Active
#define PS4_DAC_CURRSETPT     0X44C     // PS4 DAC Current SetPt
#define PS4_DCCT0_OFFSET      0X450     // PS4 DCCT 0 Offset
#define PS4_DCCT0_GAIN        0X454     // PS4 DCCT 0 Gain
#define PS4_DCCT1_OFFSET      0X458     // PS4 DCCT 1 Offset
#define PS4_DCCT1_GAIN        0X45C     // PS4 DCCT 1 Gain
#define PS4_DACSP_OFFSET      0X460     // PS4 DAC Setpoint Monitor Offset
#define PS4_DACSP_GAIN        0X464     // PS4 DAC Setpoint Monitor Gain
#define PS4_VOLT_OFFSET       0X468     // PS4 Voltage Monitor Offset
#define PS4_VOLT_GAIN         0X46C     // PS4 Voltage Monitor Gain
#define PS4_GND_OFFSET        0X470     // PS4 GND Monitor Offset
#define PS4_GND_GAIN          0X474     // PS4 GND Monitor Gain
#define PS4_SPARE_OFFSET      0X478     // PS4 Spare Monitor Offset
#define PS4_SPARE_GAIN        0X47C     // PS4 Spare Monitor Gain
#define PS4_REG_OFFSET        0X480     // PS4 Regulator Output Offset
#define PS4_REG_GAIN          0X484     // PS4 Regulator Output Gain
#define PS4_ERR_OFFSET        0X488     // PS4 Error Monitor Offset
#define PS4_ERR_GAIN          0X48C     // PS4 Error Monitor Gain
#define PS4_DIGOUT            0X490     // PS4 Digital Outputs bit0=On1, bit1=On2, bit2=Reset, bit3=spare, bit4=Park
#define PS4_DIGIN             0X494     // PS4 Digital Inputs bit0=Acon, bit1=Flt1, bit2=Flt2, bit3=spare


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




/*

//PL AXI4 Bus Registers
#define FPGAVER               0X0       // FPGA Version
#define LEDS                  0X4       // PS Leds
#define EVR_TS_S              0X10      // EVR Timestamp (s)
#define EVR_TS_NS             0X14      // EVR Timestamp (ns)
#define EVR_RESET             0X18      // EVR Reset
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
#define PS1_DAC_OPMODE        0X10C     // PS1 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define PS1_DAC_CNTRL         0X110     // PS1 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS1_DAC_RESET         0X114     // PS1 DAC Reset
#define PS1_DAC_RAMPLEN       0X118     // PS1 DAC Ramp Table Length
#define PS1_DAC_RAMPADDR      0X11C     // PS1 DAC Ramp Table Address
#define PS1_DAC_RAMPDATA      0X120     // PS1 DAC Ramp Table Data
#define PS1_DAC_RUNRAMP       0X124     // PS1 DAC Run RampTable
#define PS1_DAC_RAMPACTIVE    0X128     // PS1 DAC Ramptable Run Active
#define PS1_DAC_CURRSETPT     0X12C     // PS1 DAC Current SetPt
#define PS2_DAC_OFFSET        0X140     // PS2 DAC Offset
#define PS2_DAC_GAIN          0X144     // PS2 DAC Gain
#define PS2_DAC_SETPT         0X148     // PS2 DAC SetPoint - when in jumpmode
#define PS2_DAC_OPMODE        0X14C     // PS2 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define PS2_DAC_CNTRL         0X150     // PS2 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS2_DAC_RESET         0X154     // PS2 DAC Reset
#define PS2_DAC_RAMPLEN       0X158     // PS2 DAC Ramp Table Length
#define PS2_DAC_RAMPADDR      0X15C     // PS2 DAC Ramp Table Address
#define PS2_DAC_RAMPDATA      0X160     // PS2 DAC Ramp Table Data
#define PS2_DAC_RUNRAMP       0X164     // PS2 DAC Run RampTable
#define PS2_DAC_RAMPACTIVE    0X168     // PS2 DAC Ramptable Run Active
#define PS2_DAC_CURRSETPT     0X16C     // PS2 DAC Current SetPt
#define PS3_DAC_OFFSET        0X180     // PS3 DAC Offset
#define PS3_DAC_GAIN          0X184     // PS3 DAC Gain
#define PS3_DAC_SETPT         0X188     // PS3 DAC SetPoint - when in jumpmode
#define PS3_DAC_OPMODE        0X18C     // PS3 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define PS3_DAC_CNTRL         0X190     // PS3 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS3_DAC_RESET         0X194     // PS3 DAC Reset
#define PS3_DAC_RAMPLEN       0X198     // PS3 DAC Ramp Table Length
#define PS3_DAC_RAMPADDR      0X19C     // PS3 DAC Ramp Table Address
#define PS3_DAC_RAMPDATA      0X1A0     // PS3 DAC Ramp Table Data
#define PS3_DAC_RUNRAMP       0X1A4     // PS3 DAC Run RampTable
#define PS3_DAC_RAMPACTIVE    0X1A8     // PS3 DAC Ramptable Run Active
#define PS3_DAC_CURRSETPT     0X1AC     // PS3 DAC Current SetPt
#define PS4_DAC_OFFSET        0X1C0     // PS4 DAC Offset
#define PS4_DAC_GAIN          0X1C4     // PS4 DAC Gain
#define PS4_DAC_SETPT         0X1C8     // PS4 DAC SetPoint - when in jumpmode
#define PS4_DAC_OPMODE        0X1CC     // PS4 DAC Mode 0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
#define PS4_DAC_CNTRL         0X1D0     // PS4 DAC Control bit0=op_gnd, bit1=sdo_dis, bit2=dac_tri, bit3=rbuf, bit4=bin2sc
#define PS4_DAC_RESET         0X1D4     // PS4 DAC Reset
#define PS4_DAC_RAMPLEN       0X1D8     // PS4 DAC Ramp Table Length
#define PS4_DAC_RAMPADDR      0X1DC     // PS4 DAC Ramp Table Address
#define PS4_DAC_RAMPDATA      0X1E0     // PS4 DAC Ramp Table Data
#define PS4_DAC_RUNRAMP       0X1E4     // PS4 DAC Run RampTable
#define PS4_DAC_RAMPACTIVE    0X1E8     // PS4 DAC Ramptable Run Active
#define PS4_DAC_CURRSETPT     0X1EC     // PS4 DAC Current SetPt
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
#define SOFTTRIG              0X308     // Soft Trig
#define TESTTRIG              0X30C     // Test Trig - Test the 4-Fault, 4-Error and EVR Trigger
#define SOFTTRIG_BUFPTR       0X320     // Soft Trig Buffer Ptr.  Buffer Point latched value gets put here on soft trigger
#define SOFTTRIG_TS_S         0X324     // Soft Trig Timestamp (s)
#define SOFTTRIG_TS_NS        0X328     // Soft Trig Timestamp (ns)
#define FLT1TRIG_BUFPTR       0X330     // Fault1 Buffer Ptr.  Buffer Point latched value gets put here on Fault1 trigger
#define FLT1TRIG_TS_S         0X334     // Fault1 Trig Timestamp (s)
#define FLT1TRIG_TS_NS        0X338     // Fault1 Trig Timestamp (ns)
#define FLT2TRIG_BUFPTR       0X340     // Fault2 Buffer Ptr.  Buffer Point latched value gets put here on Fault2 trigger
#define FLT2TRIG_TS_S         0X344     // Fault2 Trig Timestamp (s)
#define FLT2TRIG_TS_NS        0X348     // Fault2 Trig Timestamp (ns)
#define FLT3TRIG_BUFPTR       0X350     // Fault3 Buffer Ptr.  Buffer Point latched value gets put here on Fault3 trigger
#define FLT3TRIG_TS_S         0X354     // Fault3 Trig Timestamp (s)
#define FLT3TRIG_TS_NS        0X358     // Fault3 Trig Timestamp (ns)
#define FLT4TRIG_BUFPTR       0X360     // Fault4 Buffer Ptr.  Buffer Point latched value gets put here on Fault4 trigger
#define FLT4TRIG_TS_S         0X364     // Fault4 Trig Timestamp (s)
#define FLT4TRIG_TS_NS        0X368     // Fault4 Trig Timestamp (ns)
#define ERR1TRIG_BUFPTR       0X370     // Err1 Buffer Ptr.  Buffer Point latched value gets put here on Err1 trigger
#define ERR1TRIG_TS_S         0X374     // Err1 Trig Timestamp (s)
#define ERR1TRIG_TS_NS        0X378     // Err1 Trig Timestamp (ns)
#define ERR2TRIG_BUFPTR       0X380     // Err2 Buffer Ptr.  Buffer Point latched value gets put here on Err2 trigger
#define ERR2TRIG_TS_S         0X384     // Err2 Trig Timestamp (s)
#define ERR2TRIG_TS_NS        0X388     // Err2 Trig Timestamp (ns)
#define ERR3TRIG_BUFPTR       0X390     // Err3 Buffer Ptr.  Buffer Point latched value gets put here on Err3 trigger
#define ERR3TRIG_TS_S         0X394     // Err3 Trig Timestamp (s)
#define ERR3TRIG_TS_NS        0X398     // Err3 Trig Timestamp (ns)
#define ERR4TRIG_BUFPTR       0X3A0     // Err4 Buffer Ptr.  Buffer Point latched value gets put here on Err4 trigger
#define ERR4TRIG_TS_S         0X3A4     // Err4 Trig Timestamp (s)
#define ERR4TRIG_TS_NS        0X3A8     // Err4 Trig Timestamp (ns)
#define EVRTRIG_BUFPTR        0X3B0     // EVR Buffer Ptr.  Buffer Point latched value gets put here on EVR trigger
#define EVRTRIG_TS_S          0X3B4     // EVR Trig Timestamp (s)
#define EVRTRIG_TS_NS         0X3B8     // EVR Trig Timestamp (ns)

#define PS1_DCCT0_OFFSET      0X400     // PS1 DCCT 0 Offset
#define PS1_DCCT0_GAIN        0X404     // PS1 DCCT 0 Gain
#define PS1_DCCT1_OFFSET      0X408     // PS1 DCCT 1 Offset
#define PS1_DCCT1_GAIN        0X40C     // PS1 DCCT 1 Gain
#define PS1_DACSP_OFFSET      0X410     // PS1 DAC Setpoint Monitor Offset
#define PS1_DACSP_GAIN        0X414     // PS1 DAC Setpoint Monitor Gain
#define PS1_VOLT_OFFSET       0X418     // PS1 Voltage Monitor Offset
#define PS1_VOLT_GAIN         0X41C     // PS1 Voltage Monitor Gain
#define PS1_GND_OFFSET        0X420     // PS1 GND Monitor Offset
#define PS1_GND_GAIN          0X424     // PS1 GND Monitor Gain
#define PS1_SPARE_OFFSET      0X428     // PS1 Spare Monitor Offset
#define PS1_SPARE_GAIN        0X42C     // PS1 Spare Monitor Gain
#define PS1_REG_OFFSET        0X430     // PS1 Regulator Output Offset
#define PS1_REG_GAIN          0X434     // PS1 Regulator Output Gain
#define PS1_ERR_OFFSET        0X438     // PS1 Error Monitor Offset
#define PS1_ERR_GAIN          0X43C     // PS1 Error Monitor Gain
#define PS2_DCCT0_OFFSET      0X440     // PS2 DCCT 0 Offset
#define PS2_DCCT0_GAIN        0X444     // PS2 DCCT 0 Gain
#define PS2_DCCT1_OFFSET      0X448     // PS2 DCCT 1 Offset
#define PS2_DCCT1_GAIN        0X44C     // PS2 DCCT 1 Gain
#define PS2_DACSP_OFFSET      0X450     // PS2 DAC Setpoint Monitor Offset
#define PS2_DACSP_GAIN        0X454     // PS2 DAC Setpoint Monitor Gain
#define PS2_VOLT_OFFSET       0X458     // PS2 Voltage Monitor Offset
#define PS2_VOLT_GAIN         0X45C     // PS2 Voltage Monitor Gain
#define PS2_GND_OFFSET        0X460     // PS2 GND Monitor Offset
#define PS2_GND_GAIN          0X464     // PS2 GND Monitor Gain
#define PS2_SPARE_OFFSET      0X468     // PS2 Spare Monitor Offset
#define PS2_SPARE_GAIN        0X46C     // PS2 Spare Monitor Gain
#define PS2_REG_OFFSET        0X470     // PS2 Regulator Output Offset
#define PS2_REG_GAIN          0X474     // PS2 Regulator Output Gain
#define PS2_ERR_OFFSET        0X478     // PS2 Error Monitor Offset
#define PS2_ERR_GAIN          0X47C     // PS2 Error Monitor Gain
#define PS3_DCCT0_OFFSET      0X480     // PS3 DCCT 0 Offset
#define PS3_DCCT0_GAIN        0X484     // PS3 DCCT 0 Gain
#define PS3_DCCT1_OFFSET      0X488     // PS3 DCCT 1 Offset
#define PS3_DCCT1_GAIN        0X48C     // PS3 DCCT 1 Gain
#define PS3_DACSP_OFFSET      0X490     // PS3 DAC Setpoint Monitor Offset
#define PS3_DACSP_GAIN        0X494     // PS3 DAC Setpoint Monitor Gain
#define PS3_VOLT_OFFSET       0X498     // PS3 Voltage Monitor Offset
#define PS3_VOLT_GAIN         0X49C     // PS3 Voltage Monitor Gain
#define PS3_GND_OFFSET        0X4A0     // PS3 GND Monitor Offset
#define PS3_GND_GAIN          0X4A4     // PS3 GND Monitor Gain
#define PS3_SPARE_OFFSET      0X4A8     // PS3 Spare Monitor Offset
#define PS3_SPARE_GAIN        0X4AC     // PS3 Spare Monitor Gain
#define PS3_REG_OFFSET        0X4B0     // PS3 Regulator Output Offset
#define PS3_REG_GAIN          0X4B4     // PS3 Regulator Output Gain
#define PS3_ERR_OFFSET        0X4B8     // PS3 Error Monitor Offset
#define PS3_ERR_GAIN          0X4BC     // PS3 Error Monitor Gain
#define PS4_DCCT0_OFFSET      0X4C0     // PS4 DCCT 0 Offset
#define PS4_DCCT0_GAIN        0X4C4     // PS4 DCCT 0 Gain
#define PS4_DCCT1_OFFSET      0X4C8     // PS4 DCCT 1 Offset
#define PS4_DCCT1_GAIN        0X4CC     // PS4 DCCT 1 Gain
#define PS4_DACSP_OFFSET      0X4D0     // PS4 DAC Setpoint Monitor Offset
#define PS4_DACSP_GAIN        0X4D4     // PS4 DAC Setpoint Monitor Gain
#define PS4_VOLT_OFFSET       0X4D8     // PS4 Voltage Monitor Offset
#define PS4_VOLT_GAIN         0X4DC     // PS4 Voltage Monitor Gain
#define PS4_GND_OFFSET        0X4E0     // PS4 GND Monitor Offset
#define PS4_GND_GAIN          0X4E4     // PS4 GND Monitor Gain
#define PS4_SPARE_OFFSET      0X4E8     // PS4 Spare Monitor Offset
#define PS4_SPARE_GAIN        0X4EC     // PS4 Spare Monitor Gain
#define PS4_REG_OFFSET        0X4F0     // PS4 Regulator Output Offset
#define PS4_REG_GAIN          0X4F4     // PS4 Regulator Output Gain
#define PS4_ERR_OFFSET        0X4F8     // PS4 Error Monitor Offset
#define PS4_ERR_GAIN          0X4FC     // PS4 Error Monitor Gain
#define ID                    0X800     // Module Identification Number
#define VERSION               0X804     // Module Version Number
#define PRJ_ID                0X808     // Project Identification Number
#define PRJ_VERSION           0X80C     // Project Version Number
#define PRJ_SHASUM            0X810     // Project Repository check sum.
#define PRJ_TIMESTAMP         0X814     // Project compilation timestamp
*/


