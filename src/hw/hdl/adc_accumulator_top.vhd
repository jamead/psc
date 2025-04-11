library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


library work;
use work.psc_pkg.ALL;


entity ADC_accumulator_top is 
generic(N_DCCT : integer := 18; 
		N_8CH  : integer := 16); 
port( 
        clk               		:  in std_logic; 
        reset             		:  in std_logic; 
        start             		:  in std_logic; --adc data ready in 
		mode                    : in std_logic_vector(7 downto 0); 
		dcct_adcs               : in t_dcct_adcs;
		mon_adcs                : in t_mon_adcs; 
		dcct_adcs_ave           : out t_dcct_adcs_ave;
		mon_adcs_ave            : out t_mon_adcs_ave;
		done                    : out std_logic_vector(3 downto 0)		
    ); 
end entity; 

architecture arch of ADC_accumulator_top is 
begin 


ADC_accumulator_inst1: entity work.ADC_accumulator
generic map(N_DCCT => N_DCCT, 
			N_8CH  => N_8CH)
port map( 
        clk               => clk,  
        reset             => reset,  
        start             => start, 
		
		--Mode inputs     
		mode              => mode(1 downto 0), --CH1_mode,  
		
		--DCCT raw inputs
        DCCT1_in          => std_logic_vector(dcct_adcs.ps1.dcct0),  
        DCCT2_in          => std_logic_vector(dcct_adcs.ps1.dcct1),   

		--8 Channel raw ADC inputs
		DAC_SP_in         => std_logic_vector(mon_adcs.ps1.dac_sp),  
		VOLT_MON_in       => std_logic_vector(mon_adcs.ps1.voltage),  
		GND_MON_in        => std_logic_vector(mon_adcs.ps1.ignd),  
		SPARE_MON_in      => std_logic_vector(mon_adcs.ps1.spare), 
		PS_REG_OUTPUT_in  => std_logic_vector(mon_adcs.ps1.ps_reg), 
		PS_ERROR_in       => std_logic_vector(mon_adcs.ps1.ps_error), 
		
		--Outputs
        DCCT1_out         => dcct_adcs_ave.ps1.dcct0,     
        DCCT2_out         => dcct_adcs_ave.ps1.dcct1,        
        DAC_SP_out        => mon_adcs_ave.ps1.dac_sp,      
        VOLT_MON_out      => mon_adcs_ave.ps1.volt_mon,     
        GND_MON_out       => mon_adcs_ave.ps1.gnd_mon,     
        SPARE_MON_out     => mon_adcs_ave.ps1.spare_mon,     
        PS_REG_OUTPUT_out => mon_adcs_ave.ps1.ps_reg, 
        PS_ERROR_out      => mon_adcs_ave.ps1.ps_error,     
        done              => done(0) --CH1_done 

    ); 
	
ADC_accumulator_inst2: entity work.ADC_accumulator 
generic map(N_DCCT => N_DCCT, 
			N_8CH  => N_8CH)
port map( 
        clk               => clk,  
        reset             => reset,  
        start             => start, 
		
		--Mode inputs     
		mode              => mode(3 downto 2), --CH1_mode,  
		
		--DCCT raw inputs
        DCCT1_in          => std_logic_vector(dcct_adcs.ps2.dcct0),  
        DCCT2_in          => std_logic_vector(dcct_adcs.ps2.dcct1),   

		--8 Channel raw ADC inputs
		DAC_SP_in         => std_logic_vector(mon_adcs.ps2.dac_sp),  
		VOLT_MON_in       => std_logic_vector(mon_adcs.ps2.voltage),  
		GND_MON_in        => std_logic_vector(mon_adcs.ps2.ignd),  
		SPARE_MON_in      => std_logic_vector(mon_adcs.ps2.spare), 
		PS_REG_OUTPUT_in  => std_logic_vector(mon_adcs.ps2.ps_reg), 
		PS_ERROR_in       => std_logic_vector(mon_adcs.ps2.ps_error), 
		
		--Outputs
        DCCT1_out         => dcct_adcs_ave.ps2.dcct0,     
        DCCT2_out         => dcct_adcs_ave.ps2.dcct1,        
        DAC_SP_out        => mon_adcs_ave.ps2.dac_sp,      
        VOLT_MON_out      => mon_adcs_ave.ps2.volt_mon,     
        GND_MON_out       => mon_adcs_ave.ps2.gnd_mon,     
        SPARE_MON_out     => mon_adcs_ave.ps2.spare_mon,     
        PS_REG_OUTPUT_out => mon_adcs_ave.ps2.ps_reg, 
        PS_ERROR_out      => mon_adcs_ave.ps2.ps_error,     
        done              => done(1) --CH1_done 
		
    ); 
	
