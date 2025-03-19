library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity axi4_write_adc is
    port (
        clk             : in std_logic;
        reset           : in std_logic;
        trigger         : in std_logic;  -- 10 kHz trigger

        -- AXI Write Address Channel
        s_axi_awaddr : out std_logic_vector(31 downto 0);
        s_axi_awburst : out std_logic_vector(1 downto 0);
        s_axi_awcache : out std_logic_vector(3 downto 0);
        s_axi_awlen : out std_logic_vector(3 downto 0);
        s_axi_awlock : out std_logic_vector(1 downto 0);
        s_axi_awprot : out std_logic_vector(2 downto 0);
        s_axi_awqos : out std_logic_vector(3 downto 0);
        s_axi_awready : in std_logic;
        s_axi_awsize : out std_logic_vector(2 downto 0);
        s_axi_awvalid : out std_logic;

        -- AXI Write Data Channel
        s_axi_wdata : out std_logic_vector(31 downto 0);
        s_axi_wlast : out std_logic;
        s_axi_wready : in std_logic;
        s_axi_wstrb : out std_logic_vector(3 downto 0);
        s_axi_wvalid : out std_logic;

        -- AXI Write Response Channel
        s_axi_bready : out std_logic;
        s_axi_bresp : in std_logic_vector(1 downto 0);
        s_axi_bvalid : in std_logic
    );
end entity axi4_write_adc;

architecture rtl of axi4_write_adc is


   type  state_type is (IDLE, ADDRESS, DATA, AWAITRESP);  
   signal state :  state_type;


    signal wordnum : integer range 0 to 8 := 0;
    signal addr_base : std_logic_vector(31 downto 0) := x"1000_0000";  -- Example DDR address
    
    signal datacnt : std_logic_vector(31 downto 0);
    signal prev_trigger : std_logic;

    --debug signals (connect to ila)
    attribute mark_debug                 : string;
    attribute mark_debug of trigger : signal is "true";
    attribute mark_debug of prev_trigger : signal is "true";

    attribute mark_debug of s_axi_awaddr : signal is "true";
    attribute mark_debug of s_axi_awburst : signal is "true";
    attribute mark_debug of s_axi_awcache : signal is "true";
    attribute mark_debug of s_axi_awlen : signal is "true";
    attribute mark_debug of s_axi_awlock : signal is "true";
    attribute mark_debug of s_axi_awprot : signal is "true";
    attribute mark_debug of s_axi_awqos : signal is "true";
    attribute mark_debug of s_axi_awready : signal is "true";
    attribute mark_debug of s_axi_awsize : signal is "true";
    attribute mark_debug of s_axi_awvalid : signal is "true";

    attribute mark_debug of s_axi_wdata : signal is "true";
    attribute mark_debug of s_axi_wlast : signal is "true";
    attribute mark_debug of s_axi_wready : signal is "true";
    attribute mark_debug of s_axi_wstrb : signal is "true";
    attribute mark_debug of s_axi_wvalid : signal is "true";

    attribute mark_debug of s_axi_bready : signal is "true";
    attribute mark_debug of s_axi_bresp : signal is "true";
    attribute mark_debug of s_axi_bvalid : signal is "true";
    
    attribute mark_debug of wordnum : signal is "true"; 
    attribute mark_debug of datacnt : signal is "true";  
    attribute mark_debug of state : signal is "true"; 




begin
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        wordnum <= 0;
        s_axi_awvalid <= '0';
        s_axi_wvalid <= '0';
        s_axi_bready <= '0';
        state <= idle;
        datacnt <= 32d"0";
      else
        case state is 
          when IDLE =>                
            prev_trigger <= trigger;
            if (trigger = '1' and prev_trigger = '0') then

              wordnum <= 0;
              s_axi_awaddr <= addr_base;
              s_axi_awvalid <= '1';
              s_axi_awburst <= "00"; --"01"; -- Incrementing burst
              s_axi_awcache <= "0011"; -- Normal non-cacheable bufferable
              s_axi_awlen <= x"0"; --x"7";  -- 8-beat burst
              s_axi_awlock <= "00";    
              s_axi_awprot <= "000";  -- Unprivileged secure data
              s_axi_awqos <= "0000";   
              s_axi_awsize <= "010"; -- 4 bytes (32-bit)
              state <= address;
            end if;

          when ADDRESS =>
             -- Address handshake
             if (s_axi_awready = '1') then
                 s_axi_awvalid <= '0';  -- Address accepted
                 s_axi_wvalid <= '1';  --assert data valid
                 s_axi_wdata <= datacnt;
                 datacnt <= std_logic_vector(unsigned(datacnt) + 1);
                 s_axi_wstrb <= x"F";
                 s_axi_wlast <= '1';
                 state <= awaitresp; --data;
                 wordnum <= 0;
             end if;
             
          when DATA => 
             -- Write data
--             if (s_axi_wready = '1') then
--                 if (wordnum < 8) then
--                   s_axi_wdata <=  datacnt;  --data_values(wordnum);
--                   datacnt <= std_logic_vector(unsigned(datacnt) + 1);
--                   if wordnum = 7 then
--                      s_axi_wlast <= '1';
--                      state <= awaitresp;
--                   end if;
--                   wordnum <= wordnum + 1;
--                 end if;
--             end if;    
                
          when AWAITRESP =>
              s_axi_wlast <= '0';
              s_axi_wvalid <= '0';
              s_axi_bready <= '1';
              -- Clear bready after response
              if s_axi_bvalid = '1' then
                    addr_base <= std_logic_vector(unsigned(addr_base) + 4);
                    if (addr_base > x"1100_0000") then 
                      addr_base <= x"1000_0000";
                    end if;
                    s_axi_bready <= '0';
                    state <= idle;
              end if;
              
          end case;
        end if;
      end if;
   end process;
end architecture;

