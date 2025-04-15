
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.psc_pkg.all; 

entity dac_gainoffset is 
	port(
      clk            : in std_logic;
      reset          : in std_logic; 
      tenkhz_trig    : in std_logic; 
      dac_setpt_raw  : in signed(19 downto 0);
      dac_cntrl      : in t_dac_cntrl_onech; 
      dac_setpt      : out signed(19 downto 0);
      done           : out std_logic 
     );
end entity;

architecture arch of dac_gainoffset is


  type  state_type is (IDLE, APPLY_OFFSETS, APPLY_GAINS, MULT_DLY);  
  signal state :  state_type;
  signal conv_done_last : std_logic;
  signal multdlycnt : std_logic_vector(3 downto 0);
  
  signal dac_setpt_oc : signed(19 downto 0);



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
		   if tenkhz_trig = '1' then 				   
		      state <= apply_offsets;
           end if;
         

         when APPLY_OFFSETS =>
           dac_setpt_oc <= dac_setpt_raw - dac_cntrl.offset;
           state <= apply_gains;

           
         when APPLY_GAINS =>
           --dcct adc format is Q0.19 format (1sign, 0 integer, 19 fractional bits) range -1 to 0.99999
           --gain is Q3.20 format (1sign, 3 integer, 20 fractional bits) range -8 to 7.99999
           dac_setpt <= fixed_mul(dac_setpt_oc, dac_cntrl.gain, 4);
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

