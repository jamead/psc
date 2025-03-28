
-- The evr_top module is a top-level entity for an Event Receiver (EVR) system, 
-- designed to decode timing and control events in a high-precision timing environment. 
-- The design leverages Gigabit Transceiver (GTX) functionality for data reception 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library work;
use work.psc_pkg.ALL;


entity evr_top is
   port(

    sys_clk        : in std_logic;
    sys_rst        : in std_logic;
    gtx_reset      : in std_logic_vector(7 downto 0);
    
    gtx_refclk     : in std_logic;
    rx_p           : in std_logic;
    rx_n           : in std_logic;

    trignum        : in std_logic_vector(7 downto 0);
    trigdly        : in std_logic_vector(31 downto 0);
    
    tbt_trig       : out std_logic;
    fa_trig        : out std_logic;
    sa_trig        : out std_logic;
    usr_trig       : out std_logic;
    gps_trig       : out std_logic;
    timestamp      : out std_logic_vector(63 downto 0);
    
    evr_rcvd_clk   : out std_logic;
    
    dbg            : out std_logic_vector(19 downto 0)
    
);
end evr_top;
 
 
architecture behv of evr_top is
	


   type  state_type is (IDLE, ACTIVE);  
   signal state :  state_type;

   signal datastream        : std_logic_vector(7 downto 0);
   signal eventstream       : std_logic_vector(7 downto 0);
   
   signal rxdata            : std_logic_vector(15 downto 0);
   signal rxcharisk         : std_logic_vector(1 downto 0);
   signal rxout_clk         : std_logic;   
   signal rxusr_clk         : std_logic;
   signal rxresetdone       : std_logic;
         
   signal cpllfbcklost         : std_logic;
   signal cplllock             : std_logic;

   
   signal tx_fsm_reset_done : std_logic;
   signal rx_fsm_reset_done : std_logic;   
   
   signal eventclock        : std_logic;
   
   signal prev_datastream   : std_logic_vector(3 downto 0);
   signal tbt_trig_i        : std_logic;
   signal tbt_trig_stretch  : std_logic;
   signal tbt_cnt           : std_logic_vector(2 downto 0);
   
   


   --debug signals (connect to ila)
--   attribute mark_debug     : string;
--   attribute mark_debug of eventstream: signal is "true";
--   attribute mark_debug of datastream: signal is "true";
--   attribute mark_debug of timestamp: signal is "true";
--   attribute mark_debug of eventclock: signal is "true";
--   attribute mark_debug of prev_datastream: signal is "true";
--   attribute mark_debug of tbt_trig: signal is "true";
--   attribute mark_debug of tbt_trig_i: signal is "true";   
--   attribute mark_debug of trignum: signal is "true";
--   attribute mark_debug of trigdly: signal is "true";
--   attribute mark_debug of tbt_trig_stretch: signal is "true";
--   attribute mark_debug of tbt_cnt: signal is "true";   
--   attribute mark_debug of rxdata: signal is "true";
--   attribute mark_debug of rxcharisk: signal is "true";
--   attribute mark_debug of gtx_reset: signal is "true";
   
--   attribute mark_debug of rxresetdone: signal is "true"; 
--   attribute mark_debug of tx_fsm_reset_done: signal is "true"; 
--   attribute mark_debug of rx_fsm_reset_done: signal is "true"; 
--   attribute mark_debug of cplllock: signal is "true";          
--   attribute mark_debug of cpllfbcklost: signal is "true"; 

   

begin

evr_rcvd_clk <= rxusr_clk;

tbt_trig <= tbt_trig_stretch;


rxoutclk_bufg0_i : BUFG
        port map ( I => rxout_clk, O => rxusr_clk);  



