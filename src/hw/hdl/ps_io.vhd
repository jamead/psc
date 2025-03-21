
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
    mon_adcs         : in t_mon_adcs;
    dac_cntrl        : out t_dac_cntrl;
	dac_stat         : in t_dac_stat;
	ss_buf_stat      : in t_snapshot_stat; 
	rcom             : out std_logic_vector(19 downto 0);
	rsts             : in std_logic_vector(19 downto 0)
      
  );
end ps_io;


architecture behv of ps_io is

  

  
  signal reg_i           : t_addrmap_pl_regs_in;
  signal reg_o           : t_addrmap_pl_regs_out;
  
  signal soft_trig       : std_logic;
  signal soft_trig_prev  : std_logic;

  
  attribute mark_debug     : string;
  attribute mark_debug of soft_trig: signal is "true";
  attribute mark_debug of reg_i: signal is "true";
  



begin

reg_i.fpgaver.val.data <= std_logic_vector(to_unsigned(FPGA_VERSION,32));

leds <= reg_o.leds.val.data;

-- DCCT and Monitor ADC slow readbacks
reg_i.ps1_dcct0.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps1.dcct0), 32));
reg_i.ps1_dcct1.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps1.dcct1), 32));
reg_i.ps1_dacsp.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.dac_sp), 32));
reg_i.ps1_volt.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.volt_mon), 32));
reg_i.ps1_gnd.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.gnd_mon), 32));
reg_i.ps1_spare.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.spare_mon), 32));
reg_i.ps1_reg.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.ps_reg), 32));
reg_i.ps1_err.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.ps_error), 32));

reg_i.ps2_dcct0.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps2.dcct0), 32));
reg_i.ps2_dcct1.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps2.dcct1), 32));
reg_i.ps2_dacsp.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.dac_sp), 32));
reg_i.ps2_volt.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.volt_mon), 32));
reg_i.ps2_gnd.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.gnd_mon), 32));
reg_i.ps2_spare.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.spare_mon), 32));
reg_i.ps2_reg.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.ps_reg), 32));
reg_i.ps2_err.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.ps_error), 32));

reg_i.ps3_dcct0.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps3.dcct0), 32));
reg_i.ps3_dcct1.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps3.dcct1), 32));
reg_i.ps3_dacsp.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.dac_sp), 32));
reg_i.ps3_volt.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.volt_mon), 32));
reg_i.ps3_gnd.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.gnd_mon), 32));
reg_i.ps3_spare.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.spare_mon), 32));
reg_i.ps3_reg.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.ps_reg), 32));
reg_i.ps3_err.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.ps_error), 32));

reg_i.ps4_dcct0.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps4.dcct0), 32));
reg_i.ps4_dcct1.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps4.dcct1), 32));
reg_i.ps4_dacsp.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.dac_sp), 32));
reg_i.ps4_volt.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.volt_mon), 32));
reg_i.ps4_gnd.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.gnd_mon), 32));
reg_i.ps4_spare.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.spare_mon), 32));
reg_i.ps4_reg.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.ps_reg), 32));
reg_i.ps4_err.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.ps_error), 32));


-- DAC control and Ramp Tables and status
dac_cntrl.ps1.offset <= reg_o.ps1_dac_offset.val.data; 
dac_cntrl.ps1.gain <= reg_o.ps1_dac_gain.val.data; 
dac_cntrl.ps1.setpoint <= reg_o.ps1_dac_setpt.val.data;
dac_cntrl.ps1.jump <= reg_o.ps1_dac_jumpmode.val.data(0);
dac_cntrl.ps1.cntrl <= reg_o.ps1_dac_cntrl.val.data;
dac_cntrl.ps1.reset <= reg_o.ps1_dac_reset.val.data(0);
dac_cntrl.ps1.ramplen <= reg_o.ps1_dac_ramplen.val.data;
dac_cntrl.ps1.dpram_addr <= reg_o.ps1_dac_rampaddr.val.data;
dac_cntrl.ps1.dpram_data <= reg_o.ps1_dac_rampdata.val.data;
dac_cntrl.ps1.dpram_we <= reg_o.ps1_dac_rampdata.val.swacc;
dac_cntrl.ps1.load <= reg_o.ps1_dac_runramp.val.data(0);

reg_i.ps1_dac_rampactive.val.data(0) <= dac_stat.ps1.active;
reg_i.ps1_dac_currampaddr.val.data <= dac_stat.ps1.cur_addr;



-- Digital IO
rcom(3 downto 0) <= reg_o.ps1_digout.val.data(3 downto 0);
rcom(7 downto 4) <= reg_o.ps1_digout.val.data(3 downto 0);
rcom(11 downto 8) <= reg_o.ps1_digout.val.data(3 downto 0);
rcom(15 downto 12) <= reg_o.ps1_digout.val.data(3 downto 0);
rcom(16) <= reg_o.ps1_digout.val.data(4);  --park bit
rcom(17) <= reg_o.ps2_digout.val.data(4);  --park bit
rcom(18) <= reg_o.ps3_digout.val.data(4);  --park bit
rcom(19) <= reg_o.ps4_digout.val.data(4);  --park_bit

reg_i.ps1_digin.val.data <= rsts(3 downto 0);
reg_i.ps2_digin.val.data <= rsts(7 downto 4);
reg_i.ps3_digin.val.data <= rsts(11 downto 8);
reg_i.ps4_digin.val.data <= rsts(15 downto 12);

-- Snapshot buffer stats
reg_i.snapshot_addrptr.val.data <= ss_buf_stat.addr_ptr;
reg_i.snapshot_totaltrigs.val.data <= ss_buf_stat.tenkhzcnt;


soft_trig <= reg_o.softtrig.val.data(0);

process (pl_clock)
begin
  if (rising_edge(pl_clock)) then
    if (pl_reset = '1') then
      reg_i.softtrig_bufptr.val.data <= 32d"0";
    else
      soft_trig_prev <= soft_trig;
      if (soft_trig = '1' and soft_trig_prev = '0') then     
        reg_i.softtrig_bufptr.val.data <= ss_buf_stat.addr_ptr;
      end if;
    end if;
  end if;
end process;  







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
