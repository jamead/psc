-- Adds a gain and offset to the DCCT reading.  
-- Offset is Q0.19
-- Gain is floating point IEEE754



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.psc_pkg.all; 

entity dcct_gainoffset_fp is 
	port(
      clk            : in std_logic;
      reset          : in std_logic; 
      conv_done      : in std_logic; 
      dcct0_raw      : in signed(19 downto 0);
      dcct1_raw      : in signed(19 downto 0);
      dcct_params    : in t_dcct_adcs_params_onech; 
      dcct_out       : out t_dcct_adcs_onech;
      done           : out std_logic 
     );
end entity;

architecture arch of dcct_gainoffset_fp is


  type  state_type is (IDLE, APPLY_OFFSETS, APPLY_GAINS, MULT_DLY);  
  signal state           :  state_type;
  signal conv_done_last  : std_logic;
  signal multdlycnt      : std_logic_vector(4 downto 0);
  signal dcct0_oc        : signed(19 downto 0);
  signal dcct1_oc        : signed(19 downto 0);
  
  signal dcct0_raw_f     : std_logic_vector(31 downto 0);
  signal dcct1_raw_f     : std_logic_vector(31 downto 0);
  signal dcct0_wgain_f   : std_logic_vector(31 downto 0);
  signal dcct1_wgain_f   : std_logic_vector(31 downto 0);
  signal dcct0_corr      : std_logic_vector(31 downto 0);
  signal dcct1_corr      : std_logic_vector(31 downto 0);

   attribute mark_debug                 : string;
   attribute mark_debug of dcct0_oc: signal is "true";
   attribute mark_debug of dcct0_raw_f : signal is "true";
   attribute mark_debug of dcct0_wgain_f: signal is "true";
   



begin

dcct_out.dcct0 <= signed(dcct0_corr(31 downto 12)); 
dcct_out.dcct1 <= signed(dcct1_corr(31 downto 12)); 

dcct_out.dcct0_fp <= dcct0_wgain_f;
dcct_out.dcct0_raw <= dcct0_raw;




--fixed to float conversion for dcct0
dcct0_conv : entity work.fix20_to_float
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => '1',
    s_axis_a_tdata => std_logic_vector(resize(dcct0_oc,24)),
    m_axis_result_tvalid => open,
    m_axis_result_tdata => dcct0_raw_f
  );

--fixed to float conversion for dcct1
dcct1_conv : entity work.fix20_to_float
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => '1',
    s_axis_a_tdata => std_logic_vector(resize(dcct1_oc,24)),
    m_axis_result_tvalid => open,
    m_axis_result_tdata => dcct1_raw_f
  );


-- dcct0 gain mult
dcct0_gain: entity work.fp_mult
  port map (
    aclk  => clk,
    s_axis_a_tvalid => '1', 
    s_axis_a_tdata => dcct0_raw_f,
    s_axis_b_tvalid => '1',
    s_axis_b_tdata => dcct_params.dcct0_gain,
    m_axis_result_tvalid => open,
    m_axis_result_tdata => dcct0_wgain_f
 );

dcct1_gain: entity work.fp_mult
  port map (
    aclk  => clk,
    s_axis_a_tvalid => '1', 
    s_axis_a_tdata => dcct1_raw_f,
    s_axis_b_tvalid => '1',
    s_axis_b_tdata => dcct_params.dcct1_gain,
    m_axis_result_tvalid => open,
    m_axis_result_tdata => dcct1_wgain_f
 );


-- Convert to Fixed20 and Output 
dcct0_out : entity work.float_to_fix32
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => '1',
    s_axis_a_tdata => dcct0_wgain_f,
    m_axis_result_tvalid => open,
    m_axis_result_tdata => dcct0_corr
  );

-- Convert to Fixed20 and Output 
dcct1_out : entity work.float_to_fix32
  PORT MAP (
    aclk => clk,
    s_axis_a_tvalid => '1',
    s_axis_a_tdata => dcct1_wgain_f,
    m_axis_result_tvalid => open,
    m_axis_result_tdata => dcct1_corr
  );




process(clk) 
  begin 
	if rising_edge(clk) then 
	 if reset = '1' then 
		done <= '0'; 		   
	 else 
	   case state is 
	     when IDLE =>
	       done <= '0';
	       conv_done_last <= conv_done;
		   if (conv_done = '1' and conv_done_last = '0') then 				   
		      state <= apply_offsets;
           end if;
         
         when APPLY_OFFSETS =>
           dcct0_oc <= dcct0_raw - dcct_params.dcct0_offset;
           dcct1_oc <= dcct1_raw - dcct_params.dcct1_offset;
           state <= apply_gains;

           
         when APPLY_GAINS =>
           state <= mult_dly;
           multdlycnt <= 5d"0";
           
         when MULT_DLY =>
           if (multdlycnt = 5d"20") then
             state <= idle;
             done <= '1';
           else
             multdlycnt <= std_logic_vector(unsigned(multdlycnt) + 1);
           end if;
  
           
         when OTHERS => 
           state <= idle;       
	          
	   end case;       
	          
	  end if; 
    end if; 
end process; 

end arch;

