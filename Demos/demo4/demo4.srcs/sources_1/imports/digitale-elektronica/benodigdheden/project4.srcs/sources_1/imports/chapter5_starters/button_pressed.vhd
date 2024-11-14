library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment lines below if you need arithmetic operations
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.NUMERIC_STD.ALL;

entity button_pressed is
port ( 
    clk        : in  STD_LOGIC;
    reset      : in  STD_LOGIC;
    button_in  : in  STD_LOGIC;
    button_out : out STD_LOGIC
);
end button_pressed;

architecture behavioural of button_pressed is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------

    -- Signals for interconnection between components
    signal btn_sync_1       : std_logic;   -- eerste stap synchronizatie
    signal btn_sync         : STD_LOGIC;   -- stap 2 Synchronized button input
    signal cnt_up           : STD_LOGIC;   -- Control signal to increment counter
    signal cnt_down         : STD_LOGIC;   -- Control signal to decrement counter
    signal overflow         : STD_LOGIC;   -- Overflow signal from sticky_counter
    signal underflow        : STD_LOGIC;   -- Underflow signal from sticky_counter
    signal btn_pressed      : STD_LOGIC;   -- Debounced output from controller to button_out

    -- Signal for the counter's state if needed in minmax logic
    signal counter_state    : STD_LOGIC_VECTOR(3 downto 0); -- 4-bit counter output !!!!!!!!!!!!!!!!! change for 8 bit counter

begin
    -- Synchronization process for button input to prevent glitches
    SYNC_PROC : process(clk, reset)
    begin
        if reset = '1' then
            btn_sync_1 <= '0';
            btn_sync   <= '0';
        elsif rising_edge(clk) then
            btn_sync_1 <= button_in; -- First stage of synchronization
            btn_sync   <= btn_sync_1; -- finaal synchronizedd signal
        end if;
    end process;

    -- MinMax Process to detect overflow and underflow conditions
    process(counter_state)
    begin
        if counter_state = "1111" then --!!!!8
            overflow <= '1';
        else
            overflow <= '0';
        end if;

        if counter_state = "0000" then --!!!!8
            underflow <= '1';
        else
            underflow <= '0';
        end if;
    end process;

    -- Debounce Controller instance
    debounce_controller_inst : entity work.debounce_control
        port map (
            clk         => clk,
            reset       => reset,
            btn_in      => btn_sync,       -- Synchronized button input
            overflow    => overflow,       -- Overflow from sticky_counter
            underflow   => underflow,      -- Underflow from sticky_counter
            cnt_up      => cnt_up,         -- Control signal for counter increment
            cnt_dwn     => cnt_down,       -- Control signal for counter decrement
            btn_pressed => btn_pressed     -- Debounced button press signal
        );

    -- Sticky Counter instance
    sticky_counter_inst : entity work.sticky_counter
        generic map (
            N => 4 --!!!!!change to 8
        )
        port map (
            clk         => clk,
            reset       => reset,
            cnt_up      => cnt_up,         -- Increment control from controller
            cnt_dwn     => cnt_down,       -- Decrement control from controller
            data_out    => counter_state   -- Current state for minmax check
        );

    -- Synchronous output assignment
    button_out <= btn_pressed;


end behavioural;
