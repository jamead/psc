create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list sys/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 9 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {read_dcct_adcs/dcct_adc1/bit_count[0]} {read_dcct_adcs/dcct_adc1/bit_count[1]} {read_dcct_adcs/dcct_adc1/bit_count[2]} {read_dcct_adcs/dcct_adc1/bit_count[3]} {read_dcct_adcs/dcct_adc1/bit_count[4]} {read_dcct_adcs/dcct_adc1/bit_count[5]} {read_dcct_adcs/dcct_adc1/bit_count[6]} {read_dcct_adcs/dcct_adc1/bit_count[7]} {read_dcct_adcs/dcct_adc1/bit_count[8]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 20 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {read_dcct_adcs/dcct_adc1/dcct2[0]} {read_dcct_adcs/dcct_adc1/dcct2[1]} {read_dcct_adcs/dcct_adc1/dcct2[2]} {read_dcct_adcs/dcct_adc1/dcct2[3]} {read_dcct_adcs/dcct_adc1/dcct2[4]} {read_dcct_adcs/dcct_adc1/dcct2[5]} {read_dcct_adcs/dcct_adc1/dcct2[6]} {read_dcct_adcs/dcct_adc1/dcct2[7]} {read_dcct_adcs/dcct_adc1/dcct2[8]} {read_dcct_adcs/dcct_adc1/dcct2[9]} {read_dcct_adcs/dcct_adc1/dcct2[10]} {read_dcct_adcs/dcct_adc1/dcct2[11]} {read_dcct_adcs/dcct_adc1/dcct2[12]} {read_dcct_adcs/dcct_adc1/dcct2[13]} {read_dcct_adcs/dcct_adc1/dcct2[14]} {read_dcct_adcs/dcct_adc1/dcct2[15]} {read_dcct_adcs/dcct_adc1/dcct2[16]} {read_dcct_adcs/dcct_adc1/dcct2[17]} {read_dcct_adcs/dcct_adc1/dcct2[18]} {read_dcct_adcs/dcct_adc1/dcct2[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 20 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {read_dcct_adcs/dcct_adc1/dcct1[0]} {read_dcct_adcs/dcct_adc1/dcct1[1]} {read_dcct_adcs/dcct_adc1/dcct1[2]} {read_dcct_adcs/dcct_adc1/dcct1[3]} {read_dcct_adcs/dcct_adc1/dcct1[4]} {read_dcct_adcs/dcct_adc1/dcct1[5]} {read_dcct_adcs/dcct_adc1/dcct1[6]} {read_dcct_adcs/dcct_adc1/dcct1[7]} {read_dcct_adcs/dcct_adc1/dcct1[8]} {read_dcct_adcs/dcct_adc1/dcct1[9]} {read_dcct_adcs/dcct_adc1/dcct1[10]} {read_dcct_adcs/dcct_adc1/dcct1[11]} {read_dcct_adcs/dcct_adc1/dcct1[12]} {read_dcct_adcs/dcct_adc1/dcct1[13]} {read_dcct_adcs/dcct_adc1/dcct1[14]} {read_dcct_adcs/dcct_adc1/dcct1[15]} {read_dcct_adcs/dcct_adc1/dcct1[16]} {read_dcct_adcs/dcct_adc1/dcct1[17]} {read_dcct_adcs/dcct_adc1/dcct1[18]} {read_dcct_adcs/dcct_adc1/dcct1[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 3 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {read_dcct_adcs/dcct_adc1/state[0]} {read_dcct_adcs/dcct_adc1/state[1]} {read_dcct_adcs/dcct_adc1/state[2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 6 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {read_dcct_adcs/dcct_adc1/num_bits[0]} {read_dcct_adcs/dcct_adc1/num_bits[1]} {read_dcct_adcs/dcct_adc1/num_bits[2]} {read_dcct_adcs/dcct_adc1/num_bits[3]} {read_dcct_adcs/dcct_adc1/num_bits[4]} {read_dcct_adcs/dcct_adc1/num_bits[5]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 40 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {read_dcct_adcs/dcct_adc1/shift_reg[0]} {read_dcct_adcs/dcct_adc1/shift_reg[1]} {read_dcct_adcs/dcct_adc1/shift_reg[2]} {read_dcct_adcs/dcct_adc1/shift_reg[3]} {read_dcct_adcs/dcct_adc1/shift_reg[4]} {read_dcct_adcs/dcct_adc1/shift_reg[5]} {read_dcct_adcs/dcct_adc1/shift_reg[6]} {read_dcct_adcs/dcct_adc1/shift_reg[7]} {read_dcct_adcs/dcct_adc1/shift_reg[8]} {read_dcct_adcs/dcct_adc1/shift_reg[9]} {read_dcct_adcs/dcct_adc1/shift_reg[10]} {read_dcct_adcs/dcct_adc1/shift_reg[11]} {read_dcct_adcs/dcct_adc1/shift_reg[12]} {read_dcct_adcs/dcct_adc1/shift_reg[13]} {read_dcct_adcs/dcct_adc1/shift_reg[14]} {read_dcct_adcs/dcct_adc1/shift_reg[15]} {read_dcct_adcs/dcct_adc1/shift_reg[16]} {read_dcct_adcs/dcct_adc1/shift_reg[17]} {read_dcct_adcs/dcct_adc1/shift_reg[18]} {read_dcct_adcs/dcct_adc1/shift_reg[19]} {read_dcct_adcs/dcct_adc1/shift_reg[20]} {read_dcct_adcs/dcct_adc1/shift_reg[21]} {read_dcct_adcs/dcct_adc1/shift_reg[22]} {read_dcct_adcs/dcct_adc1/shift_reg[23]} {read_dcct_adcs/dcct_adc1/shift_reg[24]} {read_dcct_adcs/dcct_adc1/shift_reg[25]} {read_dcct_adcs/dcct_adc1/shift_reg[26]} {read_dcct_adcs/dcct_adc1/shift_reg[27]} {read_dcct_adcs/dcct_adc1/shift_reg[28]} {read_dcct_adcs/dcct_adc1/shift_reg[29]} {read_dcct_adcs/dcct_adc1/shift_reg[30]} {read_dcct_adcs/dcct_adc1/shift_reg[31]} {read_dcct_adcs/dcct_adc1/shift_reg[32]} {read_dcct_adcs/dcct_adc1/shift_reg[33]} {read_dcct_adcs/dcct_adc1/shift_reg[34]} {read_dcct_adcs/dcct_adc1/shift_reg[35]} {read_dcct_adcs/dcct_adc1/shift_reg[36]} {read_dcct_adcs/dcct_adc1/shift_reg[37]} {read_dcct_adcs/dcct_adc1/shift_reg[38]} {read_dcct_adcs/dcct_adc1/shift_reg[39]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 20 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {read_dcct_adcs/dcct_params[ps1][dcct1_offset][0]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][1]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][2]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][3]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][4]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][5]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][6]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][7]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][8]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][9]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][10]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][11]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][12]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][13]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][14]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][15]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][16]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][17]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][18]} {read_dcct_adcs/dcct_params[ps1][dcct1_offset][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 24 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {read_dcct_adcs/dcct_params[ps1][dcct1_gain][0]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][1]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][2]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][3]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][4]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][5]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][6]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][7]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][8]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][9]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][10]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][11]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][12]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][13]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][14]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][15]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][16]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][17]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][18]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][19]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][20]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][21]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][22]} {read_dcct_adcs/dcct_params[ps1][dcct1_gain][23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 20 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {read_dcct_adcs/dcct_params[ps1][dcct0_offset][0]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][1]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][2]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][3]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][4]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][5]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][6]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][7]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][8]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][9]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][10]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][11]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][12]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][13]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][14]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][15]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][16]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][17]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][18]} {read_dcct_adcs/dcct_params[ps1][dcct0_offset][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 24 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {read_dcct_adcs/dcct_params[ps1][dcct0_gain][0]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][1]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][2]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][3]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][4]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][5]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][6]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][7]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][8]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][9]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][10]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][11]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][12]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][13]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][14]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][15]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][16]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][17]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][18]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][19]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][20]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][21]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][22]} {read_dcct_adcs/dcct_params[ps1][dcct0_gain][23]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 20 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {read_dcct_adcs/dcct_out[ps4][dcct1][0]} {read_dcct_adcs/dcct_out[ps4][dcct1][1]} {read_dcct_adcs/dcct_out[ps4][dcct1][2]} {read_dcct_adcs/dcct_out[ps4][dcct1][3]} {read_dcct_adcs/dcct_out[ps4][dcct1][4]} {read_dcct_adcs/dcct_out[ps4][dcct1][5]} {read_dcct_adcs/dcct_out[ps4][dcct1][6]} {read_dcct_adcs/dcct_out[ps4][dcct1][7]} {read_dcct_adcs/dcct_out[ps4][dcct1][8]} {read_dcct_adcs/dcct_out[ps4][dcct1][9]} {read_dcct_adcs/dcct_out[ps4][dcct1][10]} {read_dcct_adcs/dcct_out[ps4][dcct1][11]} {read_dcct_adcs/dcct_out[ps4][dcct1][12]} {read_dcct_adcs/dcct_out[ps4][dcct1][13]} {read_dcct_adcs/dcct_out[ps4][dcct1][14]} {read_dcct_adcs/dcct_out[ps4][dcct1][15]} {read_dcct_adcs/dcct_out[ps4][dcct1][16]} {read_dcct_adcs/dcct_out[ps4][dcct1][17]} {read_dcct_adcs/dcct_out[ps4][dcct1][18]} {read_dcct_adcs/dcct_out[ps4][dcct1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 20 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {read_dcct_adcs/dcct_out[ps4][dcct0][0]} {read_dcct_adcs/dcct_out[ps4][dcct0][1]} {read_dcct_adcs/dcct_out[ps4][dcct0][2]} {read_dcct_adcs/dcct_out[ps4][dcct0][3]} {read_dcct_adcs/dcct_out[ps4][dcct0][4]} {read_dcct_adcs/dcct_out[ps4][dcct0][5]} {read_dcct_adcs/dcct_out[ps4][dcct0][6]} {read_dcct_adcs/dcct_out[ps4][dcct0][7]} {read_dcct_adcs/dcct_out[ps4][dcct0][8]} {read_dcct_adcs/dcct_out[ps4][dcct0][9]} {read_dcct_adcs/dcct_out[ps4][dcct0][10]} {read_dcct_adcs/dcct_out[ps4][dcct0][11]} {read_dcct_adcs/dcct_out[ps4][dcct0][12]} {read_dcct_adcs/dcct_out[ps4][dcct0][13]} {read_dcct_adcs/dcct_out[ps4][dcct0][14]} {read_dcct_adcs/dcct_out[ps4][dcct0][15]} {read_dcct_adcs/dcct_out[ps4][dcct0][16]} {read_dcct_adcs/dcct_out[ps4][dcct0][17]} {read_dcct_adcs/dcct_out[ps4][dcct0][18]} {read_dcct_adcs/dcct_out[ps4][dcct0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 20 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {read_dcct_adcs/dcct_out[ps3][dcct1][0]} {read_dcct_adcs/dcct_out[ps3][dcct1][1]} {read_dcct_adcs/dcct_out[ps3][dcct1][2]} {read_dcct_adcs/dcct_out[ps3][dcct1][3]} {read_dcct_adcs/dcct_out[ps3][dcct1][4]} {read_dcct_adcs/dcct_out[ps3][dcct1][5]} {read_dcct_adcs/dcct_out[ps3][dcct1][6]} {read_dcct_adcs/dcct_out[ps3][dcct1][7]} {read_dcct_adcs/dcct_out[ps3][dcct1][8]} {read_dcct_adcs/dcct_out[ps3][dcct1][9]} {read_dcct_adcs/dcct_out[ps3][dcct1][10]} {read_dcct_adcs/dcct_out[ps3][dcct1][11]} {read_dcct_adcs/dcct_out[ps3][dcct1][12]} {read_dcct_adcs/dcct_out[ps3][dcct1][13]} {read_dcct_adcs/dcct_out[ps3][dcct1][14]} {read_dcct_adcs/dcct_out[ps3][dcct1][15]} {read_dcct_adcs/dcct_out[ps3][dcct1][16]} {read_dcct_adcs/dcct_out[ps3][dcct1][17]} {read_dcct_adcs/dcct_out[ps3][dcct1][18]} {read_dcct_adcs/dcct_out[ps3][dcct1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 20 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {read_dcct_adcs/dcct_out[ps3][dcct0][0]} {read_dcct_adcs/dcct_out[ps3][dcct0][1]} {read_dcct_adcs/dcct_out[ps3][dcct0][2]} {read_dcct_adcs/dcct_out[ps3][dcct0][3]} {read_dcct_adcs/dcct_out[ps3][dcct0][4]} {read_dcct_adcs/dcct_out[ps3][dcct0][5]} {read_dcct_adcs/dcct_out[ps3][dcct0][6]} {read_dcct_adcs/dcct_out[ps3][dcct0][7]} {read_dcct_adcs/dcct_out[ps3][dcct0][8]} {read_dcct_adcs/dcct_out[ps3][dcct0][9]} {read_dcct_adcs/dcct_out[ps3][dcct0][10]} {read_dcct_adcs/dcct_out[ps3][dcct0][11]} {read_dcct_adcs/dcct_out[ps3][dcct0][12]} {read_dcct_adcs/dcct_out[ps3][dcct0][13]} {read_dcct_adcs/dcct_out[ps3][dcct0][14]} {read_dcct_adcs/dcct_out[ps3][dcct0][15]} {read_dcct_adcs/dcct_out[ps3][dcct0][16]} {read_dcct_adcs/dcct_out[ps3][dcct0][17]} {read_dcct_adcs/dcct_out[ps3][dcct0][18]} {read_dcct_adcs/dcct_out[ps3][dcct0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 20 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {read_dcct_adcs/dcct_out[ps2][dcct1][0]} {read_dcct_adcs/dcct_out[ps2][dcct1][1]} {read_dcct_adcs/dcct_out[ps2][dcct1][2]} {read_dcct_adcs/dcct_out[ps2][dcct1][3]} {read_dcct_adcs/dcct_out[ps2][dcct1][4]} {read_dcct_adcs/dcct_out[ps2][dcct1][5]} {read_dcct_adcs/dcct_out[ps2][dcct1][6]} {read_dcct_adcs/dcct_out[ps2][dcct1][7]} {read_dcct_adcs/dcct_out[ps2][dcct1][8]} {read_dcct_adcs/dcct_out[ps2][dcct1][9]} {read_dcct_adcs/dcct_out[ps2][dcct1][10]} {read_dcct_adcs/dcct_out[ps2][dcct1][11]} {read_dcct_adcs/dcct_out[ps2][dcct1][12]} {read_dcct_adcs/dcct_out[ps2][dcct1][13]} {read_dcct_adcs/dcct_out[ps2][dcct1][14]} {read_dcct_adcs/dcct_out[ps2][dcct1][15]} {read_dcct_adcs/dcct_out[ps2][dcct1][16]} {read_dcct_adcs/dcct_out[ps2][dcct1][17]} {read_dcct_adcs/dcct_out[ps2][dcct1][18]} {read_dcct_adcs/dcct_out[ps2][dcct1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 20 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {read_dcct_adcs/dcct_out[ps2][dcct0][0]} {read_dcct_adcs/dcct_out[ps2][dcct0][1]} {read_dcct_adcs/dcct_out[ps2][dcct0][2]} {read_dcct_adcs/dcct_out[ps2][dcct0][3]} {read_dcct_adcs/dcct_out[ps2][dcct0][4]} {read_dcct_adcs/dcct_out[ps2][dcct0][5]} {read_dcct_adcs/dcct_out[ps2][dcct0][6]} {read_dcct_adcs/dcct_out[ps2][dcct0][7]} {read_dcct_adcs/dcct_out[ps2][dcct0][8]} {read_dcct_adcs/dcct_out[ps2][dcct0][9]} {read_dcct_adcs/dcct_out[ps2][dcct0][10]} {read_dcct_adcs/dcct_out[ps2][dcct0][11]} {read_dcct_adcs/dcct_out[ps2][dcct0][12]} {read_dcct_adcs/dcct_out[ps2][dcct0][13]} {read_dcct_adcs/dcct_out[ps2][dcct0][14]} {read_dcct_adcs/dcct_out[ps2][dcct0][15]} {read_dcct_adcs/dcct_out[ps2][dcct0][16]} {read_dcct_adcs/dcct_out[ps2][dcct0][17]} {read_dcct_adcs/dcct_out[ps2][dcct0][18]} {read_dcct_adcs/dcct_out[ps2][dcct0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 20 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {read_dcct_adcs/dcct_out[ps1][dcct1][0]} {read_dcct_adcs/dcct_out[ps1][dcct1][1]} {read_dcct_adcs/dcct_out[ps1][dcct1][2]} {read_dcct_adcs/dcct_out[ps1][dcct1][3]} {read_dcct_adcs/dcct_out[ps1][dcct1][4]} {read_dcct_adcs/dcct_out[ps1][dcct1][5]} {read_dcct_adcs/dcct_out[ps1][dcct1][6]} {read_dcct_adcs/dcct_out[ps1][dcct1][7]} {read_dcct_adcs/dcct_out[ps1][dcct1][8]} {read_dcct_adcs/dcct_out[ps1][dcct1][9]} {read_dcct_adcs/dcct_out[ps1][dcct1][10]} {read_dcct_adcs/dcct_out[ps1][dcct1][11]} {read_dcct_adcs/dcct_out[ps1][dcct1][12]} {read_dcct_adcs/dcct_out[ps1][dcct1][13]} {read_dcct_adcs/dcct_out[ps1][dcct1][14]} {read_dcct_adcs/dcct_out[ps1][dcct1][15]} {read_dcct_adcs/dcct_out[ps1][dcct1][16]} {read_dcct_adcs/dcct_out[ps1][dcct1][17]} {read_dcct_adcs/dcct_out[ps1][dcct1][18]} {read_dcct_adcs/dcct_out[ps1][dcct1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 20 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {read_dcct_adcs/dcct_out[ps1][dcct0][0]} {read_dcct_adcs/dcct_out[ps1][dcct0][1]} {read_dcct_adcs/dcct_out[ps1][dcct0][2]} {read_dcct_adcs/dcct_out[ps1][dcct0][3]} {read_dcct_adcs/dcct_out[ps1][dcct0][4]} {read_dcct_adcs/dcct_out[ps1][dcct0][5]} {read_dcct_adcs/dcct_out[ps1][dcct0][6]} {read_dcct_adcs/dcct_out[ps1][dcct0][7]} {read_dcct_adcs/dcct_out[ps1][dcct0][8]} {read_dcct_adcs/dcct_out[ps1][dcct0][9]} {read_dcct_adcs/dcct_out[ps1][dcct0][10]} {read_dcct_adcs/dcct_out[ps1][dcct0][11]} {read_dcct_adcs/dcct_out[ps1][dcct0][12]} {read_dcct_adcs/dcct_out[ps1][dcct0][13]} {read_dcct_adcs/dcct_out[ps1][dcct0][14]} {read_dcct_adcs/dcct_out[ps1][dcct0][15]} {read_dcct_adcs/dcct_out[ps1][dcct0][16]} {read_dcct_adcs/dcct_out[ps1][dcct0][17]} {read_dcct_adcs/dcct_out[ps1][dcct0][18]} {read_dcct_adcs/dcct_out[ps1][dcct0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {read_dcct_adcs/dcct_params[numbits_sel]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list read_dcct_adcs/done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list read_dcct_adcs/dcct_adc1/sclk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list read_dcct_adcs/conv_done]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list tenkhz_trig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list read_dcct_adcs/dcct_adc1/sdi]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list read_dcct_adcs/dcct_adc1/start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list read_dcct_adcs/dcct_adc1/cnv]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list read_dcct_adcs/dcct_adc1/data_rdy]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets pl_clk0]
