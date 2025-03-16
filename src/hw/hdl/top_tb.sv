`timescale 1ns/1ps
`define zynq top_tb.dut.sys.processing_system7_0.inst



module top_tb;

  // Parameters
  parameter FPGA_VERSION = 1;
  parameter SIM_MODE     = 0;



  // Signals
  reg clk;
  reg reset_n;
  reg resp; 

  // DUT Ports
  wire [14:0] ddr_addr;
  wire [2:0]  ddr_ba;
  wire        ddr_cas_n;
  wire        ddr_ck_n;
  wire        ddr_ck_p;
  wire        ddr_cke;
  wire        ddr_cs_n;
  wire [3:0]  ddr_dm;
  wire [31:0] ddr_dq;
  wire [3:0]  ddr_dqs_n;
  wire [3:0]  ddr_dqs_p;
  wire        ddr_odt;
  wire        ddr_ras_n;
  wire        ddr_reset_n;
  wire        ddr_we_n;
  wire        fixed_io_ddr_vrn;
  wire        fixed_io_ddr_vrp;
  wire [53:0] fixed_io_mio;
  wire        fixed_io_ps_clk;
  wire        fixed_io_ps_porb;
  wire        fixed_io_ps_srstb;
  wire [19:0] rcom;
  reg  [19:0] rsts;
  wire        mon_adc_rst;
  wire        mon_adc_cnv;
  wire        mon_adc_sck;
  wire        mon_adc_fs;
  reg  [2:0]  mon_adc_busy;
  reg  [2:0]  mon_adc_sdo;
  wire        dcct_adc_cnv;
  wire        dcct_adc_sck;
  reg  [3:0]  dcct_adc_busy;
  reg  [3:0]  dcct_adc_sdo;
  wire        stpt_dac_sck;
  wire        stpt_dac_sync;
  wire [3:0]  stpt_dac_sdo;
  wire [3:0]  sfp_sck;
  wire [3:0]  sfp_sda;
  wire [7:0]  sfp_leds;
  reg         gtx_evr_refclk_p;
  reg         gtx_evr_refclk_n;
  reg         gtx_evr_rx_p;
  reg         gtx_evr_rx_n;
  reg         gtx_gige_refclk_p;
  reg         gtx_gige_refclk_n;
  reg  [3:0]  trig;
  wire        si570_sck;
  wire        si570_sda;
  wire        onewire_sck;
  wire        onewire_sda;
  wire        mac_id;
  wire [7:0]  fp_leds;

  // Instantiate DUT
  top #(
    .FPGA_VERSION(FPGA_VERSION),
    .SIM_MODE(SIM_MODE)
  ) dut (
    .ddr_addr(ddr_addr),
    .ddr_ba(ddr_ba),
    .ddr_cas_n(ddr_cas_n),
    .ddr_ck_n(ddr_ck_n),
    .ddr_ck_p(ddr_ck_p),
    .ddr_cke(ddr_cke),
    .ddr_cs_n(ddr_cs_n),
    .ddr_dm(ddr_dm),
    .ddr_dq(ddr_dq),
    .ddr_dqs_n(ddr_dqs_n),
    .ddr_dqs_p(ddr_dqs_p),
    .ddr_odt(ddr_odt),
    .ddr_ras_n(ddr_ras_n),
    .ddr_reset_n(ddr_reset_n),
    .ddr_we_n(ddr_we_n),
    .fixed_io_ddr_vrn(fixed_io_ddr_vrn),
    .fixed_io_ddr_vrp(fixed_io_ddr_vrp),
    .fixed_io_mio(fixed_io_mio),
    .fixed_io_ps_clk(fixed_io_ps_clk),
    .fixed_io_ps_porb(fixed_io_ps_porb),
    .fixed_io_ps_srstb(fixed_io_ps_srstb),
    .rcom(rcom),
    .rsts(rsts),
    .mon_adc_rst(mon_adc_rst),
    .mon_adc_cnv(mon_adc_cnv),
    .mon_adc_sck(mon_adc_sck),
    .mon_adc_fs(mon_adc_fs),
    .mon_adc_busy(mon_adc_busy),
    .mon_adc_sdo(mon_adc_sdo),
    .dcct_adc_cnv(dcct_adc_cnv),
    .dcct_adc_sck(dcct_adc_sck),
    .dcct_adc_busy(dcct_adc_busy),
    .dcct_adc_sdo(dcct_adc_sdo),
    .stpt_dac_sck(stpt_dac_sck),
    .stpt_dac_sync(stpt_dac_sync),
    .stpt_dac_sdo(stpt_dac_sdo),
    .sfp_sck(sfp_sck),
    .sfp_sda(sfp_sda),
    .sfp_leds(sfp_leds),
    .gtx_evr_refclk_p(gtx_evr_refclk_p),
    .gtx_evr_refclk_n(gtx_evr_refclk_n),
    .gtx_evr_rx_p(gtx_evr_rx_p),
    .gtx_evr_rx_n(gtx_evr_rx_n),
    .gtx_gige_refclk_p(gtx_gige_refclk_p),
    .gtx_gige_refclk_n(gtx_gige_refclk_n),
    .trig(trig),
    .si570_sck(si570_sck),
    .si570_sda(si570_sda),
    .onewire_sck(onewire_sck),
    .onewire_sda(onewire_sda),
    .mac_id(mac_id),
    .fp_leds(fp_leds)
  );

  // Clock generation
  initial begin
    $display ("Running the Test Bench"); 
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
  end

  // Reset generation
  initial begin
    reset_n = 0;
    #20;
    reset_n = 1;
    #100;
      // Add test stimulus here.
      rsts = 20'h0;
      trig = 4'h0;
      gtx_evr_refclk_p = 1;
      gtx_evr_refclk_n = 0;
      gtx_evr_rx_p = 1;
      gtx_evr_rx_n = 0;
      gtx_gige_refclk_p = 1;
      gtx_gige_refclk_n = 0;
      mon_adc_busy = 3'b0;
      mon_adc_sdo = 3'b0;
      dcct_adc_busy = 4'b0;
      dcct_adc_sdo = 4'b0;

    #10000000; // Run simulation for 10ms
    $finish;
  end


  // Example stimulus (replace with your actual test cases)
  initial begin

    //`ZYNQ_VIP.por_srstb_reset(1'b1); 
    //#200; 
    //`ZYNQ_VIP.por_srstb_reset(1'b0); 
    //`ZYNQ_VIP.fpga_soft_reset(32'h1); 
    //#2000 ;  // This delay depends on your clock frequency. It should be at least 16 clock cycles.  
    //`ZYNQ_VIP.por_srstb_reset(1'b1); 
    //`ZYNQ_VIP.fpga_soft_reset(32'h0); 
    //#2000 ; 

    #2000;
    //Write the FP LEDs
    `zynq.write_data(32'h43C00004,4, 32'h1, resp);      
    `zynq.write_data(32'h43C00004,4, 32'h2, resp);    
    `zynq.write_data(32'h43C00004,4, 32'h3, resp);             

    `zynq.write_data(32'h43C00118,4, 32'd100, resp);  //set ramplen
    for (int i = 0; i <= 100; i++) begin
      `zynq.write_data(32'h43C0011C, 4, i, resp);  // set rampaddr
      `zynq.write_data(32'h43C00120, 4, i, resp);        // set rampdata
    end
    `zynq.write_data(32'h43C00124,4, 32'h1, resp);  //run the ramptable  
    `zynq.write_data(32'h43C00124,4, 32'h0, resp);  //run the ramptable  

    #1000000;
    
    
    
  end
  
  
endmodule
  
