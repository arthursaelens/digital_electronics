library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment lines below if you need arithmetic operations
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- use IEEE.NUMERIC_STD.ALL;


entity debounce_control is
port(
  clk          : in std_logic;
  reset        : in std_logic;
  btn_in       : in std_logic;
  overflow     : in std_logic;
  underflow    : in std_logic;
  cnt_up       : out std_logic;
  cnt_dwn      : out std_logic;
  btn_pressed  : out std_logic
);
end debounce_control;

architecture Behavioral of debounce_control is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------

  -- Define states
  type state_type is (
    S0,  -- neutraal
    S1,  -- optellen
    S2,  -- overflowed
    S3,  -- aftellen
    S4   -- underflowed
  );
  signal state, next_state : state_type;

begin

  --register
  process(clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state <= S0;  -- Initialize to S0: neutraal
      else
        state <= next_state;  -- Move to the next state
      end if;
    end if;
  end process;

  --toestandsfunctie
  process(state, btn_in, overflow, underflow)
  begin
    -- Default transition: remain in the current state if no transition is specified
    next_state <= state;

    case state is
      when S0 =>  -- Neutral state
        if btn_in = '1' then
          next_state <= S1;  -- Move to count up state
        end if;

      when S1 =>  -- Counting up state
        if overflow = '1' then
          next_state <= S2;  -- Move to overflow detected state
        elsif btn_in = '0' then
          next_state <= S0;  -- Return to neutral if button is released
        end if;

      when S2 =>  -- Overflowed state
        if btn_in = '0' then
          next_state <= S3;  -- Move to count down state
        end if;

      when S3 =>  -- Counting down state
        if underflow = '1' then
          next_state <= S4;  -- Move to underflow detected state
        elsif btn_in = '1' then
          next_state <= S0;  -- Return to neutral if button is pressed again
        end if;

      when S4 =>  -- Underflow detected state
        next_state <= S0;  -- Automatically return to neutral after one clock cycle
    end case;
  end process;


  process(state)
  begin
    case state is
      when S0 =>
        -- Neutral state: no outputs active
        cnt_up      <= '0';
        cnt_dwn     <= '0';
        btn_pressed <= '0';

      when S1 =>
        -- Counting up
        cnt_up      <= '1';
        cnt_dwn     <= '0';
        btn_pressed <= '0';

      when S2 =>
        -- Overflow detected
        cnt_up      <= '0';
        cnt_dwn     <= '0';
        btn_pressed <= '0';

      when S3 =>
        -- Counting down
        cnt_up      <= '0';
        cnt_dwn     <= '1';
        btn_pressed <= '0';

      when S4 =>
        -- Underflow detected: trigger btn_pressed for one clock cycle
        cnt_up      <= '0';
        cnt_dwn     <= '0';
        btn_pressed <= '1';
        
      when others =>
        -- Default output values
        cnt_up      <= '0';
        cnt_dwn     <= '0';
        btn_pressed <= '0';
    end case;
  end process;

end Behavioral;
