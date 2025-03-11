
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
 
 library desyrdl;
use desyrdl.common.all;
use desyrdl.pkg_pl_regs.all;

library xil_defaultlib;
use xil_defaultlib.psc_pkg.ALL;
 

library work;
use work.psc_pkg.ALL;


entity top is
generic(
    FPGA_VERSION			: integer := 1;
    SIM_MODE				: integer := 0
    );
  port (
    ddr_addr                : inout std_logic_vector ( 14 downto 0 );
    ddr_ba                  : inout std_logic_vector ( 2 downto 0 );
    ddr_cas_n               : inout std_logic;
    ddr_ck_n                : inout std_logic;
    ddr_ck_p                : inout std_logic;
    ddr_cke                 : inout std_logic;
    ddr_cs_n                : inout std_logic;
    ddr_dm                  : inout std_logic_vector ( 3 downto 0 );
    ddr_dq                  : inout std_logic_vector ( 31 downto 0 );
    ddr_dqs_n               : inout std_logic_vector ( 3 downto 0 );
    ddr_dqs_p               : inout std_logic_vector ( 3 downto 0 );
    ddr_odt                 : inout std_logic;
    ddr_ras_n               : inout std_logic;
    ddr_reset_n             : inout std_logic;
    ddr_we_n                : inout std_logic;
    fixed_io_ddr_vrn        : inout std_logic;
    fixed_io_ddr_vrp        : inout std_logic;
    fixed_io_mio            : inout std_logic_vector ( 53 downto 0 );
    fixed_io_ps_clk         : inout std_logic;
    fixed_io_ps_porb        : inout std_logic;
    fixed_io_ps_srstb       : inout std_logic;
    
    -- Regulator command bits
    rcom                    : out std_logic_vector(19 downto 0);
    
    --Regulator status
    rsts                    : in std_logic_vector(19 downto 0);
    
    -- 24 16-bit ADC Channels for monitoring (3 - ADS5868)
    mon_adc_rst            : out std_logic;
    mon_adc_cnv            : out std_logic;
    mon_adc_sck            : out std_logic;
    mon_adc_fs             : out std_logic; 
    mon_adc_busy           : in std_logic_vector(2 downto 0);
    mon_adc_sdo            : in std_logic_vector(2 downto 0);

    -- 8 20-bit ADC Channels for DCCT (8 - LTC2376)
    dcct_adc_cnv            : out std_logic;
    dcct_adc_sck            : out std_logic;
    dcct_adc_busy           : in std_logic_vector(3 downto 0);
    dcct_adc_sdo            : in std_logic_vector(3 downto 0);

   -- 4 18-bit DAC Channels (4 - AD5781)
    stpt_dac_sck            : out std_logic;
    stpt_dac_sync           : out std_logic;
    stpt_dac_sdo            : out std_logic_vector(3 downto 0);
     
    --sfp i2c
    sfp_sck                 : inout std_logic_vector(3 downto 0);
    sfp_sda                 : inout std_logic_vector(3 downto 0);
    sfp_leds                : out std_logic_vector(7 downto 0);
          
    -- Embedded Event Receiver
    gtx_evr_refclk_p        : in std_logic;
    gtx_evr_refclk_n        : in std_logic;
    gtx_evr_rx_p            : in std_logic;
    gtx_evr_rx_n            : in std_logic;
    
    --gigE interface
    gtx_gige_refclk_p       : in std_logic;
    gtx_gige_refclk_n       : in std_logic;
    
    --Trigger inputs
    trig                    : in std_logic_vector(3 downto 0);
    
    -- Programmable oscillator for EVR reference clock
    si570_sck               : out std_logic;
    si570_sda               : inout std_logic;
    
    -- One wire interface
    onewire_sck             : out std_logic;
    onewire_sda             : inout std_logic;
    
    --MAC ID eeprom (11AA02E48T)
    mac_id                  : inout std_logic;
   
    --  Front panel LED's
    fp_leds                 : out std_logic_vector(7 downto 0)

  );
end top;


architecture behv of top is

   signal pl_reset              : std_logic;
   signal pl_resetn             : std_logic_vector(0 downto 0);
   signal gtx_reset             : std_logic_vector(7 downto 0);
   signal pl_clk0               : std_logic;
   
   signal gtx_gige_refclk       : std_logic;
   signal gtx_evr_refclk        : std_logic;
   
   signal leds                  : std_logic_vector(7 downto 0);
 
   signal m_axi4_m2s            : t_pl_regs_m2s;
   signal m_axi4_s2m            : t_pl_regs_s2m;
   
   signal dcct_adc_in           : t_DCCT;
   signal dcct_adc_out          : t_DCCT;

   signal mon_adc_in            : t_ADC_8CHANNEL;
   signal mon_adc_out           : t_ADC_8CHANNEL;


   signal evr_dbg               : std_logic_vector(19 downto 0);
   signal evr_tbt_trig          : std_logic;
   signal evr_fa_trig           : std_logic;
   signal evr_sa_trig           : std_logic;
   signal evr_usr_trig          : std_logic;
   signal evr_dma_trig          : std_logic;
   signal evr_gps_trig          : std_logic;
   signal evr_timestamp         : std_logic_vector(63 downto 0);
   signal evr_timestamplat      : std_logic_vector(63 downto 0);
   signal evr_trignum           : std_logic_vector(7 downto 0);
   signal evr_trigdly           : std_logic_vector(31 downto 0);
   signal evr_rcvd_clk          : std_logic;
   

   --debug signals (connect to ila)
   attribute mark_debug                 : string;
   attribute mark_debug of mon_adc_cnv     : signal is "true";



