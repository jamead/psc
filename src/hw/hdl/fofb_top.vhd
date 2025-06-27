library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 



entity fofb_top is
  port (
    clk          : in  std_logic;
    reset        : in  std_logic;   
    gtrefclk_p   : in  std_logic;
    gtrefclk_n   : in  std_logic;
    rxp          : in  std_logic_vector(1 downto 0);
    rxn          : in  std_logic_vector(1 downto 0);
    txp          : out std_logic_vector(1 downto 0);
    txn          : out std_logic_vector(1 downto 0);
    fofb_params  : in t_fofb_params; 
	fofb_stat    : out t_fofb_stat
  );
end entity fofb_top;

architecture behv of fofb_top is


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
  attribute mark_debug of fofb_params: signal is "true";
  attribute mark_debug of got_fofb_pkt_sfp0: signal is "true";
  attribute mark_debug of got_fofb_pkt_sfp1: signal is "true";


begin




--phy config vectors
configuration_vector <= "10000";
an_adv_config_vector <= x"0020";
an_restart_config    <= '0';
signal_detect <= '1';
 



phy_sfp0_rx :  gige_pcs_pma_rx
  generic map (
    EXAMPLE_SIMULATION => 0
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
    gmii_rxd => gmii_rxd_sfp0,
    gmii_rx_dv => gmii_rx_dv_sfp0,
    gmii_rx_er => gmii_rx_er_sfp0,
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
--  generic map (
--    EXAMPLE_SIMULATION => 0
--  )
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
    gmii_tx_er => gmii_tx_er_sfp1,
    gmii_rxd => gmii_rxd_sfp1, 
    gmii_rx_dv => gmii_rx_dv_sfp1,
    gmii_rx_er => gmii_rx_er_sfp1,
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





--FOFB recieve fsm 
fofb_rcv_sfp0 : entity work.udp_rx
  port map(  
    clk => user_clk2,         
    reset => reset,	
    rx_data_in => gmii_rxd_sfp0, 
    rx_dv => gmii_rx_dv_sfp0,                                   	                         
    udp_pkt_rx => rx_udp_pkt_out_sfp0,
    rx_done => udp_rx_done_sfp0
	 );
	 
--FOFB recieve fsm 
fofb_rcv_sfp1 : entity work.udp_rx
  port map(  
    clk => user_clk2,         
    reset => reset,	
    rx_data_in => gmii_rxd_sfp1, 
    rx_dv => gmii_rx_dv_sfp1,                                   	                         
    udp_pkt_rx => rx_udp_pkt_out_sfp1,
    rx_done => udp_rx_done_sfp1
	 );	 
	 

process (user_clk2)
begin 
  if (rising_edge(user_clk2)) then
    if (reset = '1') then
       got_fofb_pkt_sfp0 <= '0';
    else
       if ((udp_rx_done_sfp0 = '1') and (rx_udp_pkt_out_sfp0.ip_dest_addr = fofb_params.ipaddr)) then
         got_fofb_pkt_sfp0 <= '1';
       else
         got_fofb_pkt_sfp0 <= '0';
       end if;
     end if;
   end if;
end process;   


process (user_clk2)
begin 
  if (rising_edge(user_clk2)) then
    if (reset = '1') then
       got_fofb_pkt_sfp1 <= '0';
    else
       if ((udp_rx_done_sfp1 = '1') and (rx_udp_pkt_out_sfp1.ip_dest_addr = fofb_params.ipaddr)) then
         got_fofb_pkt_sfp1 <= '1';
       else
         got_fofb_pkt_sfp1 <= '0';
       end if;
     end if;
   end if;
end process;   




end architecture behv;
