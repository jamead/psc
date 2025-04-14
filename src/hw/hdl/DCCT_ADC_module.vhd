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


  signal dcct_adc_data12 : std_logic_vector(35 downto 0); 
  signal dcct_adc_data34 : std_logic_vector(35 downto 0); 
  signal dcct_adc_data56 : std_logic_vector(35 downto 0); 
  signal dcct_adc_data78 : std_logic_vector(35 downto 0); 
  signal conv_done : std_logic; 
  --signal conv_done_last : std_logic;
  --signal multdlycnt : std_logic_vector(3 downto 0);



  --debug signals (connect to ila)
--   attribute mark_debug                 : string;
--   attribute mark_debug of dcct_params  : signal is "true";
--   attribute mark_debug of dcct_out     : signal is "true";
--   attribute mark_debug of done : signal is "true";
--   attribute mark_debug of conv_done: signal is "true";
--   attribute mark_debug of state: signal is "true";



---- Multiplies two signed vectors and returns result shifted down by 'fraction_bits'
--function fixed_mul(
--    signal a           : signed;
--    signal b           : signed;
--    constant fraction_bits : natural
--) return signed is
--    variable product : signed(a'length + b'length - 1 downto 0);
--    variable shifted : signed(a'length - 1 downto 0);
--begin
--    -- This multiplication works because VHDL automatically infers result size
--    product := a * b;

--    -- Extract most significant bits after shifting right by fraction_bits
--    shifted := product(product'high - fraction_bits downto product'high - fraction_bits - (a'length - 1));

--    return shifted;
--end function;




begin








dcct_adc1: entity work.ADC_LTC2376_intf 
  generic map(DATA_BITS => 36,
    SPI_CLK_DIV   => 5)  
  port map(
	clk => clk,
	reset => reset,
	start => start, 
	busy => '0', --busy not used
	sdi => sdi(0), 
	cnv => cnv, 
	sclk => sclk, 
	sdo => open,
	data_out => DCCT_ADC_data12,
	data_rdy => conv_done
);
			
gainoff_adc1: entity work.dcct_gainoffset
  port map(
    clk => clk,
    reset => reset,
    conv_done => conv_done,
    dcct_adc => dcct_adc_data12,
    dcct_params => dcct_params.ps1,
    dcct_out => dcct_out.ps1,
    done => done
);


		
dcct_adc2: entity work.ADC_LTC2376_intf 
  generic map(DATA_BITS => 36,
	SPI_CLK_DIV   => 5)  
  port map(
	clk => clk,
	reset => reset,
	start => start,  
	busy => '0', --busy not used
	sdi => sdi(1), 
	cnv => open, 
	sclk => open, 
	sdo => open,
	data_out => dcct_adc_data34,
	data_rdy => open
);
			
gainoff_adc2: entity work.dcct_gainoffset
  port map(
    clk => clk,
    reset => reset,
    conv_done => conv_done,
    dcct_adc => dcct_adc_data34,
    dcct_params => dcct_params.ps2,
    dcct_out => dcct_out.ps2,
    done => open
);



			
dcct_adc3: entity work.ADC_LTC2376_intf 
  generic map(DATA_BITS => 36,
	SPI_CLK_DIV   => 5)  
  port map(
	clk => clk,
	reset => reset,
	start => start,   
	busy => '0', --busy not used
	sdi => sdi(2), 
	cnv => open, 
	sclk => open, 
	sdo => open,
	data_out => dcct_adc_data56,
	data_rdy => open
);
	
gainoff_adc3: entity work.dcct_gainoffset
  port map(
    clk => clk,
    reset => reset,
    conv_done => conv_done,
    dcct_adc => dcct_adc_data56,
    dcct_params => dcct_params.ps3,
    dcct_out => dcct_out.ps3,
    done => open
);
	
			
		
dcct_adc4: entity work.ADC_LTC2376_intf 
  generic map(DATA_BITS => 36,
	SPI_CLK_DIV   => 5)  
  port map(
	clk => clk,
	reset => reset,
	start => start,   
	busy => '0', --busy not used
	sdi => sdi(3), 
	cnv => open, 
	sclk => open, 
	sdo => open,
	data_out => dcct_adc_data78,
	data_rdy => open
);
			
gainoff_adc4: entity work.dcct_gainoffset
  port map(
    clk => clk,
    reset => reset,
    conv_done => conv_done,
    dcct_adc => dcct_adc_data78,
    dcct_params => dcct_params.ps4,
    dcct_out => dcct_out.ps4,
    done => open
);



--process(clk) 
--  begin 
--	if rising_edge(clk) then 
--	 if reset = '1' then 
--		done <= '0'; 
--		dcct_out.ps1.dcct0_raw <= (others => '0');
--		dcct_out.ps1.dcct1_raw <= (others => '0');
--		dcct_out.ps2.dcct0_raw <= (others => '0');
--		dcct_out.ps2.dcct1_raw <= (others => '0');				       
--		dcct_out.ps3.dcct0_raw <= (others => '0');
--		dcct_out.ps3.dcct1_raw <= (others => '0');
--		dcct_out.ps4.dcct0_raw <= (others => '0');
--		dcct_out.ps4.dcct1_raw <= (others => '0');			   
--	 else 
--	   case state is 
--	     when IDLE =>
--	       done <= '0';
--	       conv_done_last <= conv_done;
--		   if (conv_done = '1' and conv_done_last = '0') then 				   
--		      dcct_out.ps1.dcct0_raw <= resize(signed(DCCT_ADC_data12(17 downto 0)),20); 
--		      dcct_out.ps1.dcct1_raw <= resize(signed(DCCT_ADC_data12(35 downto 18)),20);
--		      dcct_out.ps2.dcct0_raw <= resize(signed(DCCT_ADC_data34(17 downto 0)),20); 
--		      dcct_out.ps2.dcct1_raw <= resize(signed(DCCT_ADC_data34(35 downto 18)),20);
--		      dcct_out.ps3.dcct0_raw <= resize(signed(DCCT_ADC_data56(17 downto 0)),20); 
--		      dcct_out.ps3.dcct1_raw <= resize(signed(DCCT_ADC_data56(35 downto 18)),20);
--		      dcct_out.ps4.dcct0_raw <= resize(signed(DCCT_ADC_data78(17 downto 0)),20); 
--		      dcct_out.ps4.dcct1_raw <= resize(signed(DCCT_ADC_data78(35 downto 18)),20);
--		      state <= apply_offsets;
--           end if;
         

--         when APPLY_OFFSETS =>
--           dcct_out.ps1.dcct0_oc <= dcct_out.ps1.dcct0_raw - dcct_params.ps1.dcct0_offset;
--           dcct_out.ps1.dcct1_oc <= dcct_out.ps1.dcct1_raw - dcct_params.ps1.dcct1_offset;
--           dcct_out.ps2.dcct0_oc <= dcct_out.ps2.dcct0_raw - dcct_params.ps2.dcct0_offset;
--           dcct_out.ps2.dcct1_oc <= dcct_out.ps2.dcct1_raw - dcct_params.ps2.dcct1_offset; 
--           dcct_out.ps3.dcct0_oc <= dcct_out.ps3.dcct0_raw - dcct_params.ps3.dcct0_offset;
--           dcct_out.ps3.dcct1_oc <= dcct_out.ps3.dcct1_raw - dcct_params.ps3.dcct1_offset;
--           dcct_out.ps4.dcct0_oc <= dcct_out.ps4.dcct0_raw - dcct_params.ps4.dcct0_offset;
--           dcct_out.ps4.dcct1_oc <= dcct_out.ps4.dcct1_raw - dcct_params.ps4.dcct1_offset; 
--           state <= apply_gains;

           
--         when APPLY_GAINS =>
--           --dcct adc format is Q0.19 format (1sign, 0 integer, 19 fractional bits) range -1 to 0.99999
--           --gain is Q3.20 format (1sign, 3 integer, 20 fractional bits) range -8 to 7.99999
--           dcct_out.ps1.dcct0 <= fixed_mul(dcct_out.ps1.dcct0_oc, dcct_params.ps1.dcct0_gain, 4);
--           dcct_out.ps1.dcct0 <= fixed_mul(dcct_out.ps1.dcct0_oc, dcct_params.ps1.dcct0_gain, 4);
--           dcct_out.ps1.dcct1 <= fixed_mul(dcct_out.ps1.dcct1_oc, dcct_params.ps1.dcct1_gain, 4);
--           dcct_out.ps2.dcct0 <= fixed_mul(dcct_out.ps2.dcct0_oc, dcct_params.ps2.dcct0_gain, 4);
--           dcct_out.ps2.dcct1 <= fixed_mul(dcct_out.ps2.dcct1_oc, dcct_params.ps2.dcct1_gain, 4);
--           dcct_out.ps3.dcct0 <= fixed_mul(dcct_out.ps3.dcct0_oc, dcct_params.ps3.dcct0_gain, 4);
--           dcct_out.ps3.dcct1 <= fixed_mul(dcct_out.ps3.dcct1_oc, dcct_params.ps3.dcct1_gain, 4);
--           dcct_out.ps4.dcct0 <= fixed_mul(dcct_out.ps4.dcct0_oc, dcct_params.ps4.dcct0_gain, 4);
--           dcct_out.ps4.dcct1 <= fixed_mul(dcct_out.ps4.dcct1_oc, dcct_params.ps4.dcct1_gain, 4);
--           state <= mult_dly;
--           multdlycnt <= 4d"0";
           
--         when MULT_DLY =>
--           if (multdlycnt = 4d"6") then
--             state <= idle;
--             done <= '1';
--           else
--             multdlycnt <= std_logic_vector(unsigned(multdlycnt) + 1);
--           end if;
  
           
--         when OTHERS => 
--           state <= idle;       
	          
--	   end case;       
	          
--	  end if; 
--    end if; 
--end process; 


end architecture; 