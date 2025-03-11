-------------------------------------------------------------------------------
-- Title         : ADC 8 Channel module
-------------------------------------------------------------------------------
-- File          : ADC_8CH_module.vhd
-- Author        : Thomas Chiesa tchiesa@bnl.gov
-- Created       : 07/19/2020
-------------------------------------------------------------------------------
-- Description:
-- This is the controller for the three 8 Channel ADS8568 ADCs. Gains
-- and offsets are applied
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modification history:
-- 07/19/2020: created.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.psc_pkg.all;


entity ADC_8CH_module is
	port(
	     --Clocks and Resets
		 clk          : in std_logic;
		 reset        : in std_logic;
		 start        : in std_logic;
		 --Data Registers
		 ADC_8CH_in   : in t_ADC_8CHANNEL;
		 ADC_8CH_out  : out t_ADC_8CHANNEL;
		 --SPI Signals
		 ADC8C_SDO     : in std_logic_vector(2 downto 0);
		 --ADC8C_MISO1   : in std_logic;
		 --ADC8C_MISO2   : in std_logic;
		 --ADC8C_MISO3   : in std_logic;
		 ADC8C_CONV123 : out std_logic;
		 ADC8C_FS123   : out std_logic;
		 ADC8C_SCK123  : out std_logic;
		 done         : out std_logic
	);
end entity;


architecture arch of ADC_8CH_module is
signal ADC_8CH_ADC1     : std_logic_vector(127 downto 0);
signal ADC_8CH_ADC2     : std_logic_vector(127 downto 0);
signal ADC_8CH_ADC3     : std_logic_vector(127 downto 0);
signal convert_done     : std_logic;
signal done_pipe        : std_logic;

begin

	--###############################################################################################################
	--                                           Channel 1 ADC Interface
	--###############################################################################################################

		ADC1_8CH_inst: entity work.ADC_ADS8568_intf
		generic map(DATA_BITS   => 128,
				SPI_CLK_DIV => 5)
		port map(
				--Control inputs
				clk       => clk,
				reset     => reset,
				start     => start,
				--ADC Inputs
				busy      => '0',
				sdi       => ADC8C_SDO(0), --ADC8C_MISO1,
				--ADC Outputs
				cnv       => ADC8C_CONV123,
				n_fs      => ADC8C_FS123,
				sclk      => ADC8C_SCK123,
				sdo       => open,
				data_out  => ADC_8CH_ADC1,
				data_rdy  => convert_done
			);

process(clk)
begin
    if rising_edge(clk) then
        if convert_done = '1' then
            ADC_8CH_out.ADC1.CH1.data <= ADC_8CH_ADC1(127 downto 112);
            ADC_8CH_out.ADC1.CH2.data <= ADC_8CH_ADC1(111 downto 96);
            ADC_8CH_out.ADC1.CH3.data <= ADC_8CH_ADC1(95 downto 80);
            ADC_8CH_out.ADC1.CH4.data <= ADC_8CH_ADC1(79 downto 64);
            ADC_8CH_out.ADC1.CH5.data <= ADC_8CH_ADC1(63 downto 48);
            ADC_8CH_out.ADC1.CH6.data <= ADC_8CH_ADC1(47 downto 32);
            ADC_8CH_out.ADC1.CH7.data <= ADC_8CH_ADC1(31 downto 16);
            ADC_8CH_out.ADC1.CH8.data <= ADC_8CH_ADC1(15 downto 0);
        end if;
    end if;
end process;



	--###############################################################################################################
	--                                           Channel 2 ADC Interface
	--###############################################################################################################
		ADC2_8CH_inst: entity work.ADC_ADS8568_intf
		generic map(DATA_BITS   => 128,
				SPI_CLK_DIV => 5)
		port map(
				--Control inputs
				clk       => clk,
				reset     => reset,
				start     => start,
				--ADC Inputs
				busy      => '0',
				sdi       => ADC8C_SDO(1), --ADC8C_MISO2,
				--ADC Outputs
				cnv       => open,
				n_fs      => open,
				sclk      => open,
				sdo       => open,
				data_out  => ADC_8CH_ADC2,
				data_rdy  => open
			);

process(clk)
begin
    if rising_edge(clk) then
        if convert_done = '1' then
            ADC_8CH_out.ADC2.CH1.data <= ADC_8CH_ADC2(127 downto 112);
            ADC_8CH_out.ADC2.CH2.data <= ADC_8CH_ADC2(111 downto 96);
            ADC_8CH_out.ADC2.CH3.data <= ADC_8CH_ADC2(95 downto 80);
            ADC_8CH_out.ADC2.CH4.data <= ADC_8CH_ADC2(79 downto 64);
            ADC_8CH_out.ADC2.CH5.data <= ADC_8CH_ADC2(63 downto 48);
            ADC_8CH_out.ADC2.CH6.data <= ADC_8CH_ADC2(47 downto 32);
            ADC_8CH_out.ADC2.CH7.data <= ADC_8CH_ADC2(31 downto 16);
            ADC_8CH_out.ADC2.CH8.data <= ADC_8CH_ADC2(15 downto 0);
        end if;
    end if;
end process;


	--###############################################################################################################
	--                                           Channel 3 ADC Interface
	--###############################################################################################################
		ADC3_8CH_inst: entity work.ADC_ADS8568_intf
		generic map(DATA_BITS   => 128,
				SPI_CLK_DIV => 5)
		port map(
				--Control inputs
				clk       => clk,
				reset     => reset,
				start     => start,
				--ADC Inputs
				busy      => '0',
				sdi       => ADC8C_SDO(2), --ADC8C_MISO3,
				--ADC Outputs
				cnv       => open,
				n_fs      => open,
				sclk      => open,
				sdo       => open,
				data_out  => ADC_8CH_ADC3,
				data_rdy  => open
			);

process(clk)
begin
    if rising_edge(clk) then
        if convert_done = '1' then
            ADC_8CH_out.ADC3.CH1.data <= ADC_8CH_ADC3(127 downto 112);
            ADC_8CH_out.ADC3.CH2.data <= ADC_8CH_ADC3(111 downto 96);
            ADC_8CH_out.ADC3.CH3.data <= ADC_8CH_ADC3(95 downto 80);
            ADC_8CH_out.ADC3.CH4.data <= ADC_8CH_ADC3(79 downto 64);
            ADC_8CH_out.ADC3.CH5.data <= ADC_8CH_ADC3(63 downto 48);
            ADC_8CH_out.ADC3.CH6.data <= ADC_8CH_ADC3(47 downto 32);
            ADC_8CH_out.ADC3.CH7.data <= ADC_8CH_ADC3(31 downto 16);
            ADC_8CH_out.ADC3.CH8.data <= ADC_8CH_ADC3(15 downto 0);
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        done_pipe <= convert_done;
        done <= done_pipe;
    end if;
end process;

end architecture;
