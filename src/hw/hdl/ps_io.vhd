
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
    
    dcct_adcs        : in t_dcct_adcs;
    dcct_params      : out t_dcct_adcs_params;
    mon_adcs         : in t_mon_adcs;
    mon_params       : out t_mon_adcs_params;
    dac_cntrl        : out t_dac_cntrl;
	dac_stat         : in t_dac_stat;
	ss_buf_stat      : in t_snapshot_stat;
	evr_params       : out t_evr_params;
	evr_trigs        : in t_evr_trigs;  
	rcom             : out std_logic_vector(19 downto 0);
	rsts             : in std_logic_vector(19 downto 0);
	fault_stat       : in t_fault_stat;
	fault_params     : out t_fault_params
     
  );
end ps_io;


architecture behv of ps_io is

  

  
  signal reg_i           : t_addrmap_pl_regs_in;
  signal reg_o           : t_addrmap_pl_regs_out;
  
  signal soft_trig       : std_logic;
  signal soft_trig_prev  : std_logic;
  
  signal flt_trig        : std_logic_vector(3 downto 0);
  signal err_trig        : std_logic_vector(3 downto 0);
  signal inj_trig        : std_logic_vector(3 downto 0);  
  signal evr_trig        : std_logic;

  signal flt_trig_prev   : std_logic_vector(3 downto 0);
  signal err_trig_prev   : std_logic_vector(3 downto 0);
  signal inj_trig_prev   : std_logic_vector(3 downto 0);  
  signal evr_trig_prev   : std_logic;

  
  attribute mark_debug     : string;
  attribute mark_debug of dac_cntrl: signal is "true";
--  attribute mark_debug of soft_trig_prev: signal is "true";  
--  attribute mark_debug of reg_i: signal is "true";
--  attribute mark_debug of ss_buf_stat: signal is "true";
--  attribute mark_debug of flt_trig: signal is "true";
--  attribute mark_debug of flt_trig_prev: signal is "true";  
--  attribute mark_debug of err_trig: signal is "true";
--  attribute mark_debug of err_trig_prev: signal is "true"; 
--  attribute mark_debug of evr_trig: signal is "true";
--  attribute mark_debug of evr_trig_prev: signal is "true"; 

begin


-- Global Registers

reg_i.fpgaver.val.data <= std_logic_vector(to_unsigned(FPGA_VERSION,32));
reg_i.evr_ts_s.val.data <= evr_trigs.ts_s;
reg_i.evr_ts_ns.val.data <= evr_trigs.ts_ns; 
evr_params.reset <= reg_o.evr_reset.val.data;
evr_params.inj_eventno <= reg_o.evr_inj_eventno.val.data;
evr_params.pm_eventno <= reg_o.evr_pm_eventno.val.data;




-- PS1 Registers

-- DCCT and Monitor ADC slow readbacks and gains & offsets
reg_i.ps1_dcct0.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps1.dcct0), 32));
reg_i.ps1_dcct1.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps1.dcct1), 32));
reg_i.ps1_dacmon.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.dacmon), 32));
reg_i.ps1_volt.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.voltage), 32));
reg_i.ps1_gnd.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.ignd), 32));
reg_i.ps1_spare.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.spare), 32));
reg_i.ps1_reg.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.ps_reg), 32));
reg_i.ps1_err.val.data <= std_logic_vector(resize(signed(mon_adcs.ps1.ps_error), 32));

dcct_params.ps1.dcct0_offset <= signed(reg_o.ps1_dcct0_offset.val.data(19 downto 0)); 
dcct_params.ps1.dcct0_gain <= signed(reg_o.ps1_dcct0_gain.val.data(23 downto 0)); 
dcct_params.ps1.dcct1_offset <= signed(reg_o.ps1_dcct1_offset.val.data(19 downto 0)); 
dcct_params.ps1.dcct1_gain <= signed(reg_o.ps1_dcct1_gain.val.data(23 downto 0)); 
mon_params.ps1.dacmon_offset <= signed(reg_o.ps1_dacmon_offset.val.data(15 downto 0)); 
mon_params.ps1.dacmon_gain <= signed(reg_o.ps1_dacmon_gain.val.data(23 downto 0)); 
mon_params.ps1.voltage_offset <= signed(reg_o.ps1_volt_offset.val.data(15 downto 0)); 
mon_params.ps1.voltage_gain <= signed(reg_o.ps1_volt_gain.val.data(23 downto 0));
mon_params.ps1.ignd_offset <= signed(reg_o.ps1_gnd_offset.val.data(15 downto 0)); 
mon_params.ps1.ignd_gain <= signed(reg_o.ps1_gnd_gain.val.data(23 downto 0));
mon_params.ps1.spare_offset <= signed(reg_o.ps1_spare_offset.val.data(15 downto 0)); 
mon_params.ps1.spare_gain <= signed(reg_o.ps1_spare_gain.val.data(23 downto 0));
mon_params.ps1.ps_reg_offset <= signed(reg_o.ps1_reg_offset.val.data(15 downto 0)); 
mon_params.ps1.ps_reg_gain <= signed(reg_o.ps1_reg_gain.val.data(23 downto 0));
mon_params.ps1.ps_error_offset <= signed(reg_o.ps1_err_offset.val.data(15 downto 0)); 
mon_params.ps1.ps_error_gain <= signed(reg_o.ps1_err_gain.val.data(23 downto 0));

