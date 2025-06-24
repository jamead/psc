----------------------------------------------------------------------------------
-- Company: BNL
-- Engineer: Thomas Chiesa
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: udp_rx
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: This is a state machine that handles the UDP reception.  It takes the bytes from the TEMAC
-- and registers each byte as it is received. 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
use work.psc_pkg.all;



--  Entity Declaration

entity udp_rx is
	port
	(
	    clk         		: in  std_logic;           
        reset			    : in  std_logic; 
        rx_data_in	      	: in  std_logic_vector(7 downto 0); 
        rx_dv			    : in  std_logic;                                      	              
        udp_pkt_rx          : out t_udp_pkt;
        rx_done             : out std_logic
    );
end udp_rx;


--  Architecture Body

architecture udp_rx_arch OF udp_rx is
    type state_type is (IDLE, RX_PREAMBLE, RX_DATA, RX_FINISHED);
    signal state: state_type;
	 
	 
     signal framebytenum 		: INTEGER range 0 to 32767;
	 signal databytenum 		: INTEGER RANGE 0 TO 127;
	 signal len   				: std_logic_vector(15 downto 0);
	 signal cntvalsig     		: std_logic_vector(15 downto 0);
	 signal ip_totallen			: std_logic_vector(15 downto 0);		
	 signal ip_header_chksum 	: std_logic_vector(15 downto 0);			
	 signal fast_ps_id          : std_logic_vector(15 downto 0);
	 signal zero_pad0           : std_logic_vector(15 downto 0); 
	 signal zero_pad1           : std_logic_vector(15 downto 0); 
	 signal zero_pad2           : std_logic_vector(15 downto 0); 
	 signal zero_pad3           : std_logic_vector(15 downto 0); 
	 signal zero_pad4           : std_logic_vector(15 downto 0); 
	 signal zero_pad5           : std_logic_vector(15 downto 0); 
	 signal zero_pad6           : std_logic_vector(15 downto 0); 
	 signal zero_pad7           : std_logic_vector(15 downto 0); 
	 signal zero_pad8           : std_logic_vector(15 downto 0); 
	 signal nonce               : std_logic_vector(15 downto 0); 
	 signal payload             : std_logic_vector(175 downto 0);	 
     signal stretch_count       : integer := 0; 
     signal stretch_pulse       : std_logic;
     signal rx_check_count      : integer; 
     signal rx_check            : std_logic; 
     signal udp_pkt_buf_rx      : t_udp_pkt; 
     signal pkt_length_int      : integer; 
     
     
     attribute mark_debug : string;  
     attribute mark_debug of framebytenum: signal is "true";
     attribute mark_debug of state: signal is "true";  
     attribute mark_debug of rx_done: signal is "true";
     attribute mark_debug of udp_pkt_buf_rx: signal is "true";
     

begin

udp_pkt_rx <= udp_pkt_buf_rx; 


