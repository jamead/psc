library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sine is
end tb_sine;

architecture behavior of tb_sine is

  -- Component declaration
  component cordic_sine
    port (
      aclk                : in  std_logic;
      s_axis_phase_tvalid : in  std_logic;
      s_axis_phase_tdata  : in  std_logic_vector(31 downto 0);
      m_axis_dout_tvalid  : out std_logic;
      m_axis_dout_tdata   : out std_logic_vector(63 downto 0)
    );
  end component;
  
  constant pi : real := 3.1415926;


  -- Clock
  signal clk         : std_logic := '0';
  constant clk_period : time := 10 ns;

  -- Stimulus signals
  signal s_axis_phase_tvalid : std_logic := '0';
  signal s_axis_phase_tdata  : std_logic_vector(31 downto 0) := (others => '0');

  -- Outputs
  signal m_axis_dout_tvalid  : std_logic;
  signal m_axis_dout_tdata   : std_logic_vector(63 downto 0);


  signal phase_data  : signed(31 downto 0) := (others => '0');

  signal sine_val    : signed(31 downto 0);
  signal cos_val     : signed(31 downto 0);
  signal sine_real   : real;
  signal cos_real    : real;

begin

-- Instantiate UUT
uut: cordic_sine
  port map (
    aclk                => clk,
    s_axis_phase_tvalid => s_axis_phase_tvalid,
    s_axis_phase_tdata  => s_axis_phase_tdata,
    m_axis_dout_tvalid  => m_axis_dout_tvalid,
    m_axis_dout_tdata   => m_axis_dout_tdata
);



-- Clock generation
clk_process: process
  begin
    while true loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
end process;




  -- Stimulus process
stim_proc: process
  begin
    -- Wait for global reset
    wait for 100 ns;

   -- Calculate phase_data: angle * 2^24 / (2π)  
   -- Input Phase: 1 sign, 2 integer, 29 fractional bits
   phase_data <= to_signed(integer(pi/2 * 2**29), 32);
 
   wait for 100 ns;
   s_axis_phase_tdata <= std_logic_vector(phase_data);

   -- Assert valid
   s_axis_phase_tvalid <= '1';
   wait for clk_period;
   s_axis_phase_tvalid <= '0';

   wait for 400 ns;

   -- Extract sine and cosine (signed 24-bit)
   cos_val <= signed(m_axis_dout_tdata(31 downto 0));
   sine_val <= signed(m_axis_dout_tdata(63 downto 32));

   -- Convert to real
   --output is 1 sign bit, 1 integer bit, 30 fractional bits
   wait for 100 ns;
   sine_real <= real(to_integer(sine_val)) / 2**30;
   cos_real  <= real(to_integer(cos_val))  / 2**30;

   report ", Sine: " & real'image(sine_real) &
          ", Cosine: " & real'image(cos_real);

   wait for clk_period;


    -- End simulation
    report "Testbench completed.";
    wait;
  end process;

end behavior;


 
