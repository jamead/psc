library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eventMarkerWatchdog is
  generic (
    SYSCLK_FREQUENCY : integer := 100000000;
    DEBUG            : string  := "false"
  );
  port (
    sysClk    : in  std_logic;
    evrMarker : in  std_logic;
    isValid   : out std_logic := '0'
  );
end entity;

architecture rtl of eventMarkerWatchdog is
  constant UPPER_LIMIT : integer := (SYSCLK_FREQUENCY * 11) / 10;
  constant LOWER_LIMIT : integer := (SYSCLK_FREQUENCY * 9) / 10;

  signal watchdog : unsigned(31 downto 0) := (others => '0');
  signal marker_m, marker, marker_d : std_logic := '0';

begin
  process(sysClk)
  begin
    if rising_edge(sysClk) then
      marker_m <= evrMarker;
      marker   <= marker_m;
      marker_d <= marker;

      if marker = '1' and marker_d = '0' then
        if watchdog > LOWER_LIMIT and watchdog < UPPER_LIMIT then
          isValid <= '1';
        else
          isValid <= '0';
        end if;
        watchdog <= (others => '0');
      elsif watchdog < to_unsigned(UPPER_LIMIT, watchdog'length) then
        watchdog <= watchdog + 1;
      else
        isValid <= '0';
      end if;
    end if;
  end process;
end architecture;

