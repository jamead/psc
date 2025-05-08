library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity ADC_accumulator is 
port( 
        clk               :  in std_logic; 
        reset             :  in std_logic; 
        start             :  in std_logic; --adc data ready in
		
		--Mode inputs     
		mode              :  in std_logic_vector(1 downto 0); 
		
		--DCCT raw inputs
        DCCT1_in          :  in signed(19 downto 0); 
        DCCT2_in          :  in signed(19 downto 0); 

		--8 Channel raw ADC inputs
		DAC_SP_in         :  in signed(15 downto 0); 
		VOLT_MON_in       :  in signed(15 downto 0); 
		GND_MON_in        :  in signed(15 downto 0); 
		SPARE_MON_in      :  in signed(15 downto 0); 
		PS_REG_OUTPUT_in  :  in signed(15 downto 0); 
		PS_ERROR_in       :  in signed(15 downto 0); 
		
		--Outputs
        DCCT1_out         :  out signed(31 downto 0); 
        DCCT2_out         :  out signed(31 downto 0); 
        DAC_SP_out        :  out signed(31 downto 0); 
        VOLT_MON_out      :  out signed(31 downto 0); 
        GND_MON_out       :  out signed(31 downto 0); 
        SPARE_MON_out     :  out signed(31 downto 0); 
        PS_REG_OUTPUT_out :  out signed(31 downto 0); 
        PS_ERROR_out      :  out signed(31 downto 0);

        done              :  out std_logic

    ); 
end entity; 


architecture arch of ADC_accumulator is 
begin 

--###################################################
--DCCT ACCUMULATORS
--###################################################
average_inst1 : entity work.average
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => DCCT1_in, 
    done            => done,  
    sel             => mode, 
    avg_out         => DCCT1_out
    ); 
    
average_inst2 : entity work.average
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => DCCT2_in, 
    done            => open,  
    sel             => mode, 
    avg_out         => DCCT2_out 
    );  


--###################################################
--8 CHANNEL ADC ACCUMULATORS
--###################################################
average_inst3 : entity work.average
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => resize(DAC_SP_in,20), 
    done            => open,  
    sel             => mode,
    avg_out         => DAC_SP_out 
    ); 
    
average_inst4 : entity work.average
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => resize(VOLT_MON_in,20), 
    done            => open,  
    sel             => mode, 
    avg_out         => VOLT_MON_out 
    ); 
    
average_inst5 : entity work.average
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => resize(GND_MON_in,20), 
    done            => open,  
    sel             => mode, 
    avg_out         => GND_MON_out 
    ); 
    
average_inst6 : entity work.average
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => resize(SPARE_MON_in,20), 
    done            => open,  
    sel             => mode, 
    avg_out         => SPARE_MON_out 
    ); 
    
average_inst7 : entity work.average
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => resize(PS_REG_OUTPUT_in,20), 
    done            => open, 
    sel             => mode,  
    avg_out         => PS_REG_OUTPUT_out 
    ); 
    
average_inst8 : entity work.average
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => resize(PS_ERROR_in,20), 
    done            => open, 
    sel             => mode,
    avg_out         => PS_ERROR_out 
    ); 
	
	
end architecture; 
