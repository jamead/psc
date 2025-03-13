library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package psc_pkg is


--########################################################################
--                           Records
--########################################################################
type t_DCCT_ADC is record
  adc_data  : std_logic_vector(19 downto 0);
  gain      : std_logic_vector(31 downto 0);
  offset    : std_logic_vector(31 downto 0);
end record;

--DCCT record
type t_DCCT is record
  done           : std_logic;
  ADC1           : t_DCCT_ADC;
  ADC2           : t_DCCT_ADC;
  ADC3           : t_DCCT_ADC;
  ADC4           : t_DCCT_ADC;
  ADC5           : t_DCCT_ADC;
  ADC6           : t_DCCT_ADC;
  ADC7           : t_DCCT_ADC;
  ADC8           : t_DCCT_ADC;
end record;

type t_ADC_8CH_g_o is record
  data           : std_logic_vector(15 downto 0);
  gain           : std_logic_vector(31 downto 0);
  offset         : std_logic_vector(31 downto 0);
end record;





type t_dcct_adcs_onech is record
  dcct0         : std_logic_vector(17 downto 0);
  dcct1         : std_logic_vector(17 downto 0);
end record;

type t_dcct_adcs is record
  ps1           : t_dcct_adcs_onech;
  ps2           : t_dcct_adcs_onech;
  ps3           : t_dcct_adcs_onech;
  ps4           : t_dcct_adcs_onech;
end record;
 
  
type t_dcct_adcs_ave_onech is record
  dcct0         : std_logic_vector(31 downto 0);
  dcct1         : std_logic_vector(31 downto 0);
end record;

type t_dcct_adcs_ave is record
  ps1           : t_dcct_adcs_ave_onech;
  ps2           : t_dcct_adcs_ave_onech;
  ps3           : t_dcct_adcs_ave_onech;
  ps4           : t_dcct_adcs_ave_onech;
end record;





type t_mon_adcs_onech is record
  dac_sp        : std_logic_vector(15 downto 0);
  volt_mon      : std_logic_vector(15 downto 0);
  gnd_mon       : std_logic_vector(15 downto 0);
  spare_mon     : std_logic_vector(15 downto 0);
  ps_reg        : std_logic_vector(15 downto 0);
  ps_error      : std_logic_vector(15 downto 0);
end record;

type t_mon_adcs is record
  ps1           : t_mon_adcs_onech;
  ps2           : t_mon_adcs_onech;
  ps3           : t_mon_adcs_onech;
  ps4           : t_mon_adcs_onech;
end record;


type t_mon_adcs_ave_onech is record
  dac_sp        : std_logic_vector(31 downto 0);
  volt_mon      : std_logic_vector(31 downto 0);
  gnd_mon       : std_logic_vector(31 downto 0);
  spare_mon     : std_logic_vector(31 downto 0);
  ps_reg        : std_logic_vector(31 downto 0);
  ps_error      : std_logic_vector(31 downto 0);
end record;

type t_mon_adcs_ave is record
  ps1           : t_mon_adcs_ave_onech;
  ps2           : t_mon_adcs_ave_onech;
  ps3           : t_mon_adcs_ave_onech;
  ps4           : t_mon_adcs_ave_onech;
end record;


--type t_ADC_CHANNEL is record
--  CH1            : t_ADC_8CH_g_o;
--  CH2            : t_ADC_8CH_g_o;
--  CH3            : t_ADC_8CH_g_o;
--  CH4            : t_ADC_8CH_g_o;
--  CH5            : t_ADC_8CH_g_o;
--  CH6            : t_ADC_8CH_g_o;
--  CH7            : t_ADC_8CH_g_o;
--  CH8            : t_ADC_8CH_g_o;
--end record;

----8 Channel ADC record
--type t_ADC_8CHANNEL is record
--  --ADC1 Data Regs
--  ADC1       	: t_ADC_CHANNEL;
--  ADC2       	: t_ADC_CHANNEL;
--  ADC3     	: t_ADC_CHANNEL;
--end record;








type t_dac is record 
  --DAC controls 
  setpoint            : std_logic_vector(17 downto 0); 
  load                : std_logic; 
  done                : std_logic; 
  --Control Register Bits 
  ctrl_reg            : std_logic_vector(4 downto 0); 
  --Offset and Gain regs
  gain                : std_logic_vector(31 downto 0); 
  offset              : std_logic_vector(31 downto 0); 
  --Reset
  reset               : std_logic; 
  --For Jump mode
  dac1234_jump        : std_logic; 
end record; 



--########################################################################
--                         Components
--########################################################################
component system is
  port (
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    iic_0_scl_i : in STD_LOGIC;
    iic_0_scl_o : out STD_LOGIC;
    iic_0_scl_t : out STD_LOGIC;
    iic_0_sda_i : in STD_LOGIC;
    iic_0_sda_o : out STD_LOGIC;
    iic_0_sda_t : out STD_LOGIC; 
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC;
    pl_clk0 : out STD_LOGIC;
    pl_resetn : out STD_LOGIC_VECTOR(0 downto 0)
  );
  end component;



end package;
