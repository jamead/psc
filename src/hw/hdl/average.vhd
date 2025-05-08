--------------------------------------------------------------------------------------------------------------
--Author: Thomas Chiesa
--Part: Average
--Description: This program is a Moving Average Filter implemented with an inferred RAM.  When a new data 
--value is written to the filter, the updated average occurs on the next positive edge of the clock. The 
--averaging is done using integer arithmetic. 



--------------------------------------------------------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use ieee.math_real.all;  

entity average is 		
port(
		clk      : in std_logic; 
		reset    : in std_logic;
		start    : in std_logic;  
		data_in  : in signed(19 downto 0); 
		avg_out  : out signed(31 downto 0); 
		sel      : in std_logic_vector(1 downto 0); --select average mode
		done     : out std_logic
		); 
end entity; 

architecture arch of average is
type state is (IDLE, WRITE_TO_RAM, ACCUMULATE, FINISHED); 
signal present_state : state; 

constant N : integer := 20;
type ram_array is array (499 downto 0) of signed(N-1 downto 0);	--RAM array 

constant M : integer := integer(ceil(log2(real((2**(N))*500))));	
signal ram : ram_array := (others => (others => '0')); 			
signal accum : signed(M-1 downto 0) := (others => '0'); 		
signal addr_cnt : integer := 500;                                
signal addr_max : integer := 0; 
signal ram_cnt : integer := 0; 
signal mode : std_logic_vector(1 downto 0); 
 
	
begin 

--register select bit as mode value
process(clk) 
begin 
    if rising_edge(clk) then 
        mode <= sel; 
    end if; 
end process; 

	storage: process(clk) 
	begin 
		if rising_edge(clk) then 
			if reset = '1' then   
				addr_cnt <= 0; 
				accum <= (others => '0'); 
				present_state <= IDLE; 
				done <= '0'; 
			else
			    case(present_state) is  
			     
				    when IDLE => 
						done <= '0'; 
						if start = '1' then 
						  case(mode) is 
						      when "00" => 
						          --avg_out <= std_logic_vector(resize(signed(data_in),32)); 
						          accum <= resize(signed(data_in),M); 
						          present_state <= FINISHED; 
						      when "01" => 
						          addr_max <= 167; --NPLC of 1
						          present_state <= WRITE_TO_RAM; 
						       when "10" => 
						          addr_max <= 500; --NPLC of 3
						          present_state <= WRITE_TO_RAM; 
						       when "11" => 
						          addr_max <= 10; --Ramping Average
						          present_state <= WRITE_TO_RAM; 
						        when others => 
						          present_state <= IDLE; 
						    end case; 
						end if; 
	    
				    --read and write to inferred RAM to take the delta (change) from the oldest data in the RAM and the newest written entry
				    when WRITE_TO_RAM => 	
				        if ram_cnt = addr_max then 
				            ram_cnt <= 0; 
				        else 
							ram(ram_cnt) <= data_in; --newest data written into ram 
		                    ram_cnt <= ram_cnt +1; 
		                end if;  
		                    present_state <= ACCUMULATE; 


				    --Accumulator: adds newest value and subtracts oldest value from accumulated value		
                    when ACCUMULATE => 	
                        if addr_cnt = addr_max then 
                            addr_cnt <= 0; 
                            present_state <= FINISHED; 
                        else 
                            accum <= accum + signed(ram(addr_cnt)); 
                            addr_cnt <= addr_cnt +1; 
                        end if; 
				    
				    --Average completed, strobe done bit
				    when FINISHED => 
						--Multiplier output can be truncated to 18 bits because the scale factor is always less than 1
						avg_out <= resize(accum,32);  
						accum <= (others => '0'); 
						done <= '1'; 
						present_state <= IDLE; 
                				
                	when others => 
                	   present_state <= IDLE; 
                	   
               end case; 
			end if; 
		end if; 
	end process; 
end architecture; 
	