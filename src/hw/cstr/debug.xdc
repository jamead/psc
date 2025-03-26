

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list sys/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {write_dacs/state[0]} {write_dacs/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 20 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {write_dacs/ramp_dac_setpt[0]} {write_dacs/ramp_dac_setpt[1]} {write_dacs/ramp_dac_setpt[2]} {write_dacs/ramp_dac_setpt[3]} {write_dacs/ramp_dac_setpt[4]} {write_dacs/ramp_dac_setpt[5]} {write_dacs/ramp_dac_setpt[6]} {write_dacs/ramp_dac_setpt[7]} {write_dacs/ramp_dac_setpt[8]} {write_dacs/ramp_dac_setpt[9]} {write_dacs/ramp_dac_setpt[10]} {write_dacs/ramp_dac_setpt[11]} {write_dacs/ramp_dac_setpt[12]} {write_dacs/ramp_dac_setpt[13]} {write_dacs/ramp_dac_setpt[14]} {write_dacs/ramp_dac_setpt[15]} {write_dacs/ramp_dac_setpt[16]} {write_dacs/ramp_dac_setpt[17]} {write_dacs/ramp_dac_setpt[18]} {write_dacs/ramp_dac_setpt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 20 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {write_dacs/dac_setpt[0]} {write_dacs/dac_setpt[1]} {write_dacs/dac_setpt[2]} {write_dacs/dac_setpt[3]} {write_dacs/dac_setpt[4]} {write_dacs/dac_setpt[5]} {write_dacs/dac_setpt[6]} {write_dacs/dac_setpt[7]} {write_dacs/dac_setpt[8]} {write_dacs/dac_setpt[9]} {write_dacs/dac_setpt[10]} {write_dacs/dac_setpt[11]} {write_dacs/dac_setpt[12]} {write_dacs/dac_setpt[13]} {write_dacs/dac_setpt[14]} {write_dacs/dac_setpt[15]} {write_dacs/dac_setpt[16]} {write_dacs/dac_setpt[17]} {write_dacs/dac_setpt[18]} {write_dacs/dac_setpt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 20 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {write_dacs/dac_rddata[0]} {write_dacs/dac_rddata[1]} {write_dacs/dac_rddata[2]} {write_dacs/dac_rddata[3]} {write_dacs/dac_rddata[4]} {write_dacs/dac_rddata[5]} {write_dacs/dac_rddata[6]} {write_dacs/dac_rddata[7]} {write_dacs/dac_rddata[8]} {write_dacs/dac_rddata[9]} {write_dacs/dac_rddata[10]} {write_dacs/dac_rddata[11]} {write_dacs/dac_rddata[12]} {write_dacs/dac_rddata[13]} {write_dacs/dac_rddata[14]} {write_dacs/dac_rddata[15]} {write_dacs/dac_rddata[16]} {write_dacs/dac_rddata[17]} {write_dacs/dac_rddata[18]} {write_dacs/dac_rddata[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {write_dacs/dac_rdaddr[0]} {write_dacs/dac_rdaddr[1]} {write_dacs/dac_rdaddr[2]} {write_dacs/dac_rdaddr[3]} {write_dacs/dac_rdaddr[4]} {write_dacs/dac_rdaddr[5]} {write_dacs/dac_rdaddr[6]} {write_dacs/dac_rdaddr[7]} {write_dacs/dac_rdaddr[8]} {write_dacs/dac_rdaddr[9]} {write_dacs/dac_rdaddr[10]} {write_dacs/dac_rdaddr[11]} {write_dacs/dac_rdaddr[12]} {write_dacs/dac_rdaddr[13]} {write_dacs/dac_rdaddr[14]} {write_dacs/dac_rdaddr[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {write_dacs/dac_cntrl[ps1][ramplen][0]} {write_dacs/dac_cntrl[ps1][ramplen][1]} {write_dacs/dac_cntrl[ps1][ramplen][2]} {write_dacs/dac_cntrl[ps1][ramplen][3]} {write_dacs/dac_cntrl[ps1][ramplen][4]} {write_dacs/dac_cntrl[ps1][ramplen][5]} {write_dacs/dac_cntrl[ps1][ramplen][6]} {write_dacs/dac_cntrl[ps1][ramplen][7]} {write_dacs/dac_cntrl[ps1][ramplen][8]} {write_dacs/dac_cntrl[ps1][ramplen][9]} {write_dacs/dac_cntrl[ps1][ramplen][10]} {write_dacs/dac_cntrl[ps1][ramplen][11]} {write_dacs/dac_cntrl[ps1][ramplen][12]} {write_dacs/dac_cntrl[ps1][ramplen][13]} {write_dacs/dac_cntrl[ps1][ramplen][14]} {write_dacs/dac_cntrl[ps1][ramplen][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 16 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {write_dacs/dac_cntrl[ps1][offset][0]} {write_dacs/dac_cntrl[ps1][offset][1]} {write_dacs/dac_cntrl[ps1][offset][2]} {write_dacs/dac_cntrl[ps1][offset][3]} {write_dacs/dac_cntrl[ps1][offset][4]} {write_dacs/dac_cntrl[ps1][offset][5]} {write_dacs/dac_cntrl[ps1][offset][6]} {write_dacs/dac_cntrl[ps1][offset][7]} {write_dacs/dac_cntrl[ps1][offset][8]} {write_dacs/dac_cntrl[ps1][offset][9]} {write_dacs/dac_cntrl[ps1][offset][10]} {write_dacs/dac_cntrl[ps1][offset][11]} {write_dacs/dac_cntrl[ps1][offset][12]} {write_dacs/dac_cntrl[ps1][offset][13]} {write_dacs/dac_cntrl[ps1][offset][14]} {write_dacs/dac_cntrl[ps1][offset][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 20 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {write_dacs/dac_cntrl[ps1][setpoint][0]} {write_dacs/dac_cntrl[ps1][setpoint][1]} {write_dacs/dac_cntrl[ps1][setpoint][2]} {write_dacs/dac_cntrl[ps1][setpoint][3]} {write_dacs/dac_cntrl[ps1][setpoint][4]} {write_dacs/dac_cntrl[ps1][setpoint][5]} {write_dacs/dac_cntrl[ps1][setpoint][6]} {write_dacs/dac_cntrl[ps1][setpoint][7]} {write_dacs/dac_cntrl[ps1][setpoint][8]} {write_dacs/dac_cntrl[ps1][setpoint][9]} {write_dacs/dac_cntrl[ps1][setpoint][10]} {write_dacs/dac_cntrl[ps1][setpoint][11]} {write_dacs/dac_cntrl[ps1][setpoint][12]} {write_dacs/dac_cntrl[ps1][setpoint][13]} {write_dacs/dac_cntrl[ps1][setpoint][14]} {write_dacs/dac_cntrl[ps1][setpoint][15]} {write_dacs/dac_cntrl[ps1][setpoint][16]} {write_dacs/dac_cntrl[ps1][setpoint][17]} {write_dacs/dac_cntrl[ps1][setpoint][18]} {write_dacs/dac_cntrl[ps1][setpoint][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 2 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {write_dacs/dac_cntrl[ps1][mode][0]} {write_dacs/dac_cntrl[ps1][mode][1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 16 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {write_dacs/dac_cntrl[ps1][gain][0]} {write_dacs/dac_cntrl[ps1][gain][1]} {write_dacs/dac_cntrl[ps1][gain][2]} {write_dacs/dac_cntrl[ps1][gain][3]} {write_dacs/dac_cntrl[ps1][gain][4]} {write_dacs/dac_cntrl[ps1][gain][5]} {write_dacs/dac_cntrl[ps1][gain][6]} {write_dacs/dac_cntrl[ps1][gain][7]} {write_dacs/dac_cntrl[ps1][gain][8]} {write_dacs/dac_cntrl[ps1][gain][9]} {write_dacs/dac_cntrl[ps1][gain][10]} {write_dacs/dac_cntrl[ps1][gain][11]} {write_dacs/dac_cntrl[ps1][gain][12]} {write_dacs/dac_cntrl[ps1][gain][13]} {write_dacs/dac_cntrl[ps1][gain][14]} {write_dacs/dac_cntrl[ps1][gain][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 20 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {write_dacs/dac_cntrl[ps1][dpram_data][0]} {write_dacs/dac_cntrl[ps1][dpram_data][1]} {write_dacs/dac_cntrl[ps1][dpram_data][2]} {write_dacs/dac_cntrl[ps1][dpram_data][3]} {write_dacs/dac_cntrl[ps1][dpram_data][4]} {write_dacs/dac_cntrl[ps1][dpram_data][5]} {write_dacs/dac_cntrl[ps1][dpram_data][6]} {write_dacs/dac_cntrl[ps1][dpram_data][7]} {write_dacs/dac_cntrl[ps1][dpram_data][8]} {write_dacs/dac_cntrl[ps1][dpram_data][9]} {write_dacs/dac_cntrl[ps1][dpram_data][10]} {write_dacs/dac_cntrl[ps1][dpram_data][11]} {write_dacs/dac_cntrl[ps1][dpram_data][12]} {write_dacs/dac_cntrl[ps1][dpram_data][13]} {write_dacs/dac_cntrl[ps1][dpram_data][14]} {write_dacs/dac_cntrl[ps1][dpram_data][15]} {write_dacs/dac_cntrl[ps1][dpram_data][16]} {write_dacs/dac_cntrl[ps1][dpram_data][17]} {write_dacs/dac_cntrl[ps1][dpram_data][18]} {write_dacs/dac_cntrl[ps1][dpram_data][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 16 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {write_dacs/dac_cntrl[ps1][dpram_addr][0]} {write_dacs/dac_cntrl[ps1][dpram_addr][1]} {write_dacs/dac_cntrl[ps1][dpram_addr][2]} {write_dacs/dac_cntrl[ps1][dpram_addr][3]} {write_dacs/dac_cntrl[ps1][dpram_addr][4]} {write_dacs/dac_cntrl[ps1][dpram_addr][5]} {write_dacs/dac_cntrl[ps1][dpram_addr][6]} {write_dacs/dac_cntrl[ps1][dpram_addr][7]} {write_dacs/dac_cntrl[ps1][dpram_addr][8]} {write_dacs/dac_cntrl[ps1][dpram_addr][9]} {write_dacs/dac_cntrl[ps1][dpram_addr][10]} {write_dacs/dac_cntrl[ps1][dpram_addr][11]} {write_dacs/dac_cntrl[ps1][dpram_addr][12]} {write_dacs/dac_cntrl[ps1][dpram_addr][13]} {write_dacs/dac_cntrl[ps1][dpram_addr][14]} {write_dacs/dac_cntrl[ps1][dpram_addr][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {write_dacs/dac_cntrl[ps1][cntrl][0]} {write_dacs/dac_cntrl[ps1][cntrl][1]} {write_dacs/dac_cntrl[ps1][cntrl][2]} {write_dacs/dac_cntrl[ps1][cntrl][3]} {write_dacs/dac_cntrl[ps1][cntrl][4]} {write_dacs/dac_cntrl[ps1][cntrl][5]} {write_dacs/dac_cntrl[ps1][cntrl][6]} {write_dacs/dac_cntrl[ps1][cntrl][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 6 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {adc2ddr/wordnum[0]} {adc2ddr/wordnum[1]} {adc2ddr/wordnum[2]} {adc2ddr/wordnum[3]} {adc2ddr/wordnum[4]} {adc2ddr/wordnum[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 6 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {adc2ddr/state[0]} {adc2ddr/state[1]} {adc2ddr/state[2]} {adc2ddr/state[3]} {adc2ddr/state[4]} {adc2ddr/state[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {adc2ddr/datacnt[0]} {adc2ddr/datacnt[1]} {adc2ddr/datacnt[2]} {adc2ddr/datacnt[3]} {adc2ddr/datacnt[4]} {adc2ddr/datacnt[5]} {adc2ddr/datacnt[6]} {adc2ddr/datacnt[7]} {adc2ddr/datacnt[8]} {adc2ddr/datacnt[9]} {adc2ddr/datacnt[10]} {adc2ddr/datacnt[11]} {adc2ddr/datacnt[12]} {adc2ddr/datacnt[13]} {adc2ddr/datacnt[14]} {adc2ddr/datacnt[15]} {adc2ddr/datacnt[16]} {adc2ddr/datacnt[17]} {adc2ddr/datacnt[18]} {adc2ddr/datacnt[19]} {adc2ddr/datacnt[20]} {adc2ddr/datacnt[21]} {adc2ddr/datacnt[22]} {adc2ddr/datacnt[23]} {adc2ddr/datacnt[24]} {adc2ddr/datacnt[25]} {adc2ddr/datacnt[26]} {adc2ddr/datacnt[27]} {adc2ddr/datacnt[28]} {adc2ddr/datacnt[29]} {adc2ddr/datacnt[30]} {adc2ddr/datacnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {write_dacs/dac_cntrl[ps1][reset]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {write_dacs/dac_cntrl[ps1][ramprun]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list write_dacs/ramp_active]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {write_dacs/dac_cntrl[ps1][dpram_we]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list ps_regs/soft_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list adc2ddr/trigger]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list tenkhz_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list write_dacs/dac_rden]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sys_n_115]
