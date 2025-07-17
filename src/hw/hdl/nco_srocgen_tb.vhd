library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;   

entity tb_nco_srocgen is
end entity;

architecture behv of tb_nco_srocgen is

  signal clk          : std_logic := '0';
  signal reset        : std_logic := '1';
  signal step_size    : unsigned(31 downto 0);
  signal resync_pulse : std_logic := '0';
  signal pulse_out    : std_logic;

  constant CLK_PERIOD : time := 10 ns;  -- 100 MHz

  -- For printing simulation time
  file log_file : text open write_mode is "/home/mead/nco_srocgen_log.txt";

begin

  -- Instantiate the NCO with resync
  uut: entity work.nco_srocgen
    port map (
      clk          => clk,
      reset        => reset,
      step_size    => step_size,
      resync_pulse => resync_pulse,
      pulse_out    => pulse_out
    );

  -- Clock generation: 100 MHz
  clk_process : process
  begin
    while now < 20000 ms loop  -- Run for 2 ms simulation
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stim_proc : process
    variable L : line;
  begin
    -- Initialize step_size for 9961.722 Hz output
    -- step_size = floor(2^32 * 9961.722 / 100000000) = 4279969272
    --step_size <= to_unsigned(4279969272, 32);
    --step_size <= 32d"427853"; 
    step_size <= x"1976B6F4";

    -- Release reset after 100 ns
    wait for 100 ns;
    reset <= '0';

    -- Generate resync pulse every 1,000,000 clock cycles (simulate faster)
    -- For simulation speed, we shorten this to 1,000,000 cycles = 10 ms
    for i in 0 to 10 loop  -- 11 resync pulses total
      wait for CLK_PERIOD * 1_000_000;
      resync_pulse <= '1';
      wait for CLK_PERIOD;
      resync_pulse <= '0';

      -- Print resync event time
      write(L, string'("Resync pulse issued at time "));
      write(L, now);
      writeline(log_file, L);
    end loop;

    wait;
  end process;

  -- Monitor output pulse times (optional)
  monitor_proc : process(clk)
    variable L : line;
  begin
    if rising_edge(clk) then
      if pulse_out = '1' then
        write(L, string'("Output pulse at time "));
        write(L, now);
        writeline(log_file, L);
      end if;
    end if;
  end process;

end architecture;