begin



fp_leds(7 downto 0) <= leds;  

pl_reset <= not pl_resetn(0); 



--gtx refclk for EVR
evr_refclk : IBUFDS_GTE2  
  port map (
    O => gtx_evr_refclk, 
    ODIV2 => open,
    CEB => 	'0',
    I => gtx_evr_refclk_p,
    IB => gtx_evr_refclk_n
);

--gtx refclk for gigE
fofb_refclk : IBUFDS_GTE2  
  port map (
    O => gtx_gige_refclk, 
    ODIV2 => open,
    CEB => 	'0',
    I => gtx_gige_refclk_p,
    IB => gtx_gige_refclk_n
);

-- reads 8 channels of DCCT ADC's
read_dcct_adcs: entity work.DCCT_ADC_module
  port map(
    clk => pl_clk0, 
    reset => pl_reset, 
    start => trig(0), 
    DCCT_in  => dcct_adc_in, 
    DCCT_out => dcct_adc_out,  
    sdi => dcct_adc_sdo, 
    cnv => dcct_adc_cnv, 
    sclk => dcct_adc_sck, 
    sdo => open,
	done => open 
);


-- reads 24 channels of monitor ADC's
mon_adc_rst <= '0';
read_mon_adcs: entity work.ADC_8CH_module
  port map(
    clk => pl_clk0, 
    reset => pl_reset, 
    start => trig(0), 
    adc_8ch_in => mon_adc_in,
    adc_8ch_out => mon_adc_out,
    adc8c_sdo => mon_adc_sdo,
    adc8c_conv123 => mon_adc_cnv, 
    adc8c_fs123 => mon_adc_fs, 
    adc8c_sck123 => mon_adc_sck,
    done => open
);




--embedded event receiver
evr: entity work.evr_top 
  port map(
    sys_clk => pl_clk0,
    sys_rst => pl_reset,
    gtx_reset => gtx_reset,
    gtx_refclk => gtx_evr_refclk, 
    rx_p => gtx_evr_rx_p,
    rx_n => gtx_evr_rx_n,
    trignum => evr_trignum,  
    trigdly => (x"00000001"),   
    tbt_trig => evr_tbt_trig, 
    fa_trig => evr_fa_trig, 
    sa_trig => evr_sa_trig, 
    usr_trig => evr_usr_trig, 
    gps_trig => evr_gps_trig, 
    timestamp => evr_timestamp,  
    evr_rcvd_clk => evr_rcvd_clk,
    dbg => evr_dbg  
);	




ps_pl: entity work.ps_io
  generic map (
    FPGA_VERSION => FPGA_VERSION
    )
  port map (
    pl_clock => pl_clk0, 
    pl_reset => pl_reset, 
    m_axi4_m2s => m_axi4_m2s, 
    m_axi4_s2m => m_axi4_s2m,
    leds => leds            
  );

 

sys: component system
  port map (
    ddr_addr(14 downto 0) => ddr_addr(14 downto 0),
    ddr_ba(2 downto 0) => ddr_ba(2 downto 0),
    ddr_cas_n => ddr_cas_n,
    ddr_ck_n => ddr_ck_n,
    ddr_ck_p => ddr_ck_p,
    ddr_cke => ddr_cke,
    ddr_cs_n => ddr_cs_n,
    ddr_dm(3 downto 0) => ddr_dm(3 downto 0),
    ddr_dq(31 downto 0) => ddr_dq(31 downto 0),
    ddr_dqs_n(3 downto 0) => ddr_dqs_n(3 downto 0),
    ddr_dqs_p(3 downto 0) => ddr_dqs_p(3 downto 0),
    ddr_odt => ddr_odt,
    ddr_ras_n => ddr_ras_n,
    ddr_reset_n => ddr_reset_n,
    ddr_we_n  => ddr_we_n,
    fixed_io_ddr_vrn => fixed_io_ddr_vrn,
    fixed_io_ddr_vrp => fixed_io_ddr_vrp,
    fixed_io_mio(53 downto 0) => fixed_io_mio(53 downto 0),
    fixed_io_ps_clk => fixed_io_ps_clk,
    fixed_io_ps_porb => fixed_io_ps_porb,
    fixed_io_ps_srstb => fixed_io_ps_srstb,

    pl_clk0 => pl_clk0,
    pl_resetn => pl_resetn,  
    m_axi_araddr => m_axi4_m2s.araddr, 
    m_axi_arprot => m_axi4_m2s.arprot,
    m_axi_arready => m_axi4_s2m.arready,
    m_axi_arvalid => m_axi4_m2s.arvalid,
    m_axi_awaddr => m_axi4_m2s.awaddr,
    m_axi_awprot => m_axi4_m2s.awprot,
    m_axi_awready => m_axi4_s2m.awready,
    m_axi_awvalid => m_axi4_m2s.awvalid,
    m_axi_bready => m_axi4_m2s.bready,
    m_axi_bresp => m_axi4_s2m.bresp,
    m_axi_bvalid => m_axi4_s2m.bvalid,
    m_axi_rdata => m_axi4_s2m.rdata,
    m_axi_rready => m_axi4_m2s.rready,
    m_axi_rresp => m_axi4_s2m.rresp,
    m_axi_rvalid => m_axi4_s2m.rvalid,
    m_axi_wdata => m_axi4_m2s.wdata,
    m_axi_wready => m_axi4_s2m.wready,
    m_axi_wstrb => m_axi4_m2s.wstrb,
    m_axi_wvalid => m_axi4_m2s.wvalid  
  );



       
    
    
end behv;
