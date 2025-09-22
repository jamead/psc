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
connect_debug_port u_ila_0/clk [get_nets [list {evr/evr_trigs[rcvd_clk]}]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {evr/ts/secondsReg[0]} {evr/ts/secondsReg[1]} {evr/ts/secondsReg[2]} {evr/ts/secondsReg[3]} {evr/ts/secondsReg[4]} {evr/ts/secondsReg[5]} {evr/ts/secondsReg[6]} {evr/ts/secondsReg[7]} {evr/ts/secondsReg[8]} {evr/ts/secondsReg[9]} {evr/ts/secondsReg[10]} {evr/ts/secondsReg[11]} {evr/ts/secondsReg[12]} {evr/ts/secondsReg[13]} {evr/ts/secondsReg[14]} {evr/ts/secondsReg[15]} {evr/ts/secondsReg[16]} {evr/ts/secondsReg[17]} {evr/ts/secondsReg[18]} {evr/ts/secondsReg[19]} {evr/ts/secondsReg[20]} {evr/ts/secondsReg[21]} {evr/ts/secondsReg[22]} {evr/ts/secondsReg[23]} {evr/ts/secondsReg[24]} {evr/ts/secondsReg[25]} {evr/ts/secondsReg[26]} {evr/ts/secondsReg[27]} {evr/ts/secondsReg[28]} {evr/ts/secondsReg[29]} {evr/ts/secondsReg[30]} {evr/ts/secondsReg[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {evr/ts/Offset[0]} {evr/ts/Offset[1]} {evr/ts/Offset[2]} {evr/ts/Offset[3]} {evr/ts/Offset[4]} {evr/ts/Offset[5]} {evr/ts/Offset[6]} {evr/ts/Offset[7]} {evr/ts/Offset[8]} {evr/ts/Offset[9]} {evr/ts/Offset[10]} {evr/ts/Offset[11]} {evr/ts/Offset[12]} {evr/ts/Offset[13]} {evr/ts/Offset[14]} {evr/ts/Offset[15]} {evr/ts/Offset[16]} {evr/ts/Offset[17]} {evr/ts/Offset[18]} {evr/ts/Offset[19]} {evr/ts/Offset[20]} {evr/ts/Offset[21]} {evr/ts/Offset[22]} {evr/ts/Offset[23]} {evr/ts/Offset[24]} {evr/ts/Offset[25]} {evr/ts/Offset[26]} {evr/ts/Offset[27]} {evr/ts/Offset[28]} {evr/ts/Offset[29]} {evr/ts/Offset[30]} {evr/ts/Offset[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 5 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {evr/ts/pos[0]} {evr/ts/pos[1]} {evr/ts/pos[2]} {evr/ts/pos[3]} {evr/ts/pos[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 32 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {evr/ts/seconds_tmp[0]} {evr/ts/seconds_tmp[1]} {evr/ts/seconds_tmp[2]} {evr/ts/seconds_tmp[3]} {evr/ts/seconds_tmp[4]} {evr/ts/seconds_tmp[5]} {evr/ts/seconds_tmp[6]} {evr/ts/seconds_tmp[7]} {evr/ts/seconds_tmp[8]} {evr/ts/seconds_tmp[9]} {evr/ts/seconds_tmp[10]} {evr/ts/seconds_tmp[11]} {evr/ts/seconds_tmp[12]} {evr/ts/seconds_tmp[13]} {evr/ts/seconds_tmp[14]} {evr/ts/seconds_tmp[15]} {evr/ts/seconds_tmp[16]} {evr/ts/seconds_tmp[17]} {evr/ts/seconds_tmp[18]} {evr/ts/seconds_tmp[19]} {evr/ts/seconds_tmp[20]} {evr/ts/seconds_tmp[21]} {evr/ts/seconds_tmp[22]} {evr/ts/seconds_tmp[23]} {evr/ts/seconds_tmp[24]} {evr/ts/seconds_tmp[25]} {evr/ts/seconds_tmp[26]} {evr/ts/seconds_tmp[27]} {evr/ts/seconds_tmp[28]} {evr/ts/seconds_tmp[29]} {evr/ts/seconds_tmp[30]} {evr/ts/seconds_tmp[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {evr/ts/EventStream[0]} {evr/ts/EventStream[1]} {evr/ts/EventStream[2]} {evr/ts/EventStream[3]} {evr/ts/EventStream[4]} {evr/ts/EventStream[5]} {evr/ts/EventStream[6]} {evr/ts/EventStream[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {evr/ts/offsetReg[0]} {evr/ts/offsetReg[1]} {evr/ts/offsetReg[2]} {evr/ts/offsetReg[3]} {evr/ts/offsetReg[4]} {evr/ts/offsetReg[5]} {evr/ts/offsetReg[6]} {evr/ts/offsetReg[7]} {evr/ts/offsetReg[8]} {evr/ts/offsetReg[9]} {evr/ts/offsetReg[10]} {evr/ts/offsetReg[11]} {evr/ts/offsetReg[12]} {evr/ts/offsetReg[13]} {evr/ts/offsetReg[14]} {evr/ts/offsetReg[15]} {evr/ts/offsetReg[16]} {evr/ts/offsetReg[17]} {evr/ts/offsetReg[18]} {evr/ts/offsetReg[19]} {evr/ts/offsetReg[20]} {evr/ts/offsetReg[21]} {evr/ts/offsetReg[22]} {evr/ts/offsetReg[23]} {evr/ts/offsetReg[24]} {evr/ts/offsetReg[25]} {evr/ts/offsetReg[26]} {evr/ts/offsetReg[27]} {evr/ts/offsetReg[28]} {evr/ts/offsetReg[29]} {evr/ts/offsetReg[30]} {evr/ts/offsetReg[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {evr/evr_trigs[ts_ns][0]} {evr/evr_trigs[ts_ns][1]} {evr/evr_trigs[ts_ns][2]} {evr/evr_trigs[ts_ns][3]} {evr/evr_trigs[ts_ns][4]} {evr/evr_trigs[ts_ns][5]} {evr/evr_trigs[ts_ns][6]} {evr/evr_trigs[ts_ns][7]} {evr/evr_trigs[ts_ns][8]} {evr/evr_trigs[ts_ns][9]} {evr/evr_trigs[ts_ns][10]} {evr/evr_trigs[ts_ns][11]} {evr/evr_trigs[ts_ns][12]} {evr/evr_trigs[ts_ns][13]} {evr/evr_trigs[ts_ns][14]} {evr/evr_trigs[ts_ns][15]} {evr/evr_trigs[ts_ns][16]} {evr/evr_trigs[ts_ns][17]} {evr/evr_trigs[ts_ns][18]} {evr/evr_trigs[ts_ns][19]} {evr/evr_trigs[ts_ns][20]} {evr/evr_trigs[ts_ns][21]} {evr/evr_trigs[ts_ns][22]} {evr/evr_trigs[ts_ns][23]} {evr/evr_trigs[ts_ns][24]} {evr/evr_trigs[ts_ns][25]} {evr/evr_trigs[ts_ns][26]} {evr/evr_trigs[ts_ns][27]} {evr/evr_trigs[ts_ns][28]} {evr/evr_trigs[ts_ns][29]} {evr/evr_trigs[ts_ns][30]} {evr/evr_trigs[ts_ns][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {evr/evr_trigs[ts_s][0]} {evr/evr_trigs[ts_s][1]} {evr/evr_trigs[ts_s][2]} {evr/evr_trigs[ts_s][3]} {evr/evr_trigs[ts_s][4]} {evr/evr_trigs[ts_s][5]} {evr/evr_trigs[ts_s][6]} {evr/evr_trigs[ts_s][7]} {evr/evr_trigs[ts_s][8]} {evr/evr_trigs[ts_s][9]} {evr/evr_trigs[ts_s][10]} {evr/evr_trigs[ts_s][11]} {evr/evr_trigs[ts_s][12]} {evr/evr_trigs[ts_s][13]} {evr/evr_trigs[ts_s][14]} {evr/evr_trigs[ts_s][15]} {evr/evr_trigs[ts_s][16]} {evr/evr_trigs[ts_s][17]} {evr/evr_trigs[ts_s][18]} {evr/evr_trigs[ts_s][19]} {evr/evr_trigs[ts_s][20]} {evr/evr_trigs[ts_s][21]} {evr/evr_trigs[ts_s][22]} {evr/evr_trigs[ts_s][23]} {evr/evr_trigs[ts_s][24]} {evr/evr_trigs[ts_s][25]} {evr/evr_trigs[ts_s][26]} {evr/evr_trigs[ts_s][27]} {evr/evr_trigs[ts_s][28]} {evr/evr_trigs[ts_s][29]} {evr/evr_trigs[ts_s][30]} {evr/evr_trigs[ts_s][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {evr/eventstream[0]} {evr/eventstream[1]} {evr/eventstream[2]} {evr/eventstream[3]} {evr/eventstream[4]} {evr/eventstream[5]} {evr/eventstream[6]} {evr/eventstream[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 5 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {evr/ts/Position[0]} {evr/ts/Position[1]} {evr/ts/Position[2]} {evr/ts/Position[3]} {evr/ts/Position[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {evr/ts/Seconds[0]} {evr/ts/Seconds[1]} {evr/ts/Seconds[2]} {evr/ts/Seconds[3]} {evr/ts/Seconds[4]} {evr/ts/Seconds[5]} {evr/ts/Seconds[6]} {evr/ts/Seconds[7]} {evr/ts/Seconds[8]} {evr/ts/Seconds[9]} {evr/ts/Seconds[10]} {evr/ts/Seconds[11]} {evr/ts/Seconds[12]} {evr/ts/Seconds[13]} {evr/ts/Seconds[14]} {evr/ts/Seconds[15]} {evr/ts/Seconds[16]} {evr/ts/Seconds[17]} {evr/ts/Seconds[18]} {evr/ts/Seconds[19]} {evr/ts/Seconds[20]} {evr/ts/Seconds[21]} {evr/ts/Seconds[22]} {evr/ts/Seconds[23]} {evr/ts/Seconds[24]} {evr/ts/Seconds[25]} {evr/ts/Seconds[26]} {evr/ts/Seconds[27]} {evr/ts/Seconds[28]} {evr/ts/Seconds[29]} {evr/ts/Seconds[30]} {evr/ts/Seconds[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 8 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {evr/datastream[0]} {evr/datastream[1]} {evr/datastream[2]} {evr/datastream[3]} {evr/datastream[4]} {evr/datastream[5]} {evr/datastream[6]} {evr/datastream[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 16 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {evr/rxdata[0]} {evr/rxdata[1]} {evr/rxdata[2]} {evr/rxdata[3]} {evr/rxdata[4]} {evr/rxdata[5]} {evr/rxdata[6]} {evr/rxdata[7]} {evr/rxdata[8]} {evr/rxdata[9]} {evr/rxdata[10]} {evr/rxdata[11]} {evr/rxdata[12]} {evr/rxdata[13]} {evr/rxdata[14]} {evr/rxdata[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 2 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {evr/rxcharisk[0]} {evr/rxcharisk[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list evr/ts/clear]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list evr/onehz_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list evr/ts/eventClock]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list evr/ts/clear_reg__0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {evr/evr_trigs[sa_trig]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {evr/evr_trigs[pm_trig]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {evr/evr_trigs[fa_trig]}]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_evr_trigs[rcvd_clk]]
