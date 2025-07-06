library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 



entity fofb_phy is
  generic (
    SIM_MODE     : integer := 0
  );
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;   
    gtrefclk_p   : in  std_logic;
    gtrefclk_n   : in  std_logic;
    rxp          : in  std_logic_vector(1 downto 0);
    rxn          : in  std_logic_vector(1 downto 0);
    txp          : out std_logic_vector(1 downto 0);
    txn          : out std_logic_vector(1 downto 0);
    fofb_clk     : out std_logic;
    fofb_rxd     : out std_logic_vector(7 downto 0);
    fofb_rx_dv   : out std_logic;
    fofb_txd     : in  std_logic_vector(7 downto 0);
    fofb_tx_en   : in  std_logic
  );
end entity fofb_phy;

architecture behv of fofb_phy is


  signal gtrefclk_bufg_out     : std_logic;
  signal gtrefclk              : std_logic;
  signal user_clk              : std_logic;    
  signal user_clk2             : std_logic; 
  signal rxuser_clk            : std_logic;                     
  signal rxuser_clk2           : std_logic;
  signal resetdone             : std_logic;


 -- GMII signals
  signal gmii_isolate         : std_logic;  
  --sfp0 is the receiver                 
  signal gmii_txd_sfp0        : std_logic_vector(7 downto 0);  
  signal gmii_tx_en_sfp0      : std_logic;                     
  signal gmii_tx_er_sfp0      : std_logic;   
  signal gmii_rxd_sfp0_sim    : std_logic_vector(7 downto 0); 
  signal gmii_rx_dv_sfp0_sim  : std_logic;                    
  signal gmii_rx_er_sfp0_sim  : std_logic; 
  signal gmii_rxd_sfp0_syn    : std_logic_vector(7 downto 0); 
  signal gmii_rx_dv_sfp0_syn  : std_logic;                    
  signal gmii_rx_er_sfp0_syn  : std_logic;       
                    
  signal gmii_rxd_sfp0        : std_logic_vector(7 downto 0); 
  signal gmii_rx_dv_sfp0      : std_logic;                    
  signal gmii_rx_er_sfp0      : std_logic;    

  --sfp1 is the transmitter
  signal gmii_txd_sfp1        : std_logic_vector(7 downto 0);  
  signal gmii_tx_en_sfp1      : std_logic;                     
  signal gmii_tx_er_sfp1      : std_logic;                     
  signal gmii_rxd_sfp1        : std_logic_vector(7 downto 0); 
  signal gmii_rx_dv_sfp1      : std_logic;                    
  signal gmii_rx_er_sfp1      : std_logic;   
                 
  signal gmii_rx_dv_prev      : std_logic;
  signal gmii_tx_en_prev      : std_logic;

  signal configuration_vector  : std_logic_vector(4 downto 0);
  signal an_adv_config_vector  : std_logic_vector(15 downto 0);
  signal an_restart_config     : std_logic;
  signal an_interrupt_sfp0     : std_logic;
  signal an_interrupt_sfp1     : std_logic;
  signal status_vector_sfp0    : std_logic_vector(15 downto 0);
  signal status_vector_sfp1    : std_logic_vector(15 downto 0);
  signal signal_detect         : std_logic;

  signal mmcm_locked           : std_logic;
  signal pma_reset             : std_logic;
  
  signal rx_udp_pkt_out_sfp0   : t_udp_pkt;
  signal rx_udp_pkt_out_sfp1   : t_udp_pkt;  
  signal udp_rx_done_sfp0      : std_logic;
  signal udp_rx_done_sfp1      : std_logic;  
  signal got_fofb_pkt_sfp0     : std_logic;
  signal got_fofb_pkt_sfp1     : std_logic;
  
  signal gt0_qplloutclk        : std_logic;
  signal gt0_qplloutrefclk     : std_logic;

  attribute mark_debug : string;  
  attribute mark_debug of gmii_rxd_sfp0: signal is "true";
  attribute mark_debug of gmii_rx_dv_sfp0: signal is "true";  
  attribute mark_debug of gmii_rx_er_sfp0: signal is "true";
  attribute mark_debug of gmii_txd_sfp0: signal is "true";
  attribute mark_debug of gmii_tx_en_sfp0: signal is "true";  
  attribute mark_debug of gmii_tx_er_sfp0: signal is "true"; 
  
  attribute mark_debug of gmii_rxd_sfp1: signal is "true";
  attribute mark_debug of gmii_rx_dv_sfp1: signal is "true";  
  attribute mark_debug of gmii_rx_er_sfp1: signal is "true";
  attribute mark_debug of gmii_txd_sfp1: signal is "true";
  attribute mark_debug of gmii_tx_en_sfp1: signal is "true";  
  attribute mark_debug of gmii_tx_er_sfp1: signal is "true";   
  
  
  attribute mark_debug of status_vector_sfp0: signal is "true";
  attribute mark_debug of status_vector_sfp1: signal is "true"; 
  attribute mark_debug of an_interrupt_sfp0: signal is "true";
  attribute mark_debug of an_interrupt_sfp1: signal is "true";  
  attribute mark_debug of resetdone: signal is "true";  
  attribute mark_debug of got_fofb_pkt_sfp0: signal is "true";
  attribute mark_debug of got_fofb_pkt_sfp1: signal is "true";


