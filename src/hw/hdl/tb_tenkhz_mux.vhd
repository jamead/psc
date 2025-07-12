library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.psc_pkg.all;  -- for t_evr_trigs, t_evr_params

entity tb_tenkhz_mux is
end entity;

architecture sim of tb_tenkhz_mux is

  -- Component under test
  component tenkhz_mux
    port(
      pl_clk        : in std_logic;
      evr_clk       : in std_logic;
      reset         : in std_logic;

      evr_trigs     : in t_evr_trigs;
      evr_params    : in t_evr_params;

      flt_10kHz     : out std_logic;
      tenkhz_out    : out std_logic
    );
  end component;

  -- Signals
  signal pl_clk        : std_logic := '0';
  signal evr_clk       : std_logic := '0';
  signal reset         : std_logic := '1';

  signal evr_trigs     : t_evr_trigs;
  signal evr_params    : t_evr_params;

  signal flt_10kHz     : std_logic;
  signal tenkhz_out    : std_logic;
  
  signal clkcnt        : integer := 0;
  signal clkcnt_1hz    : integer := 0;

  -- Clock period constants
  constant PL_CLK_PERIOD  : time := 10 ns;  -- 100 MHz
  constant EVR_CLK_PERIOD : time := 8 ns;  -- 125 MHz

begin

  -- DUT instantiation
  uut: tenkhz_mux
    port map (
      pl_clk       => pl_clk,
      evr_clk      => evr_clk,
      reset        => reset,
      evr_trigs    => evr_trigs,
      evr_params   => evr_params,
      flt_10kHz    => flt_10kHz,
      tenkhz_out   => tenkhz_out
    );

  -- Clock generators
  pl_clk_gen : process
  begin
    while true loop
      pl_clk <= '0';
      wait for PL_CLK_PERIOD / 2;
      pl_clk <= '1';
      wait for PL_CLK_PERIOD / 2;
    end loop;
  end process;

  evr_clk_gen : process
  begin
    while true loop
      evr_clk <= '0';
      wait for EVR_CLK_PERIOD / 2;
      evr_clk <= '1';
      wait for EVR_CLK_PERIOD / 2;
    end loop;
  end process;

  -- Stimulus process
  stim : process
  begin
    -- Initial reset
    reset <= '1';
    wait for 100 ns;
    reset <= '0';

    -- Use internal 10 kHz source
    evr_params.tenkhz_src <= "00";
    
    evr_params.tenkhz_cnt <= 32d"10040";

    wait for 1000 ms;


end process;
   
 process(evr_clk)
  begin
    if rising_edge(evr_clk) then
      clkcnt_1hz <= clkcnt_1hz + 1;
      if (clkcnt_1hz = 1280000) then
         evr_trigs.onehz_trig <= '1';
      end if;
      if (clkcnt_1hz = 1280100) then
         evr_trigs.onehz_trig <= '0';   
         clkcnt_1hz <= 0;
      end if;
    end if;
end process;     
   
   
   
    
 process(evr_clk)
  begin
    if rising_edge(evr_clk) then
      clkcnt <= clkcnt + 1;
      if (clkcnt = 124000) then
         evr_trigs.fa_trig <= '1';
      end if;
      if (clkcnt = 124100) then
         evr_trigs.fa_trig <= '0';   
         clkcnt <= 0;
      end if;
    end if;
end process;   

end architecture;

