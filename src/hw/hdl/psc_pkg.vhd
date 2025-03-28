library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package psc_pkg is




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
  dac_setpt             : std_logic_vector(19 downto 0);
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
  ramprun             : std_logic; 
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
  --mode  0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
  mode                : std_logic_vector(1 downto 0); 
end record; 

type t_dac_cntrl is record
  ps1           : t_dac_cntrl_onech;
  ps2           : t_dac_cntrl_onech;
  ps3           : t_dac_cntrl_onech;
  ps4           : t_dac_cntrl_onech;
end record;


-- snapshot data (circular buffer) types
type t_snapshot_stat is record
  addr_ptr  : std_logic_vector(31 downto 0);
  tenkhzcnt : std_logic_vector(31 downto 0);
end record;


type t_pl_snapshot_axi4_m2s is record
  awaddr :  std_logic_vector(31 downto 0);
  awburst : std_logic_vector(1 downto 0);
  awcache : std_logic_vector(3 downto 0);
  awlen : std_logic_vector(7 downto 0);
  awlock : std_logic_vector(0 to 0);
  awprot : std_logic_vector(2 downto 0);
  awqos : std_logic_vector(3 downto 0);
  awsize : std_logic_vector(2 downto 0);
  awvalid : std_logic;
  wdata : std_logic_vector(31 downto 0);
  wlast : std_logic;
  wstrb : std_logic_vector(3 downto 0);
  wvalid : std_logic;
  bready : std_logic;
end record;



type t_pl_snapshot_axi4_s2m is record
  awready : std_logic;
  wready : std_logic;
  bresp : std_logic_vector(1 downto 0);
  bvalid : std_logic;
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
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awlock : in STD_LOGIC_VECTOR ( 0 to 0 );
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
  
  

component timeofDayReceiver is
   port (
       clock        : in std_logic;
       reset        : in std_logic; 
       eventstream  : in std_logic_vector(7 downto 0);
       timestamp    : out std_logic_vector(63 downto 0); 
       seconds      : out std_logic_vector(31 downto 0); 
       offset       : out std_logic_vector(31 downto 0); 
       position     : out std_logic_vector(4 downto 0);
       eventclock   : out std_logic
 );
end component;


component EventReceiverChannel is 
    port (
       clock        : in std_logic;
       reset        : in std_logic;
       eventstream  : in std_logic_vector(7 downto 0); 
       myevent      : in std_logic_vector(7 downto 0);
       mydelay      : in std_logic_vector(31 downto 0); 
       mywidth      : in std_logic_vector(31 downto 0); 
       mypolarity   : in std_logic;
       trigger      : out std_logic 
);
end component;


component evr_gtx
 
port
(
    SYSCLK_IN                               : in   std_logic;
    SOFT_RESET_RX_IN                        : in   std_logic;
    DONT_RESET_ON_DATA_ERROR_IN             : in   std_logic;
    GT0_TX_FSM_RESET_DONE_OUT               : out  std_logic;
    GT0_RX_FSM_RESET_DONE_OUT               : out  std_logic;
    GT0_DATA_VALID_IN                       : in   std_logic;

    --_________________________________________________________________________
    --GT0  (X1Y0)
    --____________________________CHANNEL PORTS________________________________
    --------------------------------- CPLL Ports -------------------------------
    gt0_cpllfbclklost_out                   : out  std_logic;
    gt0_cplllock_out                        : out  std_logic;
    gt0_cplllockdetclk_in                   : in   std_logic;
    gt0_cpllreset_in                        : in   std_logic;
    -------------------------- Channel - Clocking Ports ------------------------
    gt0_gtrefclk0_in                        : in   std_logic;
    gt0_gtrefclk1_in                        : in   std_logic;
    ---------------------------- Channel - DRP Ports  --------------------------
    gt0_drpaddr_in                          : in   std_logic_vector(8 downto 0);
    gt0_drpclk_in                           : in   std_logic;
    gt0_drpdi_in                            : in   std_logic_vector(15 downto 0);
    gt0_drpdo_out                           : out  std_logic_vector(15 downto 0);
    gt0_drpen_in                            : in   std_logic;
    gt0_drprdy_out                          : out  std_logic;
    gt0_drpwe_in                            : in   std_logic;
    --------------------------- Digital Monitor Ports --------------------------
    gt0_dmonitorout_out                     : out  std_logic_vector(7 downto 0);
    --------------------- RX Initialization and Reset Ports --------------------
    gt0_eyescanreset_in                     : in   std_logic;
    gt0_rxuserrdy_in                        : in   std_logic;
    -------------------------- RX Margin Analysis Ports ------------------------
    gt0_eyescandataerror_out                : out  std_logic;
    gt0_eyescantrigger_in                   : in   std_logic;
    ------------------ Receive Ports - FPGA RX Interface Ports -----------------
    gt0_rxusrclk_in                         : in   std_logic;
    gt0_rxusrclk2_in                        : in   std_logic;
    ------------------ Receive Ports - FPGA RX interface Ports -----------------
    gt0_rxdata_out                          : out  std_logic_vector(15 downto 0);
    ------------------ Receive Ports - RX 8B/10B Decoder Ports -----------------
    gt0_rxdisperr_out                       : out  std_logic_vector(1 downto 0);
    gt0_rxnotintable_out                    : out  std_logic_vector(1 downto 0);
    --------------------------- Receive Ports - RX AFE -------------------------
    gt0_gtxrxp_in                           : in   std_logic;
    ------------------------ Receive Ports - RX AFE Ports ----------------------
    gt0_gtxrxn_in                           : in   std_logic;
    -------------- Receive Ports - RX Byte and Word Alignment Ports ------------
    gt0_rxcommadet_out                      : out  std_logic;
    --------------------- Receive Ports - RX Equalizer Ports -------------------
    gt0_rxdfelpmreset_in                    : in   std_logic;
    gt0_rxmonitorout_out                    : out  std_logic_vector(6 downto 0);
    gt0_rxmonitorsel_in                     : in   std_logic_vector(1 downto 0);
    --------------- Receive Ports - RX Fabric Output Control Ports -------------
    gt0_rxoutclk_out                        : out  std_logic;
    gt0_rxoutclkfabric_out                  : out  std_logic;
    ------------- Receive Ports - RX Initialization and Reset Ports ------------
    gt0_gtrxreset_in                        : in   std_logic;
    gt0_rxpmareset_in                       : in   std_logic;
    ------------------- Receive Ports - RX8B/10B Decoder Ports -----------------
    gt0_rxchariscomma_out                   : out  std_logic_vector(1 downto 0);
    gt0_rxcharisk_out                       : out  std_logic_vector(1 downto 0);
    -------------- Receive Ports -RX Initialization and Reset Ports ------------
    gt0_rxresetdone_out                     : out  std_logic;
    --------------------- TX Initialization and Reset Ports --------------------
    gt0_gttxreset_in                        : in   std_logic;


    --____________________________COMMON PORTS________________________________
     GT0_QPLLOUTCLK_IN  : in std_logic;
     GT0_QPLLOUTREFCLK_IN : in std_logic

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
