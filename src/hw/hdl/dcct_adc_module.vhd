library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 

entity dcct_adc_module is 
  port(
    clk          : in std_logic; 
    reset        : in std_logic; 
    start        : in std_logic; 
    dcct_params  : t_dcct_adcs_params;
    dcct_out     : out t_dcct_adcs; 
    sdi          : in std_logic_vector(3 downto 0);
    cnv          : out std_logic; 
    sclk         : out std_logic; 
    sdo          : out std_logic;
	done         : out std_logic 
); 
end entity; 
		
architecture arch of dcct_adc_module is 

  type  state_type is (IDLE, APPLY_OFFSETS, APPLY_GAINS, MULT_DLY);  
  signal state :  state_type;

  type t_dcct is array(0 to 7) of signed(19 downto 0);
  signal dcct : t_dcct;

  signal conv_done : std_logic; 



--debug signals (connect to ila)
--   attribute mark_debug                 : string;
--   attribute mark_debug of dcct_params  : signal is "true";
--   attribute mark_debug of dcct_out     : signal is "true";
--   attribute mark_debug of dcct : signal is "true";
--   attribute mark_debug of done : signal is "true";
--   attribute mark_debug of conv_done: signal is "true";
--   attribute mark_debug of state: signal is "true";



begin




dcct_adc1: entity work.adc_ltc2376 
  port map(
	clk => clk,
	reset => reset,
	resolution => dcct_params.numbits_sel, 
	start => start, 
	busy => '0', --busy not used
	sdi => sdi(0), 
	cnv => cnv, 
	sclk => sclk, 
	sdo => open,
	dcct1 => dcct(0),
	dcct2 => dcct(1),
	data_rdy => conv_done
);
			
gainoff_adc1: entity work.dcct_gainoffset
  port map(
    clk => clk,
    reset => reset,
    conv_done => conv_done,
 	dcct0_raw => dcct(0),
	dcct1_raw => dcct(1), 
    dcct_params => dcct_params.ps1,
    dcct_out => dcct_out.ps1,
    done => done
);


		
dcct_adc2: entity work.adc_ltc2376
  port map(
	clk => clk,
	reset => reset,
	start => start,  
	resolution => dcct_params.numbits_sel, 
	busy => '0', --busy not used
	sdi => sdi(1), 
	cnv => open, 
	sclk => open, 
	sdo => open,
	dcct1 => dcct(2),
	dcct2 => dcct(3),
	data_rdy => open
);
			
gainoff_adc2: entity work.dcct_gainoffset
  port map(
    clk => clk,
    reset => reset,
    conv_done => conv_done,
 	dcct0_raw => dcct(2),
	dcct1_raw => dcct(3), 
    dcct_params => dcct_params.ps2,
    dcct_out => dcct_out.ps2,
    done => open
);



			
dcct_adc3: entity work.adc_ltc2376   
  port map(
	clk => clk,
	reset => reset,
	start => start,
	resolution => dcct_params.numbits_sel,    
	busy => '0', --busy not used
	sdi => sdi(2), 
	cnv => open, 
	sclk => open, 
	sdo => open,
	dcct1 => dcct(4),
	dcct2 => dcct(5),
	data_rdy => open
);
	
gainoff_adc3: entity work.dcct_gainoffset
  port map(
    clk => clk,
    reset => reset,
    conv_done => conv_done,
 	dcct0_raw => dcct(4),
	dcct1_raw => dcct(5), 
    dcct_params => dcct_params.ps3,
    dcct_out => dcct_out.ps3,
    done => open
);
	
			
		
dcct_adc4: entity work.adc_ltc2376  
  port map(
	clk => clk,
	reset => reset,
	start => start,  
	resolution => dcct_params.numbits_sel, 
	busy => '0', --busy not used
	sdi => sdi(3), 
	cnv => open, 
	sclk => open, 
	sdo => open,
	dcct1 => dcct(6),
	dcct2 => dcct(7),
	data_rdy => open
);
			
gainoff_adc4: entity work.dcct_gainoffset
  port map(
    clk => clk,
    reset => reset,
    conv_done => conv_done,
 	dcct0_raw => dcct(6),
	dcct1_raw => dcct(7),   
    dcct_params => dcct_params.ps4,
    dcct_out => dcct_out.ps4,
    done => open
);



end architecture; 