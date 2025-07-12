library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

library work;
use work.psc_pkg.ALL;


entity tenkhz_gen is
  port(
    clk    	    	: in std_logic; 
    reset      		: in std_logic; 
		  				
    evr_trigs       : in t_evr_trigs;
    evr_params      : in t_evr_params;

    --Outputs
    flt_10kHz       : out std_logic; 		
    tenkhz_trig     : out std_logic        
    ); 

end entity; 
    
architecture arch of tenkhz_gen is 

	signal evr_onehz_trig    : std_logic;


	
begin 

--Fault Signal 
flt_10kHz <= '0';  



-- 1Hz event from EVR resync's our Storage Ring Orbit Clock (SROC) (10KHz)
sync_1Hz_trig: entity work.pulse_sync
  port map(
    clk => clk,
    pulse_in => evr_trigs.onehz_trig,
    pulse_out => evr_onehz_trig
);



 -- generate 10KHz triggers with nco, resync pulse is EVR 1Hz event
uut: entity work.nco_srocgen
  port map (
    clk => clk,
    reset  => reset,
    step_size => unsigned(evr_params.nco_stepsize),
    resync_pulse => evr_onehz_trig,
    pulse_out => tenkhz_trig
    );









end architecture; 
