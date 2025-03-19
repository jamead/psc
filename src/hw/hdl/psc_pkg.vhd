library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package psc_pkg is


type t_dma_params is record
    len          : std_logic_vector(31 downto 0);
    enb          : std_logic;
    testdata_enb : std_logic;
end record t_dma_params;



-- DCCT ADC record types
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



-- Monitor ADC record types

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



-- DAC record types

type t_dac_stat_onech is record
  active                : std_logic;
  cur_addr              : std_logic_vector(15 downto 0);
end record;

type t_dac_stat is record
  ps1           : t_dac_stat_onech;
  ps2           : t_dac_stat_onech;
  ps3           : t_dac_stat_onech;
  ps4           : t_dac_stat_onech;
end record;


type t_dac_cntrl_onech is record 
  --DAC controls 
  setpoint            : std_logic_vector(19 downto 0); 
  load                : std_logic; 
  ramplen             : std_logic_vector(15 downto 0);
  gain                : std_logic_vector(15 downto 0);
  offset              : std_logic_vector(15 downto 0);
  --Control Register Bits 
  cntrl               : std_logic_vector(7 downto 0); 
  -- DPRAM for table
  dpram_addr          : std_logic_vector(15 downto 0);
  dpram_data          : std_logic_vector(19 downto 0);
  dpram_we            : std_logic;
  --Reset
  reset               : std_logic; 
  --For Jump mode
  jump                : std_logic; 
end record; 

type t_dac_cntrl is record
  ps1           : t_dac_cntrl_onech;
  ps2           : t_dac_cntrl_onech;
  ps3           : t_dac_cntrl_onech;
  ps4           : t_dac_cntrl_onech;
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
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awready : out STD_LOGIC;
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wvalid : in STD_LOGIC;    
    
    
--    s_axis_s2mm_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
--    s_axis_s2mm_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
--    s_axis_s2mm_tlast : in STD_LOGIC;
--    s_axis_s2mm_tready : out STD_LOGIC;
--    s_axis_s2mm_tvalid : in STD_LOGIC;    
    pl_clk0 : out STD_LOGIC;
    pl_resetn : out STD_LOGIC_VECTOR(0 downto 0)
  );
  end component;
  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  

component dac_dpram IS
  port (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC;  --_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
  );
END component;




end package;
