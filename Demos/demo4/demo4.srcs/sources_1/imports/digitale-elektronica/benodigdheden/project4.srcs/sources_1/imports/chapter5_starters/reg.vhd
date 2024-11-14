library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
generic( N : integer );
port (
    reset    : in STD_LOGIC;
    clk      : in STD_LOGIC;
    enable   : in STD_LOGIC;
    data_in  : in STD_LOGIC_VECTOR(N-1 downto 0);
    data_out : out STD_LOGIC_VECTOR(N-1 downto 0)
);
end reg;

architecture behavioural of reg is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------
constant zeros: std_logic_vector (N - 1 downto 0) := (others => '0');

-- add code here if necessary

begin
    process(clk, reset)
    begin
        if (reset = '1') then
            data_out <= zeros;
        elsif (rising_edge(clk)) then
            if (enable = '1') then
                data_out <= data_in;
            end if;
        end if;
    end process;
end behavioural;