ADC_accumulator_inst3: entity work.ADC_accumulator 
generic map(N_DCCT => N_DCCT, 
			N_8CH  => N_8CH)
port map( 
        clk               => clk,  
        reset             => reset,  
        start             => start, 

		--Mode inputs     
		mode              => mode(5 downto 4), --CH1_mode,  
		
		--DCCT raw inputs
        DCCT1_in          => std_logic_vector(dcct_adcs.ps3.dcct0),  
        DCCT2_in          => std_logic_vector(dcct_adcs.ps3.dcct1),   

		--8 Channel raw ADC inputs
		DAC_SP_in         => std_logic_vector(mon_adcs.ps3.dac_sp),  
		VOLT_MON_in       => std_logic_vector(mon_adcs.ps3.voltage),  
		GND_MON_in        => std_logic_vector(mon_adcs.ps3.ignd),  
		SPARE_MON_in      => std_logic_vector(mon_adcs.ps3.spare), 
		PS_REG_OUTPUT_in  => std_logic_vector(mon_adcs.ps3.ps_reg), 
		PS_ERROR_in       => std_logic_vector(mon_adcs.ps3.ps_error), 
		
		--Outputs
        DCCT1_out         => dcct_adcs_ave.ps2.dcct0,     
        DCCT2_out         => dcct_adcs_ave.ps2.dcct1,        
        DAC_SP_out        => mon_adcs_ave.ps2.dac_sp,      
        VOLT_MON_out      => mon_adcs_ave.ps2.volt_mon,     
        GND_MON_out       => mon_adcs_ave.ps2.gnd_mon,     
        SPARE_MON_out     => mon_adcs_ave.ps2.spare_mon,     
        PS_REG_OUTPUT_out => mon_adcs_ave.ps2.ps_reg, 
        PS_ERROR_out      => mon_adcs_ave.ps2.ps_error,     
        done              => done(2) --CH1_done 

    ); 


ADC_accumulator_inst4: entity work.ADC_accumulator
generic map(N_DCCT => N_DCCT,
			N_8CH  => N_8CH)
port map( 
        clk               => clk,  
        reset             => reset,  
        start             => start, 
		
		--Mode inputs     
		mode              => mode(7 downto 6), --CH1_mode,  
		
		--DCCT raw inputs
        DCCT1_in          => std_logic_vector(dcct_adcs.ps4.dcct0),  
        DCCT2_in          => std_logic_vector(dcct_adcs.ps4.dcct1),   

		--8 Channel raw ADC inputs
		DAC_SP_in         => std_logic_vector(mon_adcs.ps4.dac_sp),  
		VOLT_MON_in       => std_logic_vector(mon_adcs.ps4.voltage),  
		GND_MON_in        => std_logic_vector(mon_adcs.ps4.ignd),  
		SPARE_MON_in      => std_logic_vector(mon_adcs.ps4.spare), 
		PS_REG_OUTPUT_in  => std_logic_vector(mon_adcs.ps4.ps_reg), 
		PS_ERROR_in       => std_logic_vector(mon_adcs.ps4.ps_error), 
		
		--Outputs
        DCCT1_out         => dcct_adcs_ave.ps4.dcct0,     
        DCCT2_out         => dcct_adcs_ave.ps4.dcct1,        
        DAC_SP_out        => mon_adcs_ave.ps4.dac_sp,      
        VOLT_MON_out      => mon_adcs_ave.ps4.volt_mon,     
        GND_MON_out       => mon_adcs_ave.ps4.gnd_mon,     
        SPARE_MON_out     => mon_adcs_ave.ps4.spare_mon,     
        PS_REG_OUTPUT_out => mon_adcs_ave.ps4.ps_reg, 
        PS_ERROR_out      => mon_adcs_ave.ps4.ps_error,     
        done              => done(3) --CH1_done 
		

    ); 

end architecture; 