-- DAC control and Ramp Tables and status
dac_cntrl.ps1.offset <= signed(reg_o.ps1_dac_setpt_offset.val.data(19 downto 0)); 
dac_cntrl.ps1.gain <= signed(reg_o.ps1_dac_setpt_gain.val.data(23 downto 0)); 
dac_cntrl.ps1.setpoint <= reg_o.ps1_dac_setpt.val.data;
dac_cntrl.ps1.mode <= reg_o.ps1_dac_opmode.val.data;
dac_cntrl.ps1.cntrl <= reg_o.ps1_dac_cntrl.val.data;
dac_cntrl.ps1.reset <= reg_o.ps1_dac_reset.val.data(0);
dac_cntrl.ps1.ramplen <= reg_o.ps1_dac_ramplen.val.data;
dac_cntrl.ps1.dpram_addr <= reg_o.ps1_dac_rampaddr.val.data;
dac_cntrl.ps1.dpram_data <= reg_o.ps1_dac_rampdata.val.data;
dac_cntrl.ps1.dpram_we <= reg_o.ps1_dac_rampdata.val.swacc;
dac_cntrl.ps1.ramprun <= reg_o.ps1_dac_runramp.val.swacc; --data(0);

reg_i.ps1_dac_rampactive.val.data(0) <= dac_stat.ps1.active;
reg_i.ps1_dac_currsetpt.val.data <= std_logic_vector(resize(signed(dac_stat.ps1.dac_setpt),32));


-- Digital Outputs
rcom(0) <= reg_o.ps1_digout_on1.val.data(0);
rcom(1) <= reg_o.ps1_digout_on2.val.data(0);
rcom(2) <= reg_o.ps1_digout_reset.val.data(0);
rcom(3) <= reg_o.ps1_digout_spare.val.data(0);
rcom(16) <= reg_o.ps1_digout_park.val.data(0);

-- Digital Inputs
reg_i.ps1_digin.val.data <= rsts(16) & rsts(3 downto 0);


--Fault Threasholds and Counter Limits
fault_params.ps1.clear <= reg_o.ps1_fault_clear.val.data(0);
fault_params.ps1.enable <= reg_o.ps1_fault_mask.val.data;
fault_params.ps1.ovc1_thresh <= reg_o.ps1_ovc1_thresh.val.data;
fault_params.ps1.ovc2_thresh <= reg_o.ps1_ovc2_thresh.val.data;
fault_params.ps1.ovv_thresh <= reg_o.ps1_ovv_thresh.val.data;
fault_params.ps1.err1_thresh <= reg_o.ps1_err1_thresh.val.data;
fault_params.ps1.err2_thresh <= reg_o.ps1_err2_thresh.val.data;
fault_params.ps1.ignd_thresh <= reg_o.ps1_ignd_thresh.val.data;
fault_params.ps1.ovc1_cntlim <= reg_o.ps1_ovc1_cntlim.val.data;
fault_params.ps1.ovc2_cntlim <= reg_o.ps1_ovc2_cntlim.val.data;
fault_params.ps1.ovv_cntlim <= reg_o.ps1_ovv_cntlim.val.data;
fault_params.ps1.err1_cntlim <= reg_o.ps1_err1_cntlim.val.data;
fault_params.ps1.err2_cntlim <= reg_o.ps1_err2_cntlim.val.data;
fault_params.ps1.ignd_cntlim <= reg_o.ps1_ignd_cntlim.val.data;
fault_params.ps1.flt1_cntlim <= reg_o.ps1_flt1_cntlim.val.data;
fault_params.ps1.flt2_cntlim <= reg_o.ps1_flt2_cntlim.val.data;
fault_params.ps1.flt3_cntlim <= reg_o.ps1_flt3_cntlim.val.data;
fault_params.ps1.on_cntlim <= reg_o.ps1_on_cntlim.val.data;
fault_params.ps1.heart_cntlim <= reg_o.ps1_heartbeat_cntlim.val.data;

