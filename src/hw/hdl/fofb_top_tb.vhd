library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 

entity fofb_top_tb is
end entity;

architecture tb of fofb_top_tb is

  -- DUT ports
  signal clk         : std_logic := '0';
  signal reset       : std_logic := '1';
  signal gtrefclk_p  : std_logic := '0';
  signal gtrefclk_n  : std_logic := '1';
  signal rxp         : std_logic_vector(1 downto 0);
  signal rxn         : std_logic_vector(1 downto 0);
  signal txp         : std_logic_vector(1 downto 0);
  signal txn         : std_logic_vector(1 downto 0);
  signal fofb_params : t_fofb_params := (others => (others => '0')); 
  signal fofb_data   : t_fofb_data;

  signal configuration_vector  : std_logic_vector(4 downto 0);
  signal an_adv_config_vector  : std_logic_vector(15 downto 0);
  signal an_restart_config     : std_logic;
  signal an_interrupt_sfp0     : std_logic;
  signal an_interrupt_sfp1     : std_logic;
  signal status_vector_sfp0    : std_logic_vector(15 downto 0);
  signal status_vector_sfp1    : std_logic_vector(15 downto 0);
  signal signal_detect         : std_logic;
  
  signal gtrefclk              : std_logic;
  signal gtrefclk_bufg_out     : std_logic;
  signal mmcm_locked           : std_logic;
  signal user_clk              : std_logic;
  signal user_clk2             : std_logic;
  signal rxuser_clk            : std_logic;
  signal rxuser_clk2           : std_logic;
  signal pma_reset             : std_logic;
  signal resetdone             : std_logic;

  signal gmii_txd              : std_logic_vector(7 downto 0);  
  signal gmii_tx_en            : std_logic;                     
  signal gmii_tx_er            : std_logic;   
  
  signal scale_factor          : std_logic_vector(31 downto 0); 


-- Stimulus array: 78 bytes matching the case statement
  type byte_array_t is array (0 to 85) of std_logic_vector(7 downto 0);
  constant tx_data_bytes : byte_array_t := (
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
    x"10", x"00", x"11", x"01",                     -- Src IP
    x"10", x"00", x"12", x"02",                     -- Dst IP
    x"00", x"2A",                                   -- Src port
    x"00", x"2B",                                   -- Dst port
    x"00", x"28",                                   -- UDP length
    x"1A", x"2B",                                   -- UDP checksum
    x"DE", x"AD",                                   -- fast_ps_id
    x"BE", x"EF",                                   -- readback_cmd
    x"01", x"02", x"03", x"04", x"05", x"06", x"07", x"08", -- nonce
    x"0A", x"0B",                                   -- fast_addr1
    x"3F", x"A0", x"00", x"00",                     -- setpoint1
    x"1A", x"1B",                                   -- fast_addr2
    x"21", x"22", x"23", x"24",                     -- setpoint2
    x"2A", x"2B",                                   -- fast_addr3
    x"31", x"32", x"33", x"34",                     -- setpoint3
    x"3A", x"3B",                                   -- fast_addr4
    x"41", x"42", x"43", x"44"                      -- setpoint4
  );






begin


--phy config vectors
configuration_vector <= "10000";
an_adv_config_vector <= x"0020";
an_restart_config    <= '0';
signal_detect <= '1';

fofb_params.ipaddr <= x"10001202";
fofb_params.ps1_addr <= x"0a0b";

--scale_factor <= x"474350cd";  --50000.8
fofb_params.ps1_scalefactor <= x"474ccccd";  --52428.8
--scale_factor <= x"3FA66666";  --1.3



  -- Clock generation
clk_gen : process
  begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;


 -- GTX Refclk
 gtrefclk_n <= not gtrefclk_p;
refclk_gen : process
  begin
    gtrefclk_p <= '0';
    wait for 4 ns;
    gtrefclk_p <= '1';
    wait for 4 ns;
end process;




stim_proc : process
  begin
    reset <= '1';
    gmii_txd <= x"00";
    gmii_tx_en <= '0';
    gmii_tx_er <= '0';
    txp(1) <= '0';
    txn(1) <= '1';
    wait for 100 ns;
    reset <= '0';
    wait for 25 us;
    gmii_tx_en <= '1';
    for i in tx_data_bytes'range loop
      gmii_txd <= tx_data_bytes(i);
      wait until rising_edge(user_clk2);
    end loop;
    gmii_tx_en <= '0';

    wait;
end process;



-- Instantiate a Transceiver to simulate the source
-- Doesn't generate the correct txp,txn signals :(
--phy_testbench :  gige_pcs_pma_rx
--  generic map (
--    EXAMPLE_SIMULATION => 1
--   )
--  port map (
--    gtrefclk_p => gtrefclk_p,
--    gtrefclk_n => gtrefclk_n,
--    gtrefclk_out => gtrefclk, 
--    gtrefclk_bufg_out => gtrefclk_bufg_out, 
--    txp => txp(0),
--    txn => txn(0),
--    rxp => rxp(0),
--    rxn => rxn(0),
--    mmcm_locked_out => mmcm_locked, 
--    userclk_out => user_clk, 
--    userclk2_out => user_clk2,
--    rxuserclk_out => rxuser_clk,
--    rxuserclk2_out => rxuser_clk2,
--    independent_clock_bufg => clk,  
--    pma_reset_out => pma_reset,
--    resetdone => resetdone,  
--    gmii_txd => gmii_txd,
--    gmii_tx_en => gmii_tx_en,
--    gmii_tx_er => gmii_tx_er,
--    gmii_rxd => open, 
--    gmii_rx_dv => open, 
--    gmii_rx_er => open, 
--    gmii_isolate => open, --gmii_isolate,
--    configuration_vector => configuration_vector,
--    an_interrupt => an_interrupt_sfp0,
--    an_adv_config_vector => an_adv_config_vector,
--    an_restart_config => an_restart_config,
--    status_vector => status_vector_sfp0,
--    reset => reset,
--    signal_detect => signal_detect,
--    gt0_qplloutclk_out => open, --gt0_qplloutclk,
--    gt0_qplloutrefclk_out => open --gt0_qplloutrefclk
--); 







  -- Instantiate the DUT
  uut : entity work.fofb_top
    generic map (
      SIM_MODE => 1
    )
    port map (
      pl_clk0     => clk,
      reset       => reset,
      gtrefclk_p  => gtrefclk_p,
      gtrefclk_n  => gtrefclk_n,
      rxp         => txp,
      rxn         => txn,
      txp         => rxp,
      txn         => rxn,
      fofb_params => fofb_params,
      fofb_data   => fofb_data
    );

end architecture;
