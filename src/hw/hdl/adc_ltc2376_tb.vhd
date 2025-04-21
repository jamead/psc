library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_adc_ltc2376 is
end tb_adc_ltc2376;

architecture tb of tb_adc_ltc2376 is

  constant DATA_BITS   : natural := 36;
  constant SPI_CLK_DIV : natural := 5;

  signal clk        : std_logic := '0';
  signal reset      : std_logic := '0';
  signal start      : std_logic := '0';
  signal busy       : std_logic := '0';
  signal sdi        : std_logic := '0';
  signal cnv        : std_logic;
  signal sclk       : std_logic;
  signal sdo        : std_logic;
  signal data_out   : std_logic_vector(39 downto 0);
  signal data_rdy   : std_logic;
  signal resolution : std_logic;
  signal dcct1      : signed(19 downto 0);
  signal dcct2      : signed(19 downto 0);

begin

  -- Instantiate the DUT (Design Under Test)
  uut: entity work.adc_ltc2376
    generic map (
      DATA_BITS   => DATA_BITS,
      SPI_CLK_DIV => SPI_CLK_DIV
    )
    port map (
      clk      => clk,
      reset    => reset,
      resolution => '1', --resolution,
      start    => start,
      busy     => busy,
      sdi      => sdi,
      cnv      => cnv,
      sclk     => sclk,
      sdo      => sdo,
      dcct1    => dcct1,
      dcct2    => dcct2,
      --data_out => data_out,
      data_rdy => data_rdy
    );

  -- Clock generation
  clk_process: process
  begin
    while true loop
      clk <= '1';
      wait for 5 ns;  -- 100 MHz clock
      clk <= '0';
      wait for 5 ns;
    end loop;
  end process;

  -- Stimulus
  stim_proc: process
  begin
    -- Reset pulse
    reset <= '1';
    sdi <= '0';
    resolution <= '0';
    wait for 100 ns;
    reset <= '0';

    wait for 1000 ns;

    -- Simulate start of ADC read
    start <= '1';
    wait for 100 ns;
    start <= '0';

    -- Simulate ADC busy signal (asserted during conversion)
    wait for 40 ns;
    busy <= '1';
    wait for 100 ns;
    busy <= '0';
    wait for 2900 ns;    
    
 -- simulate 18 bit case

--    sdi <= '0';  --bit 17
--    wait for 100 ns;
--    sdi <= '1';  --bit 16
--    wait for 100 ns;
--    sdi <= '0';  --bit 15
--    wait for 100 ns;
--    sdi <= '0';  --bit 14
--    wait for 100 ns;   
--    sdi <= '0';  --bit 13
--    wait for 100 ns;
--    sdi <= '0';  --bit 12
--    wait for 100 ns;    
--    sdi <= '0';  --bit 11
--    wait for 100 ns;
--    sdi <= '0';  --bit 10
--    wait for 100 ns;
--    sdi <= '0';  --bit 9
--    wait for 100 ns;
--    sdi <= '0';  --bit 8
--    wait for 100 ns;   
--    sdi <= '0';  --bit 7
--    wait for 100 ns;
--    sdi <= '0';  --bit 6
--    wait for 100 ns; 
--    sdi <= '0';  --bit 5
--    wait for 100 ns;
--    sdi <= '0';  --bit 4
--    wait for 100 ns;
--    sdi <= '0';  --bit 3
--    wait for 100 ns;
--    sdi <= '1';  --bit 2
--    wait for 100 ns;   
--    sdi <= '1';  --bit 1
--    wait for 100 ns;
--    sdi <= '1';  --bit 0
--    wait for 100 ns;    
--    sdi <= '0';  --bit 17
--    wait for 100 ns;
--    sdi <= '1';  --bit 16
--    wait for 100 ns;
--    sdi <= '0';  --bit 15
--    wait for 100 ns;
--    sdi <= '0';  --bit 14
--    wait for 100 ns;   
--    sdi <= '0';  --bit 13
--    wait for 100 ns;
--    sdi <= '0';  --bit 12
--    wait for 100 ns;    
--    sdi <= '0';  --bit 11
--    wait for 100 ns;
--    sdi <= '0';  --bit 10
--    wait for 100 ns;
--    sdi <= '0';  --bit 9
--    wait for 100 ns;
--    sdi <= '0';  --bit 8
--    wait for 100 ns;   
--    sdi <= '0';  --bit 7
--    wait for 100 ns;
--    sdi <= '0';  --bit 6
--    wait for 100 ns; 
--    sdi <= '0';  --bit 5
--    wait for 100 ns;
--    sdi <= '0';  --bit 4
--    wait for 100 ns;
--    sdi <= '0';  --bit 3
--    wait for 100 ns;
--    sdi <= '1';  --bit 2
--    wait for 100 ns;   
--    sdi <= '1';  --bit 1
--    wait for 100 ns;
--    sdi <= '1';  --bit 0


