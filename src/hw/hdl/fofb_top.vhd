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
    txn          : out std_logic
  );
end entity fofb_top;

architecture behv of fofb_top is


component gige_pcs_pma is
generic (
    EXAMPLE_SIMULATION        : in integer := 01
          );
  port (
    gtrefclk_p : in  std_logic;                         
    gtrefclk_n : in  std_logic;                         
    gtrefclk_out : out std_logic;                         
    gtrefclk_bufg_out : out std_logic; 
    txp : out std_logic;                    -- Differential +ve of serial transmission from PMA to PMD.
    txn : out std_logic;                    -- Differential -ve of serial transmission from PMA to PMD.
    rxp : in std_logic;                     -- Differential +ve for serial reception from PMD to PMA.
    rxn : in std_logic;                     -- Differential -ve for serial reception from PMD to PMA.
    userclk_out : out std_logic;                        
    userclk2_out : out std_logic;                        
    rxuserclk_out : out std_logic;                        
    rxuserclk2_out : out std_logic;                        
    pma_reset_out : out std_logic;                           -- transceiver PMA reset signal
    mmcm_locked_out : out std_logic;                           -- MMCM Locked
    resetdone : out std_logic;
    independent_clock_bufg : in std_logic;                 
    gmii_txd : in std_logic_vector(7 downto 0);  -- Transmit data from client MAC.
    gmii_tx_en : in std_logic;                     -- Transmit control signal from client MAC.
    gmii_tx_er : in std_logic;                     -- Transmit control signal from client MAC.
    gmii_rxd : out std_logic_vector(7 downto 0); -- Received Data to client MAC.
    gmii_rx_dv : out std_logic;                    -- Received control signal to client MAC.
    gmii_rx_er : out std_logic;                    -- Received control signal to client MAC.
    gmii_isolate : out std_logic;                    -- Tristate control to electrically isolate GMII.
    configuration_vector : in std_logic_vector(4 downto 0);  -- Alternative to MDIO interface.
    an_interrupt : out std_logic;                    -- Interrupt to processor to signal that Auto-Negotiation has completed
    an_adv_config_vector : in std_logic_vector(15 downto 0); -- Alternate interface to program REG4 (AN ADV)
    an_restart_config : in std_logic;                     -- Alternate signal to modify AN restart bit in REG0
    status_vector : out std_logic_vector(15 downto 0); -- Core status.
    reset : in std_logic;                     -- Asynchronous reset for entire core.
    signal_detect : in std_logic;                      -- Input from PMD to indicate presence of optical input.
    gt0_qplloutclk_out : out std_logic;
    gt0_qplloutrefclk_out : out std_logic
   );
end component;




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



end architecture behv;
