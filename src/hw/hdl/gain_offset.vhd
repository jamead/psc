-------------------------------------------------------------------------------
-- Title         : Gain and Offset module
-------------------------------------------------------------------------------
-- File          : gain_offset.vhd
-- Author        : Thomas Chiesa tchiesa@bnl.gov
-- Created       : 07/19/2020
-------------------------------------------------------------------------------
-- Description:
-- This gain and offset module is used for the ADCs and the DACs to
-- apply gains and offsets.  It is inteneded to interface to the
-- processor with a 32-bit word.  The fixed point gain uses an signed
-- 8.24 format. So the maximum gain multiplication is 127.  Both the
-- gain and offset are limited to the maximum bit value based on generic
-- N.
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modification history:
-- 07/19/2020: created.
-------------------------------------------------------------------------------

library unisim;
use unisim.vcomponents.all;

library UNIMACRO;
use UNIMACRO.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity gain_offset is
	generic (N : integer := 18);
	port (
		   clk      : in std_logic;
		   reset    : in std_logic;
		   start    : in std_logic;
		   data_in  : in std_logic_vector(N - 1 downto 0);
		   gain     : in std_logic_vector(31 downto 0);
		   offset   : in std_logic_vector(31 downto 0);
		   result   : out std_logic_vector(N - 1 downto 0);
		   done     : out std_logic
	    );
end entity;

architecture arch of gain_offset is
	type state is (IDLE, STAGE1, STAGE2, STAGE3, COMPLETE);
	signal present_state : state;

    --Constants for Limiters
	constant C_UPPER_LIMIT : signed(N + 2 downto 0) := to_signed(((2 ** (N - 1)) - 1), N + 3);
	constant C_LOWER_LIMIT : signed(N + 2 downto 0) := to_signed( - 1 * ((2 ** (N - 1)) - 1), N + 3);

	signal input_offset_lim : signed(31 downto 0);
	signal trunc_offset     : signed(N downto 0);
	signal gain_mult_trunc  : signed(((N + 25) - 17 - 1) downto 0);
	signal gain_resize      : signed(N + 2 downto 0);
	signal gain_lim         : signed(N + 2 downto 0);
	signal adder_lim        : signed(N + 2 downto 0);
	signal adder_out        : signed(N + 2 downto 0);
	signal multicycle_cnt   : integer range 0 to 10;

	signal gain_mult_slv    : std_logic_vector((N + 25) - 1 downto 0);
	signal gain_mult        : signed((N + 25) - 1 downto 0);
	signal mult_clk_en      : std_logic;
begin
			gain_mult_trunc <= gain_mult((N + 25) - 1 downto 17);
			gain_resize <= resize(gain_mult_trunc, N + 3);

	process (clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				present_state <= IDLE;
				done <= '0';
				multicycle_cnt <= 0;
				result <= (others => '0');
			else
				--Truncate the offset
				trunc_offset <= signed(offset(N downto 0));

				case(present_state) is
					-- IDLE: Wait for start bit to be set, clear done bit.
					when IDLE =>
						done <= '0';
						if start = '1' then
							present_state <= STAGE1;
						end if;

					-- STAGE1: Limit the input offset value and
					-- in parallel run the multiply for a 3 clock latency.
					when STAGE1 =>
						if multicycle_cnt = 3 then
							present_state <= STAGE2;
							multicycle_cnt <= 0;
						else

						    gain_mult <= signed(gain(31 downto 7)) * signed(data_in);

							--Input Offset Limiter
							if signed(offset) >= C_UPPER_LIMIT then
								input_offset_lim <= resize(C_UPPER_LIMIT, 32);
							elsif signed(offset) <= C_LOWER_LIMIT then
								input_offset_lim <= resize(C_LOWER_LIMIT, 32);
							else
								input_offset_lim <= signed(offset);
							end if;
							mult_clk_en <= '1';
							multicycle_cnt <= multicycle_cnt + 1;
						end if;

					-- STAGE2: Put the output of the multiplier and put through a
					-- limiter.
					when STAGE2 =>
						if multicycle_cnt = 3 then
							multicycle_cnt <= 0;
							present_state <= STAGE3;
						else
							--Gain Limiter
							if gain_resize >= C_UPPER_LIMIT then
								gain_lim <= C_UPPER_LIMIT;
							elsif gain_resize <= C_LOWER_LIMIT then
								gain_lim <= C_LOWER_LIMIT;
							else
								gain_lim <= gain_resize;
							end if;
							multicycle_cnt <= multicycle_cnt + 1;
						end if;

					-- STAGE3: Final adding of the gain and offset, with output limiter.
					when STAGE3 =>
						if multicycle_cnt = 4 then
							multicycle_cnt <= 0;
							present_state <= COMPLETE;
						else
							--add gain and offset together
							adder_out <= gain_lim + resize(input_offset_lim, N + 3);

							--Output Limiter
							if adder_out >= C_UPPER_LIMIT then
								adder_lim <= C_UPPER_LIMIT; --adder_out; --to_signed((2**N-1),N+3);
							elsif adder_out <= C_LOWER_LIMIT then
								adder_lim <= C_LOWER_LIMIT;
							else
								adder_lim <= adder_out;
							end if;
							multicycle_cnt <= multicycle_cnt + 1;
						end if;

					-- COMPLETE: Gain and Offset calculation completed. Register the
					-- result, strobe done bit and return to IDLE state.
					when COMPLETE =>
						result <= std_logic_vector(adder_lim(N - 1 downto 0));
						done <= '1';
						present_state <= IDLE;

					when others =>
						present_state <= IDLE;
				end case;
			end if;
		end if;
	end process;
end architecture;
