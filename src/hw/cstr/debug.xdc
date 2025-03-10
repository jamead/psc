create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list sys/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 20 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {adc_raw[2][0]} {adc_raw[2][1]} {adc_raw[2][2]} {adc_raw[2][3]} {adc_raw[2][4]} {adc_raw[2][5]} {adc_raw[2][6]} {adc_raw[2][7]} {adc_raw[2][8]} {adc_raw[2][9]} {adc_raw[2][10]} {adc_raw[2][11]} {adc_raw[2][12]} {adc_raw[2][13]} {adc_raw[2][14]} {adc_raw[2][15]} {adc_raw[2][16]} {adc_raw[2][17]} {adc_raw[2][18]} {adc_raw[2][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 20 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {adc_raw[1][0]} {adc_raw[1][1]} {adc_raw[1][2]} {adc_raw[1][3]} {adc_raw[1][4]} {adc_raw[1][5]} {adc_raw[1][6]} {adc_raw[1][7]} {adc_raw[1][8]} {adc_raw[1][9]} {adc_raw[1][10]} {adc_raw[1][11]} {adc_raw[1][12]} {adc_raw[1][13]} {adc_raw[1][14]} {adc_raw[1][15]} {adc_raw[1][16]} {adc_raw[1][17]} {adc_raw[1][18]} {adc_raw[1][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 20 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {adc_raw[3][0]} {adc_raw[3][1]} {adc_raw[3][2]} {adc_raw[3][3]} {adc_raw[3][4]} {adc_raw[3][5]} {adc_raw[3][6]} {adc_raw[3][7]} {adc_raw[3][8]} {adc_raw[3][9]} {adc_raw[3][10]} {adc_raw[3][11]} {adc_raw[3][12]} {adc_raw[3][13]} {adc_raw[3][14]} {adc_raw[3][15]} {adc_raw[3][16]} {adc_raw[3][17]} {adc_raw[3][18]} {adc_raw[3][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 20 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {adc_raw[0][0]} {adc_raw[0][1]} {adc_raw[0][2]} {adc_raw[0][3]} {adc_raw[0][4]} {adc_raw[0][5]} {adc_raw[0][6]} {adc_raw[0][7]} {adc_raw[0][8]} {adc_raw[0][9]} {adc_raw[0][10]} {adc_raw[0][11]} {adc_raw[0][12]} {adc_raw[0][13]} {adc_raw[0][14]} {adc_raw[0][15]} {adc_raw[0][16]} {adc_raw[0][17]} {adc_raw[0][18]} {adc_raw[0][19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 2 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {trig_logic/trig_status[0]} {trig_logic/trig_status[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {stream_fa/sample_num[0]} {stream_fa/sample_num[1]} {stream_fa/sample_num[2]} {stream_fa/sample_num[3]} {stream_fa/sample_num[4]} {stream_fa/sample_num[5]} {stream_fa/sample_num[6]} {stream_fa/sample_num[7]} {stream_fa/sample_num[8]} {stream_fa/sample_num[9]} {stream_fa/sample_num[10]} {stream_fa/sample_num[11]} {stream_fa/sample_num[12]} {stream_fa/sample_num[13]} {stream_fa/sample_num[14]} {stream_fa/sample_num[15]} {stream_fa/sample_num[16]} {stream_fa/sample_num[17]} {stream_fa/sample_num[18]} {stream_fa/sample_num[19]} {stream_fa/sample_num[20]} {stream_fa/sample_num[21]} {stream_fa/sample_num[22]} {stream_fa/sample_num[23]} {stream_fa/sample_num[24]} {stream_fa/sample_num[25]} {stream_fa/sample_num[26]} {stream_fa/sample_num[27]} {stream_fa/sample_num[28]} {stream_fa/sample_num[29]} {stream_fa/sample_num[30]} {stream_fa/sample_num[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 16 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {stream_fa/fifo_rd_data_cnt[0]} {stream_fa/fifo_rd_data_cnt[1]} {stream_fa/fifo_rd_data_cnt[2]} {stream_fa/fifo_rd_data_cnt[3]} {stream_fa/fifo_rd_data_cnt[4]} {stream_fa/fifo_rd_data_cnt[5]} {stream_fa/fifo_rd_data_cnt[6]} {stream_fa/fifo_rd_data_cnt[7]} {stream_fa/fifo_rd_data_cnt[8]} {stream_fa/fifo_rd_data_cnt[9]} {stream_fa/fifo_rd_data_cnt[10]} {stream_fa/fifo_rd_data_cnt[11]} {stream_fa/fifo_rd_data_cnt[12]} {stream_fa/fifo_rd_data_cnt[13]} {stream_fa/fifo_rd_data_cnt[14]} {stream_fa/fifo_rd_data_cnt[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 128 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {stream_fa/fifo_din[0]} {stream_fa/fifo_din[1]} {stream_fa/fifo_din[2]} {stream_fa/fifo_din[3]} {stream_fa/fifo_din[4]} {stream_fa/fifo_din[5]} {stream_fa/fifo_din[6]} {stream_fa/fifo_din[7]} {stream_fa/fifo_din[8]} {stream_fa/fifo_din[9]} {stream_fa/fifo_din[10]} {stream_fa/fifo_din[11]} {stream_fa/fifo_din[12]} {stream_fa/fifo_din[13]} {stream_fa/fifo_din[14]} {stream_fa/fifo_din[15]} {stream_fa/fifo_din[16]} {stream_fa/fifo_din[17]} {stream_fa/fifo_din[18]} {stream_fa/fifo_din[19]} {stream_fa/fifo_din[20]} {stream_fa/fifo_din[21]} {stream_fa/fifo_din[22]} {stream_fa/fifo_din[23]} {stream_fa/fifo_din[24]} {stream_fa/fifo_din[25]} {stream_fa/fifo_din[26]} {stream_fa/fifo_din[27]} {stream_fa/fifo_din[28]} {stream_fa/fifo_din[29]} {stream_fa/fifo_din[30]} {stream_fa/fifo_din[31]} {stream_fa/fifo_din[32]} {stream_fa/fifo_din[33]} {stream_fa/fifo_din[34]} {stream_fa/fifo_din[35]} {stream_fa/fifo_din[36]} {stream_fa/fifo_din[37]} {stream_fa/fifo_din[38]} {stream_fa/fifo_din[39]} {stream_fa/fifo_din[40]} {stream_fa/fifo_din[41]} {stream_fa/fifo_din[42]} {stream_fa/fifo_din[43]} {stream_fa/fifo_din[44]} {stream_fa/fifo_din[45]} {stream_fa/fifo_din[46]} {stream_fa/fifo_din[47]} {stream_fa/fifo_din[48]} {stream_fa/fifo_din[49]} {stream_fa/fifo_din[50]} {stream_fa/fifo_din[51]} {stream_fa/fifo_din[52]} {stream_fa/fifo_din[53]} {stream_fa/fifo_din[54]} {stream_fa/fifo_din[55]} {stream_fa/fifo_din[56]} {stream_fa/fifo_din[57]} {stream_fa/fifo_din[58]} {stream_fa/fifo_din[59]} {stream_fa/fifo_din[60]} {stream_fa/fifo_din[61]} {stream_fa/fifo_din[62]} {stream_fa/fifo_din[63]} {stream_fa/fifo_din[64]} {stream_fa/fifo_din[65]} {stream_fa/fifo_din[66]} {stream_fa/fifo_din[67]} {stream_fa/fifo_din[68]} {stream_fa/fifo_din[69]} {stream_fa/fifo_din[70]} {stream_fa/fifo_din[71]} {stream_fa/fifo_din[72]} {stream_fa/fifo_din[73]} {stream_fa/fifo_din[74]} {stream_fa/fifo_din[75]} {stream_fa/fifo_din[76]} {stream_fa/fifo_din[77]} {stream_fa/fifo_din[78]} {stream_fa/fifo_din[79]} {stream_fa/fifo_din[80]} {stream_fa/fifo_din[81]} {stream_fa/fifo_din[82]} {stream_fa/fifo_din[83]} {stream_fa/fifo_din[84]} {stream_fa/fifo_din[85]} {stream_fa/fifo_din[86]} {stream_fa/fifo_din[87]} {stream_fa/fifo_din[88]} {stream_fa/fifo_din[89]} {stream_fa/fifo_din[90]} {stream_fa/fifo_din[91]} {stream_fa/fifo_din[92]} {stream_fa/fifo_din[93]} {stream_fa/fifo_din[94]} {stream_fa/fifo_din[95]} {stream_fa/fifo_din[96]} {stream_fa/fifo_din[97]} {stream_fa/fifo_din[98]} {stream_fa/fifo_din[99]} {stream_fa/fifo_din[100]} {stream_fa/fifo_din[101]} {stream_fa/fifo_din[102]} {stream_fa/fifo_din[103]} {stream_fa/fifo_din[104]} {stream_fa/fifo_din[105]} {stream_fa/fifo_din[106]} {stream_fa/fifo_din[107]} {stream_fa/fifo_din[108]} {stream_fa/fifo_din[109]} {stream_fa/fifo_din[110]} {stream_fa/fifo_din[111]} {stream_fa/fifo_din[112]} {stream_fa/fifo_din[113]} {stream_fa/fifo_din[114]} {stream_fa/fifo_din[115]} {stream_fa/fifo_din[116]} {stream_fa/fifo_din[117]} {stream_fa/fifo_din[118]} {stream_fa/fifo_din[119]} {stream_fa/fifo_din[120]} {stream_fa/fifo_din[121]} {stream_fa/fifo_din[122]} {stream_fa/fifo_din[123]} {stream_fa/fifo_din[124]} {stream_fa/fifo_din[125]} {stream_fa/fifo_din[126]} {stream_fa/fifo_din[127]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {stream_fa/fa_data[ypos][0]} {stream_fa/fa_data[ypos][1]} {stream_fa/fa_data[ypos][2]} {stream_fa/fa_data[ypos][3]} {stream_fa/fa_data[ypos][4]} {stream_fa/fa_data[ypos][5]} {stream_fa/fa_data[ypos][6]} {stream_fa/fa_data[ypos][7]} {stream_fa/fa_data[ypos][8]} {stream_fa/fa_data[ypos][9]} {stream_fa/fa_data[ypos][10]} {stream_fa/fa_data[ypos][11]} {stream_fa/fa_data[ypos][12]} {stream_fa/fa_data[ypos][13]} {stream_fa/fa_data[ypos][14]} {stream_fa/fa_data[ypos][15]} {stream_fa/fa_data[ypos][16]} {stream_fa/fa_data[ypos][17]} {stream_fa/fa_data[ypos][18]} {stream_fa/fa_data[ypos][19]} {stream_fa/fa_data[ypos][20]} {stream_fa/fa_data[ypos][21]} {stream_fa/fa_data[ypos][22]} {stream_fa/fa_data[ypos][23]} {stream_fa/fa_data[ypos][24]} {stream_fa/fa_data[ypos][25]} {stream_fa/fa_data[ypos][26]} {stream_fa/fa_data[ypos][27]} {stream_fa/fa_data[ypos][28]} {stream_fa/fa_data[ypos][29]} {stream_fa/fa_data[ypos][30]} {stream_fa/fa_data[ypos][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 32 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {stream_fa/fa_data[xpos][0]} {stream_fa/fa_data[xpos][1]} {stream_fa/fa_data[xpos][2]} {stream_fa/fa_data[xpos][3]} {stream_fa/fa_data[xpos][4]} {stream_fa/fa_data[xpos][5]} {stream_fa/fa_data[xpos][6]} {stream_fa/fa_data[xpos][7]} {stream_fa/fa_data[xpos][8]} {stream_fa/fa_data[xpos][9]} {stream_fa/fa_data[xpos][10]} {stream_fa/fa_data[xpos][11]} {stream_fa/fa_data[xpos][12]} {stream_fa/fa_data[xpos][13]} {stream_fa/fa_data[xpos][14]} {stream_fa/fa_data[xpos][15]} {stream_fa/fa_data[xpos][16]} {stream_fa/fa_data[xpos][17]} {stream_fa/fa_data[xpos][18]} {stream_fa/fa_data[xpos][19]} {stream_fa/fa_data[xpos][20]} {stream_fa/fa_data[xpos][21]} {stream_fa/fa_data[xpos][22]} {stream_fa/fa_data[xpos][23]} {stream_fa/fa_data[xpos][24]} {stream_fa/fa_data[xpos][25]} {stream_fa/fa_data[xpos][26]} {stream_fa/fa_data[xpos][27]} {stream_fa/fa_data[xpos][28]} {stream_fa/fa_data[xpos][29]} {stream_fa/fa_data[xpos][30]} {stream_fa/fa_data[xpos][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {stream_fa/fa_data[trignum][0]} {stream_fa/fa_data[trignum][1]} {stream_fa/fa_data[trignum][2]} {stream_fa/fa_data[trignum][3]} {stream_fa/fa_data[trignum][4]} {stream_fa/fa_data[trignum][5]} {stream_fa/fa_data[trignum][6]} {stream_fa/fa_data[trignum][7]} {stream_fa/fa_data[trignum][8]} {stream_fa/fa_data[trignum][9]} {stream_fa/fa_data[trignum][10]} {stream_fa/fa_data[trignum][11]} {stream_fa/fa_data[trignum][12]} {stream_fa/fa_data[trignum][13]} {stream_fa/fa_data[trignum][14]} {stream_fa/fa_data[trignum][15]} {stream_fa/fa_data[trignum][16]} {stream_fa/fa_data[trignum][17]} {stream_fa/fa_data[trignum][18]} {stream_fa/fa_data[trignum][19]} {stream_fa/fa_data[trignum][20]} {stream_fa/fa_data[trignum][21]} {stream_fa/fa_data[trignum][22]} {stream_fa/fa_data[trignum][23]} {stream_fa/fa_data[trignum][24]} {stream_fa/fa_data[trignum][25]} {stream_fa/fa_data[trignum][26]} {stream_fa/fa_data[trignum][27]} {stream_fa/fa_data[trignum][28]} {stream_fa/fa_data[trignum][29]} {stream_fa/fa_data[trignum][30]} {stream_fa/fa_data[trignum][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {stream_fa/fa_data[sum][0]} {stream_fa/fa_data[sum][1]} {stream_fa/fa_data[sum][2]} {stream_fa/fa_data[sum][3]} {stream_fa/fa_data[sum][4]} {stream_fa/fa_data[sum][5]} {stream_fa/fa_data[sum][6]} {stream_fa/fa_data[sum][7]} {stream_fa/fa_data[sum][8]} {stream_fa/fa_data[sum][9]} {stream_fa/fa_data[sum][10]} {stream_fa/fa_data[sum][11]} {stream_fa/fa_data[sum][12]} {stream_fa/fa_data[sum][13]} {stream_fa/fa_data[sum][14]} {stream_fa/fa_data[sum][15]} {stream_fa/fa_data[sum][16]} {stream_fa/fa_data[sum][17]} {stream_fa/fa_data[sum][18]} {stream_fa/fa_data[sum][19]} {stream_fa/fa_data[sum][20]} {stream_fa/fa_data[sum][21]} {stream_fa/fa_data[sum][22]} {stream_fa/fa_data[sum][23]} {stream_fa/fa_data[sum][24]} {stream_fa/fa_data[sum][25]} {stream_fa/fa_data[sum][26]} {stream_fa/fa_data[sum][27]} {stream_fa/fa_data[sum][28]} {stream_fa/fa_data[sum][29]} {stream_fa/fa_data[sum][30]} {stream_fa/fa_data[sum][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 32 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {stream_fa/fa_data[chd_mag][0]} {stream_fa/fa_data[chd_mag][1]} {stream_fa/fa_data[chd_mag][2]} {stream_fa/fa_data[chd_mag][3]} {stream_fa/fa_data[chd_mag][4]} {stream_fa/fa_data[chd_mag][5]} {stream_fa/fa_data[chd_mag][6]} {stream_fa/fa_data[chd_mag][7]} {stream_fa/fa_data[chd_mag][8]} {stream_fa/fa_data[chd_mag][9]} {stream_fa/fa_data[chd_mag][10]} {stream_fa/fa_data[chd_mag][11]} {stream_fa/fa_data[chd_mag][12]} {stream_fa/fa_data[chd_mag][13]} {stream_fa/fa_data[chd_mag][14]} {stream_fa/fa_data[chd_mag][15]} {stream_fa/fa_data[chd_mag][16]} {stream_fa/fa_data[chd_mag][17]} {stream_fa/fa_data[chd_mag][18]} {stream_fa/fa_data[chd_mag][19]} {stream_fa/fa_data[chd_mag][20]} {stream_fa/fa_data[chd_mag][21]} {stream_fa/fa_data[chd_mag][22]} {stream_fa/fa_data[chd_mag][23]} {stream_fa/fa_data[chd_mag][24]} {stream_fa/fa_data[chd_mag][25]} {stream_fa/fa_data[chd_mag][26]} {stream_fa/fa_data[chd_mag][27]} {stream_fa/fa_data[chd_mag][28]} {stream_fa/fa_data[chd_mag][29]} {stream_fa/fa_data[chd_mag][30]} {stream_fa/fa_data[chd_mag][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 32 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {stream_fa/fa_data[chc_mag][0]} {stream_fa/fa_data[chc_mag][1]} {stream_fa/fa_data[chc_mag][2]} {stream_fa/fa_data[chc_mag][3]} {stream_fa/fa_data[chc_mag][4]} {stream_fa/fa_data[chc_mag][5]} {stream_fa/fa_data[chc_mag][6]} {stream_fa/fa_data[chc_mag][7]} {stream_fa/fa_data[chc_mag][8]} {stream_fa/fa_data[chc_mag][9]} {stream_fa/fa_data[chc_mag][10]} {stream_fa/fa_data[chc_mag][11]} {stream_fa/fa_data[chc_mag][12]} {stream_fa/fa_data[chc_mag][13]} {stream_fa/fa_data[chc_mag][14]} {stream_fa/fa_data[chc_mag][15]} {stream_fa/fa_data[chc_mag][16]} {stream_fa/fa_data[chc_mag][17]} {stream_fa/fa_data[chc_mag][18]} {stream_fa/fa_data[chc_mag][19]} {stream_fa/fa_data[chc_mag][20]} {stream_fa/fa_data[chc_mag][21]} {stream_fa/fa_data[chc_mag][22]} {stream_fa/fa_data[chc_mag][23]} {stream_fa/fa_data[chc_mag][24]} {stream_fa/fa_data[chc_mag][25]} {stream_fa/fa_data[chc_mag][26]} {stream_fa/fa_data[chc_mag][27]} {stream_fa/fa_data[chc_mag][28]} {stream_fa/fa_data[chc_mag][29]} {stream_fa/fa_data[chc_mag][30]} {stream_fa/fa_data[chc_mag][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 32 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {stream_fa/fa_data[chb_mag][0]} {stream_fa/fa_data[chb_mag][1]} {stream_fa/fa_data[chb_mag][2]} {stream_fa/fa_data[chb_mag][3]} {stream_fa/fa_data[chb_mag][4]} {stream_fa/fa_data[chb_mag][5]} {stream_fa/fa_data[chb_mag][6]} {stream_fa/fa_data[chb_mag][7]} {stream_fa/fa_data[chb_mag][8]} {stream_fa/fa_data[chb_mag][9]} {stream_fa/fa_data[chb_mag][10]} {stream_fa/fa_data[chb_mag][11]} {stream_fa/fa_data[chb_mag][12]} {stream_fa/fa_data[chb_mag][13]} {stream_fa/fa_data[chb_mag][14]} {stream_fa/fa_data[chb_mag][15]} {stream_fa/fa_data[chb_mag][16]} {stream_fa/fa_data[chb_mag][17]} {stream_fa/fa_data[chb_mag][18]} {stream_fa/fa_data[chb_mag][19]} {stream_fa/fa_data[chb_mag][20]} {stream_fa/fa_data[chb_mag][21]} {stream_fa/fa_data[chb_mag][22]} {stream_fa/fa_data[chb_mag][23]} {stream_fa/fa_data[chb_mag][24]} {stream_fa/fa_data[chb_mag][25]} {stream_fa/fa_data[chb_mag][26]} {stream_fa/fa_data[chb_mag][27]} {stream_fa/fa_data[chb_mag][28]} {stream_fa/fa_data[chb_mag][29]} {stream_fa/fa_data[chb_mag][30]} {stream_fa/fa_data[chb_mag][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {stream_fa/fa_data[cha_mag][0]} {stream_fa/fa_data[cha_mag][1]} {stream_fa/fa_data[cha_mag][2]} {stream_fa/fa_data[cha_mag][3]} {stream_fa/fa_data[cha_mag][4]} {stream_fa/fa_data[cha_mag][5]} {stream_fa/fa_data[cha_mag][6]} {stream_fa/fa_data[cha_mag][7]} {stream_fa/fa_data[cha_mag][8]} {stream_fa/fa_data[cha_mag][9]} {stream_fa/fa_data[cha_mag][10]} {stream_fa/fa_data[cha_mag][11]} {stream_fa/fa_data[cha_mag][12]} {stream_fa/fa_data[cha_mag][13]} {stream_fa/fa_data[cha_mag][14]} {stream_fa/fa_data[cha_mag][15]} {stream_fa/fa_data[cha_mag][16]} {stream_fa/fa_data[cha_mag][17]} {stream_fa/fa_data[cha_mag][18]} {stream_fa/fa_data[cha_mag][19]} {stream_fa/fa_data[cha_mag][20]} {stream_fa/fa_data[cha_mag][21]} {stream_fa/fa_data[cha_mag][22]} {stream_fa/fa_data[cha_mag][23]} {stream_fa/fa_data[cha_mag][24]} {stream_fa/fa_data[cha_mag][25]} {stream_fa/fa_data[cha_mag][26]} {stream_fa/fa_data[cha_mag][27]} {stream_fa/fa_data[cha_mag][28]} {stream_fa/fa_data[cha_mag][29]} {stream_fa/fa_data[cha_mag][30]} {stream_fa/fa_data[cha_mag][31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 2 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {gen_adcs[0].readadc/state[0]} {gen_adcs[0].readadc/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 5 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {gen_adcs[0].readadc/bitnum[0]} {gen_adcs[0].readadc/bitnum[1]} {gen_adcs[0].readadc/bitnum[2]} {gen_adcs[0].readadc/bitnum[3]} {gen_adcs[0].readadc/bitnum[4]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 20 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {gen_adcs[0].readadc/adc_data[0]} {gen_adcs[0].readadc/adc_data[1]} {gen_adcs[0].readadc/adc_data[2]} {gen_adcs[0].readadc/adc_data[3]} {gen_adcs[0].readadc/adc_data[4]} {gen_adcs[0].readadc/adc_data[5]} {gen_adcs[0].readadc/adc_data[6]} {gen_adcs[0].readadc/adc_data[7]} {gen_adcs[0].readadc/adc_data[8]} {gen_adcs[0].readadc/adc_data[9]} {gen_adcs[0].readadc/adc_data[10]} {gen_adcs[0].readadc/adc_data[11]} {gen_adcs[0].readadc/adc_data[12]} {gen_adcs[0].readadc/adc_data[13]} {gen_adcs[0].readadc/adc_data[14]} {gen_adcs[0].readadc/adc_data[15]} {gen_adcs[0].readadc/adc_data[16]} {gen_adcs[0].readadc/adc_data[17]} {gen_adcs[0].readadc/adc_data[18]} {gen_adcs[0].readadc/adc_data[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 20 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {gen_adcs[0].readadc/adc_buf[0]} {gen_adcs[0].readadc/adc_buf[1]} {gen_adcs[0].readadc/adc_buf[2]} {gen_adcs[0].readadc/adc_buf[3]} {gen_adcs[0].readadc/adc_buf[4]} {gen_adcs[0].readadc/adc_buf[5]} {gen_adcs[0].readadc/adc_buf[6]} {gen_adcs[0].readadc/adc_buf[7]} {gen_adcs[0].readadc/adc_buf[8]} {gen_adcs[0].readadc/adc_buf[9]} {gen_adcs[0].readadc/adc_buf[10]} {gen_adcs[0].readadc/adc_buf[11]} {gen_adcs[0].readadc/adc_buf[12]} {gen_adcs[0].readadc/adc_buf[13]} {gen_adcs[0].readadc/adc_buf[14]} {gen_adcs[0].readadc/adc_buf[15]} {gen_adcs[0].readadc/adc_buf[16]} {gen_adcs[0].readadc/adc_buf[17]} {gen_adcs[0].readadc/adc_buf[18]} {gen_adcs[0].readadc/adc_buf[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list stream_fa/fifo_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list stream_fa/fa_data_fiforst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {stream_fa/fa_data[data_rdy]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list stream_fa/fa_data_enb]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list trig_logic/evr_trig_lat]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {gen_adcs[0].readadc/adc_busy}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {gen_adcs[0].readadc/adc_busy_s}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list {gen_adcs[0].readadc/adc_cnv}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list {gen_adcs[0].readadc/adc_data_valid}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list trig_logic/evr_trig_lat_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list trig_logic/trig_clear]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list {gen_adcs[0].readadc/sck_enbne}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list {gen_adcs[0].readadc/adc_sck}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list {gen_adcs[0].readadc/adc_sdi}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list {gen_adcs[0].readadc/adc_sdo}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list trig_logic/trig_active]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets dbg_OBUF[4]]
