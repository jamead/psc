library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac_ad5781_tb is
end entity;

architecture behv of dac_ad5781_tb is

-- Component Declaration
component dac_ad5781 is
    generic(SPI_CLK_DIV : natural := 5); 
    port(
        clk       : in std_logic; 
        reset     : in std_logic; 
        start     : in std_logic; 
        dac_data  : in std_logic_vector(19 downto 0); 
        dac_ctrl_bits : in std_logic_vector(4 downto 0);  
        n_sync    : out std_logic; 
        sclk      : out std_logic; 
        sdo       : out std_logic;
        done      : out std_logic
    );
end component;

    -- Signals
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '1';
    signal start     : std_logic := '0';
    signal dac_data  : std_logic_vector(19 downto 0) := (others => '0');
    signal dac_ctrl_bits : std_logic_vector(4 downto 0) := (others => '0');
    signal n_sync    : std_logic;
    signal sclk      : std_logic;
    signal sdo       : std_logic;
    signal done      : std_logic;

    -- Clock period
    constant clk_period : time := 10 ns;

begin

-- DUT Instantiation
uut: dac_ad5781
    generic map (
        SPI_CLK_DIV => 5
    )
    port map (
        clk => clk,
        reset => reset,
        start => start,
        dac_data => dac_data,
        dac_ctrl_bits => dac_ctrl_bits,
        n_sync => n_sync,
        sclk => sclk,
        sdo => sdo,
        done => done
);

    -- Clock generation
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Initial reset
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

        -- Apply input
        dac_data <= 20x"00055";  -- example 20 bit data
        dac_ctrl_bits <= "10101";  -- example control bits

        wait for 1000 ns;
        -- Trigger a start
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Wait for 'done' to go high
        wait until done = '1';
        
        wait for 1000 ns;
          -- Trigger a start
        start <= '1';
        wait for clk_period;
        start <= '0';
      

        -- Wait a bit and finish
        wait for 100 ns;
        assert false report "Simulation complete" severity note;
        wait;
    end process;

end architecture;

