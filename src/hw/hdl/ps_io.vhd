
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library desyrdl;
use desyrdl.common.all;
use desyrdl.pkg_pl_regs.all;

library xil_defaultlib;
use xil_defaultlib.psc_pkg.ALL;



entity ps_io is
  generic (
    FPGA_VERSION        : in integer := 01
  );
  port (  
    pl_clock         : in std_logic;
    pl_reset         : in std_logic;
   
    m_axi4_m2s       : in t_pl_regs_m2s;
    m_axi4_s2m       : out t_pl_regs_s2m;   
     
    leds             : out std_logic_vector(7 downto 0);
    
    dcct_adcs        : in t_dcct_adcs;
    mon_adcs         : in t_mon_adcs
   
    
    
  );
end ps_io;


architecture behv of ps_io is

  

  
  signal reg_i        : t_addrmap_pl_regs_in;
  signal reg_o        : t_addrmap_pl_regs_out;

  attribute mark_debug     : string;
  attribute mark_debug of reg_o: signal is "true";



begin

reg_i.fpgaver.data.data <= std_logic_vector(to_unsigned(FPGA_VERSION,32));

leds <= reg_o.leds.data.data;

-- DCCT ADC slow readbacks
reg_i.ps1_dcct0_adc.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps1.dcct0), 32));
reg_i.ps1_dcct1_adc.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps1.dcct1), 32));
reg_i.ps2_dcct0_adc.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps2.dcct0), 32));
reg_i.ps2_dcct1_adc.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps2.dcct1), 32));
reg_i.ps3_dcct0_adc.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps3.dcct0), 32));
reg_i.ps3_dcct1_adc.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps3.dcct1), 32));
reg_i.ps4_dcct0_adc.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps4.dcct0), 32));
reg_i.ps4_dcct1_adc.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps4.dcct1), 32));




regs: pl_regs
  port map (
    pi_clock => pl_clock, 
    pi_reset => pl_reset, 

    pi_s_top => m_axi4_m2s, 
    po_s_top => m_axi4_s2m, 
    -- to logic interface
    pi_addrmap => reg_i,  
    po_addrmap => reg_o
  );





end behv;
