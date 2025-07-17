library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pulse_enable_tb is
end entity;

architecture sim of pulse_enable_tb is

    -- DUT signals
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '1';
    signal en         : std_logic := '0';
    signal enable_in  : std_logic := '0';
    signal en_out     : std_logic;
    signal period_in  : std_logic_vector(31 downto 0) := (others => '0');

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the DUT
    uut: entity work.pulse_enable
        port map (
            clk        => clk,
            reset      => reset,
            en         => en,
            enable_in  => enable_in,
            en_out     => en_out,
            period_in  => period_in
        );

    -- Clock process
    clk_process : process
    begin
        while now < 200 ms loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Hold reset
        wait for 20 ns;
        reset <= '0';

        -- Pulsed enable mode (en = 1)
        en <= '1';
        enable_in <= '1';
        period_in <= std_logic_vector(to_unsigned(50, 32));  -- Pulse period = 20 cycles
        wait for 5 ms;
        enable_in <= '0';
        wait for 1 ms;

        -- Change period
        --enable_in <= '1';
        --period_in <= std_logic_vector(to_unsigned(40, 32));
        --wait for 400 ns;
        wait for 10 ms;
        -- Stop simulation
        wait;
    end process;

end architecture;


