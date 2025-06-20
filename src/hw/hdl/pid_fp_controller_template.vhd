library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pid_controller is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;

        -- Fixed-point 20-bit inputs
        setpoint    : in  signed(19 downto 0);
        feedback    : in  signed(19 downto 0);

        -- Float parameters
        Kp, Ki, Kd  : in  std_logic_vector(31 downto 0);  -- IEEE-754 single precision

        -- Output
        control_out : out signed(19 downto 0)
    );
end entity;

architecture rtl of pid_controller is

    -- Float signals (32-bit IEEE-754)
    signal sp_f, fb_f        : std_logic_vector(31 downto 0);
    signal err_f             : std_logic_vector(31 downto 0);
    signal p_term, i_term, d_term : std_logic_vector(31 downto 0);
    signal pid_sum_f         : std_logic_vector(31 downto 0);

    -- For integration and differentiation
    signal err_dly           : std_logic_vector(31 downto 0) := (others => '0');
    signal err_int           : std_logic_vector(31 downto 0) := (others => '0');
    signal err_diff          : std_logic_vector(31 downto 0);

begin

    -- Fixed to float conversion (Xilinx IP)
    sp_conv : entity work.fixed_to_float
        port map (
            a => setpoint,
            result => sp_f,
            clk => clk
        );

    fb_conv : entity work.fixed_to_float
        port map (
            a => feedback,
            result => fb_f,
            clk => clk
        );

    -- Error = setpoint - feedback
    err_calc : entity work.fp_sub
        port map (
            a => sp_f,
            b => fb_f,
            result => err_f,
            clk => clk
        );

    -- Derivative = error - previous_error
    diff_calc : entity work.fp_sub
        port map (
            a => err_f,
            b => err_dly,
            result => err_diff,
            clk => clk
        );

    -- Integral = integral + error
    int_calc : entity work.fp_add
        port map (
            a => err_int,
            b => err_f,
            result => err_int,
            clk => clk
        );

    -- P = Kp * error
    p_calc : entity work.fp_mul
        port map (
            a => Kp,
            b => err_f,
            result => p_term,
            clk => clk
        );

    -- I = Ki * integral
    i_calc : entity work.fp_mul
        port map (
            a => Ki,
            b => err_int,
            result => i_term,
            clk => clk
        );

    -- D = Kd * derivative
    d_calc : entity work.fp_mul
        port map (
            a => Kd,
            b => err_diff,
            result => d_term,
            clk => clk
        );

    -- PID = P + I + D
    pid_sum : entity work.fp_add
        port map (
            a => p_term,
            b => i_term,
            result => pid_sum_f,
            clk => clk
        );

    pid_out_add : entity work.fp_add
        port map (
            a => pid_sum_f,
            b => d_term,
            result => pid_sum_f,
            clk => clk
        );

    -- Float to fixed output
    out_conv : entity work.float_to_fixed
        port map (
            a => pid_sum_f,
            result => control_out,
            clk => clk
        );

    -- Pipeline stage: delay error for derivative term
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                err_dly  <= (others => '0');
            else
                err_dly  <= err_f;
            end if;
        end if;
    end process;

end architecture;

