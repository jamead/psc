----------------------------------------------------------------------------------
-- Company: Brookhaven National Laboratory
-- Engineer: TAC
--
-- Create Date: 01/28/2020 02:12:52 PM
-- Design Name:
-- Module Name: LTC2376_20_intf - arch
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description: ADC interface for the LTC2376-20, 20 bit ADC.
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity ADC_ADS8568_intf is
generic(DATA_BITS   : natural := 128;
        SPI_CLK_DIV : natural := 10);
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
end entity;

architecture arch of ADC_ADS8568_intf is
type state is (IDLE,SET_CNV,WAIT_FOR_NOT_BUSY,WAIT_FOR_MSB_VALID,CLOCK_MSB,SCLK_HI,SCLK_LO,DONE);
constant CNV_PULSE : natural := 12;
constant CNV_WIDTH : natural := 400;
constant WAIT_MSB : natural := 6;
signal present_state : state;
signal shift_reg   : std_logic_vector(DATA_BITS -1 downto 0);
signal cnv_count   : natural range 0 to 500 := 0;
signal clk_count   : natural range 0 to 500 := 0;
signal bit_count   : natural range 0 to 500 := 0;

begin

process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            cnv_count <= 0;
            clk_count <= 0;
            bit_count <= 0;
            shift_reg <= (others => '0');
            data_out  <= (others => '0');
            data_rdy  <= '0';
            cnv <= '0';
            present_state <= IDLE;
        else
            case(present_state) is
                --IDLE: wait for start trigger
                when IDLE =>
                    if start = '1' then
                        present_state <= SET_CNV;
                    end if;
				    n_fs     <= '1';
                    sclk     <= '1';
                    data_rdy <= '0';

                --SET_CNV: set cnv signal high for at least
                --2 clocks datasheet specifies a min of 20ns
                when SET_CNV =>
                    if cnv_count = CNV_PULSE then
                        cnv           <= '0';
                        cnv_count     <= 0;
                        present_state <= WAIT_FOR_NOT_BUSY;
                    else
                        cnv           <= '1';
                        cnv_count <= cnv_count +1;
                    end if;

                --WAIT_FOR_NOT_BUSY: wait for busy to go low, then
                --transition to starting sclk
                when WAIT_FOR_NOT_BUSY =>
                    if cnv_count = CNV_WIDTH then
                        cnv_count     <= 0;
						n_fs          <= '0';
                        present_state <= WAIT_FOR_MSB_VALID;
                    else
                        cnv_count <= cnv_count +1;
                    end if;

			    --WAIT_FOR_MSB_VALID: MSB is not valid until 12 ns after n_FS goes low.  After at least 2 clocks (with period of 8 ns) pass
				--then MSB can be shifted in
				when WAIT_FOR_MSB_VALID =>
					if cnv_count = WAIT_MSB then
						sclk          <= '0';
                        shift_reg     <= shift_reg(DATA_BITS-2 downto 0) & sdi; --shift in first bit
						present_state <= CLOCK_MSB;
					else
						cnv_count <= cnv_count +1;
					end if;

				--MSB: Handles clock count when SCLK goes low for the first time (MSB)
                when CLOCK_MSB =>
                    if clk_count = SPI_CLK_DIV -1 then
                        clk_count <= 0;
                        sclk      <= '1';
                        present_state <= SCLK_HI;
                    else
                        clk_count <= clk_count +1;
                        sclk <= '0';
                    end if;


                --SCLK_HI: set sclk high for correct number of
                --clock counts
                when SCLK_HI =>
                    if clk_count = SPI_CLK_DIV -1 then
                        sclk <= '0';
                        clk_count <= 0;
                        bit_count <= bit_count +1;
                        shift_reg     <= shift_reg(DATA_BITS-2 downto 0) & sdi;
                        present_state <= SCLK_LO;
                    else
                        clk_count <= clk_count +1;
                        sclk <= '1';
                    end if;

                --SCLK_LO: set sclk low for correct number of
                --clock counts
                when SCLK_LO =>
                    if bit_count = (DATA_BITS-1) then
                        bit_count <= 0;
                        present_state <= DONE;
                    else
                        if clk_count = SPI_CLK_DIV -1 then
                            clk_count <= 0;
                            sclk      <= '1';
                            present_state <= SCLK_HI;
                        else
                            clk_count <= clk_count +1;
                            sclk <= '0';
                        end if;
                    end if;

                --DONE: register the shift register data and
                --return to idle.
                when DONE =>
                    data_out <= shift_reg;
                    data_rdy <= '1';
                    present_state <= IDLE;

                when others =>
                present_state <= IDLE;
            end case;
        end if;
    end if;
end process;
end architecture;
