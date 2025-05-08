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
connect_debug_port u_ila_0/probe0 [get_nets [list {read_dcct_adcs/dcct[1][0]} {read_dcct_adcs/dcct[1][1]} {read_dcct_adcs/dcct[1][2]} {read_dcct_adcs/dcct[1][3]} {read_dcct_adcs/dcct[1][4]} {read_dcct_adcs/dcct[1][5]} {read_dcct_adcs/dcct[1][6]} {read_dcct_adcs/dcct[1][7]} {read_dcct_adcs/dcct[1][8]} {read_dcct_adcs/dcct[1][9]} {read_dcct_adcs/dcct[1][10]} {read_dcct_adcs/dcct[1][11]} {read_dcct_adcs/dcct[1][12]} {read_dcct_adcs/dcct[1][13]} {read_dcct_adcs/dcct[1][14]} {read_dcct_adcs/dcct[1][15]} {read_dcct_adcs/dcct[1][16]} {read_dcct_adcs/dcct[1][17]} {read_dcct_adcs/dcct[1][18]} {read_dcct_adcs/dcct[1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 20 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {read_dcct_adcs/dcct[0][0]} {read_dcct_adcs/dcct[0][1]} {read_dcct_adcs/dcct[0][2]} {read_dcct_adcs/dcct[0][3]} {read_dcct_adcs/dcct[0][4]} {read_dcct_adcs/dcct[0][5]} {read_dcct_adcs/dcct[0][6]} {read_dcct_adcs/dcct[0][7]} {read_dcct_adcs/dcct[0][8]} {read_dcct_adcs/dcct[0][9]} {read_dcct_adcs/dcct[0][10]} {read_dcct_adcs/dcct[0][11]} {read_dcct_adcs/dcct[0][12]} {read_dcct_adcs/dcct[0][13]} {read_dcct_adcs/dcct[0][14]} {read_dcct_adcs/dcct[0][15]} {read_dcct_adcs/dcct[0][16]} {read_dcct_adcs/dcct[0][17]} {read_dcct_adcs/dcct[0][18]} {read_dcct_adcs/dcct[0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 20 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {read_dcct_adcs/dcct[2][0]} {read_dcct_adcs/dcct[2][1]} {read_dcct_adcs/dcct[2][2]} {read_dcct_adcs/dcct[2][3]} {read_dcct_adcs/dcct[2][4]} {read_dcct_adcs/dcct[2][5]} {read_dcct_adcs/dcct[2][6]} {read_dcct_adcs/dcct[2][7]} {read_dcct_adcs/dcct[2][8]} {read_dcct_adcs/dcct[2][9]} {read_dcct_adcs/dcct[2][10]} {read_dcct_adcs/dcct[2][11]} {read_dcct_adcs/dcct[2][12]} {read_dcct_adcs/dcct[2][13]} {read_dcct_adcs/dcct[2][14]} {read_dcct_adcs/dcct[2][15]} {read_dcct_adcs/dcct[2][16]} {read_dcct_adcs/dcct[2][17]} {read_dcct_adcs/dcct[2][18]} {read_dcct_adcs/dcct[2][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 20 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {read_dcct_adcs/dcct[3][0]} {read_dcct_adcs/dcct[3][1]} {read_dcct_adcs/dcct[3][2]} {read_dcct_adcs/dcct[3][3]} {read_dcct_adcs/dcct[3][4]} {read_dcct_adcs/dcct[3][5]} {read_dcct_adcs/dcct[3][6]} {read_dcct_adcs/dcct[3][7]} {read_dcct_adcs/dcct[3][8]} {read_dcct_adcs/dcct[3][9]} {read_dcct_adcs/dcct[3][10]} {read_dcct_adcs/dcct[3][11]} {read_dcct_adcs/dcct[3][12]} {read_dcct_adcs/dcct[3][13]} {read_dcct_adcs/dcct[3][14]} {read_dcct_adcs/dcct[3][15]} {read_dcct_adcs/dcct[3][16]} {read_dcct_adcs/dcct[3][17]} {read_dcct_adcs/dcct[3][18]} {read_dcct_adcs/dcct[3][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 20 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {read_dcct_adcs/dcct[4][0]} {read_dcct_adcs/dcct[4][1]} {read_dcct_adcs/dcct[4][2]} {read_dcct_adcs/dcct[4][3]} {read_dcct_adcs/dcct[4][4]} {read_dcct_adcs/dcct[4][5]} {read_dcct_adcs/dcct[4][6]} {read_dcct_adcs/dcct[4][7]} {read_dcct_adcs/dcct[4][8]} {read_dcct_adcs/dcct[4][9]} {read_dcct_adcs/dcct[4][10]} {read_dcct_adcs/dcct[4][11]} {read_dcct_adcs/dcct[4][12]} {read_dcct_adcs/dcct[4][13]} {read_dcct_adcs/dcct[4][14]} {read_dcct_adcs/dcct[4][15]} {read_dcct_adcs/dcct[4][16]} {read_dcct_adcs/dcct[4][17]} {read_dcct_adcs/dcct[4][18]} {read_dcct_adcs/dcct[4][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 20 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {read_dcct_adcs/dcct[7][0]} {read_dcct_adcs/dcct[7][1]} {read_dcct_adcs/dcct[7][2]} {read_dcct_adcs/dcct[7][3]} {read_dcct_adcs/dcct[7][4]} {read_dcct_adcs/dcct[7][5]} {read_dcct_adcs/dcct[7][6]} {read_dcct_adcs/dcct[7][7]} {read_dcct_adcs/dcct[7][8]} {read_dcct_adcs/dcct[7][9]} {read_dcct_adcs/dcct[7][10]} {read_dcct_adcs/dcct[7][11]} {read_dcct_adcs/dcct[7][12]} {read_dcct_adcs/dcct[7][13]} {read_dcct_adcs/dcct[7][14]} {read_dcct_adcs/dcct[7][15]} {read_dcct_adcs/dcct[7][16]} {read_dcct_adcs/dcct[7][17]} {read_dcct_adcs/dcct[7][18]} {read_dcct_adcs/dcct[7][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 20 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {read_dcct_adcs/dcct[5][0]} {read_dcct_adcs/dcct[5][1]} {read_dcct_adcs/dcct[5][2]} {read_dcct_adcs/dcct[5][3]} {read_dcct_adcs/dcct[5][4]} {read_dcct_adcs/dcct[5][5]} {read_dcct_adcs/dcct[5][6]} {read_dcct_adcs/dcct[5][7]} {read_dcct_adcs/dcct[5][8]} {read_dcct_adcs/dcct[5][9]} {read_dcct_adcs/dcct[5][10]} {read_dcct_adcs/dcct[5][11]} {read_dcct_adcs/dcct[5][12]} {read_dcct_adcs/dcct[5][13]} {read_dcct_adcs/dcct[5][14]} {read_dcct_adcs/dcct[5][15]} {read_dcct_adcs/dcct[5][16]} {read_dcct_adcs/dcct[5][17]} {read_dcct_adcs/dcct[5][18]} {read_dcct_adcs/dcct[5][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 20 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {read_dcct_adcs/dcct[6][0]} {read_dcct_adcs/dcct[6][1]} {read_dcct_adcs/dcct[6][2]} {read_dcct_adcs/dcct[6][3]} {read_dcct_adcs/dcct[6][4]} {read_dcct_adcs/dcct[6][5]} {read_dcct_adcs/dcct[6][6]} {read_dcct_adcs/dcct[6][7]} {read_dcct_adcs/dcct[6][8]} {read_dcct_adcs/dcct[6][9]} {read_dcct_adcs/dcct[6][10]} {read_dcct_adcs/dcct[6][11]} {read_dcct_adcs/dcct[6][12]} {read_dcct_adcs/dcct[6][13]} {read_dcct_adcs/dcct[6][14]} {read_dcct_adcs/dcct[6][15]} {read_dcct_adcs/dcct[6][16]} {read_dcct_adcs/dcct[6][17]} {read_dcct_adcs/dcct[6][18]} {read_dcct_adcs/dcct[6][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 20 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {read_dcct_adcs/dcct_out[ps1][dcct0][0]} {read_dcct_adcs/dcct_out[ps1][dcct0][1]} {read_dcct_adcs/dcct_out[ps1][dcct0][2]} {read_dcct_adcs/dcct_out[ps1][dcct0][3]} {read_dcct_adcs/dcct_out[ps1][dcct0][4]} {read_dcct_adcs/dcct_out[ps1][dcct0][5]} {read_dcct_adcs/dcct_out[ps1][dcct0][6]} {read_dcct_adcs/dcct_out[ps1][dcct0][7]} {read_dcct_adcs/dcct_out[ps1][dcct0][8]} {read_dcct_adcs/dcct_out[ps1][dcct0][9]} {read_dcct_adcs/dcct_out[ps1][dcct0][10]} {read_dcct_adcs/dcct_out[ps1][dcct0][11]} {read_dcct_adcs/dcct_out[ps1][dcct0][12]} {read_dcct_adcs/dcct_out[ps1][dcct0][13]} {read_dcct_adcs/dcct_out[ps1][dcct0][14]} {read_dcct_adcs/dcct_out[ps1][dcct0][15]} {read_dcct_adcs/dcct_out[ps1][dcct0][16]} {read_dcct_adcs/dcct_out[ps1][dcct0][17]} {read_dcct_adcs/dcct_out[ps1][dcct0][18]} {read_dcct_adcs/dcct_out[ps1][dcct0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 20 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {read_dcct_adcs/dcct_out[ps1][dcct1][0]} {read_dcct_adcs/dcct_out[ps1][dcct1][1]} {read_dcct_adcs/dcct_out[ps1][dcct1][2]} {read_dcct_adcs/dcct_out[ps1][dcct1][3]} {read_dcct_adcs/dcct_out[ps1][dcct1][4]} {read_dcct_adcs/dcct_out[ps1][dcct1][5]} {read_dcct_adcs/dcct_out[ps1][dcct1][6]} {read_dcct_adcs/dcct_out[ps1][dcct1][7]} {read_dcct_adcs/dcct_out[ps1][dcct1][8]} {read_dcct_adcs/dcct_out[ps1][dcct1][9]} {read_dcct_adcs/dcct_out[ps1][dcct1][10]} {read_dcct_adcs/dcct_out[ps1][dcct1][11]} {read_dcct_adcs/dcct_out[ps1][dcct1][12]} {read_dcct_adcs/dcct_out[ps1][dcct1][13]} {read_dcct_adcs/dcct_out[ps1][dcct1][14]} {read_dcct_adcs/dcct_out[ps1][dcct1][15]} {read_dcct_adcs/dcct_out[ps1][dcct1][16]} {read_dcct_adcs/dcct_out[ps1][dcct1][17]} {read_dcct_adcs/dcct_out[ps1][dcct1][18]} {read_dcct_adcs/dcct_out[ps1][dcct1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 20 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {read_dcct_adcs/dcct_out[ps2][dcct0][0]} {read_dcct_adcs/dcct_out[ps2][dcct0][1]} {read_dcct_adcs/dcct_out[ps2][dcct0][2]} {read_dcct_adcs/dcct_out[ps2][dcct0][3]} {read_dcct_adcs/dcct_out[ps2][dcct0][4]} {read_dcct_adcs/dcct_out[ps2][dcct0][5]} {read_dcct_adcs/dcct_out[ps2][dcct0][6]} {read_dcct_adcs/dcct_out[ps2][dcct0][7]} {read_dcct_adcs/dcct_out[ps2][dcct0][8]} {read_dcct_adcs/dcct_out[ps2][dcct0][9]} {read_dcct_adcs/dcct_out[ps2][dcct0][10]} {read_dcct_adcs/dcct_out[ps2][dcct0][11]} {read_dcct_adcs/dcct_out[ps2][dcct0][12]} {read_dcct_adcs/dcct_out[ps2][dcct0][13]} {read_dcct_adcs/dcct_out[ps2][dcct0][14]} {read_dcct_adcs/dcct_out[ps2][dcct0][15]} {read_dcct_adcs/dcct_out[ps2][dcct0][16]} {read_dcct_adcs/dcct_out[ps2][dcct0][17]} {read_dcct_adcs/dcct_out[ps2][dcct0][18]} {read_dcct_adcs/dcct_out[ps2][dcct0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 20 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {read_dcct_adcs/dcct_out[ps2][dcct1][0]} {read_dcct_adcs/dcct_out[ps2][dcct1][1]} {read_dcct_adcs/dcct_out[ps2][dcct1][2]} {read_dcct_adcs/dcct_out[ps2][dcct1][3]} {read_dcct_adcs/dcct_out[ps2][dcct1][4]} {read_dcct_adcs/dcct_out[ps2][dcct1][5]} {read_dcct_adcs/dcct_out[ps2][dcct1][6]} {read_dcct_adcs/dcct_out[ps2][dcct1][7]} {read_dcct_adcs/dcct_out[ps2][dcct1][8]} {read_dcct_adcs/dcct_out[ps2][dcct1][9]} {read_dcct_adcs/dcct_out[ps2][dcct1][10]} {read_dcct_adcs/dcct_out[ps2][dcct1][11]} {read_dcct_adcs/dcct_out[ps2][dcct1][12]} {read_dcct_adcs/dcct_out[ps2][dcct1][13]} {read_dcct_adcs/dcct_out[ps2][dcct1][14]} {read_dcct_adcs/dcct_out[ps2][dcct1][15]} {read_dcct_adcs/dcct_out[ps2][dcct1][16]} {read_dcct_adcs/dcct_out[ps2][dcct1][17]} {read_dcct_adcs/dcct_out[ps2][dcct1][18]} {read_dcct_adcs/dcct_out[ps2][dcct1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 20 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {read_dcct_adcs/dcct_out[ps3][dcct0][0]} {read_dcct_adcs/dcct_out[ps3][dcct0][1]} {read_dcct_adcs/dcct_out[ps3][dcct0][2]} {read_dcct_adcs/dcct_out[ps3][dcct0][3]} {read_dcct_adcs/dcct_out[ps3][dcct0][4]} {read_dcct_adcs/dcct_out[ps3][dcct0][5]} {read_dcct_adcs/dcct_out[ps3][dcct0][6]} {read_dcct_adcs/dcct_out[ps3][dcct0][7]} {read_dcct_adcs/dcct_out[ps3][dcct0][8]} {read_dcct_adcs/dcct_out[ps3][dcct0][9]} {read_dcct_adcs/dcct_out[ps3][dcct0][10]} {read_dcct_adcs/dcct_out[ps3][dcct0][11]} {read_dcct_adcs/dcct_out[ps3][dcct0][12]} {read_dcct_adcs/dcct_out[ps3][dcct0][13]} {read_dcct_adcs/dcct_out[ps3][dcct0][14]} {read_dcct_adcs/dcct_out[ps3][dcct0][15]} {read_dcct_adcs/dcct_out[ps3][dcct0][16]} {read_dcct_adcs/dcct_out[ps3][dcct0][17]} {read_dcct_adcs/dcct_out[ps3][dcct0][18]} {read_dcct_adcs/dcct_out[ps3][dcct0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 20 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {read_dcct_adcs/dcct_out[ps3][dcct1][0]} {read_dcct_adcs/dcct_out[ps3][dcct1][1]} {read_dcct_adcs/dcct_out[ps3][dcct1][2]} {read_dcct_adcs/dcct_out[ps3][dcct1][3]} {read_dcct_adcs/dcct_out[ps3][dcct1][4]} {read_dcct_adcs/dcct_out[ps3][dcct1][5]} {read_dcct_adcs/dcct_out[ps3][dcct1][6]} {read_dcct_adcs/dcct_out[ps3][dcct1][7]} {read_dcct_adcs/dcct_out[ps3][dcct1][8]} {read_dcct_adcs/dcct_out[ps3][dcct1][9]} {read_dcct_adcs/dcct_out[ps3][dcct1][10]} {read_dcct_adcs/dcct_out[ps3][dcct1][11]} {read_dcct_adcs/dcct_out[ps3][dcct1][12]} {read_dcct_adcs/dcct_out[ps3][dcct1][13]} {read_dcct_adcs/dcct_out[ps3][dcct1][14]} {read_dcct_adcs/dcct_out[ps3][dcct1][15]} {read_dcct_adcs/dcct_out[ps3][dcct1][16]} {read_dcct_adcs/dcct_out[ps3][dcct1][17]} {read_dcct_adcs/dcct_out[ps3][dcct1][18]} {read_dcct_adcs/dcct_out[ps3][dcct1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 20 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {read_dcct_adcs/dcct_out[ps4][dcct0][0]} {read_dcct_adcs/dcct_out[ps4][dcct0][1]} {read_dcct_adcs/dcct_out[ps4][dcct0][2]} {read_dcct_adcs/dcct_out[ps4][dcct0][3]} {read_dcct_adcs/dcct_out[ps4][dcct0][4]} {read_dcct_adcs/dcct_out[ps4][dcct0][5]} {read_dcct_adcs/dcct_out[ps4][dcct0][6]} {read_dcct_adcs/dcct_out[ps4][dcct0][7]} {read_dcct_adcs/dcct_out[ps4][dcct0][8]} {read_dcct_adcs/dcct_out[ps4][dcct0][9]} {read_dcct_adcs/dcct_out[ps4][dcct0][10]} {read_dcct_adcs/dcct_out[ps4][dcct0][11]} {read_dcct_adcs/dcct_out[ps4][dcct0][12]} {read_dcct_adcs/dcct_out[ps4][dcct0][13]} {read_dcct_adcs/dcct_out[ps4][dcct0][14]} {read_dcct_adcs/dcct_out[ps4][dcct0][15]} {read_dcct_adcs/dcct_out[ps4][dcct0][16]} {read_dcct_adcs/dcct_out[ps4][dcct0][17]} {read_dcct_adcs/dcct_out[ps4][dcct0][18]} {read_dcct_adcs/dcct_out[ps4][dcct0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 20 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {read_dcct_adcs/dcct_out[ps4][dcct1][0]} {read_dcct_adcs/dcct_out[ps4][dcct1][1]} {read_dcct_adcs/dcct_out[ps4][dcct1][2]} {read_dcct_adcs/dcct_out[ps4][dcct1][3]} {read_dcct_adcs/dcct_out[ps4][dcct1][4]} {read_dcct_adcs/dcct_out[ps4][dcct1][5]} {read_dcct_adcs/dcct_out[ps4][dcct1][6]} {read_dcct_adcs/dcct_out[ps4][dcct1][7]} {read_dcct_adcs/dcct_out[ps4][dcct1][8]} {read_dcct_adcs/dcct_out[ps4][dcct1][9]} {read_dcct_adcs/dcct_out[ps4][dcct1][10]} {read_dcct_adcs/dcct_out[ps4][dcct1][11]} {read_dcct_adcs/dcct_out[ps4][dcct1][12]} {read_dcct_adcs/dcct_out[ps4][dcct1][13]} {read_dcct_adcs/dcct_out[ps4][dcct1][14]} {read_dcct_adcs/dcct_out[ps4][dcct1][15]} {read_dcct_adcs/dcct_out[ps4][dcct1][16]} {read_dcct_adcs/dcct_out[ps4][dcct1][17]} {read_dcct_adcs/dcct_out[ps4][dcct1][18]} {read_dcct_adcs/dcct_out[ps4][dcct1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 2 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {read_dcct_adcs/dcct_params[ps1][ave_mode][0]} {read_dcct_adcs/dcct_params[ps1][ave_mode][1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 24 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {read_dcct_adcs/dcct_params[ps1][dcct0_gain][0]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][1]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][2]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][3]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][4]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][5]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][6]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][7]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][8]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][9]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][10]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][11]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][12]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][13]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][14]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][15]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][16]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][17]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][18]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][19]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][20]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][21]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][22]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 20 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {read_dcct_adcs/dcct_params[ps1][dcct0_offset][0]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][1]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][2]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][3]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][4]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][5]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][6]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][7]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][8]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][9]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][10]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][11]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][12]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][13]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][14]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][15]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][16]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][17]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][18]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 24 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {read_dcct_adcs/dcct_params[ps1][dcct1_gain][0]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][1]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][2]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][3]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][4]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][5]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][6]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][7]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][8]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][9]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][10]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][11]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][12]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][13]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][14]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][15]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][16]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][17]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][18]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][19]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][20]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][21]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][22]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 20 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {read_dcct_adcs/dcct_params[ps1][dcct1_offset][0]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][1]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][2]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][3]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][4]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][5]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][6]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][7]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][8]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][9]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][10]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][11]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][12]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][13]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][14]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][15]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][16]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][17]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][18]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list read_dcct_adcs/done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {read_dcct_adcs/dcct_params[numbits_sel]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list read_dcct_adcs/conv_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list tenkhz_trig]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets pl_clk0]