reg_i.ps1_faults_live.val.data <= fault_stat.ps1.live;
reg_i.ps1_faults_lat.val.data <= fault_stat.ps1.lat;



-- PS2 Registers

-- DCCT and Monitor ADC slow readbacks and gains & offsets
reg_i.ps2_dcct0.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps2.dcct0), 32));
reg_i.ps2_dcct1.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps2.dcct1), 32));
reg_i.ps2_dacmon.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.dacmon), 32));
reg_i.ps2_volt.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.voltage), 32));
reg_i.ps2_gnd.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.ignd), 32));
reg_i.ps2_spare.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.spare), 32));
reg_i.ps2_reg.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.ps_reg), 32));
reg_i.ps2_err.val.data <= std_logic_vector(resize(signed(mon_adcs.ps2.ps_error), 32));

dcct_params.ps2.dcct0_offset <= signed(reg_o.ps2_dcct0_offset.val.data(19 downto 0)); 
dcct_params.ps2.dcct0_gain <= signed(reg_o.ps2_dcct0_gain.val.data(23 downto 0)); 
dcct_params.ps2.dcct1_offset <= signed(reg_o.ps2_dcct1_offset.val.data(19 downto 0)); 
dcct_params.ps2.dcct1_gain <= signed(reg_o.ps2_dcct1_gain.val.data(23 downto 0)); 
mon_params.ps2.dacmon_offset <= signed(reg_o.ps2_dacmon_offset.val.data(15 downto 0)); 
mon_params.ps2.dacmon_gain <= signed(reg_o.ps2_dacmon_gain.val.data(23 downto 0)); 
mon_params.ps2.voltage_offset <= signed(reg_o.ps2_volt_offset.val.data(15 downto 0)); 
mon_params.ps2.voltage_gain <= signed(reg_o.ps2_volt_gain.val.data(23 downto 0));
mon_params.ps2.ignd_offset <= signed(reg_o.ps2_gnd_offset.val.data(15 downto 0)); 
mon_params.ps2.ignd_gain <= signed(reg_o.ps2_gnd_gain.val.data(23 downto 0));
mon_params.ps2.spare_offset <= signed(reg_o.ps2_spare_offset.val.data(15 downto 0)); 
mon_params.ps2.spare_gain <= signed(reg_o.ps2_spare_gain.val.data(23 downto 0));
mon_params.ps2.ps_reg_offset <= signed(reg_o.ps2_reg_offset.val.data(15 downto 0)); 
mon_params.ps2.ps_reg_gain <= signed(reg_o.ps2_reg_gain.val.data(23 downto 0));
mon_params.ps2.ps_error_offset <= signed(reg_o.ps2_err_offset.val.data(15 downto 0)); 
mon_params.ps2.ps_error_gain <= signed(reg_o.ps2_err_gain.val.data(23 downto 0));

-- DAC control and Ramp Tables and status
dac_cntrl.ps2.offset <= signed(reg_o.ps2_dac_setpt_offset.val.data(19 downto 0)); 
dac_cntrl.ps2.gain <= signed(reg_o.ps2_dac_setpt_gain.val.data(23 downto 0)); 
dac_cntrl.ps2.setpoint <= reg_o.ps2_dac_setpt.val.data;
dac_cntrl.ps2.mode <= reg_o.ps2_dac_opmode.val.data;
dac_cntrl.ps2.cntrl <= reg_o.ps2_dac_cntrl.val.data;
dac_cntrl.ps2.reset <= reg_o.ps2_dac_reset.val.data(0);
dac_cntrl.ps2.ramplen <= reg_o.ps2_dac_ramplen.val.data;
dac_cntrl.ps2.dpram_addr <= reg_o.ps2_dac_rampaddr.val.data;
dac_cntrl.ps2.dpram_data <= reg_o.ps2_dac_rampdata.val.data;
dac_cntrl.ps2.dpram_we <= reg_o.ps2_dac_rampdata.val.swacc;
dac_cntrl.ps2.ramprun <= reg_o.ps2_dac_runramp.val.swacc; --data(0);

reg_i.ps2_dac_rampactive.val.data(0) <= dac_stat.ps2.active;
reg_i.ps2_dac_currsetpt.val.data <= std_logic_vector(resize(signed(dac_stat.ps2.dac_setpt),32));

-- Digital Outputs
rcom(4) <= reg_o.ps2_digout_on1.val.data(0);
rcom(5) <= reg_o.ps2_digout_on2.val.data(0);
rcom(6) <= reg_o.ps2_digout_reset.val.data(0);
rcom(7) <= reg_o.ps2_digout_spare.val.data(0);
rcom(17) <= reg_o.ps2_digout_park.val.data(0);