process(clk) 
  begin
  if rising_edge(clk) then 
     if reset = '1' then
        state              		<= idle;
		fast_ps_id              <= x"0000"; 
		framebytenum            <= 0;
		databytenum				<= 0;
		rx_done                 <= '0'; 
     else 
        case(state) is
          when IDLE =>
				rx_done			<= '0';
				--frame_good set high means that the FCS (frame check sequence) is correct i.e. ethernet packet
				--is a valid ethernet packet
				--The packet length is the packet length +4 (I assume the 4 comes from the 4 byte FCS) 
				--The packet length is 78 +FCS = 82
				--if frame_good = '1' and pkt_length_int = 82 then 
                if (rx_dv = '1') then   --if (rx_sop = '1') and (rx_dval = '1')then           
                  state <= rx_preamble;	
                  framebytenum <= 0;
                  databytenum <= 0;
                end if;
                
           when RX_PREAMBLE =>
              if (rx_data_in = x"D5") then
                 state <= rx_data;
              end if;
               
           when RX_DATA =>
  				framebytenum <= framebytenum + 1;
				case framebytenum is 
				    --- IP Header ---
					when 0 =>      udp_pkt_buf_rx.mac_dest_addr(39 downto 32)   <= rx_data_in;
					when 1 =>      udp_pkt_buf_rx.mac_dest_addr(31 downto 24)   <= rx_data_in;
					when 2 =>      udp_pkt_buf_rx.mac_dest_addr(23 downto 16)   <= rx_data_in;
					when 3 =>      udp_pkt_buf_rx.mac_dest_addr(15 downto 8)    <= rx_data_in;
					when 4 =>      udp_pkt_buf_rx.mac_dest_addr(7 downto 0)     <= rx_data_in;
					when 5 =>      udp_pkt_buf_rx.mac_src_addr(47 downto 40)	<= rx_data_in;
					when 6 =>      udp_pkt_buf_rx.mac_src_addr(39 downto 32)	<= rx_data_in;
					when 7 =>      udp_pkt_buf_rx.mac_src_addr(31 downto 24)	<= rx_data_in;
					when 8 =>      udp_pkt_buf_rx.mac_src_addr(23 downto 16)	<= rx_data_in;
					when 9 =>      udp_pkt_buf_rx.mac_src_addr(15 downto 8)	    <= rx_data_in;
					when 10 =>     udp_pkt_buf_rx.mac_src_addr(7 downto 0)		<= rx_data_in;   
					when 11 =>     udp_pkt_buf_rx.mac_len_type(15 downto 8)     <= rx_data_in;
					when 12 =>     udp_pkt_buf_rx.mac_len_type(7 downto 0)      <= rx_data_in;
					when 13 =>     udp_pkt_buf_rx.ip_ver                        <= rx_data_in(7 downto 4);
						           udp_pkt_buf_rx.ip_ihl                        <= rx_data_in(3 downto 0);
					when 14 =>     udp_pkt_buf_rx.ip_tos                        <= rx_data_in;
					when 15 =>     udp_pkt_buf_rx.total_len(15 downto 8)        <= rx_data_in;
					when 16 =>     udp_pkt_buf_rx.total_len(7 downto 0)         <= rx_data_in;
					when 17 =>     udp_pkt_buf_rx.ip_ident(15 downto 8)         <= rx_data_in;
					when 18 =>     udp_pkt_buf_rx.ip_ident(7 downto 0)          <= rx_data_in;
					when 19 =>     udp_pkt_buf_rx.ip_flags(2 downto 0)          <= rx_data_in(7 downto 5);
	                               udp_pkt_buf_rx.ip_fragoffset(12 downto 8)    <= rx_data_in(4 downto 0);
					when 20 =>     udp_pkt_buf_rx.ip_fragoffset(7 downto 0)     <= rx_data_in;
					when 21 =>     udp_pkt_buf_rx.ip_ttl					    <= rx_data_in;
					when 22 =>     udp_pkt_buf_rx.ip_protocol				    <= rx_data_in;
					when 23 =>     udp_pkt_buf_rx.header_checksum(15 downto 8)  <= rx_data_in;
					when 24 =>     udp_pkt_buf_rx.header_checksum(7 downto 0)   <= rx_data_in;
					when 25 =>     udp_pkt_buf_rx.ip_src_addr(31 downto 24)     <= rx_data_in;
					when 26 =>     udp_pkt_buf_rx.ip_src_addr(23 downto 16)     <= rx_data_in;
					when 27 =>     udp_pkt_buf_rx.ip_src_addr(15 downto 8)      <= rx_data_in;
					when 28 =>     udp_pkt_buf_rx.ip_src_addr(7 downto 0)       <= rx_data_in;
					when 29 =>     udp_pkt_buf_rx.ip_dest_addr(31 downto 24)    <= rx_data_in;
					when 30 =>     udp_pkt_buf_rx.ip_dest_addr(23 downto 16)    <= rx_data_in;
					when 31 =>     udp_pkt_buf_rx.ip_dest_addr(15 downto 8)     <= rx_data_in;
					when 32 =>     udp_pkt_buf_rx.ip_dest_addr(7 downto 0)      <= rx_data_in;						
					when 33 =>     udp_pkt_buf_rx.udp_src_port(15 downto 8)     <= rx_data_in;
					when 34 =>     udp_pkt_buf_rx.udp_src_port(7 downto 0)      <= rx_data_in;
					when 35 =>     udp_pkt_buf_rx.udp_dest_port(15 downto 8)    <= rx_data_in;
					when 36 =>     udp_pkt_buf_rx.udp_dest_port(7 downto 0)     <= rx_data_in;				
					when 37 =>     udp_pkt_buf_rx.udp_len(15 downto 8)	        <= rx_data_in;
					when 38 =>     udp_pkt_buf_rx.udp_len(7 downto 0)           <= rx_data_in;						
					when 39 =>     udp_pkt_buf_rx.udp_checksum(15 downto 8)     <= rx_data_in;
					when 40 =>     udp_pkt_buf_rx.udp_checksum(7 downto 0)      <= rx_data_in;	
					--Start of UDP Payload							   		   			
					when 41 => 	   udp_pkt_buf_rx.fast_ps_id(15 downto 8)       <= rx_data_in;
					when 42 =>     udp_pkt_buf_rx.fast_ps_id(7 downto 0)        <= rx_data_in;
					when 43 =>     udp_pkt_buf_rx.readback_cmd(15 downto 8)     <= rx_data_in; 
					when 44 =>     udp_pkt_buf_rx.readback_cmd(7 downto 0)      <= rx_data_in;
					when 45 =>     udp_pkt_buf_rx.nonce(63 downto 56)           <= rx_data_in;
					when 46 =>     udp_pkt_buf_rx.nonce(55 downto 48)           <= rx_data_in;  
					when 47 =>     udp_pkt_buf_rx.nonce(47 downto 40)           <= rx_data_in;  
                    when 48 =>     udp_pkt_buf_rx.nonce(39 downto 32)           <= rx_data_in; 
                    when 49 =>     udp_pkt_buf_rx.nonce(31 downto 24)           <= rx_data_in; 
                    when 50 =>     udp_pkt_buf_rx.nonce(23 downto 16)           <= rx_data_in;  
                    when 51 =>     udp_pkt_buf_rx.nonce(15 downto 8)            <= rx_data_in; 
                    when 52 =>     udp_pkt_buf_rx.nonce(7 downto 0)             <= rx_data_in; 
                    when 53 =>     udp_pkt_buf_rx.fast_addr1(15 downto 8)       <= rx_data_in; 
                    when 54 =>     udp_pkt_buf_rx.fast_addr1(7 downto 0)        <= rx_data_in; 
                    when 55 =>     udp_pkt_buf_rx.setpoint1(31 downto 24)       <= rx_data_in; 
                    when 56 =>     udp_pkt_buf_rx.setpoint1(23 downto 16)       <= rx_data_in;
                    when 57 =>     udp_pkt_buf_rx.setpoint1(15 downto 8)        <= rx_data_in; 
                    when 58 =>     udp_pkt_buf_rx.setpoint1(7 downto 0)         <= rx_data_in;
                    when 59 =>     udp_pkt_buf_rx.fast_addr2(15 downto 8)       <= rx_data_in;
                    when 60 =>     udp_pkt_buf_rx.fast_addr2(7 downto 0)        <= rx_data_in; 
                    when 61 =>     udp_pkt_buf_rx.setpoint2(31 downto 24)       <= rx_data_in; 
                    when 62 =>     udp_pkt_buf_rx.setpoint2(23 downto 16)       <= rx_data_in; 
                    when 63 =>     udp_pkt_buf_rx.setpoint2(15 downto 8)        <= rx_data_in; 
                    when 64 =>     udp_pkt_buf_rx.setpoint2(7 downto 0)         <= rx_data_in; 
                    when 65 =>     udp_pkt_buf_rx.fast_addr3(15 downto 8)       <= rx_data_in; 
                    when 66 =>     udp_pkt_buf_rx.fast_addr3(7 downto 0)        <= rx_data_in; 
					when 67 =>     udp_pkt_buf_rx.setpoint3(31 downto 24)       <= rx_data_in; 
                    when 68 =>     udp_pkt_buf_rx.setpoint3(23 downto 16)       <= rx_data_in; 
                    when 69 =>     udp_pkt_buf_rx.setpoint3(15 downto 8)        <= rx_data_in; 
                    when 70 =>     udp_pkt_buf_rx.setpoint3(7 downto 0)         <= rx_data_in; 
                    when 71 =>     udp_pkt_buf_rx.fast_addr4(15 downto 8)       <= rx_data_in; 
                    when 72 =>     udp_pkt_buf_rx.fast_addr4(7 downto 0)        <= rx_data_in; 
                    when 73 =>     udp_pkt_buf_rx.setpoint4(31 downto 24)       <= rx_data_in; 
                    when 74 =>     udp_pkt_buf_rx.setpoint4(23 downto 16)       <= rx_data_in; 
                    when 75 =>     udp_pkt_buf_rx.setpoint4(15 downto 8)        <= rx_data_in; 
                    when 76 =>     udp_pkt_buf_rx.setpoint4(7 downto 0)         <= rx_data_in; 
					when others => 
								   framebytenum <= 77; 
					end case;			
							

                  if (rx_dv = '0') then 
                        framebytenum <= 0; 
                        state <= RX_FINISHED;                     
				  end if;
				  
			when RX_FINISHED => 
			     rx_done <= '1'; 
			     state <= IDLE; 
						
		    when others => 
		    state <= IDLE;				
					
        end case;
     end if;
  end if; 
  end process;
end architecture;
