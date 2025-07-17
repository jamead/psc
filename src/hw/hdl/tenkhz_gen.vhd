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

    flt_10kHz       : out std_logic; 
    tenkhz_freq     : out std_logic_vector(31 downto 0);		
    tenkhz_trig     : out std_logic        
    ); 

end entity; 
    
architecture arch of tenkhz_gen is 

	signal evr_onehz_trig    : std_logic;
	signal tenkhz_rate_cnt   : std_logic_vector(31 downto 0);
    signal tenkhz_trig_prev  : std_logic;

   --debug signals (connect to ila)
   attribute mark_debug                 : string;
   attribute mark_debug of tenkhz_rate_cnt : signal is "true";
   attribute mark_debug of tenkhz_trig : signal is "true";
   attribute mark_debug of tenkhz_trig_prev : signal is "true";
   attribute mark_debug of tenkhz_freq : signal is "true";   
	
	
	
begin 

--Fault Signal 
flt_10kHz <= '0';  



---- 1Hz event from EVR resync's our Storage Ring Orbit Clock (SROC) (10KHz)
--sync_1Hz_trig: entity work.pulse_sync
--  port map(
--    clk => clk,
--    pulse_in => evr_trigs.onehz_trig,
--    pulse_out => evr_onehz_trig
--);



 -- generate 10KHz triggers with nco, resync pulse is EVR 1Hz event
uut: entity work.nco_srocgen
  port map (
    clk => clk,
    reset  => reset,
    step_size => unsigned(evr_params.nco_stepsize),
    resync_pulse => evr_trigs.onehz_trig, --evr_onehz_trig,
    pulse_out => tenkhz_trig
    );



--measure 10KHz event frequency
process(clk)
  begin
    if rising_edge(clk) then
      tenkhz_rate_cnt <= std_logic_vector(unsigned(tenkhz_rate_cnt) + 1);
      tenkhz_trig_prev <= tenkhz_trig;
      if (tenkhz_trig_prev = '0' and tenkhz_trig = '1') then
           tenkhz_freq <= tenkhz_rate_cnt;
           tenkhz_rate_cnt <= 32d"0";
      end if;
    end if;
end process;   






end architecture; 
