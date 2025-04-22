-------------------------------------------------------------------------------
-- Title         : DCCT ADC module
-------------------------------------------------------------------------------
-- File          : DCCT_ADC_module.vhd
-- Author        : Thomas Chiesa tchiesa@bnl.gov
-- Created       : 07/19/2020
-------------------------------------------------------------------------------
-- Description:
-- This progam contains the 8 DCCT ADCs with gain and offset control. 

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modification history:
-- 07/19/2020: created.
-------------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 



-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADC_LTC2376_intf is
generic(DATA_BITS   : natural := 20;
        SPI_CLK_DIV : natural := 10); --Dividing the 100 MHz clock to 10MHz 50MHz/5 = 10MHz
port (
        --Control inputs
        clk          : in std_logic; 
        reset        : in std_logic; 
        start        : in std_logic; 
        --ADC Inputs
        busy         : in std_logic; 
        sdi          : in std_logic; 
        --ADC Outputs
        cnv          : out std_logic; 
        sclk         : out std_logic; 
        sdo          : out std_logic;
        data_out     : out std_logic_vector(DATA_BITS -1 downto 0); 
        data_rdy     : out std_logic
       );
end entity;

architecture arch of ADC_LTC2376_intf is
type state is (IDLE,SET_CNV,WAIT_FOR_NOT_BUSY,SCLK_HI,SCLK_LO,DONE); 
constant CNV_PULSE : natural := 10; --2 clock counts, 40ns, datasheet specifies min of 20ns
constant CNV_WIDTH : natural := 310; --slightly more than 3us, max wait is 3us according to datasheet
signal present_state : state; 
signal shift_reg   : std_logic_vector(DATA_BITS -1 downto 0); 
signal cnv_count   : natural range 0 to 500 := 0; 
signal clk_count   : natural range 0 to 500 := 0; 
signal bit_count   : natural range 0 to 500 := 0; 


  --debug signals (connect to ila)
   attribute mark_debug                 : string;
   attribute mark_debug of start  : signal is "true";
   attribute mark_debug of busy     : signal is "true";
   attribute mark_debug of sdi    : signal is "true";
   attribute mark_debug of cnv     : signal is "true";
   attribute mark_debug of sclk  : signal is "true";
   attribute mark_debug of data_out     : signal is "true";
   attribute mark_debug of present_state : signal is "true";
   attribute mark_debug of data_rdy  : signal is "true";
   attribute mark_debug of cnv_count     : signal is "true";
   attribute mark_debug of clk_count  : signal is "true";
   attribute mark_debug of bit_count     : signal is "true";
   
  




begin

process(clk) 
begin 
    if rising_edge(clk) then 
        if reset = '1' then 
            cnv_count <= 0; 
            clk_count <= 0; 
            bit_count <= 0;
            shift_reg <= (others => '0');
            data_out  <= (others => '0');
            data_rdy  <= '0';
            cnv <= '0';
            present_state <= IDLE; 
        else 
            case(present_state) is 
                --IDLE: wait for start trigger
                when IDLE => 
                    if start = '1' then 
                        present_state <= SET_CNV; 
                    end if;                 
                    sclk     <= '0'; 
                    data_rdy <= '0'; 
                    
                --SET_CNV: set cnv signal high for at least
                --2 clocks datasheet specifies a min of 20ns 
                when SET_CNV => 
                    if cnv_count = CNV_PULSE then 
                        cnv           <= '0'; 
                        cnv_count     <= 0; 
                        present_state <= WAIT_FOR_NOT_BUSY; 
                    else 
                        cnv           <= '1'; 
                        cnv_count <= cnv_count +1; 
                    end if;       
                    
                --WAIT_FOR_NOT_BUSY: wait for busy to go low, then 
                --transition to starting sclk      
                when WAIT_FOR_NOT_BUSY => 
                    if cnv_count = CNV_WIDTH then 
                        cnv_count     <= 0;
                        sclk          <= '1'; 
                        shift_reg     <= shift_reg(DATA_BITS-2 downto 0) & sdi;
                        present_state <= SCLK_HI;      
                    else 
                        cnv_count <= cnv_count +1;
                    end if; 
                   
                --SCLK_HI: set sclk high for correct number of 
                --clock counts                               
                when SCLK_HI => 
                    if clk_count = SPI_CLK_DIV -1 then 
                        sclk <= '0'; 
                        clk_count <= 0; 
                        bit_count <= bit_count +1; 
                        present_state <= SCLK_LO; 
                    else 
                        clk_count <= clk_count +1;
                        sclk <= '1'; 
                    end if; 
                
                --SCLK_LO: set sclk low for correct number of 
                --clock counts
                when SCLK_LO => 
                    if bit_count = (DATA_BITS) then 
                        bit_count <= 0;                     
                        present_state <= DONE;                 
                    else
                        if clk_count = SPI_CLK_DIV -1 then 
                            clk_count <= 0; 
                            sclk      <= '1';
                            shift_reg     <= shift_reg(DATA_BITS-2 downto 0) & sdi;
                            present_state <= SCLK_HI; 
                        else
                            clk_count <= clk_count +1; 
                            sclk <= '0'; 
                        end if; 
                    end if;     
                
                --DONE: register the shift register data and 
                --return to idle.       
                when DONE => 
                    if clk_count = 6 then 
                        clk_count <= 0; 
                        data_out <= shift_reg; 
                        present_state <= IDLE; 
                    else 
                        clk_count <= clk_count +1; 
                        data_rdy <= '1'; 
                    end if;                    
                
                when others => 
                present_state <= IDLE;
            end case; 
        end if; 
    end if; 
end process; 
end architecture;
