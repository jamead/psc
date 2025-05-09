Library UNISIM;
use UNISIM.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity tenkhz_mux is
    port(
		  clk        		: in std_logic; 
		  reset      		: in std_logic; 
		  
		  disable_fldbck    : in std_logic;  					--Used to disable the pulse muxing, if disable = '1' then 
																--the system will not foldback to internal clock if external clock is lost
																
		  switch     		: in std_logic;  					--When switch = '1' then the EVR 10 kHz pulse is used, when '0' the FOFB 10 kHz pulse is used. 
							
		  evr_10khz  		: in std_logic;  					--EVR 10 kHz pulse input 
		  fofb_10khz 		: in std_logic;  					--FOFB 10 kHz pulse input
		  
		  timer      		: in std_logic_vector(15 downto 0); --Timer input for designating how many pulses can be lost before switching
		  
		  --Outputs
		  flt_10kHz    		: out std_logic; 					--fault signal produce when an external 10 kHz pulse is lost temporarily
		  O          		: out std_logic                     --pulse output from Mux
    ); 

end entity; 
    
architecture arch of tenkhz_mux is 
	type state is (IDLE, START_COUNTER); 
	signal present_state : state; 
	
	signal sel : std_logic; 
	signal clock_count : integer; 
	signal evr_pulse : std_logic; 
	signal dff0, dff1 : std_logic; 
	signal external_10kHz : std_logic; 
	signal cnt_int : std_logic_vector(15 downto 0);
	signal internal_10khz : std_logic;
	signal trig : std_logic;
	
begin 

    --Fault Signal 
	flt_10kHz <= sel; 
	
	--Rising Edge Detection of EVR trigger 
	process(clk) 
	begin 
		if rising_edge(clk) then 
			if reset = '1' then 
				dff0 <= '0'; 
				dff1 <= '0'; 
				evr_pulse <= '0'; 
			else 
				dff0 <= evr_10khz; 
				dff1 <= dff0; 
				evr_pulse <= dff1 and not dff0; 
			end if;         
		end if; 
	end process;  
	
	--Switch for using either evr or fofb rx pulse for 10 kHz 
	process(clk) 
	begin 
		if rising_edge(clk) then 
			if switch = '1' then 
				external_10kHz <= evr_pulse; 
			else 
				external_10khz <= fofb_10kHz; 
		    end if; 
		end if; 
	end process; 
	
	
	--Counter for detecting if designated pulse is present
	process(clk) 
	begin 
		if rising_edge(clk) then 
			if reset = '1' then 
				clock_count <= 0; 
				sel <= '0'; 
			else 
				if external_10kHz = '1' then	
					clock_count <= 0; 
					sel <= '0'; 
				elsif clock_count = to_integer(unsigned(timer)) then 
					sel <= '1'; 
				else 
					clock_count <= clock_count +1; 
				end if; 
			end if; 	
		end if; 
	end process; 
	

--generate internal 10KHz
process (clk)
  begin
    if rising_edge(clk) then 
      if reset = '1' then    
        cnt_int <= 16d"0";
        internal_10khz <= '0';
      else       
        if (cnt_int = 16d"10000") then
          internal_10khz <= '1';
          cnt_int <= 16d"0";
        else
          cnt_int <= std_logic_vector(unsigned(cnt_int) + 1);
          internal_10khz <= '0';
        end if;
      end if;
    end if;
 end process;


O <= internal_10khz; --10 kHz clk generated internally	
--	--MUX for switching between different 10 kHz clocks 
--	process(clk)
--	begin 
--		if rising_edge(clk) then 
--			if disable_fldbck = '1' then        --disables the fold back to the internal clock
--				O <= external_10khz; 
--			else 
--				if sel = '0' then 
--					O <= external_10khz; --external 10 kHz clock either from FOFB or EVR
--				else 
--					O <= internal_10khz; --10 kHz clk generated internally
--				end if;  
--			end if; 
--		end if; 
--	end process; 

end architecture; 
