


set_clock_groups -name plclk_evrclk -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks {evr/evr_gtx_init_i/U0/evr_gtx_i/gt0_evr_gtx_i/gtxe2_i/RXOUTCLK evr/evr_gtx_init_i/U0/evr_gtx_i/gt0_evr_gtx_i/gtxe2_i/TXOUTCLK}]