-- Digital Inputs
reg_i.ps2_digin.val.data <= rsts(17) & rsts(7 downto 4);


--Fault Threasholds and Counter Limits
fault_params.ps2.clear <= reg_o.ps2_fault_clear.val.data(0);
fault_params.ps2.enable <= reg_o.ps2_fault_mask.val.data;
fault_params.ps2.ovc1_thresh <= reg_o.ps2_ovc1_thresh.val.data;
fault_params.ps2.ovc2_thresh <= reg_o.ps2_ovc2_thresh.val.data;
fault_params.ps2.ovv_thresh <= reg_o.ps2_ovv_thresh.val.data;
fault_params.ps2.err1_thresh <= reg_o.ps2_err1_thresh.val.data;
fault_params.ps2.err2_thresh <= reg_o.ps2_err2_thresh.val.data;
fault_params.ps2.ignd_thresh <= reg_o.ps2_ignd_thresh.val.data;
fault_params.ps2.ovc1_cntlim <= reg_o.ps2_ovc1_cntlim.val.data;
fault_params.ps2.ovc2_cntlim <= reg_o.ps2_ovc2_cntlim.val.data;
fault_params.ps2.ovv_cntlim <= reg_o.ps2_ovv_cntlim.val.data;
fault_params.ps2.err1_cntlim <= reg_o.ps2_err1_cntlim.val.data;
fault_params.ps2.err2_cntlim <= reg_o.ps2_err2_cntlim.val.data;
fault_params.ps2.ignd_cntlim <= reg_o.ps2_ignd_cntlim.val.data;
fault_params.ps2.flt1_cntlim <= reg_o.ps2_flt1_cntlim.val.data;
fault_params.ps2.flt2_cntlim <= reg_o.ps2_flt2_cntlim.val.data;
fault_params.ps2.flt3_cntlim <= reg_o.ps2_flt3_cntlim.val.data;
fault_params.ps2.on_cntlim <= reg_o.ps2_on_cntlim.val.data;
fault_params.ps2.heart_cntlim <= reg_o.ps2_heartbeat_cntlim.val.data;

reg_i.ps2_faults_live.val.data <= fault_stat.ps2.live;
reg_i.ps2_faults_lat.val.data <= fault_stat.ps2.lat;






-- PS3 Registers

-- DCCT and Monitor ADC slow readbacks and gains & offsets
reg_i.ps3_dcct0.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps3.dcct0), 32));
reg_i.ps3_dcct1.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps3.dcct1), 32));
reg_i.ps3_dacmon.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.dacmon), 32));
reg_i.ps3_volt.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.voltage), 32));
reg_i.ps3_gnd.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.ignd), 32));
reg_i.ps3_spare.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.spare), 32));
reg_i.ps3_reg.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.ps_reg), 32));
reg_i.ps3_err.val.data <= std_logic_vector(resize(signed(mon_adcs.ps3.ps_error), 32));

dcct_params.ps3.dcct0_offset <= signed(reg_o.ps3_dcct0_offset.val.data(19 downto 0)); 
dcct_params.ps3.dcct0_gain <= signed(reg_o.ps3_dcct0_gain.val.data(23 downto 0)); 
dcct_params.ps3.dcct1_offset <= signed(reg_o.ps3_dcct1_offset.val.data(19 downto 0)); 
dcct_params.ps3.dcct1_gain <= signed(reg_o.ps3_dcct1_gain.val.data(23 downto 0)); 
mon_params.ps3.dacmon_offset <= signed(reg_o.ps3_dacmon_offset.val.data(15 downto 0)); 
mon_params.ps3.dacmon_gain <= signed(reg_o.ps3_dacmon_gain.val.data(23 downto 0)); 
mon_params.ps3.voltage_offset <= signed(reg_o.ps3_volt_offset.val.data(15 downto 0)); 
mon_params.ps3.voltage_gain <= signed(reg_o.ps3_volt_gain.val.data(23 downto 0));
mon_params.ps3.ignd_offset <= signed(reg_o.ps3_gnd_offset.val.data(15 downto 0)); 
mon_params.ps3.ignd_gain <= signed(reg_o.ps3_gnd_gain.val.data(23 downto 0));
mon_params.ps3.spare_offset <= signed(reg_o.ps3_spare_offset.val.data(15 downto 0)); 
mon_params.ps3.spare_gain <= signed(reg_o.ps3_spare_gain.val.data(23 downto 0));
mon_params.ps3.ps_reg_offset <= signed(reg_o.ps3_reg_offset.val.data(15 downto 0)); 
mon_params.ps3.ps_reg_gain <= signed(reg_o.ps3_reg_gain.val.data(23 downto 0));
mon_params.ps3.ps_error_offset <= signed(reg_o.ps3_err_offset.val.data(15 downto 0)); 
mon_params.ps3.ps_error_gain <= signed(reg_o.ps3_err_gain.val.data(23 downto 0));

