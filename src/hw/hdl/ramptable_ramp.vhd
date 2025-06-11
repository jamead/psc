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

entity ramptable_ramp is
  port(
    clk                  : in std_logic; 
    reset                : in std_logic; 
    tenkhz_trig          : in std_logic;
    dac_cntrl            : in t_dac_cntrl_onech;
    ramp_active          : out std_logic;
    ramp_dac_setpt       : out signed(19 downto 0)
    );
end entity;

architecture arch of ramptable_ramp is


type state_type is (IDLE, RUN_RAMP, UPDATE_DAC); 


 
  signal dac_data        : std_logic_vector(19 downto 0);
  signal dac_rdaddr      : std_logic_vector(15 downto 0);
  signal dac_rddata      : std_logic_vector(19 downto 0);
  signal dac_rden        : std_logic;
  signal dac_setpt_raw   : signed(19 downto 0);
  signal dac_setpt       : signed(19 downto 0);
  signal dac_trig        : std_logic;
  signal gainoff_done    : std_logic;
  
  signal state : state_type;



   --debug signals (connect to ila)
--   attribute mark_debug                 : string;
--   attribute mark_debug of dac_data: signal is "true";


begin






dac0_table: dac_dpram
  port map (
    clka => clk,  
    wea => dac_cntrl.dpram_we,
    addra => dac_cntrl.dpram_addr,
    dina => dac_cntrl.dpram_data,
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
      ramp_active <= '0';
      ramp_dac_setpt <= (others => '0');
    else 
      case(state) is 
        when IDLE => 
          ramp_active <= '0';
          if dac_cntrl.ramprun = '1' then 
            state <= run_ramp;
            dac_rdaddr <= 16d"0";
            dac_rden <= '1';
            ramp_active <= '0';         
          end if;                 

        when RUN_RAMP => 
            if (tenkhz_trig = '1') then
               ramp_active <= '1';
               dac_rden <= '1';
               state <= update_dac;
            end if;
            
        when UPDATE_DAC =>
            dac_rden <= '1';
            if (unsigned(dac_rdaddr) + 1 > unsigned(dac_cntrl.ramplen)) then
               dac_rden <= '0';
               state <= idle;
            else
              dac_rdaddr <= std_logic_vector(unsigned(dac_rdaddr) + 1);
              ramp_dac_setpt <= signed(dac_rddata);
              ramp_active <= '1';
              state <= run_ramp;
            end if;  
      end case;
    end if;
  end if;
 end process;           
  



end arch;
