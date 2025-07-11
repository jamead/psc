-- Testbench for evrSROC

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_evrSROC is
end entity;

architecture sim of tb_evrSROC is

  constant SYSCLK_PERIOD : time := 10 ns;  -- 100 MHz
  constant EVRCLK_PERIOD : time := 10 ns;  -- Same for simplicity

  signal sysClk                   : std_logic := '0';
  signal evrClk                   : std_logic := '0';

  signal csrStrobe                : std_logic := '0';
  signal GPIO_OUT                 : std_logic_vector(31 downto 0) := (others => '0');
  signal csr                      : std_logic_vector(31 downto 0);

  signal evrHeartbeatMarker       : std_logic := '0';
  signal evrPulsePerSecondMarker  : std_logic := '0';
  signal evrSROCsynced            : std_logic;
  signal evrSROC                  : std_logic;
  signal evrSROCstrobe            : std_logic;
  signal evrCounterDbg            : std_logic_vector(8 downto 0);
  signal evrCounterHBDbg          : std_logic_vector(31 downto 0);

begin

  -- Clock generators
  sysClk <= not sysClk after SYSCLK_PERIOD / 2;
  evrClk <= not evrClk after EVRCLK_PERIOD / 2;

  uut: entity work.evrSROC
    generic map (
      SYSCLK_FREQUENCY => 100_000_000,
      DEBUG            => "false",
      DIVISOR_WIDTH    => 10,
      COUNTER_WIDTH    => 9
    )
    port map (
      sysClk                  => sysClk,
      csrStrobe               => csrStrobe,
      GPIO_OUT                => GPIO_OUT,
      csr                     => csr,
      evrClk                  => evrClk,
      evrHeartbeatMarker      => evrHeartbeatMarker,
      evrPulsePerSecondMarker => evrPulsePerSecondMarker,
      evrSROCsynced           => evrSROCsynced,
      evrSROC                 => evrSROC,
      evrSROCstrobe           => evrSROCstrobe,
      evrCounterDbg           => evrCounterDbg,
      evrCounterHBDbg         => evrCounterHBDbg
    );

  stimulus: process
  begin
    -- Wait for reset
    wait for 100 ns;

    -- Set divisor via GPIO_OUT, use a sample divisor (e.g., 100)
    GPIO_OUT(25 downto 16) <= std_logic_vector(to_unsigned(100, 10));
    csrStrobe <= '1';
    wait for SYSCLK_PERIOD;
    csrStrobe <= '0';

    -- Generate heartbeat pulses
    wait for 1 us;
    evrHeartbeatMarker <= '1'; wait for EVRCLK_PERIOD;
    evrHeartbeatMarker <= '0'; wait for 5 us;

    -- Another pulse
    evrHeartbeatMarker <= '1'; wait for EVRCLK_PERIOD;
    evrHeartbeatMarker <= '0'; wait for 10 us;

    -- PPS pulse
    evrPulsePerSecondMarker <= '1'; wait for EVRCLK_PERIOD;
    evrPulsePerSecondMarker <= '0';

    -- Let simulation run
    wait for 100 us;

    assert false report "Simulation completed." severity failure;
  end process;

end architecture;

