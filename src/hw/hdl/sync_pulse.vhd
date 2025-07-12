library ieee;
use ieee.std_logic_1164.all;

entity pulse_sync is
  port (
    clk              : in std_logic; 
    pulse_in         : in std_logic; 
    pulse_out        : out std_logic  
  );
end entity;

architecture behv of pulse_sync is

  signal sync_0         : std_logic := '0';
  signal sync_1         : std_logic := '0';
  signal sync_2         : std_logic := '0';


begin

  -- Double-flop synchronizer and rising-edge detector in clk domain
  sync_proc : process(clk)
  begin
    if rising_edge(clk) then
      sync_0      <= pulse_in;
      sync_1      <= sync_0;
      sync_2      <= sync_1;
      pulse_out   <= sync_1 and not sync_2; 
    end if;
  end process;


end architecture;

