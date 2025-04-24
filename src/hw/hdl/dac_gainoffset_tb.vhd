library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.psc_pkg.all;

entity tb_dac_gainoffset is
end entity;

architecture sim of tb_dac_gainoffset is

  -- Component declaration
  component dac_gainoffset
    port (
      clk           : in std_logic;
      reset         : in std_logic;
      tenkhz_trig   : in std_logic;
      numbits_sel   : in std_logic;
      dac_setpt_raw : in signed(19 downto 0);
      dac_cntrl     : in t_dac_cntrl_onech;
      dac_setpt     : out signed(19 downto 0);
      done          : out std_logic
    );
  end component;

  -- Testbench signals
  signal clk           : std_logic := '0';
  signal reset         : std_logic := '1';
  signal tenkhz_trig   : std_logic := '0';
  signal dac_setpt_raw : signed(19 downto 0) := (others => '0');
  signal dac_cntrl     : t_dac_cntrl_onech;
  signal dac_setpt     : signed(19 downto 0);
  signal done          : std_logic;
  
  signal numbits_sel   : std_logic := '1';  --0=18bit, 1=20bit

  constant clk_period : time := 100 ns;

begin

  -- Clock generation
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process;

  -- DUT instantiation
  uut: dac_gainoffset
    port map (
      clk           => clk,
      reset         => reset,
      tenkhz_trig   => tenkhz_trig,
      numbits_sel   => numbits_sel,
      dac_setpt_raw => dac_setpt_raw,
      dac_cntrl     => dac_cntrl,
      dac_setpt     => dac_setpt,
      done          => done
    );

  -- Stimulus process
  stim_proc : process
  begin
    -- Initialize
    dac_cntrl.offset <= to_signed(0, 20);     -- Example offset
    dac_cntrl.gain   <= to_signed(integer(1.01 * real(2**20)), 24); -- Gain = 1.1 in Q3.20 format

    wait for 100 ns;
    reset <= '0';
    wait for 100 ns;

    dac_setpt_raw <= to_signed(500000, 20); -- Example input
    tenkhz_trig <= '1';
    wait for clk_period;
    tenkhz_trig <= '0';

    wait until done = '1';
    wait for 500 ns;

    -- Try another set (pos sat)
    dac_setpt_raw <= to_signed(500000, 20);
    dac_cntrl.offset <= to_signed(0, 20);
    dac_cntrl.gain   <= to_signed(integer(1.5 * real(2**20)), 24); -- Gain = 1.5

    tenkhz_trig <= '1';
    wait for clk_period;
    tenkhz_trig <= '0';

    wait until done = '1';
    wait for 500 ns;
    
    -- Try another set (neg )
    dac_setpt_raw <= to_signed(-100000, 20);
    dac_cntrl.offset <= to_signed(0, 20);
    dac_cntrl.gain   <= to_signed(integer(1.5 * real(2**20)), 24); -- Gain = 1.5

    tenkhz_trig <= '1';
    wait for clk_period;
    tenkhz_trig <= '0';

    wait until done = '1';
    wait for 500 ns;
    
   -- Try another set (neg sat )
    dac_setpt_raw <= to_signed(-500000, 20);
    dac_cntrl.offset <= to_signed(0, 20);
    dac_cntrl.gain   <= to_signed(integer(1.5 * real(2**20)), 24); -- Gain = 1.5

    tenkhz_trig <= '1';
    wait for clk_period;
    tenkhz_trig <= '0';

    wait until done = '1';
    wait for 500 ns;
    
    
    wait;

  end process;

end architecture;