-- simulate 20bit case
    sdi <= '1';  --bit 19
    wait for 100 ns;
    sdi <= '0';  --bit 18   
    wait for 100 ns;
    sdi <= '0';  --bit 17
    wait for 100 ns;
    sdi <= '0';  --bit 16
    wait for 100 ns;
    sdi <= '0';  --bit 15
    wait for 100 ns;
    sdi <= '0';  --bit 14
    wait for 100 ns;   
    sdi <= '0';  --bit 13
    wait for 100 ns;
    sdi <= '0';  --bit 12
    wait for 100 ns;    
    sdi <= '0';  --bit 11
    wait for 100 ns;
    sdi <= '0';  --bit 10
    wait for 100 ns;
    sdi <= '0';  --bit 9
    wait for 100 ns;
    sdi <= '0';  --bit 8
    wait for 100 ns;   
    sdi <= '0';  --bit 7
    wait for 100 ns;
    sdi <= '0';  --bit 6
    wait for 100 ns; 
    sdi <= '0';  --bit 5
    wait for 100 ns;
    sdi <= '0';  --bit 4
    wait for 100 ns;
    sdi <= '0';  --bit 3
    wait for 100 ns;
    sdi <= '1';  --bit 2
    wait for 100 ns;   
    sdi <= '1';  --bit 1
    wait for 100 ns;
    sdi <= '1';  --bit 0
    wait for 100 ns;  
    
    sdi <= '1';  --bit 19
    wait for 100 ns;
    sdi <= '1';  --bit 18
    wait for 100 ns;     
    sdi <= '0';  --bit 17
    wait for 100 ns;
    sdi <= '0';  --bit 16
    wait for 100 ns;
    sdi <= '0';  --bit 15
    wait for 100 ns;
    sdi <= '0';  --bit 14
    wait for 100 ns;   
    sdi <= '0';  --bit 13
    wait for 100 ns;
    sdi <= '0';  --bit 12
    wait for 100 ns;    
    sdi <= '0';  --bit 11
    wait for 100 ns;
    sdi <= '0';  --bit 10
    wait for 100 ns;
    sdi <= '0';  --bit 9
    wait for 100 ns;
    sdi <= '0';  --bit 8
    wait for 100 ns;   
    sdi <= '0';  --bit 7
    wait for 100 ns;
    sdi <= '0';  --bit 6
    wait for 100 ns; 
    sdi <= '0';  --bit 5
    wait for 100 ns;
    sdi <= '0';  --bit 4
    wait for 100 ns;
    sdi <= '0';  --bit 3
    wait for 100 ns;
    sdi <= '1';  --bit 2
    wait for 100 ns;   
    sdi <= '1';  --bit 1
    wait for 100 ns;
    sdi <= '1';  --bit 0




--    -- Provide dummy SDI data (you can change this for actual SPI simulation)
--    for i in 0 to DATA_BITS-1 loop
--      sdi <= std_logic'val(i mod 2);  -- Alternate 0 and 1
--      wait for 40 ns;  -- Simulate one SPI bit time
--    end loop;

--    wait for 500 ns;
--    report "Test completed. Final data_out = " & integer'image(to_integer(unsigned(data_out)));

    wait;
  end process;
  
  
  
  

end tb;
