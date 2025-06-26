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
    rxp          : in  std_logic;
    rxn          : in  std_logic;
    txp          : out std_logic;
    txn          : out std_logic;
    fofb_params  : in t_fofb_params; 
	fofb_stat    : out t_fofb_stat
  );
end entity fofb_top;

architecture behv of fofb_top is


  signal gtrefclk_bufg_out     : std_logic;
  signal userclk2              : std_logic;                    
  signal rxuserclk2            : std_logic;
  signal resetdone             : std_logic;


 -- GMII signals
  signal gmii_isolate          : std_logic;                    -- Internal gmii_isolate signal.
  signal gmii_txd             : std_logic_vector(7 downto 0);  -- Transmit data from client MAC.
  signal gmii_tx_en           : std_logic;                     -- Transmit control signal from client MAC.
  signal gmii_tx_er           : std_logic;                     -- Transmit control signal from client MAC.
  signal gmii_rxd             : std_logic_vector(7 downto 0); -- Received Data to client MAC.
  signal gmii_rx_dv           : std_logic;                    -- Received control signal to client MAC.
  signal gmii_rx_er           : std_logic;                    -- Received control signal to client MAC.
  signal gmii_rx_dv_prev      : std_logic;
  signal gmii_tx_en_prev      : std_logic;

  signal configuration_vector  : std_logic_vector(4 downto 0);
  signal an_adv_config_vector  : std_logic_vector(15 downto 0);
  signal an_restart_config     : std_logic;
  signal an_interrupt          : std_logic;
  signal status_vector         : std_logic_vector(15 downto 0);
  signal signal_detect         : std_logic;

  signal mmcm_locked_out      : std_logic;
  signal pma_reset_out         : std_logic;
  
  signal rx_udp_pkt_out        : t_udp_pkt;
  signal udp_rx_done           : std_logic;
  signal got_fofb_pkt          : std_logic;

  attribute mark_debug : string;  
  attribute mark_debug of gmii_rxd: signal is "true";
  attribute mark_debug of gmii_rx_dv: signal is "true";  
  attribute mark_debug of gmii_rx_er: signal is "true";
  --attribute mark_debug of gmii_isolate: signal is "true";
  attribute mark_debug of gmii_txd: signal is "true";
  attribute mark_debug of gmii_tx_en: signal is "true";  
  attribute mark_debug of gmii_tx_er: signal is "true"; 
  
  attribute mark_debug of status_vector: signal is "true";
  attribute mark_debug of an_interrupt: signal is "true";
  attribute mark_debug of resetdone: signal is "true";  
  attribute mark_debug of fofb_params: signal is "true";
  attribute mark_debug of got_fofb_pkt: signal is "true";



begin




--phy config vectors
configuration_vector <= "10000";
an_adv_config_vector <= x"0020";
an_restart_config    <= '0';
signal_detect <= '1';
 



phy_i :  gige_pcs_pma
  generic map (
    EXAMPLE_SIMULATION => 0
   )
  port map (
    gtrefclk_p => gtrefclk_p,
    gtrefclk_n => gtrefclk_n,
    gtrefclk_out => open,
    gtrefclk_bufg_out => gtrefclk_bufg_out, 
    txp => txp,
    txn => txn,
    rxp => rxp,
    rxn => rxn,
    mmcm_locked_out => mmcm_locked_out, 
    userclk_out => open, 
    userclk2_out => userclk2,
    rxuserclk_out => open,
    rxuserclk2_out => rxuserclk2,
    independent_clock_bufg => clk,  
    pma_reset_out => pma_reset_out,
    resetdone => resetdone,  
    gmii_txd => gmii_txd,
    gmii_tx_en => gmii_tx_en,
    gmii_tx_er => gmii_tx_er,
    gmii_rxd => gmii_rxd,
    gmii_rx_dv => gmii_rx_dv,
    gmii_rx_er => gmii_rx_er,
    gmii_isolate => gmii_isolate,
    configuration_vector => configuration_vector,
    an_interrupt => an_interrupt,
    an_adv_config_vector => an_adv_config_vector,
    an_restart_config => an_restart_config,
    status_vector => status_vector,
    reset => reset,
    signal_detect => signal_detect,
    gt0_qplloutclk_out => open,
    gt0_qplloutrefclk_out => open
); 



--FOFB recieve fsm 
fofb_rcv : entity work.udp_rx
  port map(  
    clk => userclk2,         
    reset => reset,	
    rx_data_in => gmii_rxd, 
    rx_dv => gmii_rx_dv,                                   	                         
    udp_pkt_rx => rx_udp_pkt_out,
    rx_done => udp_rx_done
	 );

process (userclk2)
begin 
  if (rising_edge(userclk2)) then
    if (reset = '1') then
       got_fofb_pkt <= '0';
    else
       if ((udp_rx_done = '1') and (rx_udp_pkt_out.ip_dest_addr = fofb_params.ipaddr)) then
         got_fofb_pkt <= '1';
       else
         got_fofb_pkt <= '0';
       end if;
     end if;
   end if;
end process;   





end architecture behv;
