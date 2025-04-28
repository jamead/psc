library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;


library work;
use work.psc_pkg.ALL;


entity digio_logic is
  port (
	clk                    : in std_logic; 
	reset                  : in std_logic; 
	tenkhz_trig            : in std_logic; 		  
    rsts                   : in std_logic_vector(19 downto 0);
    rcom                   : out std_logic_vector(19 downto 0);
    dig_cntrl              : in t_dig_cntrl;
    dig_stat               : out t_dig_stat
);

end digio_logic;

architecture behv of digio_logic is	
		
  signal fault      : std_logic_vector(3 downto 0);
  signal error      : std_logic_vector(3 downto 0);


begin

--PS1
-- Digital Outputs
rcom(1) <= dig_cntrl.ps1.on2;
rcom(2) <= dig_cntrl.ps1.reset;
rcom(3) <= dig_cntrl.ps1.spare; 
rcom(16) <= dig_cntrl.ps1.park;

-- Digital Inputs
dig_stat.ps1.acon <= rsts(0);
dig_stat.ps1.flt1 <= rsts(1);
dig_stat.ps1.flt2 <= rsts(2);
dig_stat.ps1.spare <= rsts(3);
dig_stat.ps1.dcct_flt <= rsts(16);


--PS2
-- Digital Outputs
rcom(5) <= dig_cntrl.ps2.on2;
rcom(6) <= dig_cntrl.ps2.reset;
rcom(7) <= dig_cntrl.ps2.spare; 
rcom(17) <= dig_cntrl.ps2.park;

-- Digital Inputs
dig_stat.ps2.acon <= rsts(4);
dig_stat.ps2.flt1 <= rsts(5);
dig_stat.ps2.flt2 <= rsts(6);
dig_stat.ps2.spare <= rsts(7);
dig_stat.ps2.dcct_flt <= rsts(17);


--PS3
-- Digital Outputs
rcom(9) <= dig_cntrl.ps2.on2;
rcom(10) <= dig_cntrl.ps2.reset;
rcom(11) <= dig_cntrl.ps2.spare; 
rcom(18) <= dig_cntrl.ps2.park;

-- Digital Inputs
dig_stat.ps2.acon <= rsts(8);
dig_stat.ps2.flt1 <= rsts(9);
dig_stat.ps2.flt2 <= rsts(10);
dig_stat.ps2.spare <= rsts(11);
dig_stat.ps2.dcct_flt <= rsts(18);


--PS4
-- Digital Outputs
rcom(13) <= dig_cntrl.ps2.on2;
rcom(14) <= dig_cntrl.ps2.reset;
rcom(15) <= dig_cntrl.ps2.spare; 
rcom(19) <= dig_cntrl.ps2.park;

-- Digital Inputs
dig_stat.ps2.acon <= rsts(12);
dig_stat.ps2.flt1 <= rsts(13);
dig_stat.ps2.flt2 <= rsts(14);
dig_stat.ps2.spare <= rsts(15);
dig_stat.ps2.dcct_flt <= rsts(19);






chan1_on : entity work.pulse_enable
port map(
    clk        => clk,
    reset      => reset,
    en         => '1', --,
    enable_in  => dig_cntrl.ps1.on1,
    en_out     => rcom(1), 
    period_in  => 32d"10000" 
);


chan2_on : entity work.pulse_enable
port map(
    clk        => clk,
    reset      => reset,
    en         => '1', --,
    enable_in  => dig_cntrl.ps2.on1,
    en_out     => rcom(4), 
    period_in  => 32d"10000" 
);

chan3_on : entity work.pulse_enable
port map(
    clk        => clk,
    reset      => reset,
    en         => '1', --,
    enable_in  => dig_cntrl.ps3.on1,
    en_out     => rcom(8), 
    period_in  => 32d"10000" 
);

chan4_on : entity work.pulse_enable
port map(
    clk        => clk,
    reset      => reset,
    en         => '1', --,
    enable_in  => dig_cntrl.ps4.on1,
    en_out     => rcom(12), 
    period_in  => 32d"10000" 
);



end architecture; 
