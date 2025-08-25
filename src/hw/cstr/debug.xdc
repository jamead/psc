create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list sys/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 20 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {read_dcct_adcs/dcct_adc1/dcct1[0]} {read_dcct_adcs/dcct_adc1/dcct1[1]} {read_dcct_adcs/dcct_adc1/dcct1[2]} {read_dcct_adcs/dcct_adc1/dcct1[3]} {read_dcct_adcs/dcct_adc1/dcct1[4]} {read_dcct_adcs/dcct_adc1/dcct1[5]} {read_dcct_adcs/dcct_adc1/dcct1[6]} {read_dcct_adcs/dcct_adc1/dcct1[7]} {read_dcct_adcs/dcct_adc1/dcct1[8]} {read_dcct_adcs/dcct_adc1/dcct1[9]} {read_dcct_adcs/dcct_adc1/dcct1[10]} {read_dcct_adcs/dcct_adc1/dcct1[11]} {read_dcct_adcs/dcct_adc1/dcct1[12]} {read_dcct_adcs/dcct_adc1/dcct1[13]} {read_dcct_adcs/dcct_adc1/dcct1[14]} {read_dcct_adcs/dcct_adc1/dcct1[15]} {read_dcct_adcs/dcct_adc1/dcct1[16]} {read_dcct_adcs/dcct_adc1/dcct1[17]} {read_dcct_adcs/dcct_adc1/dcct1[18]} {read_dcct_adcs/dcct_adc1/dcct1[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 20 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {read_dcct_adcs/dcct_adc1/dcct2[0]} {read_dcct_adcs/dcct_adc1/dcct2[1]} {read_dcct_adcs/dcct_adc1/dcct2[2]} {read_dcct_adcs/dcct_adc1/dcct2[3]} {read_dcct_adcs/dcct_adc1/dcct2[4]} {read_dcct_adcs/dcct_adc1/dcct2[5]} {read_dcct_adcs/dcct_adc1/dcct2[6]} {read_dcct_adcs/dcct_adc1/dcct2[7]} {read_dcct_adcs/dcct_adc1/dcct2[8]} {read_dcct_adcs/dcct_adc1/dcct2[9]} {read_dcct_adcs/dcct_adc1/dcct2[10]} {read_dcct_adcs/dcct_adc1/dcct2[11]} {read_dcct_adcs/dcct_adc1/dcct2[12]} {read_dcct_adcs/dcct_adc1/dcct2[13]} {read_dcct_adcs/dcct_adc1/dcct2[14]} {read_dcct_adcs/dcct_adc1/dcct2[15]} {read_dcct_adcs/dcct_adc1/dcct2[16]} {read_dcct_adcs/dcct_adc1/dcct2[17]} {read_dcct_adcs/dcct_adc1/dcct2[18]} {read_dcct_adcs/dcct_adc1/dcct2[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 3 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {read_dcct_adcs/dcct_adc1/state[0]} {read_dcct_adcs/dcct_adc1/state[1]} {read_dcct_adcs/dcct_adc1/state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 20 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {write_dacs/dac1/dac_setpt[0]} {write_dacs/dac1/dac_setpt[1]} {write_dacs/dac1/dac_setpt[2]} {write_dacs/dac1/dac_setpt[3]} {write_dacs/dac1/dac_setpt[4]} {write_dacs/dac1/dac_setpt[5]} {write_dacs/dac1/dac_setpt[6]} {write_dacs/dac1/dac_setpt[7]} {write_dacs/dac1/dac_setpt[8]} {write_dacs/dac1/dac_setpt[9]} {write_dacs/dac1/dac_setpt[10]} {write_dacs/dac1/dac_setpt[11]} {write_dacs/dac1/dac_setpt[12]} {write_dacs/dac1/dac_setpt[13]} {write_dacs/dac1/dac_setpt[14]} {write_dacs/dac1/dac_setpt[15]} {write_dacs/dac1/dac_setpt[16]} {write_dacs/dac1/dac_setpt[17]} {write_dacs/dac1/dac_setpt[18]} {write_dacs/dac1/dac_setpt[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list read_dcct_adcs/conv_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list read_dcct_adcs/dcct_adc1/data_rdy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list read_dcct_adcs/dcct_adc1/sclk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list read_dcct_adcs/dcct_adc1/sdi]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list read_dcct_adcs/dcct_adc1/start_lat]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list read_dcct_adcs/dcct_adc1/start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list read_dcct_adcs/dcct_adc1/cnv]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list read_dcct_adcs/dcct_adc1/clk_enb]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list tenkhz_trig]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets pl_clk0]
