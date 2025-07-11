-- VHDL translation of evrSROC Verilog module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity evrSROC is
  generic (
    SYSCLK_FREQUENCY : integer := -1;
    DEBUG            : string  := "false";
    DIVISOR_WIDTH    : integer := 10;
    COUNTER_WIDTH    : integer := DIVISOR_WIDTH - 1
  );
  port (
    sysClk                    : in  std_logic;
    csrStrobe                 : in  std_logic;
    GPIO_OUT                  : in  std_logic_vector(31 downto 0);
    csr                       : out std_logic_vector(31 downto 0);

    evrClk                    : in  std_logic;
    evrHeartbeatMarker        : in  std_logic;
    evrPulsePerSecondMarker   : in  std_logic;
    evrSROCsynced             : out std_logic := '0';
    evrSROC                   : out std_logic := '0';
    evrSROCstrobe             : out std_logic := '0';
    evrCounterDbg             : out std_logic_vector(COUNTER_WIDTH-1 downto 0);
    evrCounterHBDbg           : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of evrSROC is
  signal sysClkDivisor : unsigned(DIVISOR_WIDTH downto 0) := (others => '0');
  signal reloadLo, reloadHi : unsigned(COUNTER_WIDTH-1 downto 0);
  signal evrCounter : unsigned(COUNTER_WIDTH-1 downto 0) := (others => '0');
  signal evrCounterHB : unsigned(31 downto 0) := (others => '0');
  signal evrHeartbeatMarker_d : std_logic := '0';

  signal heartBeatValid, pulsePerSecondValid : std_logic;
  signal sroc           : std_logic := '0';
  signal srocStrobe     : std_logic := '0';
  signal srocSynced     : std_logic := '0';

begin

  process(sysClk)
  begin
    if rising_edge(sysClk) then
      if csrStrobe = '1' then
        sysClkDivisor <= unsigned(GPIO_OUT(16 + DIVISOR_WIDTH - 1 downto 16));
      end if;

      reloadLo <= resize(((sysClkDivisor + 1) srl 1) - 1, COUNTER_WIDTH);
      reloadHi <= resize((sysClkDivisor srl 1) - 1, COUNTER_WIDTH);
    end if;
  end process;

  process(evrClk)
  begin
    if rising_edge(evrClk) then
      evrHeartbeatMarker_d <= evrHeartbeatMarker;

      if evrHeartbeatMarker = '1' and evrHeartbeatMarker_d = '0' then
        sroc <= '1';
        srocStrobe <= '1';
        evrCounter <= reloadHi;
        evrCounterHB <= (others => '0');
        srocSynced <= (sroc = '0' and evrCounter = 0);
      else
        evrCounterHB <= evrCounterHB + 1;
        if evrCounter = 0 then
          sroc <= not sroc;
          if sroc = '1' then
            srocStrobe <= '0';
            evrCounter <= reloadLo;
          else
            srocStrobe <= '1';
            evrCounter <= reloadHi;
          end if;
        else
          srocStrobe <= '0';
          evrCounter <= evrCounter - 1;
        end if;
      end if;
    end if;
  end process;

  evrSROC         <= sroc;
  evrSROCstrobe   <= srocStrobe;
  evrSROCsynced   <= srocSynced;
  evrCounterDbg   <= std_logic_vector(evrCounter);
  evrCounterHBDbg <= std_logic_vector(evrCounterHB);

  csr <= (31 downto 32 - DIVISOR_WIDTH => sysClkDivisor(DIVISOR_WIDTH - 1 downto 0)) &
         (2 => pulsePerSecondValid, 1 => heartBeatValid, 0 => srocSynced,
          others => '0');

  -- Instantiate watchdog modules
  hbWatchdog: entity work.eventMarkerWatchdog
    generic map (
      SYSCLK_FREQUENCY => SYSCLK_FREQUENCY,
      DEBUG => DEBUG
    )
    port map (
      sysClk => sysClk,
      evrMarker => evrHeartbeatMarker,
      isValid => heartBeatValid
    );

  ppsWatchdog: entity work.eventMarkerWatchdog
    generic map (
      SYSCLK_FREQUENCY => SYSCLK_FREQUENCY,
      DEBUG => DEBUG
    )
    port map (
      sysClk => sysClk,
      evrMarker => evrPulsePerSecondMarker,
      isValid => pulsePerSecondValid
    );

end architecture;

