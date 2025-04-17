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
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {ps_regs/dac_cntrl[ps1][dpram_addr][0]} {ps_regs/dac_cntrl[ps1][dpram_addr][1]} {ps_regs/dac_cntrl[ps1][dpram_addr][2]} {ps_regs/dac_cntrl[ps1][dpram_addr][3]} {ps_regs/dac_cntrl[ps1][dpram_addr][4]} {ps_regs/dac_cntrl[ps1][dpram_addr][5]} {ps_regs/dac_cntrl[ps1][dpram_addr][6]} {ps_regs/dac_cntrl[ps1][dpram_addr][7]} {ps_regs/dac_cntrl[ps1][dpram_addr][8]} {ps_regs/dac_cntrl[ps1][dpram_addr][9]} {ps_regs/dac_cntrl[ps1][dpram_addr][10]} {ps_regs/dac_cntrl[ps1][dpram_addr][11]} {ps_regs/dac_cntrl[ps1][dpram_addr][12]} {ps_regs/dac_cntrl[ps1][dpram_addr][13]} {ps_regs/dac_cntrl[ps1][dpram_addr][14]} {ps_regs/dac_cntrl[ps1][dpram_addr][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 20 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {ps_regs/dac_cntrl[ps1][setpoint][0]} {ps_regs/dac_cntrl[ps1][setpoint][1]} {ps_regs/dac_cntrl[ps1][setpoint][2]} {ps_regs/dac_cntrl[ps1][setpoint][3]} {ps_regs/dac_cntrl[ps1][setpoint][4]} {ps_regs/dac_cntrl[ps1][setpoint][5]} {ps_regs/dac_cntrl[ps1][setpoint][6]} {ps_regs/dac_cntrl[ps1][setpoint][7]} {ps_regs/dac_cntrl[ps1][setpoint][8]} {ps_regs/dac_cntrl[ps1][setpoint][9]} {ps_regs/dac_cntrl[ps1][setpoint][10]} {ps_regs/dac_cntrl[ps1][setpoint][11]} {ps_regs/dac_cntrl[ps1][setpoint][12]} {ps_regs/dac_cntrl[ps1][setpoint][13]} {ps_regs/dac_cntrl[ps1][setpoint][14]} {ps_regs/dac_cntrl[ps1][setpoint][15]} {ps_regs/dac_cntrl[ps1][setpoint][16]} {ps_regs/dac_cntrl[ps1][setpoint][17]} {ps_regs/dac_cntrl[ps1][setpoint][18]} {ps_regs/dac_cntrl[ps1][setpoint][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 20 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {ps_regs/dac_cntrl[ps1][offset][0]} {ps_regs/dac_cntrl[ps1][offset][1]} {ps_regs/dac_cntrl[ps1][offset][2]} {ps_regs/dac_cntrl[ps1][offset][3]} {ps_regs/dac_cntrl[ps1][offset][4]} {ps_regs/dac_cntrl[ps1][offset][5]} {ps_regs/dac_cntrl[ps1][offset][6]} {ps_regs/dac_cntrl[ps1][offset][7]} {ps_regs/dac_cntrl[ps1][offset][8]} {ps_regs/dac_cntrl[ps1][offset][9]} {ps_regs/dac_cntrl[ps1][offset][10]} {ps_regs/dac_cntrl[ps1][offset][11]} {ps_regs/dac_cntrl[ps1][offset][12]} {ps_regs/dac_cntrl[ps1][offset][13]} {ps_regs/dac_cntrl[ps1][offset][14]} {ps_regs/dac_cntrl[ps1][offset][15]} {ps_regs/dac_cntrl[ps1][offset][16]} {ps_regs/dac_cntrl[ps1][offset][17]} {ps_regs/dac_cntrl[ps1][offset][18]} {ps_regs/dac_cntrl[ps1][offset][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {ps_regs/dac_cntrl[ps1][mode][0]} {ps_regs/dac_cntrl[ps1][mode][1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {ps_regs/dac_cntrl[ps1][ramplen][0]} {ps_regs/dac_cntrl[ps1][ramplen][1]} {ps_regs/dac_cntrl[ps1][ramplen][2]} {ps_regs/dac_cntrl[ps1][ramplen][3]} {ps_regs/dac_cntrl[ps1][ramplen][4]} {ps_regs/dac_cntrl[ps1][ramplen][5]} {ps_regs/dac_cntrl[ps1][ramplen][6]} {ps_regs/dac_cntrl[ps1][ramplen][7]} {ps_regs/dac_cntrl[ps1][ramplen][8]} {ps_regs/dac_cntrl[ps1][ramplen][9]} {ps_regs/dac_cntrl[ps1][ramplen][10]} {ps_regs/dac_cntrl[ps1][ramplen][11]} {ps_regs/dac_cntrl[ps1][ramplen][12]} {ps_regs/dac_cntrl[ps1][ramplen][13]} {ps_regs/dac_cntrl[ps1][ramplen][14]} {ps_regs/dac_cntrl[ps1][ramplen][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {ps_regs/dac_cntrl[ps1][cntrl][0]} {ps_regs/dac_cntrl[ps1][cntrl][1]} {ps_regs/dac_cntrl[ps1][cntrl][2]} {ps_regs/dac_cntrl[ps1][cntrl][3]} {ps_regs/dac_cntrl[ps1][cntrl][4]} {ps_regs/dac_cntrl[ps1][cntrl][5]} {ps_regs/dac_cntrl[ps1][cntrl][6]} {ps_regs/dac_cntrl[ps1][cntrl][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 20 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {ps_regs/dac_cntrl[ps1][dpram_data][0]} {ps_regs/dac_cntrl[ps1][dpram_data][1]} {ps_regs/dac_cntrl[ps1][dpram_data][2]} {ps_regs/dac_cntrl[ps1][dpram_data][3]} {ps_regs/dac_cntrl[ps1][dpram_data][4]} {ps_regs/dac_cntrl[ps1][dpram_data][5]} {ps_regs/dac_cntrl[ps1][dpram_data][6]} {ps_regs/dac_cntrl[ps1][dpram_data][7]} {ps_regs/dac_cntrl[ps1][dpram_data][8]} {ps_regs/dac_cntrl[ps1][dpram_data][9]} {ps_regs/dac_cntrl[ps1][dpram_data][10]} {ps_regs/dac_cntrl[ps1][dpram_data][11]} {ps_regs/dac_cntrl[ps1][dpram_data][12]} {ps_regs/dac_cntrl[ps1][dpram_data][13]} {ps_regs/dac_cntrl[ps1][dpram_data][14]} {ps_regs/dac_cntrl[ps1][dpram_data][15]} {ps_regs/dac_cntrl[ps1][dpram_data][16]} {ps_regs/dac_cntrl[ps1][dpram_data][17]} {ps_regs/dac_cntrl[ps1][dpram_data][18]} {ps_regs/dac_cntrl[ps1][dpram_data][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 24 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {ps_regs/dac_cntrl[ps1][gain][0]} {ps_regs/dac_cntrl[ps1][gain][1]} {ps_regs/dac_cntrl[ps1][gain][2]} {ps_regs/dac_cntrl[ps1][gain][3]} {ps_regs/dac_cntrl[ps1][gain][4]} {ps_regs/dac_cntrl[ps1][gain][5]} {ps_regs/dac_cntrl[ps1][gain][6]} {ps_regs/dac_cntrl[ps1][gain][7]} {ps_regs/dac_cntrl[ps1][gain][8]} {ps_regs/dac_cntrl[ps1][gain][9]} {ps_regs/dac_cntrl[ps1][gain][10]} {ps_regs/dac_cntrl[ps1][gain][11]} {ps_regs/dac_cntrl[ps1][gain][12]} {ps_regs/dac_cntrl[ps1][gain][13]} {ps_regs/dac_cntrl[ps1][gain][14]} {ps_regs/dac_cntrl[ps1][gain][15]} {ps_regs/dac_cntrl[ps1][gain][16]} {ps_regs/dac_cntrl[ps1][gain][17]} {ps_regs/dac_cntrl[ps1][gain][18]} {ps_regs/dac_cntrl[ps1][gain][19]} {ps_regs/dac_cntrl[ps1][gain][20]} {ps_regs/dac_cntrl[ps1][gain][21]} {ps_regs/dac_cntrl[ps1][gain][22]} {ps_regs/dac_cntrl[ps1][gain][23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 2 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {evr/inj_trig_sync[0]} {evr/inj_trig_sync[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {evr/evr_params[inj_eventno][0]} {evr/evr_params[inj_eventno][1]} {evr/evr_params[inj_eventno][2]} {evr/evr_params[inj_eventno][3]} {evr/evr_params[inj_eventno][4]} {evr/evr_params[inj_eventno][5]} {evr/evr_params[inj_eventno][6]} {evr/evr_params[inj_eventno][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {evr/evr_params[pm_eventno][0]} {evr/evr_params[pm_eventno][1]} {evr/evr_params[pm_eventno][2]} {evr/evr_params[pm_eventno][3]} {evr/evr_params[pm_eventno][4]} {evr/evr_params[pm_eventno][5]} {evr/evr_params[pm_eventno][6]} {evr/evr_params[pm_eventno][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 8 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {evr/evr_params[reset][0]} {evr/evr_params[reset][1]} {evr/evr_params[reset][2]} {evr/evr_params[reset][3]} {evr/evr_params[reset][4]} {evr/evr_params[reset][5]} {evr/evr_params[reset][6]} {evr/evr_params[reset][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {write_dacs/dac1/dac_cntrl[cntrl][0]} {write_dacs/dac1/dac_cntrl[cntrl][1]} {write_dacs/dac1/dac_cntrl[cntrl][2]} {write_dacs/dac1/dac_cntrl[cntrl][3]} {write_dacs/dac1/dac_cntrl[cntrl][4]} {write_dacs/dac1/dac_cntrl[cntrl][5]} {write_dacs/dac1/dac_cntrl[cntrl][6]} {write_dacs/dac1/dac_cntrl[cntrl][7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 16 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {write_dacs/dac1/dac_cntrl[dpram_addr][0]} {write_dacs/dac1/dac_cntrl[dpram_addr][1]} {write_dacs/dac1/dac_cntrl[dpram_addr][2]} {write_dacs/dac1/dac_cntrl[dpram_addr][3]} {write_dacs/dac1/dac_cntrl[dpram_addr][4]} {write_dacs/dac1/dac_cntrl[dpram_addr][5]} {write_dacs/dac1/dac_cntrl[dpram_addr][6]} {write_dacs/dac1/dac_cntrl[dpram_addr][7]} {write_dacs/dac1/dac_cntrl[dpram_addr][8]} {write_dacs/dac1/dac_cntrl[dpram_addr][9]} {write_dacs/dac1/dac_cntrl[dpram_addr][10]} {write_dacs/dac1/dac_cntrl[dpram_addr][11]} {write_dacs/dac1/dac_cntrl[dpram_addr][12]} {write_dacs/dac1/dac_cntrl[dpram_addr][13]} {write_dacs/dac1/dac_cntrl[dpram_addr][14]} {write_dacs/dac1/dac_cntrl[dpram_addr][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 16 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {write_dacs/dac1/dac_cntrl[ramplen][0]} {write_dacs/dac1/dac_cntrl[ramplen][1]} {write_dacs/dac1/dac_cntrl[ramplen][2]} {write_dacs/dac1/dac_cntrl[ramplen][3]} {write_dacs/dac1/dac_cntrl[ramplen][4]} {write_dacs/dac1/dac_cntrl[ramplen][5]} {write_dacs/dac1/dac_cntrl[ramplen][6]} {write_dacs/dac1/dac_cntrl[ramplen][7]} {write_dacs/dac1/dac_cntrl[ramplen][8]} {write_dacs/dac1/dac_cntrl[ramplen][9]} {write_dacs/dac1/dac_cntrl[ramplen][10]} {write_dacs/dac1/dac_cntrl[ramplen][11]} {write_dacs/dac1/dac_cntrl[ramplen][12]} {write_dacs/dac1/dac_cntrl[ramplen][13]} {write_dacs/dac1/dac_cntrl[ramplen][14]} {write_dacs/dac1/dac_cntrl[ramplen][15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 16 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {write_dacs/dac1/dac_rdaddr[0]} {write_dacs/dac1/dac_rdaddr[1]} {write_dacs/dac1/dac_rdaddr[2]} {write_dacs/dac1/dac_rdaddr[3]} {write_dacs/dac1/dac_rdaddr[4]} {write_dacs/dac1/dac_rdaddr[5]} {write_dacs/dac1/dac_rdaddr[6]} {write_dacs/dac1/dac_rdaddr[7]} {write_dacs/dac1/dac_rdaddr[8]} {write_dacs/dac1/dac_rdaddr[9]} {write_dacs/dac1/dac_rdaddr[10]} {write_dacs/dac1/dac_rdaddr[11]} {write_dacs/dac1/dac_rdaddr[12]} {write_dacs/dac1/dac_rdaddr[13]} {write_dacs/dac1/dac_rdaddr[14]} {write_dacs/dac1/dac_rdaddr[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 2 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {write_dacs/dac1/dac_cntrl[mode][0]} {write_dacs/dac1/dac_cntrl[mode][1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 20 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {write_dacs/dac1/ramp_dac_setpt[0]} {write_dacs/dac1/ramp_dac_setpt[1]} {write_dacs/dac1/ramp_dac_setpt[2]} {write_dacs/dac1/ramp_dac_setpt[3]} {write_dacs/dac1/ramp_dac_setpt[4]} {write_dacs/dac1/ramp_dac_setpt[5]} {write_dacs/dac1/ramp_dac_setpt[6]} {write_dacs/dac1/ramp_dac_setpt[7]} {write_dacs/dac1/ramp_dac_setpt[8]} {write_dacs/dac1/ramp_dac_setpt[9]} {write_dacs/dac1/ramp_dac_setpt[10]} {write_dacs/dac1/ramp_dac_setpt[11]} {write_dacs/dac1/ramp_dac_setpt[12]} {write_dacs/dac1/ramp_dac_setpt[13]} {write_dacs/dac1/ramp_dac_setpt[14]} {write_dacs/dac1/ramp_dac_setpt[15]} {write_dacs/dac1/ramp_dac_setpt[16]} {write_dacs/dac1/ramp_dac_setpt[17]} {write_dacs/dac1/ramp_dac_setpt[18]} {write_dacs/dac1/ramp_dac_setpt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 24 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {write_dacs/dac1/dac_cntrl[gain][0]} {write_dacs/dac1/dac_cntrl[gain][1]} {write_dacs/dac1/dac_cntrl[gain][2]} {write_dacs/dac1/dac_cntrl[gain][3]} {write_dacs/dac1/dac_cntrl[gain][4]} {write_dacs/dac1/dac_cntrl[gain][5]} {write_dacs/dac1/dac_cntrl[gain][6]} {write_dacs/dac1/dac_cntrl[gain][7]} {write_dacs/dac1/dac_cntrl[gain][8]} {write_dacs/dac1/dac_cntrl[gain][9]} {write_dacs/dac1/dac_cntrl[gain][10]} {write_dacs/dac1/dac_cntrl[gain][11]} {write_dacs/dac1/dac_cntrl[gain][12]} {write_dacs/dac1/dac_cntrl[gain][13]} {write_dacs/dac1/dac_cntrl[gain][14]} {write_dacs/dac1/dac_cntrl[gain][15]} {write_dacs/dac1/dac_cntrl[gain][16]} {write_dacs/dac1/dac_cntrl[gain][17]} {write_dacs/dac1/dac_cntrl[gain][18]} {write_dacs/dac1/dac_cntrl[gain][19]} {write_dacs/dac1/dac_cntrl[gain][20]} {write_dacs/dac1/dac_cntrl[gain][21]} {write_dacs/dac1/dac_cntrl[gain][22]} {write_dacs/dac1/dac_cntrl[gain][23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 2 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {write_dacs/dac1/state[0]} {write_dacs/dac1/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 20 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {write_dacs/dac1/dac_cntrl[offset][0]} {write_dacs/dac1/dac_cntrl[offset][1]} {write_dacs/dac1/dac_cntrl[offset][2]} {write_dacs/dac1/dac_cntrl[offset][3]} {write_dacs/dac1/dac_cntrl[offset][4]} {write_dacs/dac1/dac_cntrl[offset][5]} {write_dacs/dac1/dac_cntrl[offset][6]} {write_dacs/dac1/dac_cntrl[offset][7]} {write_dacs/dac1/dac_cntrl[offset][8]} {write_dacs/dac1/dac_cntrl[offset][9]} {write_dacs/dac1/dac_cntrl[offset][10]} {write_dacs/dac1/dac_cntrl[offset][11]} {write_dacs/dac1/dac_cntrl[offset][12]} {write_dacs/dac1/dac_cntrl[offset][13]} {write_dacs/dac1/dac_cntrl[offset][14]} {write_dacs/dac1/dac_cntrl[offset][15]} {write_dacs/dac1/dac_cntrl[offset][16]} {write_dacs/dac1/dac_cntrl[offset][17]} {write_dacs/dac1/dac_cntrl[offset][18]} {write_dacs/dac1/dac_cntrl[offset][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 20 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {write_dacs/dac1/dac_cntrl[dpram_data][0]} {write_dacs/dac1/dac_cntrl[dpram_data][1]} {write_dacs/dac1/dac_cntrl[dpram_data][2]} {write_dacs/dac1/dac_cntrl[dpram_data][3]} {write_dacs/dac1/dac_cntrl[dpram_data][4]} {write_dacs/dac1/dac_cntrl[dpram_data][5]} {write_dacs/dac1/dac_cntrl[dpram_data][6]} {write_dacs/dac1/dac_cntrl[dpram_data][7]} {write_dacs/dac1/dac_cntrl[dpram_data][8]} {write_dacs/dac1/dac_cntrl[dpram_data][9]} {write_dacs/dac1/dac_cntrl[dpram_data][10]} {write_dacs/dac1/dac_cntrl[dpram_data][11]} {write_dacs/dac1/dac_cntrl[dpram_data][12]} {write_dacs/dac1/dac_cntrl[dpram_data][13]} {write_dacs/dac1/dac_cntrl[dpram_data][14]} {write_dacs/dac1/dac_cntrl[dpram_data][15]} {write_dacs/dac1/dac_cntrl[dpram_data][16]} {write_dacs/dac1/dac_cntrl[dpram_data][17]} {write_dacs/dac1/dac_cntrl[dpram_data][18]} {write_dacs/dac1/dac_cntrl[dpram_data][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 20 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {write_dacs/dac1/dac_rddata[0]} {write_dacs/dac1/dac_rddata[1]} {write_dacs/dac1/dac_rddata[2]} {write_dacs/dac1/dac_rddata[3]} {write_dacs/dac1/dac_rddata[4]} {write_dacs/dac1/dac_rddata[5]} {write_dacs/dac1/dac_rddata[6]} {write_dacs/dac1/dac_rddata[7]} {write_dacs/dac1/dac_rddata[8]} {write_dacs/dac1/dac_rddata[9]} {write_dacs/dac1/dac_rddata[10]} {write_dacs/dac1/dac_rddata[11]} {write_dacs/dac1/dac_rddata[12]} {write_dacs/dac1/dac_rddata[13]} {write_dacs/dac1/dac_rddata[14]} {write_dacs/dac1/dac_rddata[15]} {write_dacs/dac1/dac_rddata[16]} {write_dacs/dac1/dac_rddata[17]} {write_dacs/dac1/dac_rddata[18]} {write_dacs/dac1/dac_rddata[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 20 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {write_dacs/dac1/dac_cntrl[setpoint][0]} {write_dacs/dac1/dac_cntrl[setpoint][1]} {write_dacs/dac1/dac_cntrl[setpoint][2]} {write_dacs/dac1/dac_cntrl[setpoint][3]} {write_dacs/dac1/dac_cntrl[setpoint][4]} {write_dacs/dac1/dac_cntrl[setpoint][5]} {write_dacs/dac1/dac_cntrl[setpoint][6]} {write_dacs/dac1/dac_cntrl[setpoint][7]} {write_dacs/dac1/dac_cntrl[setpoint][8]} {write_dacs/dac1/dac_cntrl[setpoint][9]} {write_dacs/dac1/dac_cntrl[setpoint][10]} {write_dacs/dac1/dac_cntrl[setpoint][11]} {write_dacs/dac1/dac_cntrl[setpoint][12]} {write_dacs/dac1/dac_cntrl[setpoint][13]} {write_dacs/dac1/dac_cntrl[setpoint][14]} {write_dacs/dac1/dac_cntrl[setpoint][15]} {write_dacs/dac1/dac_cntrl[setpoint][16]} {write_dacs/dac1/dac_cntrl[setpoint][17]} {write_dacs/dac1/dac_cntrl[setpoint][18]} {write_dacs/dac1/dac_cntrl[setpoint][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 20 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {write_dacs/dac1/dac_stat[dac_setpt][0]} {write_dacs/dac1/dac_stat[dac_setpt][1]} {write_dacs/dac1/dac_stat[dac_setpt][2]} {write_dacs/dac1/dac_stat[dac_setpt][3]} {write_dacs/dac1/dac_stat[dac_setpt][4]} {write_dacs/dac1/dac_stat[dac_setpt][5]} {write_dacs/dac1/dac_stat[dac_setpt][6]} {write_dacs/dac1/dac_stat[dac_setpt][7]} {write_dacs/dac1/dac_stat[dac_setpt][8]} {write_dacs/dac1/dac_stat[dac_setpt][9]} {write_dacs/dac1/dac_stat[dac_setpt][10]} {write_dacs/dac1/dac_stat[dac_setpt][11]} {write_dacs/dac1/dac_stat[dac_setpt][12]} {write_dacs/dac1/dac_stat[dac_setpt][13]} {write_dacs/dac1/dac_stat[dac_setpt][14]} {write_dacs/dac1/dac_stat[dac_setpt][15]} {write_dacs/dac1/dac_stat[dac_setpt][16]} {write_dacs/dac1/dac_stat[dac_setpt][17]} {write_dacs/dac1/dac_stat[dac_setpt][18]} {write_dacs/dac1/dac_stat[dac_setpt][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 20 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {write_dacs/dac1/dac_setpt[0]} {write_dacs/dac1/dac_setpt[1]} {write_dacs/dac1/dac_setpt[2]} {write_dacs/dac1/dac_setpt[3]} {write_dacs/dac1/dac_setpt[4]} {write_dacs/dac1/dac_setpt[5]} {write_dacs/dac1/dac_setpt[6]} {write_dacs/dac1/dac_setpt[7]} {write_dacs/dac1/dac_setpt[8]} {write_dacs/dac1/dac_setpt[9]} {write_dacs/dac1/dac_setpt[10]} {write_dacs/dac1/dac_setpt[11]} {write_dacs/dac1/dac_setpt[12]} {write_dacs/dac1/dac_setpt[13]} {write_dacs/dac1/dac_setpt[14]} {write_dacs/dac1/dac_setpt[15]} {write_dacs/dac1/dac_setpt[16]} {write_dacs/dac1/dac_setpt[17]} {write_dacs/dac1/dac_setpt[18]} {write_dacs/dac1/dac_setpt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 4 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {ps_regs/inj_trig[0]} {ps_regs/inj_trig[1]} {ps_regs/inj_trig[2]} {ps_regs/inj_trig[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {write_dacs/dac1/dac_stat[active]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {write_dacs/dac1/dac_cntrl[ramprun]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list write_dacs/tenkhz_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list {write_dacs/dac1/dac_cntrl[reset]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list tenkhz_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {evr/evr_trigs[inj_trig_stretch]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {evr/evr_trigs[inj_trig]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list write_dacs/dac1/ramp_active]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list {evr/evr_trigs[sa_trig_stretch]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list {write_dacs/dac1/dac_cntrl[dpram_we]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list write_dacs/dac1/dac_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list {ps_regs/dac_cntrl[ps1][reset]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list {ps_regs/dac_cntrl[ps1][ramprun]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list {ps_regs/dac_cntrl[ps1][dpram_we]}]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list {evr/evr_trigs[rcvd_clk]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 8 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {evr/eventstream[0]} {evr/eventstream[1]} {evr/eventstream[2]} {evr/eventstream[3]} {evr/eventstream[4]} {evr/eventstream[5]} {evr/eventstream[6]} {evr/eventstream[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 8 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {evr/datastream[0]} {evr/datastream[1]} {evr/datastream[2]} {evr/datastream[3]} {evr/datastream[4]} {evr/datastream[5]} {evr/datastream[6]} {evr/datastream[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 16 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {evr/rxdata[0]} {evr/rxdata[1]} {evr/rxdata[2]} {evr/rxdata[3]} {evr/rxdata[4]} {evr/rxdata[5]} {evr/rxdata[6]} {evr/rxdata[7]} {evr/rxdata[8]} {evr/rxdata[9]} {evr/rxdata[10]} {evr/rxdata[11]} {evr/rxdata[12]} {evr/rxdata[13]} {evr/rxdata[14]} {evr/rxdata[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 2 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {evr/rxcharisk[0]} {evr/rxcharisk[1]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 1 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list {evr/evr_trigs[fa_trig]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 1 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list {evr/evr_trigs[pm_trig]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 1 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list {evr/evr_trigs[sa_trig]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe7]
set_property port_width 1 [get_debug_ports u_ila_1/probe7]
connect_debug_port u_ila_1/probe7 [get_nets [list evr/inj_trig]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe8]
set_property port_width 1 [get_debug_ports u_ila_1/probe8]
connect_debug_port u_ila_1/probe8 [get_nets [list {evr/evr_trigs[tbt_trig]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_1_evr_trigs[rcvd_clk]]
