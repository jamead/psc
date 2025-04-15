
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 

entity mon_gainoffset is 
	port(
      clk            : in std_logic;
      reset          : in std_logic; 
      conv_done      : in std_logic; 
      mon_adc        : in t_mon_adcs_onech;
      mon_params     : in t_mon_adcs_params_onech; 
      mon_out        : out t_mon_adcs_onech;
      done           : out std_logic 
     );
end entity;

architecture arch of mon_gainoffset is


  type  state_type is (IDLE, APPLY_OFFSETS, APPLY_GAINS, MULT_DLY);  
  signal state :  state_type;
  signal conv_done_last : std_logic;
  signal multdlycnt : std_logic_vector(3 downto 0);



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


process(clk) 
  begin 
	if rising_edge(clk) then 
	 if reset = '1' then 
		done <= '0'; 		   
	 else 
	   case state is 
	     when IDLE =>
	       done <= '0';
	       conv_done_last <= conv_done;
		   if (conv_done = '1' and conv_done_last = '0') then 				   
		      state <= apply_offsets;
           end if;
         

         when APPLY_OFFSETS =>
           mon_out.dacmon_oc <= mon_adc.dacmon_raw - mon_params.dacmon_offset;
           mon_out.voltage_oc <= mon_adc.voltage_raw - mon_params.voltage_offset;
           mon_out.ignd_oc <= mon_adc.ignd_raw - mon_params.ignd_offset;
           mon_out.spare_oc <= mon_adc.spare_raw - mon_params.spare_offset;
           mon_out.ps_reg_oc <= mon_adc.ps_reg_raw - mon_params.ps_reg_offset;          
           mon_out.ps_error_oc <= mon_adc.ps_error_raw - mon_params.ps_error_offset;              
           state <= apply_gains;

           
         when APPLY_GAINS =>
           --mon adc format is Q0.15 format (1sign, 0 integer, 15 fractional bits) range -1 to 0.99999
           --gain is Q3.20 format (1sign, 3 integer, 20 fractional bits) range -8 to 7.99999
           mon_out.dacmon <= fixed_mul(mon_out.dacmon_oc, mon_params.dacmon_gain, 4);
           mon_out.voltage <= fixed_mul(mon_out.voltage_oc, mon_params.voltage_gain, 4);
           mon_out.ignd <= fixed_mul(mon_out.ignd_oc, mon_params.ignd_gain, 4);            
           mon_out.spare <= fixed_mul(mon_out.spare_oc, mon_params.spare_gain, 4);                     
           mon_out.ps_reg <= fixed_mul(mon_out.ps_reg_oc, mon_params.ps_reg_gain, 4);
           mon_out.ps_error <= fixed_mul(mon_out.ps_error_oc, mon_params.ps_error_gain, 4);
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

end arch;

