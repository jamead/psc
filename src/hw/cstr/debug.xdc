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
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {leds[0]} {leds[1]} {leds[2]} {leds[3]} {leds[4]} {leds[5]} {leds[6]} {leds[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {ps_regs/reg_i[softtrig_bufptr][val][data][0]} {ps_regs/reg_i[softtrig_bufptr][val][data][1]} {ps_regs/reg_i[softtrig_bufptr][val][data][2]} {ps_regs/reg_i[softtrig_bufptr][val][data][3]} {ps_regs/reg_i[softtrig_bufptr][val][data][4]} {ps_regs/reg_i[softtrig_bufptr][val][data][5]} {ps_regs/reg_i[softtrig_bufptr][val][data][6]} {ps_regs/reg_i[softtrig_bufptr][val][data][7]} {ps_regs/reg_i[softtrig_bufptr][val][data][8]} {ps_regs/reg_i[softtrig_bufptr][val][data][9]} {ps_regs/reg_i[softtrig_bufptr][val][data][10]} {ps_regs/reg_i[softtrig_bufptr][val][data][11]} {ps_regs/reg_i[softtrig_bufptr][val][data][12]} {ps_regs/reg_i[softtrig_bufptr][val][data][13]} {ps_regs/reg_i[softtrig_bufptr][val][data][14]} {ps_regs/reg_i[softtrig_bufptr][val][data][15]} {ps_regs/reg_i[softtrig_bufptr][val][data][16]} {ps_regs/reg_i[softtrig_bufptr][val][data][17]} {ps_regs/reg_i[softtrig_bufptr][val][data][18]} {ps_regs/reg_i[softtrig_bufptr][val][data][19]} {ps_regs/reg_i[softtrig_bufptr][val][data][20]} {ps_regs/reg_i[softtrig_bufptr][val][data][21]} {ps_regs/reg_i[softtrig_bufptr][val][data][22]} {ps_regs/reg_i[softtrig_bufptr][val][data][23]} {ps_regs/reg_i[softtrig_bufptr][val][data][24]} {ps_regs/reg_i[softtrig_bufptr][val][data][25]} {ps_regs/reg_i[softtrig_bufptr][val][data][26]} {ps_regs/reg_i[softtrig_bufptr][val][data][27]} {ps_regs/reg_i[softtrig_bufptr][val][data][28]} {ps_regs/reg_i[softtrig_bufptr][val][data][29]} {ps_regs/reg_i[softtrig_bufptr][val][data][30]} {ps_regs/reg_i[softtrig_bufptr][val][data][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 32 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {ps_regs/reg_i[snapshot_totaltrigs][val][data][0]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][1]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][2]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][3]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][4]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][5]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][6]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][7]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][8]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][9]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][10]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][11]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][12]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][13]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][14]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][15]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][16]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][17]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][18]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][19]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][20]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][21]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][22]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][23]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][24]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][25]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][26]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][27]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][28]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][29]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][30]} {ps_regs/reg_i[snapshot_totaltrigs][val][data][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {ps_regs/reg_i[snapshot_addrptr][val][data][0]} {ps_regs/reg_i[snapshot_addrptr][val][data][1]} {ps_regs/reg_i[snapshot_addrptr][val][data][2]} {ps_regs/reg_i[snapshot_addrptr][val][data][3]} {ps_regs/reg_i[snapshot_addrptr][val][data][4]} {ps_regs/reg_i[snapshot_addrptr][val][data][5]} {ps_regs/reg_i[snapshot_addrptr][val][data][6]} {ps_regs/reg_i[snapshot_addrptr][val][data][7]} {ps_regs/reg_i[snapshot_addrptr][val][data][8]} {ps_regs/reg_i[snapshot_addrptr][val][data][9]} {ps_regs/reg_i[snapshot_addrptr][val][data][10]} {ps_regs/reg_i[snapshot_addrptr][val][data][11]} {ps_regs/reg_i[snapshot_addrptr][val][data][12]} {ps_regs/reg_i[snapshot_addrptr][val][data][13]} {ps_regs/reg_i[snapshot_addrptr][val][data][14]} {ps_regs/reg_i[snapshot_addrptr][val][data][15]} {ps_regs/reg_i[snapshot_addrptr][val][data][16]} {ps_regs/reg_i[snapshot_addrptr][val][data][17]} {ps_regs/reg_i[snapshot_addrptr][val][data][18]} {ps_regs/reg_i[snapshot_addrptr][val][data][19]} {ps_regs/reg_i[snapshot_addrptr][val][data][20]} {ps_regs/reg_i[snapshot_addrptr][val][data][21]} {ps_regs/reg_i[snapshot_addrptr][val][data][22]} {ps_regs/reg_i[snapshot_addrptr][val][data][23]} {ps_regs/reg_i[snapshot_addrptr][val][data][24]} {ps_regs/reg_i[snapshot_addrptr][val][data][25]} {ps_regs/reg_i[snapshot_addrptr][val][data][26]} {ps_regs/reg_i[snapshot_addrptr][val][data][27]} {ps_regs/reg_i[snapshot_addrptr][val][data][28]} {ps_regs/reg_i[snapshot_addrptr][val][data][29]} {ps_regs/reg_i[snapshot_addrptr][val][data][30]} {ps_regs/reg_i[snapshot_addrptr][val][data][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {ps_regs/reg_i[fpgaver][val][data][0]} {ps_regs/reg_i[fpgaver][val][data][1]} {ps_regs/reg_i[fpgaver][val][data][2]} {ps_regs/reg_i[fpgaver][val][data][3]} {ps_regs/reg_i[fpgaver][val][data][4]} {ps_regs/reg_i[fpgaver][val][data][5]} {ps_regs/reg_i[fpgaver][val][data][6]} {ps_regs/reg_i[fpgaver][val][data][7]} {ps_regs/reg_i[fpgaver][val][data][8]} {ps_regs/reg_i[fpgaver][val][data][9]} {ps_regs/reg_i[fpgaver][val][data][10]} {ps_regs/reg_i[fpgaver][val][data][11]} {ps_regs/reg_i[fpgaver][val][data][12]} {ps_regs/reg_i[fpgaver][val][data][13]} {ps_regs/reg_i[fpgaver][val][data][14]} {ps_regs/reg_i[fpgaver][val][data][15]} {ps_regs/reg_i[fpgaver][val][data][16]} {ps_regs/reg_i[fpgaver][val][data][17]} {ps_regs/reg_i[fpgaver][val][data][18]} {ps_regs/reg_i[fpgaver][val][data][19]} {ps_regs/reg_i[fpgaver][val][data][20]} {ps_regs/reg_i[fpgaver][val][data][21]} {ps_regs/reg_i[fpgaver][val][data][22]} {ps_regs/reg_i[fpgaver][val][data][23]} {ps_regs/reg_i[fpgaver][val][data][24]} {ps_regs/reg_i[fpgaver][val][data][25]} {ps_regs/reg_i[fpgaver][val][data][26]} {ps_regs/reg_i[fpgaver][val][data][27]} {ps_regs/reg_i[fpgaver][val][data][28]} {ps_regs/reg_i[fpgaver][val][data][29]} {ps_regs/reg_i[fpgaver][val][data][30]} {ps_regs/reg_i[fpgaver][val][data][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 6 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {adc2ddr/state[0]} {adc2ddr/state[1]} {adc2ddr/state[2]} {adc2ddr/state[3]} {adc2ddr/state[4]} {adc2ddr/state[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {adc2ddr/datacnt[0]} {adc2ddr/datacnt[1]} {adc2ddr/datacnt[2]} {adc2ddr/datacnt[3]} {adc2ddr/datacnt[4]} {adc2ddr/datacnt[5]} {adc2ddr/datacnt[6]} {adc2ddr/datacnt[7]} {adc2ddr/datacnt[8]} {adc2ddr/datacnt[9]} {adc2ddr/datacnt[10]} {adc2ddr/datacnt[11]} {adc2ddr/datacnt[12]} {adc2ddr/datacnt[13]} {adc2ddr/datacnt[14]} {adc2ddr/datacnt[15]} {adc2ddr/datacnt[16]} {adc2ddr/datacnt[17]} {adc2ddr/datacnt[18]} {adc2ddr/datacnt[19]} {adc2ddr/datacnt[20]} {adc2ddr/datacnt[21]} {adc2ddr/datacnt[22]} {adc2ddr/datacnt[23]} {adc2ddr/datacnt[24]} {adc2ddr/datacnt[25]} {adc2ddr/datacnt[26]} {adc2ddr/datacnt[27]} {adc2ddr/datacnt[28]} {adc2ddr/datacnt[29]} {adc2ddr/datacnt[30]} {adc2ddr/datacnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list ps_regs/soft_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list adc2ddr/trigger]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list tenkhz_trig]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sys_n_115]
