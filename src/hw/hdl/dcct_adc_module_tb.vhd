library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all;

entity dcct_adc_module_tb is
end entity;

architecture tb of dcct_adc_module_tb is

  -- Clock period
  constant clk_period : time := 10 ns;

  -- DUT signals
  signal clk        : std_logic := '0';
  signal reset      : std_logic := '1';
  signal start      : std_logic := '0';
  signal sdi        : std_logic_vector(3 downto 0) := (others => '0');
  signal dcct_params: t_dcct_adcs_params;
  signal DCCT_out   : t_dcct_adcs;
  signal cnv        : std_logic;
  signal sclk       : std_logic;
  signal sdo        : std_logic;
  signal done       : std_logic;

begin

  -- Clock process
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
  end process;

  -- Instantiate DUT
  uut: entity work.dcct_adc_module
    port map (
      clk         => clk,
      reset       => reset,
      start       => start,
      dcct_params => dcct_params,
      DCCT_out    => DCCT_out,
      sdi         => sdi,
      cnv         => cnv,
      sclk        => sclk,
      sdo         => sdo,
      done        => done
    );

  -- Test process
  stim_proc: process
  begin
    wait for 20 ns;
    reset <= '0';
    sdi <= "1010";  
    dcct_params.ps1.dcct0_offset <= to_signed(100, 20);
    dcct_params.ps1.dcct0_gain <= to_signed(16#0FFFFF#, 24);
    dcct_params.ps1.dcct1_offset <= to_signed(-100, 20);
    dcct_params.ps1.dcct1_gain <= to_signed(16#1FFFFF#, 24);
    
    dcct_params.ps4.dcct0_gain <= to_signed(-1000, 24);
    dcct_params.ps4.dcct1_gain <= to_signed(-1000, 24);

    -- Start the ADC read process
    wait for 1000 ns;
    start <= '1';
    wait for 10 ns;
    start <= '0';
    
    wait for 100 us;
    start <= '1';
    wait for 10 ns;
    start <= '0';  

    wait for 100 us;
    start <= '1';
    wait for 10 ns;
    start <= '0';  
   




    -- Wait long enough for ADCs to respond and DUT to process
    wait for 500 ns;

    -- Observe outputs here in simulation or add asserts if desired
    wait;
  end process;

end architecture;