-- Stimulus array: 78 bytes matching the case statement
  type byte_array_t is array (0 to 85) of std_logic_vector(7 downto 0);
  constant rx_data_bytes : byte_array_t := (
  -- Ethernet preamble + SFD (7 x 0x55, 1 x 0xD5)
    x"55", x"55", x"55", x"55", x"55", x"55", x"55", x"D5", 
    x"AA", x"BB", x"CC", x"DD", x"EE", x"FF", -- MAC dest addr
    x"11", x"22", x"33", x"44", x"55", x"66", -- MAC src addr
    x"08", x"00",                                   -- MAC type (IPv4)
    x"45", x"00",                                   -- IP version/IHL & TOS
    x"00", x"3C",                                   -- Total length
    x"12", x"34",                                   -- IP ID
    x"40", x"00",                                   -- Flags + Frag Offset
    x"40", x"11",                                   -- TTL + Protocol (UDP)
    x"B8", x"27",                                   -- Header checksum
    x"C0", x"A8", x"00", x"01",                     -- Src IP
    x"10", x"00", x"12", x"02",                     -- Dst IP
    x"00", x"2A",                                   -- Src port
    x"00", x"2B",                                   -- Dst port
    x"00", x"28",                                   -- UDP length
    x"1A", x"2B",                                   -- UDP checksum
    x"76", x"31",                                   -- fast_ps_id
    x"00", x"01",                                   -- readback_cmd
    x"01", x"02", x"03", x"04", x"05", x"06", x"07", x"08", -- nonce
    x"0A", x"0B",                                   -- fast_addr1
    x"11", x"12", x"13", x"14",                     -- setpoint1
    x"1A", x"1B",                                   -- fast_addr2
    x"21", x"22", x"23", x"24",                     -- setpoint2
    x"2A", x"2B",                                   -- fast_addr3
    x"31", x"32", x"33", x"34",                     -- setpoint3
    x"3A", x"3B",                                   -- fast_addr4
    x"41", x"42", x"43", x"44"                      -- setpoint4
  );




begin


fofb_clk <= user_clk2;
fofb_rxd <= gmii_rxd_sfp0;
fofb_rx_dv <= gmii_rx_dv_sfp0;

gmii_txd_sfp1 <= fofb_txd;
gmii_tx_en_sfp1 <= fofb_tx_en;



fofb_sim:  if (SIM_MODE = 1) generate

stim_proc : process
  begin
    gmii_rxd_sfp0_sim <= x"00";
    gmii_rx_dv_sfp0_sim <= '0';
    gmii_rx_er_sfp0_sim <= '0';
    wait for 15 us;
    gmii_rx_dv_sfp0_sim <= '1';
    for i in rx_data_bytes'range loop
      gmii_rxd_sfp0_sim <= rx_data_bytes(i);
      wait until rising_edge(user_clk2);
    end loop;
    gmii_rx_dv_sfp0_sim <= '0';

    wait;
