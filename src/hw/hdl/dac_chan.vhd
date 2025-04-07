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



entity dac_chan is
  port(
    clk                  : in std_logic; 
    reset                : in std_logic; 
    tenkhz_trig          : in std_logic;
    dac_cntrl            : in t_dac_cntrl_onech;
    dac_stat             : out t_dac_stat_onech;
    n_sync1234		     : out std_logic; 
	sclk1234   		     : out std_logic; 
	sdo                  : out std_logic	
    );
end entity;

architecture arch of dac_chan is


type state_type is (IDLE, RUN_RAMP, UPDATE_DAC); 


 

  signal dac_rdaddr      : std_logic_vector(15 downto 0);
  signal dac_rddata      : std_logic_vector(19 downto 0);
  signal dac_rden        : std_logic;
  signal ramp_dac_setpt  : std_logic_vector(19 downto 0);
  signal dac_setpt       : std_logic_vector(19 downto 0);
  signal ramp_active     : std_logic;
  signal dac_trig        : std_logic;
  
  signal state : state_type;



   --debug signals (connect to ila)
   attribute mark_debug                 : string;
   attribute mark_debug of dac_rdaddr: signal is "true";
   attribute mark_debug of dac_rddata: signal is "true";
   attribute mark_debug of dac_rden: signal is "true"; 
   attribute mark_debug of ramp_dac_setpt: signal is "true";
   attribute mark_debug of dac_setpt: signal is "true";
   attribute mark_debug of ramp_active: signal is "true";     
   attribute mark_debug of dac_cntrl: signal is "true";    
   attribute mark_debug of state: signal is "true"; 
   attribute mark_debug of dac_cntrl: signal is "true";
   attribute mark_debug of dac_stat: signal is "true";

begin


dac_stat.dac_setpt <= dac_setpt;
dac_stat.active <= ramp_active;

--Source of DAC data depenods on Mode
--Because DAC sync's are tied together, must always update every DAC
--  0=smooth ramp, 1=ramp table, 2=FOFB, 3=Jump Mode
process(clk) 
begin 
    if rising_edge(clk) then 
      if (reset = '1') then
        dac_setpt <= (others => '0');
      else
        if (tenkhz_trig = '1') then   
          if (dac_cntrl.mode = "00" or dac_cntrl.mode = "01" ) then
            dac_setpt <= ramp_dac_setpt;
          else
            dac_setpt <= dac_cntrl.setpoint;    
          end if;
        end if;
      end if;
    end if; 
end process; 






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
              ramp_dac_setpt <= dac_rddata;
              ramp_active <= '1';
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
    reset => dac_cntrl.reset, 
	start => tenkhz_trig,  
    --DAC Inputs         
    dac_data => dac_setpt(17 downto 0),
    dac_ctrl_bits => dac_cntrl.cntrl(4 downto 0),
	--DAC Outputs        
    n_sync => n_sync1234, 
    sclk => sclk1234,
    sdo => sdo, 
    done => open
);



--setpt_dac2:  entity work.dac_ad5781_intf 
--  generic map
--    (SPI_CLK_DIV => 5) --10MHz sclk
--  port map(
--	--Control inputs
--    clk => clk,
--    reset => dac_cntrl.ps1.reset, 
--	start => tenkhz_trig,   
--    --DAC Inputs         
--    dac_data => dac_setpt(17 downto 0),
--    dac_ctrl_bits => dac_cntrl.ps1.cntrl(4 downto 0),
--	--DAC Outputs        
--    n_sync => open, 
--    sclk => open, 
--    sdo => sdo(1), 
--    done => open
--);


--setpt_dac3:  entity work.dac_ad5781_intf 
--  generic map
--    (SPI_CLK_DIV => 5) --10MHz sclk
--  port map(
--	--Control inputs
--    clk => clk,
--    reset => dac_cntrl.ps1.reset, 
--	start => tenkhz_trig, 
--    --DAC Inputs         
--    dac_data => dac_setpt(17 downto 0),
--    dac_ctrl_bits => dac_cntrl.ps1.cntrl(4 downto 0),
--	--DAC Outputs        
--    n_sync => open,
--    sclk => open,
--    sdo => sdo(2), 
--    done => open
--);
		

--setpt_dac4:  entity work.dac_ad5781_intf 
--  generic map
--    (SPI_CLK_DIV => 5) --10MHz sclk
--  port map(
--	--Control inputs
--    clk => clk,
--    reset => dac_cntrl.ps1.reset,
--	start => tenkhz_trig,  
--    --DAC Inputs         
--    dac_data => dac_setpt(17 downto 0),
--    dac_ctrl_bits => dac_cntrl.ps1.cntrl(4 downto 0),
--	--DAC Outputs        
--    n_sync => open,
--    sclk => open,
--    sdo => sdo(3), 
--    done => open
--);

end arch;
