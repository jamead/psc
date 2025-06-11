library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity smooth_ramp is
  port (
    clk         : in std_logic;
    reset       : in std_logic;
    tenkhz_trig : in std_logic;
    trig        : in std_logic;
 
    old_setpt   : in signed(19 downto 0);
    new_setpt   : in signed(19 downto 0);
    phase_inc   : in signed(31 downto 0);
    rampout     : out signed(19 downto 0)
  );
end entity;
 

architecture behv of smooth_ramp is

  -- Component declaration
  component cordic_sine
    port (
      aclk                : in  std_logic;
      s_axis_phase_tvalid : in  std_logic;
      s_axis_phase_tdata  : in  std_logic_vector(23 downto 0);
      m_axis_dout_tvalid  : out std_logic;
      m_axis_dout_tdata   : out std_logic_vector(47 downto 0)
    );
  end component;
  
  --constant pi : real := 3.1415926;

  
  type state_type is (IDLE, RUN_RAMP); 
  signal state : state_type;

  --cordic phase is 1.2.21 format  3.14/4 * 2^21 = 1647099
  --constant POS_PI            : signed(23 downto 0) := 24d"1647099";
  --constant NEG_PI            : signed(23 downto 0) := to_signed(-1647099, 24);
  
  --cordic phase is 1.2.21 format  3.14/4 * 2^31 = 421657428                     
  constant POS_PI            : signed(31 downto 0) := 32d"421657300";            
  constant NEG_PI            : signed(31 downto 0) := to_signed(-421657300, 32); 
  
  
  signal cordic_valid        : std_logic;
  signal cordic_dout         : std_logic_vector(47 downto 0);

  signal phase               : signed(31 downto 0);
  signal phase_out           : signed(23 downto 0);

  signal sin                 : signed(23 downto 0);
  signal cos                 : signed(23 downto 0);
  signal raised_cos          : signed(23 downto 0);
  signal raised_cos20        : signed(19 downto 0);
  signal cnt                 : std_logic_vector(19 downto 0);
  signal rampout_wdiff       : signed(47 downto 0);
  signal rampout_fp          : signed(23 downto 0);
  signal scaled_sine         : signed(23 downto 0);
  signal last_point          : std_logic;
  signal diff_setpt          : signed(23 downto 0);

  

   --debug signals (connect to ila)
   attribute mark_debug: string;   
   attribute mark_debug of trig: signal is "true";
   attribute mark_debug of tenkhz_trig: signal is "true";  
   attribute mark_debug of old_setpt: signal is "true";   
   attribute mark_debug of new_setpt: signal is "true";  
   attribute mark_debug of phase_inc: signal is "true";   
   attribute mark_debug of cos: signal is "true";
   attribute mark_debug of phase: signal is "true";             
   attribute mark_debug of state: signal is "true";   
   attribute mark_debug of last_point: signal is "true";  
   attribute mark_debug of cnt: signal is "true";    


begin

-- Instantiate UUT

--24 bits 
-- Input is 3 integer bits (1 sign) and 20 fractional bits
-- Output is 2 integer bits (1 sign) and 20 fractional bits
uut: cordic_sine
  port map (
    aclk                => clk,
    s_axis_phase_tvalid => tenkhz_trig,
    s_axis_phase_tdata  => std_logic_vector(phase_out),
    m_axis_dout_tvalid  => cordic_valid, 
    m_axis_dout_tdata   => cordic_dout
);

-- A = (i2 - i1) / N * pi/2
-- i2=10k, i1=0, N=10k
-- then A= pi/2 = 3.14 / 2 * 2^29 = 
-- precompute pi/N (N=1000)  => 3.14 / 1000 * 2^29 = 16866218

-- Assume N=1000
-- pi / 1000 * 2^29 = 1686629
-- pi / 1000 * 2^21 = 6588

--cur_setpt = 0;
--new_setpt = FS/2; = 2^20/2 = 536870912


sin <= signed(cordic_dout(47 downto 24));
cos <= signed(cordic_dout(23 downto 0));

--rampout <= rampoutfp(23 downto 4);

process(clk)
  begin 
    if (rising_edge(clk)) then
      if (reset = '1') then
        state <= idle;
        phase <= NEG_PI;
        phase_out <= NEG_PI(31 downto 8);
        rampout_wdiff <= 48d"0";
        rampout <= 20d"0";
        raised_cos <= 24d"0";
        rampout_fp <= 24d"0";
        cnt <= (others => '0');
        last_point <= '0';
      
      else
        case (state) is  
          when IDLE =>
            last_point <= '0';
            if (trig = '1') then
              state <= run_ramp;
              phase <= NEG_PI; 
              phase_out <= NEG_PI(31 downto 8);
              cnt <= 20d"0";
              last_point <= '0';
            end if;
          
          when RUN_RAMP =>  
            if (tenkhz_trig = '1') then
              -- smooth ramp =  old_setpt + (new_setpt - old_setpt) * 0.5 * (1 - cos(i*pi/N)
              
              --this gives a smooth function from 0 to 1
              -- run cosine from -pi/2 to 0 to get output -1 to 1, then add 1 and divide by 2
              raised_cos <= ((resize(cos,24) + to_signed(2**20,24)) srl 1);
                   
              --ramp with difference
              diff_setpt <= resize(new_setpt,24) - resize(old_setpt,24);
              rampout_wdiff <= (resize(new_setpt,24) - resize(old_setpt,24)) * raised_cos;      
              
              --resize back to 24 bits and add old_setpt 
              rampout_fp <= old_setpt + rampout_wdiff(43 downto 20);
              
              --resize back to 20 or 18 bits
              rampout <= rampout_fp(19 downto 0);

              if (last_point = '1') then
                 state <= idle;
              end if;
              
              if (phase > 0) then  --( cnt > npts) then
                phase <= (others => '0');
                last_point <= '1';
              else
                cnt <= std_logic_vector(unsigned(cnt) + 1);
                --phase <= 24d"262144"; --phase + 1000; --6588;
                phase <= phase + phase_inc; 
                phase_out <= phase(31 downto 8);
              end if;
            end if;
               
        end case;
      end if;
    end if;
end process;      
    
    
             
end behv;           
          
          
          
  


 
