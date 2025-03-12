library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 

entity DCCT_ADC_module is 
	port(
        --Control inputs
        clk       : in std_logic; 
        reset     : in std_logic; 
        start     : in std_logic; 
        -- output data
		DCCT_out      : out t_dcct_adcs; 
        --ADC Inputs
        sdi       : in std_logic_vector(3 downto 0);

        --ADC Outputs
        cnv       : out std_logic; 
        sclk      : out std_logic; 
        sdo       : out std_logic;
		done      : out std_logic 
		); 
end entity; 
		
architecture arch of DCCT_ADC_module is 

--signal DCCT1 	: t_DCCT; 
--signal DCCT2 	: t_DCCT; 
--signal DCCT3 	: t_DCCT; 
--signal DCCT4 	: t_DCCT; 
--signal DCCT5 	: t_DCCT; 
--signal DCCT6 	: t_DCCT; 
--signal DCCT7 	: t_DCCT; 
--signal DCCT8 	: t_DCCT;

signal DCCT_ADC_data12 : std_logic_vector(35 downto 0); 
signal DCCT_ADC_data34 : std_logic_vector(35 downto 0); 
signal DCCT_ADC_data56 : std_logic_vector(35 downto 0); 
signal DCCT_ADC_data78 : std_logic_vector(35 downto 0); 
signal result1, result2, result3, result4 : std_logic_vector(17 downto 0); 
signal result5, result6, result7, result8 : std_logic_vector(17 downto 0); 
signal convert_done : std_logic; 
signal all_done : std_logic; 
signal done_pipe : std_logic; 

begin 

	DCCT_ADC_inst1: entity work.ADC_LTC2376_intf 
	generic map(DATA_BITS => 36,
				SPI_CLK_DIV   => 5)  
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
			data_rdy  => all_done
			);
			


			
	DCCT_ADC_inst2: entity work.ADC_LTC2376_intf 
	generic map(DATA_BITS => 36,
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
			


			
	DCCT_ADC_inst3: entity work.ADC_LTC2376_intf 
	generic map(DATA_BITS => 36,
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
			


			
	DCCT_ADC_inst4: entity work.ADC_LTC2376_intf 
	generic map(DATA_BITS => 36,
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
			


	process(clk) 
	begin 
	   if rising_edge(clk) then 
		   if reset = '1' then 
		           done_pipe <= '0'; 
		           done <= '0'; 
		           dcct_out.ps1.dcct0 <= (others => '0');
				   dcct_out.ps1.dcct1 <= (others => '0');
				   dcct_out.ps2.dcct0 <= (others => '0');
				   dcct_out.ps2.dcct1 <= (others => '0');				       
				   dcct_out.ps3.dcct0 <= (others => '0');
				   dcct_out.ps3.dcct1 <= (others => '0');
				   dcct_out.ps4.dcct0 <= (others => '0');
				   dcct_out.ps4.dcct1 <= (others => '0');			   
			else 
				   if all_done = '1' then 
				   
					   dcct_out.ps1.dcct0 <= DCCT_ADC_data12(17 downto 0); 
					   dcct_out.ps1.dcct1 <= DCCT_ADC_data12(35 downto 18);
					   dcct_out.ps2.dcct0 <= DCCT_ADC_data34(17 downto 0); 
					   dcct_out.ps2.dcct1 <= DCCT_ADC_data34(35 downto 18);
					   dcct_out.ps3.dcct0 <= DCCT_ADC_data56(17 downto 0); 
					   dcct_out.ps3.dcct1 <= DCCT_ADC_data56(35 downto 18);
					   dcct_out.ps4.dcct0 <= DCCT_ADC_data78(17 downto 0); 
					   dcct_out.ps4.dcct1 <= DCCT_ADC_data78(35 downto 18);
					   done_pipe <= '1'; 
				   else 
					   done_pipe <= '0'; 
				   end if; 
				   done <= done_pipe; 
		   end if; 
		end if; 
	end process; 
end architecture; 