-- DAC control and Ramp Tables and status
dac_cntrl.ps3.offset <= signed(reg_o.ps3_dac_setpt_offset.val.data(19 downto 0)); 
dac_cntrl.ps3.gain <= signed(reg_o.ps3_dac_setpt_gain.val.data(23 downto 0)); 
dac_cntrl.ps3.setpoint <= reg_o.ps3_dac_setpt.val.data;
dac_cntrl.ps3.mode <= reg_o.ps3_dac_opmode.val.data;
dac_cntrl.ps3.cntrl <= reg_o.ps3_dac_cntrl.val.data;
dac_cntrl.ps3.reset <= reg_o.ps3_dac_reset.val.data(0);
dac_cntrl.ps3.ramplen <= reg_o.ps3_dac_ramplen.val.data;
dac_cntrl.ps3.dpram_addr <= reg_o.ps3_dac_rampaddr.val.data;
dac_cntrl.ps3.dpram_data <= reg_o.ps3_dac_rampdata.val.data;
dac_cntrl.ps3.dpram_we <= reg_o.ps3_dac_rampdata.val.swacc;
dac_cntrl.ps3.ramprun <= reg_o.ps3_dac_runramp.val.swacc; --data(0);

reg_i.ps3_dac_rampactive.val.data(0) <= dac_stat.ps3.active;
reg_i.ps3_dac_currsetpt.val.data <= std_logic_vector(resize(signed(dac_stat.ps3.dac_setpt),32));

-- Digital Outputs
rcom(8) <= reg_o.ps3_digout_on1.val.data(0);
rcom(9) <= reg_o.ps3_digout_on2.val.data(0);
rcom(10) <= reg_o.ps3_digout_reset.val.data(0);
rcom(11) <= reg_o.ps3_digout_spare.val.data(0);
rcom(18) <= reg_o.ps3_digout_park.val.data(0);

-- Digital Inputs
reg_i.ps3_digin.val.data <= rsts(18) & rsts(11 downto 8);


--Fault Threasholds and Counter Limits
fault_params.ps3.clear <= reg_o.ps3_fault_clear.val.data(0);
fault_params.ps3.enable <= reg_o.ps3_fault_mask.val.data;
fault_params.ps3.ovc1_thresh <= reg_o.ps3_ovc1_thresh.val.data;
fault_params.ps3.ovc2_thresh <= reg_o.ps3_ovc2_thresh.val.data;
fault_params.ps3.ovv_thresh <= reg_o.ps3_ovv_thresh.val.data;
fault_params.ps3.err1_thresh <= reg_o.ps3_err1_thresh.val.data;
fault_params.ps3.err2_thresh <= reg_o.ps3_err2_thresh.val.data;
fault_params.ps3.ignd_thresh <= reg_o.ps3_ignd_thresh.val.data;
fault_params.ps3.ovc1_cntlim <= reg_o.ps3_ovc1_cntlim.val.data;
fault_params.ps3.ovc2_cntlim <= reg_o.ps3_ovc2_cntlim.val.data;
fault_params.ps3.ovv_cntlim <= reg_o.ps3_ovv_cntlim.val.data;
fault_params.ps3.err1_cntlim <= reg_o.ps3_err1_cntlim.val.data;
fault_params.ps3.err2_cntlim <= reg_o.ps3_err2_cntlim.val.data;
fault_params.ps3.ignd_cntlim <= reg_o.ps3_ignd_cntlim.val.data;
fault_params.ps3.flt1_cntlim <= reg_o.ps3_flt1_cntlim.val.data;
fault_params.ps3.flt2_cntlim <= reg_o.ps3_flt2_cntlim.val.data;
fault_params.ps3.flt3_cntlim <= reg_o.ps3_flt3_cntlim.val.data;
fault_params.ps3.on_cntlim <= reg_o.ps3_on_cntlim.val.data;
fault_params.ps3.heart_cntlim <= reg_o.ps3_heartbeat_cntlim.val.data;

reg_i.ps3_faults_live.val.data <= fault_stat.ps3.live;
reg_i.ps3_faults_lat.val.data <= fault_stat.ps3.lat;









-- PS4 Registers

