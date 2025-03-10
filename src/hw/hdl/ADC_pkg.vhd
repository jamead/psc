library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ADC_pkg is


--########################################################################
--                           Records
--########################################################################
	type t_DCCT_ADC is record
		adc_data  : std_logic_vector(19 downto 0);
		gain      : std_logic_vector(31 downto 0);
		offset    : std_logic_vector(31 downto 0);
	end record;

	--DCCT record
	type t_DCCT is record
	    done           : std_logic;
		ADC1           : t_DCCT_ADC;
		ADC2           : t_DCCT_ADC;
		ADC3           : t_DCCT_ADC;
		ADC4           : t_DCCT_ADC;
		ADC5           : t_DCCT_ADC;
		ADC6           : t_DCCT_ADC;
		ADC7           : t_DCCT_ADC;
		ADC8           : t_DCCT_ADC;
	end record;

	type t_ADC_8CH_g_o is record
	    data           : std_logic_vector(15 downto 0);
        gain           : std_logic_vector(31 downto 0);
        offset         : std_logic_vector(31 downto 0);
	end record;

	type t_ADC_CHANNEL is record
	   CH1            : t_ADC_8CH_g_o;
	   CH2            : t_ADC_8CH_g_o;
	   CH3            : t_ADC_8CH_g_o;
	   CH4            : t_ADC_8CH_g_o;
	   CH5            : t_ADC_8CH_g_o;
	   CH6            : t_ADC_8CH_g_o;
	   CH7            : t_ADC_8CH_g_o;
	   CH8            : t_ADC_8CH_g_o;
	end record;

  	--8 Channel ADC record
	type t_ADC_8CHANNEL is record
	   --ADC1 Data Regs
	   ADC1       	: t_ADC_CHANNEL;
	   ADC2       	: t_ADC_CHANNEL;
	   ADC3     	: t_ADC_CHANNEL;
	end record;


