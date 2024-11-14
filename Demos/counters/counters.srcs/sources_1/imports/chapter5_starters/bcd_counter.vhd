library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Uncomment lines below if you need arithmetic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcd_counter is
port ( 
    clk       : in  STD_LOGIC;
    reset     : in  STD_LOGIC;
    cnt_up    : in  STD_LOGIC;
    cnt_dwn   : in  STD_LOGIC;
    data_out  : out STD_LOGIC_VECTOR (3 downto 0)
);
end bcd_counter;

architecture behavioural of bcd_counter is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------

signal counter : unsigned(3 downto 0);
begin
    process(clk, reset)
    begin
        if (reset = '1') then   --als reset 1 is teller op 0
             counter <= TO_UNSIGNED(0,4);
        elsif (rising_edge(clk)) then
            if (cnt_up = '1') then -- omhoog tellen
                if (counter < TO_UNSIGNED(9,4)) then
                    counter <= counter + 1;
                else  -- terug naar 0 als 9 al bereikt is
                    counter <= TO_UNSIGNED(0,4);
                end if;

            elsif (cnt_dwn = '1') then  -- omlaag tellen
                if (counter > TO_UNSIGNED(0,4)) then
                    counter <= counter - 1;
                else  --terug naar 9 als 0 bereikt is
                    counter <= TO_UNSIGNED(9,4);
                end if;
            end if;
        end if;
    end process;

    data_out <= std_logic_vector(counter);
end behavioural;