-- DCCT and Monitor ADC slow readbacks and gains & offsets
reg_i.ps4_dcct0.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps4.dcct0), 32));
reg_i.ps4_dcct1.val.data <= std_logic_vector(resize(signed(dcct_adcs.ps4.dcct1), 32));
reg_i.ps4_dacmon.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.dacmon), 32));
reg_i.ps4_volt.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.voltage), 32));
reg_i.ps4_gnd.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.ignd), 32));
reg_i.ps4_spare.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.spare), 32));
reg_i.ps4_reg.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.ps_reg), 32));
reg_i.ps4_err.val.data <= std_logic_vector(resize(signed(mon_adcs.ps4.ps_error), 32));

dcct_params.ps4.dcct0_offset <= signed(reg_o.ps4_dcct0_offset.val.data(19 downto 0)); 
dcct_params.ps4.dcct0_gain <= signed(reg_o.ps4_dcct0_gain.val.data(23 downto 0)); 
dcct_params.ps4.dcct1_offset <= signed(reg_o.ps4_dcct1_offset.val.data(19 downto 0)); 
dcct_params.ps4.dcct1_gain <= signed(reg_o.ps4_dcct1_gain.val.data(23 downto 0)); 
mon_params.ps4.dacmon_offset <= signed(reg_o.ps4_dacmon_offset.val.data(15 downto 0)); 
mon_params.ps4.dacmon_gain <= signed(reg_o.ps4_dacmon_gain.val.data(23 downto 0)); 
mon_params.ps4.voltage_offset <= signed(reg_o.ps4_volt_offset.val.data(15 downto 0)); 
mon_params.ps4.voltage_gain <= signed(reg_o.ps4_volt_gain.val.data(23 downto 0));
mon_params.ps4.ignd_offset <= signed(reg_o.ps4_gnd_offset.val.data(15 downto 0)); 
mon_params.ps4.ignd_gain <= signed(reg_o.ps4_gnd_gain.val.data(23 downto 0));
mon_params.ps4.spare_offset <= signed(reg_o.ps4_spare_offset.val.data(15 downto 0)); 
mon_params.ps4.spare_gain <= signed(reg_o.ps4_spare_gain.val.data(23 downto 0));
mon_params.ps4.ps_reg_offset <= signed(reg_o.ps4_reg_offset.val.data(15 downto 0)); 
mon_params.ps4.ps_reg_gain <= signed(reg_o.ps4_reg_gain.val.data(23 downto 0));
mon_params.ps4.ps_error_offset <= signed(reg_o.ps4_err_offset.val.data(15 downto 0)); 
mon_params.ps4.ps_error_gain <= signed(reg_o.ps4_err_gain.val.data(23 downto 0));

-- DAC control and Ramp Tables and status
dac_cntrl.ps4.offset <= signed(reg_o.ps4_dac_setpt_offset.val.data(19 downto 0)); 
dac_cntrl.ps4.gain <= signed(reg_o.ps4_dac_setpt_gain.val.data(23 downto 0)); 
dac_cntrl.ps4.setpoint <= reg_o.ps4_dac_setpt.val.data;
dac_cntrl.ps4.mode <= reg_o.ps4_dac_opmode.val.data;
dac_cntrl.ps4.cntrl <= reg_o.ps4_dac_cntrl.val.data;
dac_cntrl.ps4.reset <= reg_o.ps4_dac_reset.val.data(0);
dac_cntrl.ps4.ramplen <= reg_o.ps4_dac_ramplen.val.data;
dac_cntrl.ps4.dpram_addr <= reg_o.ps4_dac_rampaddr.val.data;
dac_cntrl.ps4.dpram_data <= reg_o.ps4_dac_rampdata.val.data;
dac_cntrl.ps4.dpram_we <= reg_o.ps4_dac_rampdata.val.swacc;
dac_cntrl.ps4.ramprun <= reg_o.ps4_dac_runramp.val.swacc; --data(0);

reg_i.ps4_dac_rampactive.val.data(0) <= dac_stat.ps4.active;
reg_i.ps4_dac_currsetpt.val.data <= std_logic_vector(resize(signed(dac_stat.ps4.dac_setpt),32));

-- Digital Outputs
rcom(12) <= reg_o.ps4_digout_on1.val.data(0);
rcom(13) <= reg_o.ps4_digout_on2.val.data(0);
rcom(14) <= reg_o.ps4_digout_reset.val.data(0);
rcom(15) <= reg_o.ps4_digout_spare.val.data(0);
rcom(19) <= reg_o.ps4_digout_park.val.data(0);

-- Digital Inputs
reg_i.ps4_digin.val.data <= rsts(19) & rsts(15 downto 12);


