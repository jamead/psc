

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
set_property port_width 20 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {write_dacs/dac4/ramp_dac_setpt[0]} {write_dacs/dac4/ramp_dac_setpt[1]} {write_dacs/dac4/ramp_dac_setpt[2]} {write_dacs/dac4/ramp_dac_setpt[3]} {write_dacs/dac4/ramp_dac_setpt[4]} {write_dacs/dac4/ramp_dac_setpt[5]} {write_dacs/dac4/ramp_dac_setpt[6]} {write_dacs/dac4/ramp_dac_setpt[7]} {write_dacs/dac4/ramp_dac_setpt[8]} {write_dacs/dac4/ramp_dac_setpt[9]} {write_dacs/dac4/ramp_dac_setpt[10]} {write_dacs/dac4/ramp_dac_setpt[11]} {write_dacs/dac4/ramp_dac_setpt[12]} {write_dacs/dac4/ramp_dac_setpt[13]} {write_dacs/dac4/ramp_dac_setpt[14]} {write_dacs/dac4/ramp_dac_setpt[15]} {write_dacs/dac4/ramp_dac_setpt[16]} {write_dacs/dac4/ramp_dac_setpt[17]} {write_dacs/dac4/ramp_dac_setpt[18]} {write_dacs/dac4/ramp_dac_setpt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 2 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {write_dacs/dac4/state[0]} {write_dacs/dac4/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 20 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {write_dacs/ramptest/cnt[0]} {write_dacs/ramptest/cnt[1]} {write_dacs/ramptest/cnt[2]} {write_dacs/ramptest/cnt[3]} {write_dacs/ramptest/cnt[4]} {write_dacs/ramptest/cnt[5]} {write_dacs/ramptest/cnt[6]} {write_dacs/ramptest/cnt[7]} {write_dacs/ramptest/cnt[8]} {write_dacs/ramptest/cnt[9]} {write_dacs/ramptest/cnt[10]} {write_dacs/ramptest/cnt[11]} {write_dacs/ramptest/cnt[12]} {write_dacs/ramptest/cnt[13]} {write_dacs/ramptest/cnt[14]} {write_dacs/ramptest/cnt[15]} {write_dacs/ramptest/cnt[16]} {write_dacs/ramptest/cnt[17]} {write_dacs/ramptest/cnt[18]} {write_dacs/ramptest/cnt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 24 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {write_dacs/ramptest/cos[0]} {write_dacs/ramptest/cos[1]} {write_dacs/ramptest/cos[2]} {write_dacs/ramptest/cos[3]} {write_dacs/ramptest/cos[4]} {write_dacs/ramptest/cos[5]} {write_dacs/ramptest/cos[6]} {write_dacs/ramptest/cos[7]} {write_dacs/ramptest/cos[8]} {write_dacs/ramptest/cos[9]} {write_dacs/ramptest/cos[10]} {write_dacs/ramptest/cos[11]} {write_dacs/ramptest/cos[12]} {write_dacs/ramptest/cos[13]} {write_dacs/ramptest/cos[14]} {write_dacs/ramptest/cos[15]} {write_dacs/ramptest/cos[16]} {write_dacs/ramptest/cos[17]} {write_dacs/ramptest/cos[18]} {write_dacs/ramptest/cos[19]} {write_dacs/ramptest/cos[20]} {write_dacs/ramptest/cos[21]} {write_dacs/ramptest/cos[22]} {write_dacs/ramptest/cos[23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 20 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {write_dacs/ramptest/new_setpt[0]} {write_dacs/ramptest/new_setpt[1]} {write_dacs/ramptest/new_setpt[2]} {write_dacs/ramptest/new_setpt[3]} {write_dacs/ramptest/new_setpt[4]} {write_dacs/ramptest/new_setpt[5]} {write_dacs/ramptest/new_setpt[6]} {write_dacs/ramptest/new_setpt[7]} {write_dacs/ramptest/new_setpt[8]} {write_dacs/ramptest/new_setpt[9]} {write_dacs/ramptest/new_setpt[10]} {write_dacs/ramptest/new_setpt[11]} {write_dacs/ramptest/new_setpt[12]} {write_dacs/ramptest/new_setpt[13]} {write_dacs/ramptest/new_setpt[14]} {write_dacs/ramptest/new_setpt[15]} {write_dacs/ramptest/new_setpt[16]} {write_dacs/ramptest/new_setpt[17]} {write_dacs/ramptest/new_setpt[18]} {write_dacs/ramptest/new_setpt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 20 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {write_dacs/ramptest/old_setpt[0]} {write_dacs/ramptest/old_setpt[1]} {write_dacs/ramptest/old_setpt[2]} {write_dacs/ramptest/old_setpt[3]} {write_dacs/ramptest/old_setpt[4]} {write_dacs/ramptest/old_setpt[5]} {write_dacs/ramptest/old_setpt[6]} {write_dacs/ramptest/old_setpt[7]} {write_dacs/ramptest/old_setpt[8]} {write_dacs/ramptest/old_setpt[9]} {write_dacs/ramptest/old_setpt[10]} {write_dacs/ramptest/old_setpt[11]} {write_dacs/ramptest/old_setpt[12]} {write_dacs/ramptest/old_setpt[13]} {write_dacs/ramptest/old_setpt[14]} {write_dacs/ramptest/old_setpt[15]} {write_dacs/ramptest/old_setpt[16]} {write_dacs/ramptest/old_setpt[17]} {write_dacs/ramptest/old_setpt[18]} {write_dacs/ramptest/old_setpt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {write_dacs/ramptest/phase[0]} {write_dacs/ramptest/phase[1]} {write_dacs/ramptest/phase[2]} {write_dacs/ramptest/phase[3]} {write_dacs/ramptest/phase[4]} {write_dacs/ramptest/phase[5]} {write_dacs/ramptest/phase[6]} {write_dacs/ramptest/phase[7]} {write_dacs/ramptest/phase[8]} {write_dacs/ramptest/phase[9]} {write_dacs/ramptest/phase[10]} {write_dacs/ramptest/phase[11]} {write_dacs/ramptest/phase[12]} {write_dacs/ramptest/phase[13]} {write_dacs/ramptest/phase[14]} {write_dacs/ramptest/phase[15]} {write_dacs/ramptest/phase[16]} {write_dacs/ramptest/phase[17]} {write_dacs/ramptest/phase[18]} {write_dacs/ramptest/phase[19]} {write_dacs/ramptest/phase[20]} {write_dacs/ramptest/phase[21]} {write_dacs/ramptest/phase[22]} {write_dacs/ramptest/phase[23]} {write_dacs/ramptest/phase[24]} {write_dacs/ramptest/phase[25]} {write_dacs/ramptest/phase[26]} {write_dacs/ramptest/phase[27]} {write_dacs/ramptest/phase[28]} {write_dacs/ramptest/phase[29]} {write_dacs/ramptest/phase[30]} {write_dacs/ramptest/phase[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {write_dacs/ramptest/phase_inc[0]} {write_dacs/ramptest/phase_inc[1]} {write_dacs/ramptest/phase_inc[2]} {write_dacs/ramptest/phase_inc[3]} {write_dacs/ramptest/phase_inc[4]} {write_dacs/ramptest/phase_inc[5]} {write_dacs/ramptest/phase_inc[6]} {write_dacs/ramptest/phase_inc[7]} {write_dacs/ramptest/phase_inc[8]} {write_dacs/ramptest/phase_inc[9]} {write_dacs/ramptest/phase_inc[10]} {write_dacs/ramptest/phase_inc[11]} {write_dacs/ramptest/phase_inc[12]} {write_dacs/ramptest/phase_inc[13]} {write_dacs/ramptest/phase_inc[14]} {write_dacs/ramptest/phase_inc[15]} {write_dacs/ramptest/phase_inc[16]} {write_dacs/ramptest/phase_inc[17]} {write_dacs/ramptest/phase_inc[18]} {write_dacs/ramptest/phase_inc[19]} {write_dacs/ramptest/phase_inc[20]} {write_dacs/ramptest/phase_inc[21]} {write_dacs/ramptest/phase_inc[22]} {write_dacs/ramptest/phase_inc[23]} {write_dacs/ramptest/phase_inc[24]} {write_dacs/ramptest/phase_inc[25]} {write_dacs/ramptest/phase_inc[26]} {write_dacs/ramptest/phase_inc[27]} {write_dacs/ramptest/phase_inc[28]} {write_dacs/ramptest/phase_inc[29]} {write_dacs/ramptest/phase_inc[30]} {write_dacs/ramptest/phase_inc[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 20 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {write_dacs/rampout[0]} {write_dacs/rampout[1]} {write_dacs/rampout[2]} {write_dacs/rampout[3]} {write_dacs/rampout[4]} {write_dacs/rampout[5]} {write_dacs/rampout[6]} {write_dacs/rampout[7]} {write_dacs/rampout[8]} {write_dacs/rampout[9]} {write_dacs/rampout[10]} {write_dacs/rampout[11]} {write_dacs/rampout[12]} {write_dacs/rampout[13]} {write_dacs/rampout[14]} {write_dacs/rampout[15]} {write_dacs/rampout[16]} {write_dacs/rampout[17]} {write_dacs/rampout[18]} {write_dacs/rampout[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list write_dacs/ramptest/state]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list write_dacs/ramptest/tenkhz_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list write_dacs/ramptest/trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list write_dacs/tenkhz_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list write_dacs/ramptest/last_point]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list write_dacs/dac4/ramp_active]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets pl_clk0]
