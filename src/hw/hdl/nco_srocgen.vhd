library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nco_srocgen is
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    step_size     : in  unsigned(31 downto 0);  -- Programmable step size
    resync_pulse  : in  std_logic;              -- 1-clock pulse to resync the phase accumulator
    pulse_out     : out std_logic               -- 1-clock pulse output (~9961.722 Hz average)
  );
end entity;

architecture rtl of nco_srocgen is
  signal acc           : unsigned(31 downto 0) := (others => '0');
  signal acc_msb       : std_logic := '0';
  signal acc_msb_d     : std_logic := '0';
  signal out_pulse_int : std_logic := '0';
begin

  -- Phase accumulator with resync
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        acc         <= (others => '0');
        acc_msb     <= '0';
        acc_msb_d   <= '0';
        out_pulse_int <= '0';
      else
        -- Resynchronize phase accumulator to zero
        if resync_pulse = '1' then
          acc <= (others => '0');
        else
          acc <= acc + step_size;
        end if;

        -- MSB logic for pulse generation
        acc_msb     <= acc(31);
        acc_msb_d   <= acc_msb;
        out_pulse_int <= acc_msb and not acc_msb_d;
      end if;
    end if;
  end process;

  pulse_out <= out_pulse_int;

end architecture;

