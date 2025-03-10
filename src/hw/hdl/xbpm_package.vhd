----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2020 02:07:34 PM
-- Design Name: 
-- Module Name: xbpm_package - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------



library IEEE;
use IEEE.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



package xbpm_package is

constant NUM_ADCS : integer := 8;

type ADC_RAW_TYPE is array(0 to NUM_ADCS-1) of std_logic_vector(19 downto 0);
type ADC_AVE_TYPE is array(0 to NUM_ADCS-1) of std_logic_vector(31 downto 0);



type data_type is record
  data_rdy    : std_logic;
  trignum     : std_logic_vector(31 downto 0);
  cha_mag     : std_logic_vector(31 downto 0);
  chb_mag     : std_logic_vector(31 downto 0);
  chc_mag     : std_logic_vector(31 downto 0);
  chd_mag     : std_logic_vector(31 downto 0); 
  che_mag     : std_logic_vector(31 downto 0);
  chf_mag     : std_logic_vector(31 downto 0);  
  chg_mag     : std_logic_vector(31 downto 0);
  chh_mag     : std_logic_vector(31 downto 0);     
  sum         : std_logic_vector(31 downto 0);
  xpos        : std_logic_vector(31 downto 0);
  ypos        : std_logic_vector(31 downto 0);  
end record data_type;      
      

type pos_params_type is record
  cha_offset  : std_logic_vector(31 downto 0);
  chb_offset  : std_logic_vector(31 downto 0);
  chc_offset  : std_logic_vector(31 downto 0);  
  chd_offset  : std_logic_vector(31 downto 0);
  xpos_offset : std_logic_vector(31 downto 0);
  ypos_offset : std_logic_vector(31 downto 0);  
  cha_gain    : std_logic_vector(15 downto 0);
  chb_gain    : std_logic_vector(15 downto 0);
  chc_gain    : std_logic_vector(15 downto 0);  
  chd_gain    : std_logic_vector(15 downto 0);  
  kx          : std_logic_vector(31 downto 0);
  ky          : std_logic_vector(31 downto 0);
  dds_freq    : std_logic_vector(31 downto 0);
  pos_simreal : std_logic;
end record pos_params_type;
  

type ivt_regs_type is record
   temp0 : std_logic_vector(15 downto 0);
   temp1 : std_logic_vector(15 downto 0);
   temp2 : std_logic_vector(15 downto 0);
   temp3 : std_logic_vector(15 downto 0);
   Vreg0 : std_logic_vector(15 downto 0);
   Vreg1 : std_logic_vector(15 downto 0);
   Vreg2 : std_logic_vector(15 downto 0);
   Vreg3 : std_logic_vector(15 downto 0);
   Vreg4 : std_logic_vector(15 downto 0);
   Vreg5 : std_logic_vector(15 downto 0);
   Vreg6 : std_logic_vector(15 downto 0);
   Vreg7 : std_logic_vector(15 downto 0);
   Ireg0 : std_logic_vector(15 downto 0);
   Ireg1 : std_logic_vector(15 downto 0);
   Ireg2 : std_logic_vector(15 downto 0);
   Ireg3 : std_logic_vector(15 downto 0);
   Ireg4 : std_logic_vector(15 downto 0);
   Ireg5 : std_logic_vector(15 downto 0);
   Ireg6 : std_logic_vector(15 downto 0);
   Ireg7 : std_logic_vector(15 downto 0);
end record ivt_regs_type;


component system is
  port (
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    m_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_awvalid : out STD_LOGIC;
    m_axi_awready : in STD_LOGIC;
    m_axi_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m_axi_wvalid : out STD_LOGIC;
    m_axi_wready : in STD_LOGIC;
    m_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_bvalid : in STD_LOGIC;
    m_axi_bready : out STD_LOGIC;
    m_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m_axi_arvalid : out STD_LOGIC;
    m_axi_arready : in STD_LOGIC;
    m_axi_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m_axi_rvalid : in STD_LOGIC;
    m_axi_rready : out STD_LOGIC;
    pl_clk0 : out STD_LOGIC;
    pl_resetn : out STD_LOGIC
  );
  end component;







end xbpm_package;

