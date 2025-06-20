library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.psc_pkg.all;

entity dcct_gainoffset_fp_tb is
end dcct_gainoffset_fp_tb;

architecture sim of dcct_gainoffset_fp_tb is

  -- DUT inputs
  signal clk        : std_logic := '0';
  signal reset      : std_logic := '1';
  signal conv_done  : std_logic := '0';
  signal dcct0_raw  : signed(19 downto 0) := (others => '0');
  signal dcct1_raw  : signed(19 downto 0) := (others => '0');
  signal dcct_params : t_dcct_adcs_params_onech;

  -- DUT outputs
  signal dcct_out   : t_dcct_adcs_onech;
  signal done       : std_logic;

  -- Clock period constant
  constant clk_period : time := 10 ns;

begin

  -- Clock process
  clk_process : process
  begin
    while now < 5 ms loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
    wait;
  end process;

  -- Instantiate DUT
  uut: entity work.dcct_gainoffset_fp
    port map (
      clk         => clk,
      reset       => reset,
      conv_done   => conv_done,
      dcct0_raw   => dcct0_raw,
      dcct1_raw   => dcct1_raw,
      dcct_params => dcct_params,
      dcct_out    => dcct_out,
      done        => done
    );

  -- Stimulus process
  stim_proc: process
    variable gain_val  : signed(23 downto 0);  -- Assuming Q3.20 for gain
    variable offset_val: signed(19 downto 0);  -- Q0.19 for offset
  begin
    -- Initialize
    wait for 50 ns;
    reset <= '0';

    -- Set test parameters
    offset_val := to_signed(100, 20);   -- Small positive offset
    --gain_val   := to_signed(integer(0.9999995 * real(2**20)), 24);  --to_signed(524288, 24);  -- 0x080000, = 0.5 in Q3.20
    --gain_val   := to_signed(2**19 - 1, 24);

    dcct_params.dcct0_offset <= offset_val;
    dcct_params.dcct1_offset <= offset_val;
    dcct_params.dcct0_gain   <= x"3F000000";  --0.5
    dcct_params.dcct1_gain   <= x"3DCCCCCD";  --0.1  

    dcct0_raw <= to_signed(222892,20); --to_signed(integer(0.42513 * real(2**19)), 20); --to_signed(1024, 20);
    dcct1_raw <= to_signed(1024, 20);

    wait for 30 ns;
    conv_done <= '1';
    wait for clk_period;
    conv_done <= '0';

    -- Wait for 'done' signal
    wait until done = '1';

    -- Display output
    report "DCCT0 Output: " & integer'image(to_integer(dcct_out.dcct0));
    report "DCCT1 Output: " & integer'image(to_integer(dcct_out.dcct1));

    wait;
  end process;

end sim;