--########################################################################
--                         Components
--########################################################################
	--DCCT Module
	component DCCT_ADC_module is
		port(
			--Control inputs
			clk       : in std_logic;
			reset     : in std_logic;
			start     : in std_logic;
			--Gain and Offset registers
			DCCT_in   : in t_DCCT;
			DCCT_out  : out t_DCCT;
			--ADC Inputs
			sdi_1     : in std_logic;
			sdi_2     : in std_logic;
			sdi_3     : in std_logic;
			sdi_4     : in std_logic;
			--ADC Outputs
			cnv       : out std_logic;
			sclk      : out std_logic;
			sdo       : out std_logic;
			done      : out std_logic
			);
	end component;

    --DCCT ADC Interface
   	component ADC_LTC2376_intf is
	generic(DATA_BITS   : natural := 20;
			SPI_CLK_DIV : natural := 5); --Dividing the 50 MHz clock to 10MHz 50MHz/5 = 10MHz
	port (
			--Control inputs
			clk       : in std_logic;
			reset     : in std_logic;
			start     : in std_logic;
			--ADC Inputs
			busy      : in std_logic;
			sdi       : in std_logic;
			--ADC Outputs
			cnv       : out std_logic;
			sclk      : out std_logic;
			sdo       : out std_logic;
			data_out  : out std_logic_vector(DATA_BITS -1 downto 0);
			data_rdy  : out std_logic
		);
	end component;

	--8 Channel ADC Module
	component ADC_8CH_module is
		port(
			--Clocks and Resets
			clk          : in std_logic;
			reset        : in std_logic;
			start        : in std_logic;
			--Data Registers
		    ADC_8CH_in   : in t_ADC_8CHANNEL;
			ADC_8CH_out  : out t_ADC_8CHANNEL;
			--SPI Signals
			ADC8C_MISO1   : in std_logic;
			ADC8C_MISO2   : in std_logic;
			ADC8C_MISO3   : in std_logic;
			ADC8C_CONV123 : out std_logic;
			ADC8C_FS123   : out std_logic;
			ADC8C_SCK123  : out std_logic;
			done         : out std_logic
		);
	end component;

	--8 Channel ADC Interface
	component ADC_ADS8568_intf
	generic(DATA_BITS   : natural := 128;
			SPI_CLK_DIV : natural := 5); --Dividing the 50 MHz clock to 10MHz 50MHz/5 = 10MHz
	port (
			--Control inputs
			clk       : in std_logic;
			reset     : in std_logic;
			start     : in std_logic;
			--ADC Inputs
			busy      : in std_logic;
			sdi       : in std_logic;
			--ADC Outputs
			cnv       : out std_logic;
			n_fs      : out std_logic;
			sclk      : out std_logic;
			sdo       : out std_logic;
			data_out  : out std_logic_vector(DATA_BITS -1 downto 0);
			data_rdy  : out std_logic
		);
	end component;

	component gain_offset is
		generic(N : integer := 18);
		port(
			clk 			: in std_logic;
			reset       	: in std_logic;
			start           : in std_logic;
			data_in     	: in std_logic_vector(N-1 downto 0);
			gain        	: in std_logic_vector(31 downto 0);
			offset      	: in std_logic_vector(31 downto 0);
			result      	: out std_logic_vector(N-1 downto 0);
			done            : out std_logic
			);
	end component;

	component GPIO_module is
	port(
			--Clock and Reset
			clk                      : in std_logic;
			reset                    : in std_logic;
			--GPIO Inputs
			RSTS00                   : in std_logic;
			RSTS01                   : in std_logic;
			RSTS02                   : in std_logic;
			RSTS03                   : in std_logic;
			RSTS04                   : in std_logic;
			RSTS05                   : in std_logic;
			RSTS06                   : in std_logic;
			RSTS07                   : in std_logic;
			RSTS08                   : in std_logic;
			RSTS09                   : in std_logic;
			RSTS10                   : in std_logic;
			RSTS11                   : in std_logic;
			RSTS12                   : in std_logic;
			RSTS13                   : in std_logic;
			RSTS14                   : in std_logic;
			RSTS15                   : in std_logic;
			RSTS16                   : in std_logic;
			RSTS17                   : in std_logic;
			RSTS18                   : in std_logic;
			RSTS19                   : in std_logic;
			RSTS20                   : in std_logic;
			RSTS21                   : in std_logic;
		    RSTS22                   : in std_logic;
		    RSTS23                   : in std_logic;
		    RSTS24                   : in std_logic;
		    RSTS25                   : in std_logic;
		    RSTS26                   : in std_logic;
		    RSTS27                   : in std_logic;
		    RSTS28                   : in std_logic;
		    RSTS29                   : in std_logic;
		    RSTS30                   : in std_logic;
		    RSTS31                   : in std_logic;
			--GPIO Outputs
			RCM00                    : out std_logic;
			RCM01                    : out std_logic;
			RCM02                    : out std_logic;
			RCM03                    : out std_logic;
			RCM04                    : out std_logic;
			RCM05                    : out std_logic;
			RCM06                    : out std_logic;
			RCM07                    : out std_logic;
			RCM08                    : out std_logic;
			RCM09                    : out std_logic;
			RCM10                    : out std_logic;
			RCM11                    : out std_logic;
			RCM12                    : out std_logic;
			RCM13                    : out std_logic;
			RCM14                    : out std_logic;
			RCM15                    : out std_logic;
			RCM16                    : out std_logic;
			RCM17                    : out std_logic;
			RCM18                    : out std_logic;
			RCM19                    : out std_logic;
			RCM20                    : out std_logic;
			RCM21                    : out std_logic;
			RCM22                    : out std_logic;
			RCM23                    : out std_logic;
			RCM24                    : out std_logic;
			RCM25                    : out std_logic;
			RCM26                    : out std_logic;

			--Control Registers
			GPIO_2_ps                : out std_logic_vector(31 downto 0);
			GPIO_2_rc                : in  std_logic_vector(31 downto 0)
	);
	end component;

end package;
