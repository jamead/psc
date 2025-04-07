library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 

entity dcct_adc_module is 
	port(
        --Control inputs
        clk          : in std_logic; 
        reset        : in std_logic; 
        start        : in std_logic; 
        dcct_params  : t_dcct_adcs_params;
        -- output data
		DCCT_out     : out t_dcct_adcs; 
        --ADC Inputs
        sdi          : in std_logic_vector(3 downto 0);

        --ADC Outputs
        cnv          : out std_logic; 
        sclk         : out std_logic; 
        sdo          : out std_logic;
		done         : out std_logic 
		); 
end entity; 
		
architecture arch of dcct_adc_module is 

  type  state_type is (IDLE, APPLY_OFFSETS, APPLY_GAINS, MULT_DLY);  
  signal state :  state_type;


  signal DCCT_ADC_data12 : std_logic_vector(35 downto 0); 
  signal DCCT_ADC_data34 : std_logic_vector(35 downto 0); 
  signal DCCT_ADC_data56 : std_logic_vector(35 downto 0); 
  signal DCCT_ADC_data78 : std_logic_vector(35 downto 0); 
  signal convert_done : std_logic; 
  signal conv_done : std_logic; 
  signal conv_done_last : std_logic;
  signal multdlycnt : std_logic_vector(3 downto 0);


  --debug signals (connect to ila)
   attribute mark_debug                 : string;
   attribute mark_debug of dcct_params  : signal is "true";
   attribute mark_debug of dcct_out     : signal is "true";
   attribute mark_debug of done : signal is "true";
   attribute mark_debug of conv_done: signal is "true";