end process;

end generate;




gmii_rxd_sfp0   <= gmii_rxd_sfp0_sim   when SIM_MODE = 1 else gmii_rxd_sfp0_syn;
gmii_rx_dv_sfp0 <= gmii_rx_dv_sfp0_sim when SIM_MODE = 1 else gmii_rx_dv_sfp0_syn;
gmii_rx_er_sfp0 <= gmii_rx_er_sfp0_sim when SIM_MODE = 1 else gmii_rx_er_sfp0_syn;





--phy config vectors
configuration_vector <= "10000";
an_adv_config_vector <= x"0020";
an_restart_config    <= '0';
signal_detect <= '1';
 


phy_sfp0_rx :  gige_pcs_pma_rx
  generic map (
    EXAMPLE_SIMULATION => SIM_MODE
   )
  port map (
    gtrefclk_p => gtrefclk_p,
    gtrefclk_n => gtrefclk_n,
    gtrefclk_out => gtrefclk, 
    gtrefclk_bufg_out => gtrefclk_bufg_out, 
    txp => txp(0),
    txn => txn(0),
    rxp => rxp(0),
    rxn => rxn(0),
    mmcm_locked_out => mmcm_locked, 
    userclk_out => user_clk, 
    userclk2_out => user_clk2,
    rxuserclk_out => rxuser_clk,
    rxuserclk2_out => rxuser_clk2,
    independent_clock_bufg => clk,  
    pma_reset_out => pma_reset,
    resetdone => resetdone,  
    gmii_txd => gmii_txd_sfp0,
    gmii_tx_en => gmii_tx_en_sfp0,
    gmii_tx_er => gmii_tx_er_sfp0,
    gmii_rxd => gmii_rxd_sfp0_syn,
    gmii_rx_dv => gmii_rx_dv_sfp0_syn,
    gmii_rx_er => gmii_rx_er_sfp0_syn,
    gmii_isolate => gmii_isolate,
    configuration_vector => configuration_vector,
    an_interrupt => an_interrupt_sfp0,
    an_adv_config_vector => an_adv_config_vector,
    an_restart_config => an_restart_config,
    status_vector => status_vector_sfp0,
    reset => reset,
    signal_detect => signal_detect,
    gt0_qplloutclk_out => gt0_qplloutclk,
    gt0_qplloutrefclk_out => gt0_qplloutrefclk
); 


phy_sfp1_tx : gige_pcs_pma_tx
  port map (
    gtrefclk => gtrefclk,
    gtrefclk_bufg => gtrefclk_bufg_out,
    txp => txp(1),
    txn => txn(1),
    rxp => rxp(1),
    rxn => rxn(1),
    resetdone => open,
    cplllock => open,
    mmcm_reset => open,
    txoutclk => open,
    rxoutclk => open,
    userclk => user_clk,
    userclk2 => user_clk2,
    rxuserclk => rxuser_clk,
    rxuserclk2 => rxuser_clk2,
    pma_reset => pma_reset,
    mmcm_locked => mmcm_locked,
    independent_clock_bufg => clk,
    gmii_txd  => gmii_txd_sfp1,
    gmii_tx_en => gmii_tx_en_sfp1,
    gmii_tx_er => '0',
    gmii_rxd => open, --gmii_rxd_sfp1, 
    gmii_rx_dv => open, --gmii_rx_dv_sfp1,
    gmii_rx_er => open, --gmii_rx_er_sfp1,
    gmii_isolate => open,
    configuration_vector => configuration_vector,
    an_interrupt => an_interrupt_sfp1,
    an_adv_config_vector => an_adv_config_vector,
    an_restart_config => an_restart_config,
    status_vector => status_vector_sfp1,
    reset => reset,
    signal_detect => signal_detect,
    gt0_qplloutclk_in => gt0_qplloutclk,
    gt0_qplloutrefclk_in => gt0_qplloutrefclk
  );






end architecture behv;
