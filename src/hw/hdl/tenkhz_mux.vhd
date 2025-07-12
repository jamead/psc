library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

library work;
use work.psc_pkg.ALL;


entity tenkhz_mux is
  port(
    pl_clk    		: in std_logic; 
    evr_clk         : in std_logic;
    reset      		: in std_logic; 
		  				
    evr_trigs       : in t_evr_trigs;
    evr_params      : in t_evr_params;

    --Outputs
    flt_10kHz       : out std_logic; 		--fault signal produce when an external 10 kHz pulse is lost temporarily
    tenkhz_out      : out std_logic         --pulse output from Mux
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
	signal evr_onehz_trig: std_logic;
	
	signal tenkhz_cnt    : unsigned(31 downto 0);
	signal tenkhz_cnt_hi : unsigned(31 downto 0);
	signal tenkhz_cnt_lo : unsigned(31 downto 0);
	
	signal alsu_evr_10khz : std_logic;
	signal alsu_evr_10khz_pulse : std_logic;
	signal alsu_evr_10khz_pulse_prev : std_logic;	
	signal nsls_evr_10khz : std_logic;

	
	
	
begin 

--Fault Signal 
flt_10kHz <= sel; 

tenkhz_cnt_lo <= shift_right(unsigned(evr_params.tenkhz_cnt) + 1, 1) - 1;
tenkhz_cnt_hi <= shift_right(unsigned(evr_params.tenkhz_cnt), 1) - 1;


	

---- rising edge detection of EVR trigger 
--	process(clk) 
--	begin 
--		if rising_edge(clk) then 
--			if reset = '1' then 
--				dff0 <= '0'; 
--				dff1 <= '0'; 
--				evr_pulse <= '0'; 
--			else 
--				dff0 <= evr_trigs.fa_trig; 
--				dff1 <= dff0; 
--				evr_10khz_pulse <= dff1 and not dff0; 
--			end if;         
--		end if; 
--	end process;  
	

	
	
--	--Counter for detecting if designated pulse is present
--	process(clk) 
--	begin 
--		if rising_edge(clk) then 
--			if reset = '1' then 
--				clock_count <= 0; 
--				sel <= '0'; 
--			else 
--				if external_10kHz = '1' then	
--					clock_count <= 0; 
--					sel <= '0'; 
--				elsif clock_count = to_integer(unsigned(timer)) then 
--					sel <= '1'; 
--				else 
--					clock_count <= clock_count +1; 
--				end if; 
--			end if; 	
--		end if; 
--	end process; 
	


--generate internal 10KHz from pl_clk0 (100MHz)
process (pl_clk)
  begin
    if rising_edge(pl_clk) then 
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



-- for nsls2 evr has 10khz event
sync_10KHz_trig: entity work.pulse_sync
  port map(
    pl_clk => pl_clk,
    pulse_in => evr_trigs.fa_trig,
    pulse_out => nsls_evr_10khz
);

-- for alsu, evr only has 1Hz event
sync_1Hz_trig: entity work.pulse_sync
  port map(
    pl_clk => pl_clk,
    pulse_in => evr_trigs.onehz_trig,
    pulse_out => evr_onehz_trig
);


--generate a 10KHz pulse from 1Hz evr trigger (for ALS-U)
process(pl_clk)
  begin
    if rising_edge(pl_clk) then
      if reset = '1' then
        tenkhz_cnt <= tenkhz_cnt_hi;
        alsu_evr_10khz_pulse <= '1';
      else
        if evr_onehz_trig = '1' then
          tenkhz_cnt <= tenkhz_cnt_hi;
          alsu_evr_10khz_pulse <= '1';
        elsif (tenkhz_cnt = to_unsigned(0, tenkhz_cnt'length)) then
          alsu_evr_10khz_pulse <= not(alsu_evr_10khz_pulse);
		  if (alsu_evr_10khz_pulse = '1') then
            tenkhz_cnt <= tenkhz_cnt_lo;
          else
            tenkhz_cnt <= tenkhz_cnt_hi;
          end if;
        else
          tenkhz_cnt <= tenkhz_cnt -1;
	    end if;
      end if;
    end if;
end process;


--generate a 10KHz single clock trigger from 
process(pl_clk)
  begin
    if rising_edge(pl_clk) then
      alsu_evr_10khz_pulse_prev <= alsu_evr_10khz_pulse;
      if (alsu_evr_10khz_pulse_prev = '0' and alsu_evr_10khz_pulse = '1') then
        alsu_evr_10khz <= '1';
      else
        alsu_evr_10khz <= '0';
      end if;
    end if;
end process;



--	mux for switching between different 10 kHz clocks 
process(pl_clk)
  begin 
    if rising_edge(pl_clk) then 
      if evr_params.tenkhz_src = "00" then 
        tenkhz_out <= internal_10khz; 
      else 
        tenkhz_out <= nsls_evr_10khz; 
      end if;  
    end if; 
end process; 


end architecture; 
