library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 



entity fofb_sync is
  port (
    fofb_clk     : in std_logic;
    pl_clk0      : in std_logic;

    fofb_data    : in t_fofb_data 
);
end entity fofb_sync;

architecture behv of fofb_sync is

  signal ps1_setptout_fp   : std_logic_vector(23 downto 0); 
  signal ps1_setpt_scaled  : std_logic_vector(31 downto 0);
  signal ps2_setptout_fp   : std_logic_vector(23 downto 0); 
  signal ps2_setpt_scaled  : std_logic_vector(31 downto 0);



begin



process(fofb_clk)
begin
  if rising_edge(fofb_clk) then
    if new_data_event = '1' then  -- e.g., 10 kHz strobe
      data_out        <= new_data;       -- 32-bit word
      data_toggle_125 <= not data_toggle_125; -- Toggle strobe
    end if;
  end if;
end process;



end architecture behv;
