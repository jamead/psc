library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity event_rcv_chan is
    Port (
        Clock       : in  STD_LOGIC;
        Reset       : in  STD_LOGIC;
        eventStream : in  STD_LOGIC_VECTOR(7 downto 0);
        myEvent     : in  STD_LOGIC_VECTOR(7 downto 0);
        myDelay     : in  STD_LOGIC_VECTOR(31 downto 0);
        myWidth     : in  STD_LOGIC_VECTOR(31 downto 0);
        myPolarity  : in  STD_LOGIC;
        trigger     : out STD_LOGIC
    );
end event_rcv_chan;

architecture behv of event_rcv_chan is

    signal delayCounter : unsigned(31 downto 0) := (others => '0');
    signal widthCounter : unsigned(31 downto 0) := (others => '0');
    signal startDelay   : STD_LOGIC := '0';
    signal startWidth   : STD_LOGIC := '0';
    signal trigVal      : STD_LOGIC;
    
--    attribute mark_debug                  : string;
--    attribute mark_debug of delayCounter  : signal is "true";
--    attribute mark_debug of widthCounter  : signal is "true";
--    attribute mark_debug of startDelay    : signal is "true";
--    attribute mark_debug of startWidth    : signal is "true";
--    attribute mark_debug of trigVal       : signal is "true";
--    attribute mark_debug of myEvent       : signal is "true";
--    attribute mark_debug of myDelay       : signal is "true";   
--    attribute mark_debug of trigger       : signal is "true";
--    attribute mark_debug of eventStream   : signal is "true";


begin

    -- Delay Counter Process
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' then
                delayCounter <= (others => '0');
            elsif startDelay = '1' then
                delayCounter <= delayCounter + 1;
            elsif delayCounter >= unsigned(myDelay) then
                delayCounter <= (others => '0');
            end if;
        end if;
    end process;

    -- Width Counter Process
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' then
                widthCounter <= (others => '0');
            elsif startWidth = '1' then
                widthCounter <= widthCounter + 1;
            elsif widthCounter >= unsigned(myWidth) then
                widthCounter <= (others => '0');
            end if;
        end if;
    end process;

    -- Start Delay Control
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' then
                startDelay <= '0';
            elsif myEvent = eventStream then
                startDelay <= '1';
            elsif delayCounter >= unsigned(myDelay) then
                startDelay <= '0';
            end if;
        end if;
    end process;

    -- Start Width Control
    process (Clock)
    begin
        if rising_edge(Clock) then
            if Reset = '1' then
                startWidth <= '0';
            elsif delayCounter > unsigned(myDelay) then
                startWidth <= '1';
            elsif widthCounter >= unsigned(myWidth) then
                startWidth <= '0';
            end if;
        end if;
    end process;

    -- Trigger Logic
    trigVal <= not startWidth when myPolarity = '1' else startWidth;
    trigger <= trigVal when (unsigned(myDelay) /= 0 and unsigned(myWidth) /= 0) else '0';

end behv;