process (sys_rst, rxusr_clk)
begin
   if (sys_rst = '1') then
      tbt_trig_stretch <= '0';
      tbt_cnt <= "000";
      state <= idle;
   elsif (rxusr_clk'event and rxusr_clk = '1') then
      case state is 
         when IDLE => 
             if (tbt_trig_i = '1') then
                tbt_trig_stretch <= '1';
                state <= active;
             end if;

         when ACTIVE =>
             tbt_cnt <= tbt_cnt + 1;
             if (tbt_cnt = "111") then
                tbt_trig_stretch <= '0';
                tbt_cnt <= "000";
                state <= idle;
             end if;         
          end case;          
      end if;
end process;



--tbt_trig <= datastream(0);
--datastream 0 toggles high/low for half of Frev.  Filter on the first low to high transition
--and ignore the rest
process (sys_rst, rxusr_clk)
begin
    if (sys_rst = '1') then
       tbt_trig_i <= '0';
    elsif (rxusr_clk'event and rxusr_clk = '1') then
       prev_datastream(0) <= datastream(0);
       prev_datastream(1) <= prev_datastream(0);
       prev_datastream(2) <= prev_datastream(1);
       prev_datastream(3) <= prev_datastream(2);
       if (prev_datastream = "0001") then
           tbt_trig_i <= '1';
       else
           tbt_trig_i <= '0';
       end if;
    end if;
end process;


--datastream <= gt0_rxdata(7 downto 0);
--eventstream <= gt0_rxdata(15 downto 8);
--switch byte locations of datastream and eventstream  9-20-18
datastream <= rxdata(15 downto 8);
eventstream <= rxdata(7 downto 0);



-- timestamp decoder
ts : entity work.event_rcv_ts
   port map(
       clock => rxusr_clk,
       reset => sys_rst,
       eventstream => eventstream,
       timestamp => timestamp,
       seconds => open, 
       offset => open, 
       position => open, 
       eventclock => eventclock
 );


	
-- 1 Hz GPS tick	
event_gps : entity work.event_rcv_chan 
    port map(
       clock => rxusr_clk,
       reset => sys_rst,
       eventstream => eventstream,
       myevent => (x"7D"),     -- 125d
       mydelay => (x"00000001"),
       mywidth => (x"00000175"),   -- //creates a pulse about 3us long
       mypolarity => ('0'),
       trigger => gps_trig
);



-- 10 Hz 	
event_10Hz : entity work.event_rcv_chan
    port map(
       clock => rxusr_clk,
       reset => sys_rst,
       eventstream => eventstream,
       myevent => (x"1E"),     -- 30d
       mydelay => (x"00000001"),
       mywidth => (x"00000175"),   -- //creates a pulse about 3us long
       mypolarity => ('0'),
       trigger => sa_trig
);




-- 10 KHz 	
event_10KHz : entity work.event_rcv_chan
    port map(
       clock => rxusr_clk,
       reset => sys_rst,
       eventstream => eventstream,
       myevent => (x"1F"),     -- 31d
       mydelay => (x"00000001"),
       mywidth => (x"00000175"),   -- //creates a pulse about 3us long
       mypolarity => ('0'),
       trigger => fa_trig
);
		
		
-- On demand 	
event_usr : entity work.event_rcv_chan
    port map(
       clock => rxusr_clk,
       reset => sys_rst,
       eventstream => eventstream,
       myevent => trignum,
       mydelay => trigdly, 
       mywidth => (x"00000175"),   -- //creates a pulse about 3us long
       mypolarity => ('0'),
       trigger => usr_trig
);


evr_gtx_init_i : evr_gtx
    port map
    (
        sysclk_in                       =>      sys_clk,
        soft_reset_rx_in                =>      gtx_reset(1), 
        dont_reset_on_data_error_in     =>      '0', 
        gt0_tx_fsm_reset_done_out       =>      tx_fsm_reset_done,
        gt0_rx_fsm_reset_done_out       =>      rx_fsm_reset_done,
        gt0_data_valid_in               =>      '1', 

        --_____________________________________________________________________
        --_____________________________________________________________________
        --GT0  (X1Y0)

        --------------------------------- CPLL Ports -------------------------------
        gt0_cpllfbclklost_out           =>      cpllfbcklost, 
        gt0_cplllock_out                =>      cplllock,
        gt0_cplllockdetclk_in           =>      sys_clk,
        gt0_cpllreset_in                =>      gtx_reset(0), 
        -------------------------- Channel - Clocking Ports ------------------------
        gt0_gtrefclk0_in                =>      '0',
        gt0_gtrefclk1_in                =>      gtx_refclk, 
        ---------------------------- Channel - DRP Ports  --------------------------
        gt0_drpaddr_in                  =>      (others => '0'), 
        gt0_drpclk_in                   =>      sys_clk,
        gt0_drpdi_in                    =>      (others => '0'),
        gt0_drpdo_out                   =>      open, 
        gt0_drpen_in                    =>      '0',
        gt0_drprdy_out                  =>      open,
        gt0_drpwe_in                    =>      '0', 
        --------------------------- Digital Monitor Ports --------------------------
        gt0_dmonitorout_out             =>      open,
        --------------------- RX Initialization and Reset Ports --------------------
        gt0_eyescanreset_in             =>      '0',
        gt0_rxuserrdy_in                =>      '1',
        -------------------------- RX Margin Analysis Ports ------------------------
        gt0_eyescandataerror_out        =>      open,
        gt0_eyescantrigger_in           =>      '0',
        ------------------ Receive Ports - FPGA RX Interface Ports -----------------
        gt0_rxusrclk_in                 =>      rxusr_clk,
        gt0_rxusrclk2_in                =>      rxusr_clk,
        ------------------ Receive Ports - FPGA RX interface Ports -----------------
        gt0_rxdata_out                  =>      rxdata,
        ------------------ Receive Ports - RX 8B/10B Decoder Ports -----------------
        gt0_rxdisperr_out               =>      open, 
        gt0_rxnotintable_out            =>      open, 
        --------------------------- Receive Ports - RX AFE -------------------------
        gt0_gtxrxp_in                   =>      rx_p,
        ------------------------ Receive Ports - RX AFE Ports ----------------------
        gt0_gtxrxn_in                   =>      rx_n,
        -------------- Receive Ports - RX Byte and Word Alignment Ports ------------
        gt0_rxcommadet_out              =>      open, 
        --------------------- Receive Ports - RX Equalizer Ports -------------------
        gt0_rxdfelpmreset_in            =>      '0',
        gt0_rxmonitorout_out            =>      open,
        gt0_rxmonitorsel_in             =>      "00",
        --------------- Receive Ports - RX Fabric Output Control Ports -------------
        gt0_rxoutclk_out                =>      rxout_clk,
        gt0_rxoutclkfabric_out          =>      open,
        ------------- Receive Ports - RX Initialization and Reset Ports ------------
        gt0_gtrxreset_in                =>      gtx_reset(3), 
        gt0_rxpmareset_in               =>      gtx_reset(4), 
        ------------------- Receive Ports - RX8B/10B Decoder Ports -----------------
        gt0_rxchariscomma_out           =>      open, 
        gt0_rxcharisk_out               =>      rxcharisk,
        -------------- Receive Ports -RX Initialization and Reset Ports ------------
        gt0_rxresetdone_out             =>      rxresetdone,
        --------------------- TX Initialization and Reset Ports --------------------
        gt0_gttxreset_in                =>      gtx_reset(5),

        gt0_qplloutclk_in               =>      '0', 
        gt0_qplloutrefclk_in            =>      '0'
    );





		 
		

			 
end behv;
