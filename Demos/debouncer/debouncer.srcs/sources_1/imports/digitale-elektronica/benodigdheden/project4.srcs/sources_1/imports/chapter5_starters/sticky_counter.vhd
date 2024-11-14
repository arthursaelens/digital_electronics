library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment lines below if you need arithmetic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sticky_counter is
generic ( N : integer);
port(
    clk       : in  STD_LOGIC;
    reset     : in  STD_LOGIC;
    cnt_up    : in  STD_LOGIC;
    cnt_dwn   : in  STD_LOGIC;
    data_out  : out STD_LOGIC_VECTOR (N-1 downto 0)
);
end sticky_counter;

architecture Behavioral of sticky_counter is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------
    signal counter : unsigned(N-1 downto 0); -- Geen initialisatiewaarde
begin
    process(clk, reset)

    begin
        if (reset = '1') then
            counter <= to_unsigned(0, N);
        elsif (rising_edge(clk)) then
            if (cnt_up = '1') then
                if (counter < to_unsigned(2**(N)-1, N)) then
                    counter <= counter + 1;
                end if;
            elsif cnt_dwn = '1'  then
                if counter > to_unsigned(0, N) then
                    counter <= counter - 1;
                end if;
            end if;
        end if;
    end process;

    data_out <= std_logic_vector(counter);
end Behavioral;
