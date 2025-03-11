library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library xil_defaultlib;
use xil_defaultlib.psc_pkg.ALL;
--use work.psc_pkg.all;

entity DCCT_ADC_module is
	port(
        --Control inputs
        clk       : in std_logic;
        reset     : in std_logic;
        start     : in std_logic;
		--Gain and Offset registers
		DCCT_in       : in t_DCCT;
		DCCT_out      : out t_DCCT;
        --ADC Inputs
        sdi       : in std_logic_vector(3 downto 0);
		--sdi_1     : in std_logic;
        --sdi_2     : in std_logic;
		--sdi_3     : in std_logic;
		--sdi_4     : in std_logic;
        --ADC Outputs
        cnv       : out std_logic;
        sclk      : out std_logic;
        sdo       : out std_logic;
		done      : out std_logic
		);
end entity;

architecture arch of DCCT_ADC_module is

	component gain_offset is
		generic(N : integer := 18);
		port(
			clk 			: in std_logic;
			reset       	: in std_logic;
			start           : in std_logic;
			data_in     	: in std_logic_vector(N-1 downto 0);
			gain        	: in std_logic_vector(31 downto 0);
			offset      	: in std_logic_vector(31 downto 0);
			result      	: out std_logic_vector(N-1 downto 0);
			done            : out std_logic
			);
	end component;

signal DCCT1 	: t_DCCT;
signal DCCT2 	: t_DCCT;
signal DCCT3 	: t_DCCT;
signal DCCT4 	: t_DCCT;
signal DCCT5 	: t_DCCT;
signal DCCT6 	: t_DCCT;
signal DCCT7 	: t_DCCT;
signal DCCT8 	: t_DCCT;

signal DCCT_ADC_data12 : std_logic_vector(39 downto 0);
signal DCCT_ADC_data34 : std_logic_vector(39 downto 0);
signal DCCT_ADC_data56 : std_logic_vector(39 downto 0);
signal DCCT_ADC_data78 : std_logic_vector(39 downto 0);
signal result1, result2, result3, result4 : std_logic_vector(19 downto 0);
signal result5, result6, result7, result8 : std_logic_vector(19 downto 0);
signal convert_done : std_logic;
signal all_done : std_logic;

