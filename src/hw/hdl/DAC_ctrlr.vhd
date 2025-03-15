-------------------------------------------------------------------------------
-- Title         : DAC Controller
-------------------------------------------------------------------------------
-- File          : DAC_ctrlr.vhd
-- Author        : Thomas Chiesa tchiesa@bnl.gov
-- Created       : 07/19/2020
-------------------------------------------------------------------------------
-- Description:
-- This program is the DAC controller for the PSC.  It controls all
-- four DACs on the PSC. 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modification history:
-- 07/19/2020: created.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.psc_pkg.all;



entity dac_ctrlr is
port(
			--Clks and Resets
			clk                  : in std_logic; 
			reset                : in std_logic; 
			tenkhz_trig          : in std_logic;
			--Inputs
			dac_cntrl            : in t_dac_cntrl;
			dac_stat             : out t_dac_stat;
			dac1234_jump         : in std_logic; 		
		    --Outputs
            dac1_done            : out std_logic; 
            dac2_done            : out std_logic; 
            dac3_done            : out std_logic; 
            dac4_done            : out std_logic; 
		    --SPI Outputs
			n_sync1234		     : out std_logic; 
			sclk1234   		     : out std_logic; 
			sdo                  : out std_logic_vector(3 downto 0)	

    );
end entity;

architecture arch of dac_ctrlr is


type state_type is (IDLE,RUN_RAMP,UPDATE_DAC); 



  --signal convert_done1, convert_done2, convert_done3, convert_done4 : std_logic; 
  --signal result1, result2, result3, result4 : std_logic_vector(17 downto 0); 
  --signal or_load1, or_load2, or_load3, or_load4 : std_logic; 

  signal dac_rdaddr : std_logic_vector(15 downto 0);
  signal dac_rddata : std_logic_vector(19 downto 0);
  signal dac_rden   : std_logic;
  signal dac_setpt  : std_logic_vector(19 downto 0);
  signal dac_start  : std_logic;
  
  signal state : state_type;


begin



--process(clk) 
--begin 
--    if rising_edge(clk) then 
--        or_load1 <= dac1_in.load or dac1234_jump; 
--        or_load2 <= dac2_in.load or dac1234_jump; 
--        or_load3 <= dac3_in.load or dac1234_jump; 
--        or_load4 <= dac4_in.load or dac1234_jump; 
--    end if; 
--end process; 






dac0_table: dac_dpram
  port map (
    clka => clk,  
    wea => dac_cntrl.ps1.dpram_we,
    addra => dac_cntrl.ps1.dpram_addr,
    dina => dac_cntrl.ps1.dpram_data,
    clkb => clk,
    enb => dac_rden,
    addrb => dac_rdaddr,
    doutb => dac_rddata
  );


--state machine to write out the ramp table from dpram
process(clk) 
begin 
  if rising_edge(clk) then 
    if reset = '1' then 
      state <= IDLE; 
      dac_rdaddr <= 16d"0";
      dac_rden <= '0';
      dac_start <= '0';
    else 
      case(state) is 
        when IDLE => 
          if dac_cntrl.ps1.load = '1' then 
            state <= run_ramp;
            dac_rdaddr <= 16d"0";
            dac_rden <= '0';
            dac_start <= '0';
          end if;                 

        when RUN_RAMP => 
            dac_start <= '0';
            if (tenkhz_trig = '1') then
               dac_rden <= '1';
               state <= update_dac;
            end if;
            
        when UPDATE_DAC =>
            dac_rden <= '0';
            if (dac_rdaddr > dac_cntrl.ps1.ramplen) then
               state <= idle;
            else
              dac_rdaddr <= std_logic_vector(unsigned(dac_rdaddr) + 1);
              dac_setpt <= dac_rddata;
              dac_start <= '1';
              state <= run_ramp;
            end if;  
      end case;
    end if;
  end if;
 end process;           
  







setpt_dac1:  entity work.dac_ad5781_intf 
  generic map
    (SPI_CLK_DIV => 5) --10MHz sclk
  port map(
	--Control inputs
    clk => clk,
    reset => dac_cntrl.ps1.reset, 
	start => dac_start, 
    --DAC Inputs         
    dac_data => dac_setpt(17 downto 0),
    dac_ctrl_bits => dac_cntrl.ps1.cntrl(4 downto 0),
	--DAC Outputs        
    n_sync => n_sync1234, 
    sclk => sclk1234,
    sdo => sdo(0), --sdo1,
    done => dac1_done
);

setpt_dac2:  entity work.dac_ad5781_intf 
  generic map
    (SPI_CLK_DIV => 5) --10MHz sclk
  port map(
	--Control inputs
    clk => clk,
    reset => dac_cntrl.ps1.reset, 
	start => dac_start, 
    --DAC Inputs         
    dac_data => dac_setpt(17 downto 0),
    dac_ctrl_bits => dac_cntrl.ps1.cntrl(4 downto 0),
	--DAC Outputs        
    n_sync => open, 
    sclk => open, 
    sdo => sdo(1), 
    done => dac2_done
);


setpt_dac3:  entity work.dac_ad5781_intf 
  generic map
    (SPI_CLK_DIV => 5) --10MHz sclk
  port map(
	--Control inputs
    clk => clk,
    reset => dac_cntrl.ps1.reset, 
	start => dac_start,
    --DAC Inputs         
    dac_data => dac_setpt(17 downto 0),
    dac_ctrl_bits => dac_cntrl.ps1.cntrl(4 downto 0),
	--DAC Outputs        
    n_sync => open,
    sclk => open,
    sdo => sdo(2), 
    done => dac3_done
);
		

setpt_dac4:  entity work.dac_ad5781_intf 
  generic map
    (SPI_CLK_DIV => 5) --10MHz sclk
  port map(
	--Control inputs
    clk => clk,
    reset => dac_cntrl.ps1.reset,
	start => dac_start,
    --DAC Inputs         
    dac_data => dac_setpt(17 downto 0),
    dac_ctrl_bits => dac_cntrl.ps1.cntrl(4 downto 0),
	--DAC Outputs        
    n_sync => open,
    sclk => open,
    sdo => sdo(3), 
    done => dac4_done
);

end arch;