--Fault Threasholds and Counter Limits
fault_params.ps4.clear <= reg_o.ps4_fault_clear.val.data(0);
fault_params.ps4.enable <= reg_o.ps4_fault_mask.val.data;
fault_params.ps4.ovc1_thresh <= reg_o.ps4_ovc1_thresh.val.data;
fault_params.ps4.ovc2_thresh <= reg_o.ps4_ovc2_thresh.val.data;
fault_params.ps4.ovv_thresh <= reg_o.ps4_ovv_thresh.val.data;
fault_params.ps4.err1_thresh <= reg_o.ps4_err1_thresh.val.data;
fault_params.ps4.err2_thresh <= reg_o.ps4_err2_thresh.val.data;
fault_params.ps4.ignd_thresh <= reg_o.ps4_ignd_thresh.val.data;
fault_params.ps4.ovc1_cntlim <= reg_o.ps4_ovc1_cntlim.val.data;
fault_params.ps4.ovc2_cntlim <= reg_o.ps4_ovc2_cntlim.val.data;
fault_params.ps4.ovv_cntlim <= reg_o.ps4_ovv_cntlim.val.data;
fault_params.ps4.err1_cntlim <= reg_o.ps4_err1_cntlim.val.data;
fault_params.ps4.err2_cntlim <= reg_o.ps4_err2_cntlim.val.data;
fault_params.ps4.ignd_cntlim <= reg_o.ps4_ignd_cntlim.val.data;
fault_params.ps4.flt1_cntlim <= reg_o.ps4_flt1_cntlim.val.data;
fault_params.ps4.flt2_cntlim <= reg_o.ps4_flt2_cntlim.val.data;
fault_params.ps4.flt3_cntlim <= reg_o.ps4_flt3_cntlim.val.data;
fault_params.ps4.on_cntlim <= reg_o.ps4_on_cntlim.val.data;
fault_params.ps4.heart_cntlim <= reg_o.ps4_heartbeat_cntlim.val.data;

reg_i.ps4_faults_live.val.data <= fault_stat.ps4.live;
reg_i.ps4_faults_lat.val.data <= fault_stat.ps4.lat;










-- Snapshot buffer stats
reg_i.snapshot_addrptr.val.data <= ss_buf_stat.addr_ptr;
reg_i.snapshot_totaltrigs.val.data <= ss_buf_stat.tenkhzcnt;


-- user issues a soft trigger, latch the current snapshot buffer address
soft_trig <= reg_o.softtrig.val.data(0);
flt_trig(0) <= reg_o.testtrig.val.data(0) or fault_stat.ps1.flt_trig;
flt_trig(1) <= reg_o.testtrig.val.data(1) or fault_stat.ps2.flt_trig;
flt_trig(2) <= reg_o.testtrig.val.data(2) or fault_stat.ps3.flt_trig;
flt_trig(3) <= reg_o.testtrig.val.data(3) or fault_stat.ps4.flt_trig;
err_trig(0) <= reg_o.testtrig.val.data(4) or fault_stat.ps1.err_trig;
err_trig(1) <= reg_o.testtrig.val.data(5) or fault_stat.ps2.err_trig;
err_trig(2) <= reg_o.testtrig.val.data(6) or fault_stat.ps3.err_trig;
err_trig(3) <= reg_o.testtrig.val.data(7) or fault_stat.ps4.err_trig;
inj_trig(0) <= reg_o.testtrig.val.data(8); --or fault_stat.ps1.err_trig;
inj_trig(1) <= reg_o.testtrig.val.data(9); --or fault_stat.ps2.err_trig;
inj_trig(2) <= reg_o.testtrig.val.data(10); --or fault_stat.ps3.err_trig;
inj_trig(3) <= reg_o.testtrig.val.data(11); --or fault_stat.ps4.err_trig;
evr_trig    <= reg_o.testtrig.val.data(12);



