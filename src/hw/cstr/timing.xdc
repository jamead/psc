


set_clock_groups -name plclk_evrclk -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks {evr/evr_gtx_init_i/U0/evr_gtx_i/gt0_evr_gtx_i/gtxe2_i/RXOUTCLK evr/evr_gtx_init_i/U0/evr_gtx_i/gt0_evr_gtx_i/gtxe2_i/TXOUTCLK}]

#set_clock_groups -name plclk_fofbclk -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks {fofb/phy_sfp0_rx/U0/pcs_pma_block_i/transceiver_inst/gtwizard_inst/U0/gtwizard_i/gt0_GTWIZARD_i/gtxe2_i/RXOUTCLK fofb/phy_i/U0/pcs_pma_block_i/transceiver_inst/gtwizard_inst/U0/gtwizard_i/gt0_GTWIZARD_i/gtxe2_i/TXOUTCLK}]

set_clock_groups -name plclk_fofbclk2 -asynchronous -group [get_clocks clk_fpga_0] -group [get_clocks -of_objects [get_pins fofb/fofb_phy/phy_sfp0_rx/U0/core_clocking_i/mmcm_adv_inst/CLKOUT0]]




























