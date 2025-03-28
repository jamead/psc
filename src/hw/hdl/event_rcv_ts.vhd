
--The time of day is updated by a serial stream of 0 events (0x70) and 1 events
--(0x71). This code implements a pointer into the time of day register and writes
--the data into that position. On receibt of the latch event (0x7d) the data is
--moved to the output register and the pointer is cleared. The offset is cleared
--on event 0x7d then incremented on the input clock edge.


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity event_rcv_ts is
    Port (
        Clock        : in  STD_LOGIC;
        Reset        : in  STD_LOGIC;
        EventStream  : in  STD_LOGIC_VECTOR(7 downto 0);
        TimeStamp    : out STD_LOGIC_VECTOR(63 downto 0);
        Seconds      : out STD_LOGIC_VECTOR(31 downto 0);
        Offset       : out STD_LOGIC_VECTOR(31 downto 0);
        Position     : out STD_LOGIC_VECTOR(4 downto 0);
        eventClock   : out STD_LOGIC
    );
end event_rcv_ts;

architecture behv of event_rcv_ts is

    signal offsetReg    : unsigned(31 downto 0) := (others => '0');
    signal secondsReg   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal clear        : STD_LOGIC := '0';
    signal clear_reg    : STD_LOGIC := '0';
    signal pos          : unsigned(4 downto 0) := (others => '1');
    signal seconds_tmp  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin

    -- Position Control
    process (Clock)
    begin
        if rising_edge(Clock) then
            if EventStream = x"7D" then
                pos <= (others => '1');
            elsif (EventStream = x"70") or (EventStream = x"71") then
                pos <= pos - 1;
            end if;
        end if;
    end process;
    Position <= std_logic_vector(pos);

    -- Seconds Control
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' or clear_reg = '1' then
                seconds_tmp <= (others => '0');
            elsif EventStream = x"70" then
                seconds_tmp(to_integer(pos)) <= '0';
            elsif EventStream = x"71" then
                seconds_tmp(to_integer(pos)) <= '1';
            end if;
        end if;
    end process;
    Seconds <= seconds_tmp;

    -- Register Seconds on Event
    process (Clock)
    begin
        if rising_edge(Clock) then
            if EventStream = x"7D" then
                secondsReg <= seconds_tmp;
            end if;
        end if;
    end process;

    -- Offset Control
    process (Clock)
    begin
        if rising_edge(Clock) then
            if EventStream = x"7D" then
                offsetReg <= (others => '0');
            else
                offsetReg <= offsetReg + 1;
            end if;
        end if;
    end process;
    Offset <= std_logic_vector(offsetReg);

    -- Clear Control
    process (Clock)
    begin
        if rising_edge(Clock) then
            if EventStream = x"7D" then
                clear <= '1';
            else
                clear <= '0';
            end if;
            clear_reg <= clear;
        end if;
    end process;

    -- Timestamp Control
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' then
                TimeStamp <= (others => '0');
            else
                TimeStamp <= secondsReg & std_logic_vector(offsetReg);
            end if;
        end if;
    end process;

    -- Event Clock Logic
    eventClock <= '1' when (EventStream = x"70") or (EventStream = x"71") or (EventStream = x"7D") else '0';

end behv;


