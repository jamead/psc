################################################################################
# Main tcl for the module
################################################################################

# ==============================================================================
proc init {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl init()..."



}

# ==============================================================================
proc setSources {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl setSources()..."

  variable Sources 
  lappend Sources {"../hdl/top_tb.sv" "SystemVerilog"} 
  
  lappend Sources {"../hdl/top.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/psc_pkg.vhd" "VHDL 2008"}

  lappend Sources {"../hdl/ps_io.vhd" "VHDL 2008"} 

  lappend Sources {"../hdl/DCCT_ADC_module.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/ADC_LTC2376_20_intf.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/ADC_8CH_module.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/ADC_ADS8568_intf.vhd" "VHDL 2008"} 
  
  lappend Sources {"../hdl/DAC_ctrlr.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/DAC_AD5781_intf.vhd" "VHDL 2008"}     

  lappend Sources {"../hdl/adc_accumulator_top.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/adc_accumulator.vhd" "VHDL 2008"} 
  lappend Sources {"../hdl/average.vhd" "VHDL 2008"} 
  
  lappend Sources {"../hdl/tenkhz_mux.vhd" "VHDL 2008"}  
  
  lappend Sources {"../hdl/adc2ddr.vhd" "VHDL 2008"}  
  
  lappend Sources {"../hdl/evr_top.vhd" "VHDL 2008"}  
  lappend Sources {"../hdl/event_rcv_chan.vhd" "VHDL 2008"}   
  lappend Sources {"../hdl/event_rcv_ts.vhd" "VHDL 2008"}   
  #lappend Sources {"../hdl/EventReceiverChannel.v" "Verilog"}  
  #lappend Sources {"../hdl/timeofDayReceiver.v" "Verilog"} 
  
  lappend Sources {"../hdl/stretch.vhd" "VHDL 2008"}  

  lappend Sources {"../cstr/pins.xdc"  "XDC"}
  lappend Sources {"../cstr/gtx.xdc"  "XDC"}
  lappend Sources {"../cstr/debug.xdc"  "XDC"}
  lappend Sources {"../cstr/timing.xdc"  "XDC"}   


  
}

# ==============================================================================
proc setAddressSpace {} {
   ::fwfwk::printCBM "In ./hw/src/main.tcl setAddressSpace()..."
  variable AddressSpace
  
  addAddressSpace AddressSpace "pl_regs"   RDL  {} ../rdl/pl_regs.rdl

}
 

# ==============================================================================
proc doOnCreate {} {
  # variable Vhdl
  variable TclPath

      
  ::fwfwk::printCBM "In ./hw/src/main.tcl doOnCreate()"
  set_property part             xc7z030sbg485-1              [current_project]
  set_property target_language  VHDL                         [current_project]
  set_property default_lib      xil_defaultlib               [current_project]
   
  #set_property used_in_synthesis false [get_files /home/mead/rfbpm/fwk/zubpm/src/hw/hdl/top_tb.sv] 
  #set_property used_in_implementation false [get_files  top_tb.v] 
   
  source ${TclPath}/system.tcl
  source ${TclPath}/dac_dpram.tcl
  #source ${TclPath}/div_gen_mag.tcl
  #source ${TclPath}/dds_simadc.tcl 
  #source ${TclPath}/fa_fifo.tcl 
  #source ${TclPath}/fa_rcvd_fifo.tcl
  source ${TclPath}/evr_gtx.tcl
  #source ${TclPath}/fofb_gtx.tcl

  addSources "Sources" 
  
  ::fwfwk::printCBM "TclPath = ${TclPath}"
  ::fwfwk::printCBM "SrcPath = ${::fwfwk::SrcPath}"
  
  set_property used_in_synthesis false [get_files ${::fwfwk::SrcPath}/hw/hdl/top_tb.sv] 
  set_property used_in_implementation false [get_files ${::fwfwk::SrcPath}/hw/hdl/top_tb.sv] 
  
  #get error message, open manually in tcl window for now.
  #open_wave_config "${::fwfwk::SrcPath}/hw/sim/top_tb_behav.wcfg"
  

  
  
}

# ==============================================================================
proc doOnBuild {} {
  ::fwfwk::printCBM "In ./hw/src/main.tcl doOnBuild()"



}


# ==============================================================================
proc setSim {} {
}
