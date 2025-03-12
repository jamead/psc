library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity ADC_accumulator is 
generic(N_DCCT : integer := 18; 
		N_8CH  : integer := 16); 
port( 
        clk               :  in std_logic; 
        reset             :  in std_logic; 
        start             :  in std_logic; --adc data ready in
		
		--Mode inputs     
		mode              :  in std_logic_vector(1 downto 0); 
		
		--DCCT raw inputs
        DCCT1_in          :  in std_logic_vector(N_DCCT-1 downto 0); 
        DCCT2_in          :  in std_logic_vector(N_DCCT-1 downto 0); 

		--8 Channel raw ADC inputs
		DAC_SP_in         :  in std_logic_vector(N_8CH-1 downto 0); 
		VOLT_MON_in       :  in std_logic_vector(N_8CH-1 downto 0); 
		GND_MON_in        :  in std_logic_vector(N_8CH-1 downto 0); 
		SPARE_MON_in      :  in std_logic_vector(N_8CH-1 downto 0); 
		PS_REG_OUTPUT_in  :  in std_logic_vector(N_8CH-1 downto 0); 
		PS_ERROR_in       :  in std_logic_vector(N_8CH-1 downto 0); 
		
		--Outputs
        DCCT1_out         :  out std_logic_vector(31 downto 0); 
        DCCT2_out         :  out std_logic_vector(31 downto 0); 
        DAC_SP_out        :  out std_logic_vector(31 downto 0); 
        VOLT_MON_out      :  out std_logic_vector(31 downto 0); 
        GND_MON_out       :  out std_logic_vector(31 downto 0); 
        SPARE_MON_out     :  out std_logic_vector(31 downto 0); 
        PS_REG_OUTPUT_out :  out std_logic_vector(31 downto 0); 
        PS_ERROR_out      :  out std_logic_vector(31 downto 0); 

        done              :  out std_logic

    ); 
end entity; 


architecture arch of ADC_accumulator is 
begin 

--###################################################
--DCCT ACCUMULATORS
--###################################################
average_inst1 : entity work.average
    generic map( N => N_DCCT)
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
    generic map( N => N_DCCT)
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
    generic map( N => N_8CH)
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => DAC_SP_in, 
    done            => open,  
    sel             => mode,
    avg_out         => DAC_SP_out 
    ); 
    
average_inst4 : entity work.average
    generic map( N => N_8CH)
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => VOLT_MON_in, 
    done            => open,  
    sel             => mode, 
    avg_out         => VOLT_MON_out 
    ); 
    
average_inst5 : entity work.average
    generic map( N => N_8CH)
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => GND_MON_in, 
    done            => open,  
    sel             => mode, 
    avg_out         => GND_MON_out 
    ); 
    
average_inst6 : entity work.average
    generic map( N => N_8CH)
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => SPARE_MON_in, 
    done            => open,  
    sel             => mode, 
    avg_out         => SPARE_MON_out 
    ); 
    
average_inst7 : entity work.average
    generic map( N => N_8CH)
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => PS_REG_OUTPUT_in, 
    done            => open, 
    sel             => mode,  
    avg_out         => PS_REG_OUTPUT_out 
    ); 
    
average_inst8 : entity work.average
    generic map( N => N_8CH)
    port map(
    clk             => clk, 
    reset           => reset, 
    start           => start, 
    data_in         => PS_ERROR_in, 
    done            => open, 
    sel             => mode,
    avg_out         => PS_ERROR_out 
    ); 
	
	
end architecture; 
