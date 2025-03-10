

set_clock_groups -name sysclk_2_evrclk -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks evr/evr_gtx_init_i/U0/evr_gtx_i/gt0_evr_gtx_i/gtxe2_i/RXOUTCLK]

set_clock_groups -name sysclk_2_fofbtxclk -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks fofb/fofb_gtx_init_i/U0/fofb_gtx_i/gt0_fofb_gtx_i/gtxe2_i/TXOUTCLK]
set_clock_groups -name sysclk_2_fofbrxclk -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks fofb/fofb_gtx_init_i/U0/fofb_gtx_i/gt0_fofb_gtx_i/gtxe2_i/RXOUTCLK]