-- latch the buffer address and timestamp on trigger.
process (pl_clock)
begin
  if (rising_edge(pl_clock)) then
    if (pl_reset = '1') then
      reg_i.softtrig_bufptr.val.data <= 32d"0";
      reg_i.flt1trig_bufptr.val.data <= 32d"0";
      reg_i.flt2trig_bufptr.val.data <= 32d"0";  
      reg_i.flt3trig_bufptr.val.data <= 32d"0";
      reg_i.flt4trig_bufptr.val.data <= 32d"0";  
      reg_i.err1trig_bufptr.val.data <= 32d"0";
      reg_i.err2trig_bufptr.val.data <= 32d"0";  
      reg_i.err3trig_bufptr.val.data <= 32d"0";
      reg_i.err4trig_bufptr.val.data <= 32d"0";   
      reg_i.inj1trig_bufptr.val.data <= 32d"0";
      reg_i.inj2trig_bufptr.val.data <= 32d"0";  
      reg_i.inj3trig_bufptr.val.data <= 32d"0";
      reg_i.inj4trig_bufptr.val.data <= 32d"0";            
      reg_i.evrtrig_bufptr.val.data  <= 32d"0";                   
    else    
      soft_trig_prev <= soft_trig;
      flt_trig_prev <= flt_trig;
      err_trig_prev <= err_trig;
      inj_trig_prev <= inj_trig;
      evr_trig_prev <= evr_trig;
      
      if (soft_trig = '1' and soft_trig_prev = '0') then     
        reg_i.softtrig_bufptr.val.data <= ss_buf_stat.addr_ptr;
        reg_i.softtrig_ts_s.val.data <= evr_trigs.ts_s; 
        reg_i.softtrig_ts_ns.val.data <= evr_trigs.ts_ns;         
      end if;
      if (flt_trig(0) = '1' and flt_trig_prev(0) = '0') then
        reg_i.flt1trig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.flt1trig_ts_s.val.data <= evr_trigs.ts_s; 
        reg_i.flt1trig_ts_ns.val.data <= evr_trigs.ts_ns;                  
      end if;
      if (flt_trig(1) = '1' and flt_trig_prev(1) = '0') then
        reg_i.flt2trig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.flt2trig_ts_s.val.data <= evr_trigs.ts_s; 
        reg_i.flt2trig_ts_ns.val.data <= evr_trigs.ts_ns;                  
      end if;      
      if (flt_trig(2) = '1' and flt_trig_prev(2) = '0') then
        reg_i.flt3trig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.flt3trig_ts_s.val.data <= evr_trigs.ts_s; 
        reg_i.flt3trig_ts_ns.val.data <= evr_trigs.ts_ns;                
      end if;
      if (flt_trig(3) = '1' and flt_trig_prev(3) = '0') then
        reg_i.flt4trig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.flt4trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.flt4trig_ts_ns.val.data <= evr_trigs.ts_ns;                         
      end if;        
      if (err_trig(0) = '1' and err_trig_prev(0) = '0') then
        reg_i.err1trig_bufptr.val.data <= ss_buf_stat.addr_ptr; 
        reg_i.err1trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.err1trig_ts_ns.val.data <= evr_trigs.ts_ns;                           
      end if;
      if (err_trig(1) = '1' and err_trig_prev(1) = '0') then
        reg_i.err2trig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.err2trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.err2trig_ts_ns.val.data <= evr_trigs.ts_ns;                         
      end if;      
      if (err_trig(2) = '1' and err_trig_prev(2) = '0') then
        reg_i.err3trig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.err3trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.err3trig_ts_ns.val.data <= evr_trigs.ts_ns;                 
      end if;
      if (err_trig(3) = '1' and err_trig_prev(3) = '0') then
        reg_i.err4trig_bufptr.val.data <= ss_buf_stat.addr_ptr;   
        reg_i.err4trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.err4trig_ts_ns.val.data <= evr_trigs.ts_ns;                 
      end if;  
      if (inj_trig(0) = '1' and inj_trig_prev(0) = '0') then
        reg_i.inj1trig_bufptr.val.data <= ss_buf_stat.addr_ptr; 
        reg_i.inj1trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.inj1trig_ts_ns.val.data <= evr_trigs.ts_ns;                           
      end if;
      if (inj_trig(1) = '1' and inj_trig_prev(1) = '0') then
        reg_i.inj2trig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.inj2trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.inj2trig_ts_ns.val.data <= evr_trigs.ts_ns;                         
      end if;      
      if (inj_trig(2) = '1' and inj_trig_prev(2) = '0') then
        reg_i.inj3trig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.inj3trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.inj3trig_ts_ns.val.data <= evr_trigs.ts_ns;                 
      end if;
      if (inj_trig(3) = '1' and inj_trig_prev(3) = '0') then
        reg_i.inj4trig_bufptr.val.data <= ss_buf_stat.addr_ptr;   
        reg_i.inj4trig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.inj4trig_ts_ns.val.data <= evr_trigs.ts_ns;                 
      end if;        
      if (evr_trig = '1' and evr_trig_prev = '0') then
        reg_i.evrtrig_bufptr.val.data <= ss_buf_stat.addr_ptr;  
        reg_i.evrtrig_ts_s.val.data <= evr_trigs.ts_s;
        reg_i.evrtrig_ts_ns.val.data <= evr_trigs.ts_ns;                  
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
