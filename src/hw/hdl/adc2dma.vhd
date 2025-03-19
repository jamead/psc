-------------------------------------------------------------------------------
-- Title         : AXI Data Generator
-------------------------------------------------------------------------------
-- File          : axi_data_gen.vhd
-- Author        : Joseph Mead  mead@bnl.gov
-- Created       : 01/11/2013
-------------------------------------------------------------------------------
-- Description:
-- Provides logic to send adc or test data to FIFO interface.
-- A testdata_en input permits test counters to be sent for verification 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modification history:
-- 01/11/2013: created.
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.ALL;
  
library work;
use work.psc_pkg.ALL;  
  
entity adc2dma is
  port (
    clk          	    : in  std_logic;
    reset     			: in  std_logic;                       
    tenkhz_trig 		: in  std_logic;
    dma_params          : in t_dma_params;
	dma_active          : out std_logic; 
    m_axis_tdata        : out std_logic_vector(63 downto 0);
    m_axis_tkeep        : out std_logic_vector(7 downto 0);
    m_axis_tlast        : out std_logic;
    m_axis_tready       : in std_logic;
    m_axis_tvalid       : out std_logic     
  );    
end adc2dma;

architecture behv of adc2dma is
 
  


COMPONENT adcdata_fifo
  PORT (
    s_axis_aresetn : IN STD_LOGIC;
    s_axis_aclk : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_tlast : IN STD_LOGIC;
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_tlast : OUT STD_LOGIC;
    axis_wr_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axis_rd_data_count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;



  type     state_type is (IDLE, ACTIVE, FIFO_WRITE_W0, FIFO_WRITE_W1, FIFO_WRITE_W2, FIFO_WRITE_W3,
                          FIFO_WRITE_W4, FIFO_WRITE_W5, FIFO_WRITE_W6, FIFO_WRITE_W7);             
                                             
  signal   state      : state_type;  
  

  signal len			   : std_logic_vector(31 downto 0);
  signal testdata		   : std_logic_vector(63 downto 0); 
  
  signal fifo_wrlen        : integer; 
  
  signal data_wren_i	   : std_logic;   

  signal strobe_lat		   : std_logic;
  signal tx_active		   : std_logic;
  signal dlycnt            : INTEGER;
  
  signal trig_s            : std_logic_vector(2 downto 0);
  signal trig_fifo         : std_logic;
  
  signal dma_tenkhz_cnt        : std_logic_vector(31 downto 0);
  
  
  signal fifo_din          : std_logic_vector(127 downto 0);
  signal fifo_full         : std_logic;
  signal fifo_rdcnt        : std_logic_vector(31 downto 0);
  signal fifo_wrcnt        : std_logic_vector(31 downto 0);
 
  signal fifo_rden         : std_logic;
  signal fifo_wren         : std_logic;
  signal fifo_testdata     : std_logic_vector(63 downto 0);
  
  signal s_axis_aresetn   : std_logic;
  signal s_axis_tready    : std_logic;
  signal s_axis_tdata     : std_logic_vector(63 downto 0);
  signal s_axis_testdata  : std_logic_vector(63 downto 0);
  signal s_axis_tvalid    : std_logic;
  signal s_axis_tlast     : std_logic;
  
  signal burst_len         : std_logic_vector(31 downto 0);

  
  
  attribute mark_debug              : string;


  attribute mark_debug of state: signal is "true";
  attribute mark_debug of tenkhz_trig: signal is "true";

  attribute mark_debug of trig_fifo: signal is "true";
  attribute mark_debug of fifo_wrcnt: signal is "true";
  attribute mark_debug of fifo_rdcnt: signal is "true";
  attribute mark_debug of fifo_wrlen: signal is "true";
  attribute mark_debug of s_axis_testdata : signal is "true";
  attribute mark_debug of s_axis_tvalid : signal is "true";
  attribute mark_debug of s_axis_tlast : signal is "true";
  attribute mark_debug of s_axis_tready : signal is "true";     
  
  attribute mark_debug of m_axis_tdata : signal is "true";
  attribute mark_debug of m_axis_tkeep : signal is "true";
  attribute mark_debug of m_axis_tvalid : signal is "true";
  attribute mark_debug of m_axis_tlast : signal is "true";
  attribute mark_debug of m_axis_tready : signal is "true";   
 


begin  


m_axis_tkeep <= x"F";

burst_len <= dma_params.len;


u1fifo: adcdata_fifo
  port map (
    s_axis_aresetn => not reset, 
    s_axis_aclk => clk, 
    s_axis_tvalid => s_axis_tvalid, 
    s_axis_tready => s_axis_tready, 
    s_axis_tdata => s_axis_tdata, 
    s_axis_tlast => s_axis_tlast, 
    m_axis_tvalid => m_axis_tvalid, 
    m_axis_tready => m_axis_tready, 
    m_axis_tdata => m_axis_tdata, 
    m_axis_tlast => m_axis_tlast, 
    axis_wr_data_count => fifo_wrcnt, 
    axis_rd_data_count => fifo_rdcnt
  );





--write adcdata into FIFO
process (clk)
begin 
  if (rising_edge(clk)) then
    if (reset = '1') then
      s_axis_tlast <= '0';
      s_axis_tvalid <= '0';
      fifo_wrlen <= 0;
      s_axis_testdata <= (others => '0');
      s_axis_tdata <= (others => '0');
      dma_tenkhz_cnt <= (others => '0');
      state <= IDLE;
                
    else
      case state is 
        when IDLE =>
          s_axis_tlast <= '0';
          s_axis_tvalid <= '0';
          if (dma_params.enb = '1') then
            state <= active;
            fifo_wrlen <= to_integer(unsigned(burst_len));
            s_axis_testdata <= (others => '0');
          end if;
          
        when ACTIVE =>
           s_axis_tlast <= '0';
           s_axis_tvalid <= '0';
           if (tenkhz_trig = '1') then
             state <= fifo_write_w0;
             fifo_wrlen <= fifo_wrlen - 1;
           end if;

  
       when FIFO_WRITE_W0 =>
           s_axis_tvalid <= '1';
           s_axis_tdata <= dma_tenkhz_cnt;
           state <= fifo_write_w1;           
           
        when FIFO_WRITE_W1 =>
           s_axis_tdata <=  s_axis_testdata;
           s_axis_testdata <= s_axis_testdata + 1;
           state <= fifo_write_w2;

        when FIFO_WRITE_W2 =>
           s_axis_tdata <=  s_axis_testdata;
           s_axis_testdata <= s_axis_testdata + 1;
           state <= fifo_write_w3;   
            
        when FIFO_WRITE_W3 =>
           s_axis_tdata <= s_axis_testdata;
           s_axis_testdata <= s_axis_testdata + 1;
           state <= fifo_write_w4;

        when FIFO_WRITE_W4 =>
           s_axis_tdata <=  s_axis_testdata;
           s_axis_testdata <= s_axis_testdata + 1;
           state <= fifo_write_w5;              
                     
        when FIFO_WRITE_W5 =>
           s_axis_tdata <=  s_axis_testdata;
           s_axis_testdata <= s_axis_testdata + 1;
           state <= fifo_write_w6;
                          
        when FIFO_WRITE_W6 =>
           s_axis_tdata <=  s_axis_testdata;
           s_axis_testdata <= s_axis_testdata + 1;
           state <= fifo_write_w7;   
           
        when FIFO_WRITE_W7 =>
           s_axis_tdata <=  s_axis_testdata;
           s_axis_testdata <= s_axis_testdata + 1;
           dma_tenkhz_cnt <= dma_tenkhz_cnt + 1;
           if (fifo_wrlen = 0) then
              s_axis_tlast <= '1';
              state <= idle;
           else
              state <= active;
           end if;

                      
        when OTHERS =>
           state <= idle;
      end case;
    end if;
  end if;
end process; 

end behv;
