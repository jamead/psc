-------------------------------------------------------------------------------
-- Title         : DAC Controller
-------------------------------------------------------------------------------
-- File          : DAC_ctrlr.vhd
-- Author        : Thomas Chiesa tchiesa@bnl.gov
-- Created       : 07/19/2020
-------------------------------------------------------------------------------
-- Description:
-- This program is the DAC controller for the PSC.  It controls all
-- four DACs on the PSC. 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modification history:
-- 07/19/2020: created.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.psc_pkg.all;
--use work.reg_map_pkg.all; 


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DAC_ctrlr is
port(
			--Clks and Resets
			clk                  : in std_logic; 
			reset                : in std_logic; 
			--Inputs
			dac1_in              : in t_dac;
			dac2_in              : in t_dac;
			dac3_in              : in t_dac; 
			dac4_in              : in t_dac; 	
			dac1234_jump         : in std_logic; 		
		    --Outputs
            dac1_done            : out std_logic; 
            dac2_done            : out std_logic; 
            dac3_done            : out std_logic; 
            dac4_done            : out std_logic; 
		    --SPI Outputs
			n_sync1234		     : out std_logic; 
			sclk1234   		     : out std_logic; 
			sdo                  : out std_logic_vector(3 downto 0)	
			--sdo1       		     : out std_logic;
			--sdo2                 : out std_logic;
			--sdo3                 : out std_logic;
			--sdo4                 : out std_logic
    );
end entity;

architecture arch of DAC_ctrlr is

component clk_divider is
generic(CLOCK_DIVIDE : integer := 10); 
port ( 
        clk : in std_logic;
        reset : in std_logic;
        clk_out : out std_logic;
        pulse_out : out std_logic
        );
end component;
signal convert_done1, convert_done2, convert_done3, convert_done4 : std_logic; 
signal result1, result2, result3, result4 : std_logic_vector(17 downto 0); 
signal or_load1, or_load2, or_load3, or_load4 : std_logic; 
begin

process(clk) 
begin 
    if rising_edge(clk) then 
        or_load1 <= dac1_in.load or dac1234_jump; 
        or_load2 <= dac2_in.load or dac1234_jump; 
        or_load3 <= dac3_in.load or dac1234_jump; 
        or_load4 <= dac4_in.load or dac1234_jump; 
    end if; 
end process; 



--	gain_offset_inst1: gain_offset 
--	generic map(N => 18)
--	port map(
--		clk 			=> clk,  
--		reset       	=> reset,
--		start           => dac1_in.load, 
--		data_in     	=> dac1_in.setpoint, 
--		gain        	=> dac1_in.gain,
--		offset      	=> dac1_in.offset,
--		result      	=> result1, 
--		done            => convert_done1
--		); 

	setpoint_DAC1_inst:  entity work.DAC_AD5781_intf 
	generic map(SPI_CLK_DIV => 5) --10MHz sclk
	port map(
			  --Control inputs
			  clk       		    => clk,
			  reset     		    => dac1_in.reset,
			  start                 => or_load1, --dac1_in.load,  --convert_done1
			  --DAC Inputs         
			  dac_data              => dac1_in.setpoint,
			  dac_ctrl_bits         => dac1_in.ctrl_reg,
			  --DAC Outputs        
			  n_sync    		    => n_sync1234,
			  sclk      		    => sclk1234,
			  sdo       		    => sdo(0), --sdo1,
			  done                  => dac1_done
		);
		
--	gain_offset_inst2: gain_offset 
--	generic map(N => 18)
--	port map(
--		clk 			=> clk,  
--		reset       	=> reset,
--		start           => dac2_in.load, 
--		data_in     	=> dac2_in.setpoint, 
--		gain        	=> dac2_in.gain,
--		offset      	=> dac2_in.offset,
--		result      	=> result2, 
--		done            => convert_done2
--		); 
		
	setpoint_DAC2_inst:  entity work.DAC_AD5781_intf 
	generic map(SPI_CLK_DIV => 5) --10MHz sclk
	port map(
			  --Control inputs
			  clk       		    => clk,
			  reset     		    => dac2_in.reset,
			  start                 => or_load2, --dac2_in.load, --convert_done2,
			  --DAC Inputs         
			  dac_data              => dac2_in.setpoint,
			  dac_ctrl_bits         => dac2_in.ctrl_reg,
			  --DAC Outputs        
			  n_sync    		    => open,
			  sclk      		    => open,
			  sdo       		    => sdo(1), --sdo2,
			  done                  => dac2_done
		);
		
--	gain_offset_inst3: gain_offset 
--	generic map(N => 18)
--	port map(
--		clk 			=> clk,  
--		reset       	=> reset,
--		start           => dac3_in.load, 
--		data_in     	=> dac3_in.setpoint, 
--		gain        	=> dac3_in.gain,
--		offset      	=> dac3_in.offset,
--		result      	=> result3, 
--		done            => convert_done3
--		); 
		
	setpoint_DAC3_inst:  entity work.DAC_AD5781_intf 
	generic map(SPI_CLK_DIV => 5) --10MHz sclk
	port map(
			  --Control inputs
			  clk       		    => clk,
			  reset     		    => dac3_in.reset,
			  start                 => or_load3, --dac3_in.load, --convert_done3,
			  --DAC Inputs         
			  dac_data              => dac3_in.setpoint,
			  dac_ctrl_bits         => dac3_in.ctrl_reg,
			  --DAC Outputs        
			  n_sync    		    => open,
			  sclk      		    => open,
			  sdo       		    => sdo(2), --sdo3,
			  done                  => dac3_done
		);
		
--	gain_offset_inst4: gain_offset 
--	generic map(N => 18)
--	port map(
--		clk 			=> clk,  
--		reset       	=> reset,
--		start           => dac4_in.load, 
--		data_in     	=> dac4_in.setpoint, 
--		gain        	=> dac4_in.gain,
--		offset      	=> dac4_in.offset,
--		result      	=> result4, 
--		done            => convert_done4
--		); 
		
	setpoint_DAC4_inst:  entity work.DAC_AD5781_intf 
	generic map(SPI_CLK_DIV => 5) --10MHz sclk
	port map(
			  --Control inputs
			  clk       		    => clk,
			  reset     		    => dac4_in.reset,
			  start                 => or_load4, --dac4_in.load, --convert_done4,
			  --DAC Inputs         
			  dac_data              => dac4_in.setpoint,
			  dac_ctrl_bits         => dac4_in.ctrl_reg,
			  --DAC Outputs        
			  n_sync    		    => open,
			  sclk      		    => open,
			  sdo       		    => sdo(3), --sdo4,
			  done                  => dac4_done
		);

end architecture;