-- Multiplies two signed vectors and returns result shifted down by 'fraction_bits'
function fixed_mul(
    signal a           : signed;
    signal b           : signed;
    constant fraction_bits : natural
) return signed is
    variable product : signed(a'length + b'length - 1 downto 0);
    variable shifted : signed(a'length - 1 downto 0);
begin
    -- This multiplication works because VHDL automatically infers result size
    product := a * b;

    -- Extract most significant bits after shifting right by fraction_bits
    shifted := product(product'high - fraction_bits downto product'high - fraction_bits - (a'length - 1));

    return shifted;
end function;



begin








dcct_adc1: entity work.ADC_LTC2376_intf 
  generic map(DATA_BITS => 36,
    SPI_CLK_DIV   => 5)  
  port map(
	--Control inputs
	clk       => clk,
	reset     => reset,
	start     => start, 
	--ADC Inputs
	busy      => '0', --busy not used
	sdi       => sdi(0), --sdi_1,
	--ADC Outputs
	cnv       => cnv, 
	sclk      => sclk, 
	sdo       => open,
	data_out  => DCCT_ADC_data12,
	data_rdy  => conv_done
);
			


			
dcct_adc2: entity work.ADC_LTC2376_intf 
  generic map(DATA_BITS => 36,
	SPI_CLK_DIV   => 5)  
  port map(
	--Control inputs
	clk       => clk,
	reset     => reset,
	start     => start,  
	--ADC Inputs
	busy      => '0', --busy not used
	sdi       => sdi(1), --sdi_2,
	--ADC Outputs
	cnv       => open, 
	sclk      => open, 
	sdo       => open,
	data_out  => DCCT_ADC_data34,
	data_rdy  => open
);
			


			
dcct_adc3: entity work.ADC_LTC2376_intf 
  generic map(DATA_BITS => 36,
	SPI_CLK_DIV   => 5)  
  port map(
	--Control inputs
	clk       => clk,
	reset     => reset,
	start     => start,   
	--ADC Inputs
	busy      => '0', --busy not used
	sdi       => sdi(2), --sdi_3,
	--ADC Outputs
	cnv       => open, 
	sclk      => open, 
	sdo       => open,
	data_out  => DCCT_ADC_data56,
	data_rdy  => open
);
			


			
dcct_adc4: entity work.ADC_LTC2376_intf 
  generic map(DATA_BITS => 36,
	SPI_CLK_DIV   => 5)  
  port map(
	--Control inputs
	clk       => clk,
	reset     => reset,
	start     => start,   
	--ADC Inputs
	busy      => '0', --busy not used
	sdi       => sdi(3), --sdi_4,
	--ADC Outputs
	cnv       => open, 
	sclk      => open, 
	sdo       => open,
	data_out  => DCCT_ADC_data78,
	data_rdy  => open
);
			


process(clk) 
  begin 
	if rising_edge(clk) then 
	 if reset = '1' then 
		done <= '0'; 
		dcct_out.ps1.dcct0_raw <= (others => '0');
		dcct_out.ps1.dcct1_raw <= (others => '0');
		dcct_out.ps2.dcct0_raw <= (others => '0');
		dcct_out.ps2.dcct1_raw <= (others => '0');				       
		dcct_out.ps3.dcct0_raw <= (others => '0');
		dcct_out.ps3.dcct1_raw <= (others => '0');
		dcct_out.ps4.dcct0_raw <= (others => '0');
		dcct_out.ps4.dcct1_raw <= (others => '0');			   
	 else 
	   case state is 
	     when IDLE =>
	       done <= '0';
	       conv_done_last <= conv_done;
		   if (conv_done = '1' and conv_done_last = '0') then 				   
		      dcct_out.ps1.dcct0_raw <= dcct_params.ps4.dcct0_gain; --to_signed(31000, 20); --DCCT_ADC_data12(17 downto 0); 
		      dcct_out.ps1.dcct1_raw <= dcct_params.ps4.dcct1_gain; --to_signed(1000, 20); --DCCT_ADC_data12(35 downto 18);
		      dcct_out.ps2.dcct0_raw <= resize(signed(DCCT_ADC_data34(17 downto 0)),20); 
		      dcct_out.ps2.dcct1_raw <= resize(signed(DCCT_ADC_data34(35 downto 18)),20);
		      dcct_out.ps3.dcct0_raw <= resize(signed(DCCT_ADC_data56(17 downto 0)),20); 
		      dcct_out.ps3.dcct1_raw <= resize(signed(DCCT_ADC_data56(35 downto 18)),20);
		      dcct_out.ps4.dcct0_raw <= resize(signed(DCCT_ADC_data78(17 downto 0)),20); 
		      dcct_out.ps4.dcct1_raw <= resize(signed(DCCT_ADC_data78(35 downto 18)),20);
		      state <= apply_offsets;
           end if;
         

         when APPLY_OFFSETS =>
           dcct_out.ps1.dcct0_oc <= dcct_out.ps1.dcct0_raw - dcct_params.ps1.dcct0_offset;
           dcct_out.ps1.dcct1_oc <= dcct_out.ps1.dcct1_raw - dcct_params.ps1.dcct1_offset;
           dcct_out.ps2.dcct0_oc <= dcct_out.ps2.dcct0_raw - dcct_params.ps2.dcct0_offset;
           dcct_out.ps2.dcct1_oc <= dcct_out.ps2.dcct1_raw - dcct_params.ps2.dcct1_offset; 
           dcct_out.ps3.dcct0_oc <= dcct_out.ps3.dcct0_raw - dcct_params.ps3.dcct0_offset;
           dcct_out.ps3.dcct1_oc <= dcct_out.ps3.dcct1_raw - dcct_params.ps3.dcct1_offset;
           dcct_out.ps4.dcct0_oc <= dcct_out.ps4.dcct0_raw - dcct_params.ps4.dcct0_offset;
           dcct_out.ps4.dcct1_oc <= dcct_out.ps4.dcct1_raw - dcct_params.ps4.dcct1_offset; 
           state <= apply_gains;

           
         when APPLY_GAINS =>
           --gain is Q1.19 format (1bits integer (which is the sign) and 20bit fractional part)
           --so range is -1 to 0.999999
           dcct_out.ps1.dcct0 <= fixed_mul(dcct_out.ps1.dcct0_oc, dcct_params.ps1.dcct0_gain, 1);
           dcct_out.ps1.dcct1 <= fixed_mul(dcct_out.ps1.dcct1_oc, dcct_params.ps1.dcct1_gain, 1);
           dcct_out.ps2.dcct0 <= fixed_mul(dcct_out.ps2.dcct0_oc, dcct_params.ps2.dcct0_gain, 1);
           dcct_out.ps2.dcct1 <= fixed_mul(dcct_out.ps2.dcct1_oc, dcct_params.ps2.dcct1_gain, 1);
           dcct_out.ps3.dcct0 <= fixed_mul(dcct_out.ps3.dcct0_oc, dcct_params.ps3.dcct0_gain, 1);
           dcct_out.ps3.dcct1 <= fixed_mul(dcct_out.ps3.dcct1_oc, dcct_params.ps3.dcct1_gain, 1);
           dcct_out.ps4.dcct0 <= fixed_mul(dcct_out.ps4.dcct0_oc, dcct_params.ps4.dcct0_gain, 1);
           dcct_out.ps4.dcct1 <= fixed_mul(dcct_out.ps4.dcct1_oc, dcct_params.ps4.dcct1_gain, 1);
           state <= mult_dly;
           multdlycnt <= 4d"0";
           
         when MULT_DLY =>
           if (multdlycnt = 4d"6") then
             state <= idle;
             done <= '1';
           else
             multdlycnt <= std_logic_vector(unsigned(multdlycnt) + 1);
           end if;
  
           
         when OTHERS => 
           state <= idle;       
	          
	   end case;       
	          
	  end if; 
    end if; 
end process; 


end architecture; 