begin

	DCCT_ADC_inst1: entity work.ADC_LTC2376_intf
	generic map(DATA_BITS => 40,
				SPI_CLK_DIV   => 5)  --Dividing the 100 MHz clock to 10MHz 100MHz/(2*5) = 10MHz
	port map(
			--Control inputs
			clk       => clk,
			reset     => reset,
			start     => start,
			--ADC Inputs
			busy      => '0', --busy not used
			sdi       => sdi(0), --sdi_1,
			--ADC Outputs
			cnv       => cnv,
			sclk      => sclk,
			sdo       => open,
			data_out  => DCCT_ADC_data12,
			data_rdy  => convert_done
			);

	gain_offset_inst1: gain_offset
	generic map(N => 20)
	port map(
		clk 			=> clk,
		reset       	=> reset,
		start           => convert_done,
		data_in     	=> DCCT_ADC_data12(19 downto 0),
		gain        	=> DCCT_in.ADC1.gain,
		offset      	=> DCCT_in.ADC1.offset,
		result      	=> result1,
		done            => all_done
		);

	gain_offset_inst2: gain_offset
	generic map(N => 20)
	port map(
		clk 			=> clk,
		reset       	=> reset,
		start           => convert_done,
		data_in     	=> DCCT_ADC_data12(39 downto 20),
		gain        	=> DCCT_in.ADC2.gain,
		offset      	=> DCCT_in.ADC2.offset,
		result      	=> result2,
		done            => open
		);


	DCCT_ADC_inst2: entity work.ADC_LTC2376_intf
	generic map(DATA_BITS => 40,
				SPI_CLK_DIV   => 5)
	port map(
			--Control inputs
			clk       => clk,
			reset     => reset,
			start     => start,
			--ADC Inputs
			busy      => '0', --busy not used
			sdi       => sdi(1), --sdi_2,
			--ADC Outputs
			cnv       => open,
			sclk      => open,
			sdo       => open,
			data_out  => DCCT_ADC_data34,
			data_rdy  => open
			);

	gain_offset_inst3: gain_offset
	generic map(N => 20)
	port map(
		clk 			=> clk,
		reset       	=> reset,
		start           => convert_done,
		data_in     	=> DCCT_ADC_data34(19 downto 0),
		gain        	=> DCCT_in.ADC3.gain,
		offset      	=> DCCT_in.ADC3.offset,
		result      	=> result3,
		done            => open
		);

	gain_offset_inst4: gain_offset
	generic map(N => 20)
	port map(
		clk 			=> clk,
		reset       	=> reset,
		start           => convert_done,
		data_in     	=> DCCT_ADC_data34(39 downto 20),
		gain        	=> DCCT_in.ADC4.gain,
		offset      	=> DCCT_in.ADC4.offset,
		result      	=> result4,
		done            => open
		);

	DCCT_ADC_inst3: entity work.ADC_LTC2376_intf
	generic map(DATA_BITS => 40,
				SPI_CLK_DIV   => 5)
	port map(
			--Control inputs
			clk       => clk,
			reset     => reset,
			start     => start,
			--ADC Inputs
			busy      => '0', --busy not used
			sdi       => sdi(2), --sdi_3,
			--ADC Outputs
			cnv       => open,
			sclk      => open,
			sdo       => open,
			data_out  => DCCT_ADC_data56,
			data_rdy  => open
			);

	gain_offset_inst5: gain_offset
	generic map(N => 20)
	port map(
		clk 			=> clk,
		reset       	=> reset,
		start           => convert_done,
		data_in     	=> DCCT_ADC_data56(19 downto 0),
		gain        	=> DCCT_in.ADC5.gain,
		offset      	=> DCCT_in.ADC5.offset,
		result      	=> result5,
		done            => open
		);

	gain_offset_inst6: gain_offset
	generic map(N => 20)
	port map(
		clk 			=> clk,
		reset       	=> reset,
		start           => convert_done,
		data_in     	=> DCCT_ADC_data56(39 downto 20),
		gain        	=> DCCT_in.ADC6.gain,
		offset      	=> DCCT_in.ADC6.offset,
		result      	=> result6,
		done            => open
		);



	DCCT_ADC_inst4: entity work.ADC_LTC2376_intf
	generic map(DATA_BITS => 40,
				SPI_CLK_DIV   => 5)
	port map(
			--Control inputs
			clk       => clk,
			reset     => reset,
			start     => start,
			--ADC Inputs
			busy      => '0', --busy not used
			sdi       => sdi(3), --sdi_4,
			--ADC Outputs
			cnv       => open,
			sclk      => open,
			sdo       => open,
			data_out  => DCCT_ADC_data78,
			data_rdy  => open
			);

	gain_offset_inst7: gain_offset
	generic map(N => 20)
	port map(
		clk 			=> clk,
		reset       	=> reset,
		start           => convert_done,
		data_in     	=> DCCT_ADC_data78(19 downto 0),
		gain        	=> DCCT_in.ADC7.gain,
		offset      	=> DCCT_in.ADC7.offset,
		result      	=> result7,
		done            => open
		);

	gain_offset_inst8: gain_offset
	generic map(N => 20)
	port map(
		clk 			=> clk,
		reset       	=> reset,
		start           => convert_done,
		data_in     	=> DCCT_ADC_data78(39 downto 20),
		gain        	=> DCCT_in.ADC8.gain,
		offset      	=> DCCT_in.ADC8.offset,
		result      	=> result8,
		done            => open
		);

	process(clk)
	begin
	   if rising_edge(clk) then
		   if reset = '1' then
				   DCCT_out.ADC1.adc_data <= (others => '0');
				   DCCT_out.ADC2.adc_data <= (others => '0');
				   DCCT_out.ADC3.adc_data <= (others => '0');
				   DCCT_out.ADC4.adc_data <= (others => '0');
				   DCCT_out.ADC5.adc_data <= (others => '0');
				   DCCT_out.ADC6.adc_data <= (others => '0');
				   DCCT_out.ADC7.adc_data <= (others => '0');
				   DCCT_out.ADC8.adc_data <= (others => '0');
			else
				   if all_done = '1' then
				   --if convert_done = '1' then
					   DCCT_out.ADC1.adc_data <= result1(19 downto 0);
					   DCCT_out.ADC2.adc_data <= result2(19 downto 0);
					   DCCT_out.ADC3.adc_data <= result3(19 downto 0);
					   DCCT_out.ADC4.adc_data <= result4(19 downto 0);
					   DCCT_out.ADC5.adc_data <= result5(19 downto 0);
					   DCCT_out.ADC6.adc_data <= result6(19 downto 0);
					   DCCT_out.ADC7.adc_data <= result7(19 downto 0);
					   DCCT_out.ADC8.adc_data <= result8(19 downto 0);
					   done <= '1';
				   else
					   done <= '0';
				   end if;
		   end if;
		end if;
	end process;
end architecture;
