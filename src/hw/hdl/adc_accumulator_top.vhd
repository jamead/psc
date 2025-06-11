library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


library work;
use work.psc_pkg.ALL;


entity ADC_accumulator_top is 
port( 
        clk               		:  in std_logic; 
        reset             		:  in std_logic; 
        start             		:  in std_logic; --adc data ready in 
        dcct_params             : in t_dcct_adcs_params;
        mon_params              : in t_mon_adcs_params;
		dcct_adcs               : in t_dcct_adcs;
		mon_adcs                : in t_mon_adcs; 
		dcct_adcs_ave           : out t_dcct_adcs_ave;
		mon_adcs_ave            : out t_mon_adcs_ave;
		done                    : out std_logic_vector(3 downto 0)		
    ); 
end entity; 

architecture arch of ADC_accumulator_top is 



   --debug signals (connect to ila)
   attribute mark_debug                 : string;
   --attribute mark_debug of mode : signal is "true";
   --attribute mark_debug of dcct_adcs : signal is "true";
   --attribute mark_debug of dcct_adcs_ave: signal is "true";




begin 


ave_ch1: entity work.ADC_accumulator
port map( 
        clk               => clk,  
        reset             => reset,  
        start             => start, 
		
		--Mode inputs     
		mode              => dcct_params.ps1.ave_mode, --mode(1 downto 0), --CH1_mode,  
		
		--DCCT raw inputs
        DCCT1_in          => dcct_adcs.ps1.dcct0,  
        DCCT2_in          => dcct_adcs.ps1.dcct1,   

		--8 Channel raw ADC inputs
		DAC_SP_in         => mon_adcs.ps1.dacmon,  
		VOLT_MON_in       => mon_adcs.ps1.voltage,  
		GND_MON_in        => mon_adcs.ps1.ignd,  
		SPARE_MON_in      => mon_adcs.ps1.spare, 
		PS_REG_OUTPUT_in  => mon_adcs.ps1.ps_reg, 
		PS_ERROR_in       => mon_adcs.ps1.ps_error, 
		
		--Outputs
        DCCT1_out         => dcct_adcs_ave.ps1.dcct0,     
        DCCT2_out         => dcct_adcs_ave.ps1.dcct1,        
        DAC_SP_out        => mon_adcs_ave.ps1.dacmon,      
        VOLT_MON_out      => mon_adcs_ave.ps1.voltage,     
        GND_MON_out       => mon_adcs_ave.ps1.ignd,     
        SPARE_MON_out     => mon_adcs_ave.ps1.spare,     
        PS_REG_OUTPUT_out => mon_adcs_ave.ps1.ps_reg, 
        PS_ERROR_out      => mon_adcs_ave.ps1.ps_error,     
        done              => done(0) --CH1_done 

    ); 
	
ave_ch2: entity work.ADC_accumulator 
port map( 
        clk               => clk,  
        reset             => reset,  
        start             => start, 
		
		--Mode inputs     
		mode              => dcct_params.ps2.ave_mode,  
		
		--DCCT raw inputs
        DCCT1_in          => dcct_adcs.ps2.dcct0,  
        DCCT2_in          => dcct_adcs.ps2.dcct1,   

		--8 Channel raw ADC inputs
		DAC_SP_in         => mon_adcs.ps2.dacmon,  
		VOLT_MON_in       => mon_adcs.ps2.voltage,  
		GND_MON_in        => mon_adcs.ps2.ignd,  
		SPARE_MON_in      => mon_adcs.ps2.spare, 
		PS_REG_OUTPUT_in  => mon_adcs.ps2.ps_reg, 
		PS_ERROR_in       => mon_adcs.ps2.ps_error, 
		
		--Outputs
        DCCT1_out         => dcct_adcs_ave.ps2.dcct0,     
        DCCT2_out         => dcct_adcs_ave.ps2.dcct1,        
        DAC_SP_out        => mon_adcs_ave.ps2.dacmon,      
        VOLT_MON_out      => mon_adcs_ave.ps2.voltage,     
        GND_MON_out       => mon_adcs_ave.ps2.ignd,     
        SPARE_MON_out     => mon_adcs_ave.ps2.spare,     
        PS_REG_OUTPUT_out => mon_adcs_ave.ps2.ps_reg, 
        PS_ERROR_out      => mon_adcs_ave.ps2.ps_error,     
        done              => done(1) --CH1_done 
		
    ); 
	
ave_ch3: entity work.ADC_accumulator 
port map( 
        clk               => clk,  
        reset             => reset,  
        start             => start, 

		--Mode inputs     
		mode              => dcct_params.ps3.ave_mode,  
		
		--DCCT raw inputs
        DCCT1_in          => dcct_adcs.ps3.dcct0,  
        DCCT2_in          => dcct_adcs.ps3.dcct1,   

		--8 Channel raw ADC inputs
		DAC_SP_in         => mon_adcs.ps3.dacmon,  
		VOLT_MON_in       => mon_adcs.ps3.voltage,  
		GND_MON_in        => mon_adcs.ps3.ignd,  
		SPARE_MON_in      => mon_adcs.ps3.spare, 
		PS_REG_OUTPUT_in  => mon_adcs.ps3.ps_reg, 
		PS_ERROR_in       => mon_adcs.ps3.ps_error, 
		
		--Outputs
        DCCT1_out         => dcct_adcs_ave.ps3.dcct0,     
        DCCT2_out         => dcct_adcs_ave.ps3.dcct1,        
        DAC_SP_out        => mon_adcs_ave.ps3.dacmon,      
        VOLT_MON_out      => mon_adcs_ave.ps3.voltage,     
        GND_MON_out       => mon_adcs_ave.ps3.ignd,     
        SPARE_MON_out     => mon_adcs_ave.ps3.spare,     
        PS_REG_OUTPUT_out => mon_adcs_ave.ps3.ps_reg, 
        PS_ERROR_out      => mon_adcs_ave.ps3.ps_error,     
        done              => done(2) --CH1_done 

    ); 


ave_ch4: entity work.ADC_accumulator
port map( 
        clk               => clk,  
        reset             => reset,  
        start             => start, 
		
		--Mode inputs     
		mode              => dcct_params.ps1.ave_mode,  
		
		--DCCT raw inputs
        DCCT1_in          => dcct_adcs.ps4.dcct0,  
        DCCT2_in          => dcct_adcs.ps4.dcct1,   

		--8 Channel raw ADC inputs
		DAC_SP_in         => mon_adcs.ps4.dacmon,  
		VOLT_MON_in       => mon_adcs.ps4.voltage,  
		GND_MON_in        => mon_adcs.ps4.ignd,  
		SPARE_MON_in      => mon_adcs.ps4.spare, 
		PS_REG_OUTPUT_in  => mon_adcs.ps4.ps_reg, 
		PS_ERROR_in       => mon_adcs.ps4.ps_error, 
		
		--Outputs
        DCCT1_out         => dcct_adcs_ave.ps4.dcct0,     
        DCCT2_out         => dcct_adcs_ave.ps4.dcct1,        
        DAC_SP_out        => mon_adcs_ave.ps4.dacmon,      
        VOLT_MON_out      => mon_adcs_ave.ps4.voltage,     
        GND_MON_out       => mon_adcs_ave.ps4.ignd,     
        SPARE_MON_out     => mon_adcs_ave.ps4.spare,     
        PS_REG_OUTPUT_out => mon_adcs_ave.ps4.ps_reg, 
        PS_ERROR_out      => mon_adcs_ave.ps4.ps_error,     
        done              => done(3) --CH1_done 
		

    ); 

end architecture; 