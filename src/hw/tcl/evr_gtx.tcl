##################################################################
# CHECK VIVADO VERSION
##################################################################

set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
  catch {common::send_msg_id "IPS_TCL-100" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_ip_tcl to create an updated script."}
  return 1
}

##################################################################
# START
##################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source evr_gtx.tcl
# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
  create_project vivado vivado -part xc7z030sbg485-1
  set_property target_language VHDL [current_project]
  set_property simulator_language Mixed [current_project]
}

##################################################################
# CHECK IPs
##################################################################

set bCheckIPs 1
set bCheckIPsPassed 1
if { $bCheckIPs == 1 } {
  set list_check_ips { xilinx.com:ip:gtwizard:3.6 }
  set list_ips_missing ""
  common::send_msg_id "IPS_TCL-1001" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

  foreach ip_vlnv $list_check_ips {
  set ip_obj [get_ipdefs -all $ip_vlnv]
  if { $ip_obj eq "" } {
    lappend list_ips_missing $ip_vlnv
    }
  }

  if { $list_ips_missing ne "" } {
    catch {common::send_msg_id "IPS_TCL-105" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
    set bCheckIPsPassed 0
  }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "IPS_TCL-102" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 1
}

##################################################################
# CREATE IP evr_gtx
##################################################################

set evr_gtx [create_ip -name gtwizard -vendor xilinx.com -library ip -version 3.6 -module_name evr_gtx]

# User Parameters
set_property -dict [list \
  CONFIG.gt0_val_align_comma_word {Two_Byte_Boundaries} \
  CONFIG.gt0_val_clk_cor_seq_1_1 {00000000} \
  CONFIG.gt0_val_clk_cor_seq_1_2 {00000000} \
  CONFIG.gt0_val_clk_cor_seq_1_3 {00000000} \
  CONFIG.gt0_val_clk_cor_seq_1_4 {00000000} \
  CONFIG.gt0_val_clk_cor_seq_2_1 {00000000} \
  CONFIG.gt0_val_clk_cor_seq_2_2 {00000000} \
  CONFIG.gt0_val_clk_cor_seq_2_3 {00000000} \
  CONFIG.gt0_val_clk_cor_seq_2_4 {00000000} \
  CONFIG.gt0_val_comma_preset {K28.5} \
  CONFIG.gt0_val_cpll_fbdiv {2} \
  CONFIG.gt0_val_cpll_fbdiv_45 {4} \
  CONFIG.gt0_val_decoding {8B/10B} \
  CONFIG.gt0_val_dfe_mode {LPM-Auto} \
  CONFIG.gt0_val_drp_clock {100} \
  CONFIG.gt0_val_encoding {None} \
  CONFIG.gt0_val_no_tx {true} \
  CONFIG.gt0_val_port_rxchariscomma {true} \
  CONFIG.gt0_val_port_rxcharisk {true} \
  CONFIG.gt0_val_port_rxcommadet {true} \
  CONFIG.gt0_val_port_rxslide {false} \
  CONFIG.gt0_val_rx_cm_trim {800} \
  CONFIG.gt0_val_rx_data_width {16} \
  CONFIG.gt0_val_rx_int_datawidth {20} \
  CONFIG.gt0_val_rx_line_rate {2.5} \
  CONFIG.gt0_val_rx_refclk {REFCLK1_Q0} \
  CONFIG.gt0_val_rx_reference_clock {312.500} \
  CONFIG.gt0_val_rx_termination_voltage {Programmable} \
  CONFIG.gt0_val_rxslide_mode {OFF} \
  CONFIG.gt0_val_rxusrclk {RXOUTCLK} \
  CONFIG.gt0_val_tx_data_width {20} \
  CONFIG.gt0_val_tx_int_datawidth {20} \
  CONFIG.gt0_val_tx_line_rate {2.5} \
  CONFIG.gt0_val_tx_refclk {REFCLK1_Q0} \
  CONFIG.gt0_val_tx_reference_clock {312.500} \
  CONFIG.gt1_val_rx_refclk {REFCLK1_Q0} \
  CONFIG.gt1_val_tx_refclk {REFCLK1_Q0} \
  CONFIG.gt2_val_rx_refclk {REFCLK1_Q0} \
  CONFIG.gt2_val_tx_refclk {REFCLK1_Q0} \
  CONFIG.gt3_val_rx_refclk {REFCLK1_Q0} \
  CONFIG.gt3_val_tx_refclk {REFCLK1_Q0} \
  CONFIG.identical_val_no_tx {true} \
  CONFIG.identical_val_rx_line_rate {2.5} \
  CONFIG.identical_val_rx_reference_clock {312.500} \
  CONFIG.identical_val_tx_line_rate {2.5} \
  CONFIG.identical_val_tx_reference_clock {312.500} \
] [get_ips evr_gtx]

# Runtime Parameters
set_property -dict { 
  GENERATE_SYNTH_CHECKPOINT {1}
} $evr_gtx

##################################################################

