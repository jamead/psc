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
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {adc2ddr/s_axi_awcache[0]} {adc2ddr/s_axi_awcache[1]} {adc2ddr/s_axi_awcache[2]} {adc2ddr/s_axi_awcache[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 4 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {adc2ddr/s_axi_awlen[0]} {adc2ddr/s_axi_awlen[1]} {adc2ddr/s_axi_awlen[2]} {adc2ddr/s_axi_awlen[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 3 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {adc2ddr/s_axi_awprot[0]} {adc2ddr/s_axi_awprot[1]} {adc2ddr/s_axi_awprot[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 2 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {adc2ddr/s_axi_awburst[0]} {adc2ddr/s_axi_awburst[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 2 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {adc2ddr/s_axi_awlock[0]} {adc2ddr/s_axi_awlock[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {adc2ddr/s_axi_awaddr[0]} {adc2ddr/s_axi_awaddr[1]} {adc2ddr/s_axi_awaddr[2]} {adc2ddr/s_axi_awaddr[3]} {adc2ddr/s_axi_awaddr[4]} {adc2ddr/s_axi_awaddr[5]} {adc2ddr/s_axi_awaddr[6]} {adc2ddr/s_axi_awaddr[7]} {adc2ddr/s_axi_awaddr[8]} {adc2ddr/s_axi_awaddr[9]} {adc2ddr/s_axi_awaddr[10]} {adc2ddr/s_axi_awaddr[11]} {adc2ddr/s_axi_awaddr[12]} {adc2ddr/s_axi_awaddr[13]} {adc2ddr/s_axi_awaddr[14]} {adc2ddr/s_axi_awaddr[15]} {adc2ddr/s_axi_awaddr[16]} {adc2ddr/s_axi_awaddr[17]} {adc2ddr/s_axi_awaddr[18]} {adc2ddr/s_axi_awaddr[19]} {adc2ddr/s_axi_awaddr[20]} {adc2ddr/s_axi_awaddr[21]} {adc2ddr/s_axi_awaddr[22]} {adc2ddr/s_axi_awaddr[23]} {adc2ddr/s_axi_awaddr[24]} {adc2ddr/s_axi_awaddr[25]} {adc2ddr/s_axi_awaddr[26]} {adc2ddr/s_axi_awaddr[27]} {adc2ddr/s_axi_awaddr[28]} {adc2ddr/s_axi_awaddr[29]} {adc2ddr/s_axi_awaddr[30]} {adc2ddr/s_axi_awaddr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {adc2ddr/wordnum[0]} {adc2ddr/wordnum[1]} {adc2ddr/wordnum[2]} {adc2ddr/wordnum[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {adc2ddr/datacnt[0]} {adc2ddr/datacnt[1]} {adc2ddr/datacnt[2]} {adc2ddr/datacnt[3]} {adc2ddr/datacnt[4]} {adc2ddr/datacnt[5]} {adc2ddr/datacnt[6]} {adc2ddr/datacnt[7]} {adc2ddr/datacnt[8]} {adc2ddr/datacnt[9]} {adc2ddr/datacnt[10]} {adc2ddr/datacnt[11]} {adc2ddr/datacnt[12]} {adc2ddr/datacnt[13]} {adc2ddr/datacnt[14]} {adc2ddr/datacnt[15]} {adc2ddr/datacnt[16]} {adc2ddr/datacnt[17]} {adc2ddr/datacnt[18]} {adc2ddr/datacnt[19]} {adc2ddr/datacnt[20]} {adc2ddr/datacnt[21]} {adc2ddr/datacnt[22]} {adc2ddr/datacnt[23]} {adc2ddr/datacnt[24]} {adc2ddr/datacnt[25]} {adc2ddr/datacnt[26]} {adc2ddr/datacnt[27]} {adc2ddr/datacnt[28]} {adc2ddr/datacnt[29]} {adc2ddr/datacnt[30]} {adc2ddr/datacnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 3 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {adc2ddr/s_axi_awsize[0]} {adc2ddr/s_axi_awsize[1]} {adc2ddr/s_axi_awsize[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 4 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {adc2ddr/s_axi_awqos[0]} {adc2ddr/s_axi_awqos[1]} {adc2ddr/s_axi_awqos[2]} {adc2ddr/s_axi_awqos[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 4 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {adc2ddr/s_axi_wstrb[0]} {adc2ddr/s_axi_wstrb[1]} {adc2ddr/s_axi_wstrb[2]} {adc2ddr/s_axi_wstrb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {adc2ddr/s_axi_wdata[0]} {adc2ddr/s_axi_wdata[1]} {adc2ddr/s_axi_wdata[2]} {adc2ddr/s_axi_wdata[3]} {adc2ddr/s_axi_wdata[4]} {adc2ddr/s_axi_wdata[5]} {adc2ddr/s_axi_wdata[6]} {adc2ddr/s_axi_wdata[7]} {adc2ddr/s_axi_wdata[8]} {adc2ddr/s_axi_wdata[9]} {adc2ddr/s_axi_wdata[10]} {adc2ddr/s_axi_wdata[11]} {adc2ddr/s_axi_wdata[12]} {adc2ddr/s_axi_wdata[13]} {adc2ddr/s_axi_wdata[14]} {adc2ddr/s_axi_wdata[15]} {adc2ddr/s_axi_wdata[16]} {adc2ddr/s_axi_wdata[17]} {adc2ddr/s_axi_wdata[18]} {adc2ddr/s_axi_wdata[19]} {adc2ddr/s_axi_wdata[20]} {adc2ddr/s_axi_wdata[21]} {adc2ddr/s_axi_wdata[22]} {adc2ddr/s_axi_wdata[23]} {adc2ddr/s_axi_wdata[24]} {adc2ddr/s_axi_wdata[25]} {adc2ddr/s_axi_wdata[26]} {adc2ddr/s_axi_wdata[27]} {adc2ddr/s_axi_wdata[28]} {adc2ddr/s_axi_wdata[29]} {adc2ddr/s_axi_wdata[30]} {adc2ddr/s_axi_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 2 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {adc2ddr/s_axi_bresp[0]} {adc2ddr/s_axi_bresp[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list adc2ddr/prev_trigger]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list adc2ddr/s_axi_awready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list adc2ddr/s_axi_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list adc2ddr/s_axi_bready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list adc2ddr/s_axi_bvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list adc2ddr/s_axi_wlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list adc2ddr/s_axi_wready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list adc2ddr/s_axi_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list tenkhz_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list adc2ddr/trigger]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sys_n_115]
