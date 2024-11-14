library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity addsub is
    Generic( N : integer );
    Port ( data_a : in STD_LOGIC_VECTOR (N-1 downto 0);
           data_b : in STD_LOGIC_VECTOR (N-1 downto 0);
           operation : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (N downto 0);
           sign_out : out STD_LOGIC);
end addsub;

architecture behavioural of addsub is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------

    signal extended_data_a : std_logic_vector(N downto 0); 
    signal extended_data_b : std_logic_vector(N downto 0);
    signal temp_res : std_logic_vector(N downto 0);
    signal sign_bit : std_logic; -- interne versei van tekenbit

begin

    extended_data_a <= "0" & data_a;
    extended_data_b <= "0" & data_b;
    
    process (extended_data_a, extended_data_b, operation)
    begin
        if operation = '1' then -- optelleennnnn
            temp_res <= std_logic_vector(unsigned(extended_data_a) + unsigned(extended_data_b));
            sign_bit <= '0';
        else ---trek 1 af van 0
            if extended_data_a >= extended_data_b then
                temp_res <= std_logic_vector(unsigned(extended_data_a) - unsigned(extended_data_b));
                sign_bit <= '0';
            else 
                temp_res <= std_logic_vector(unsigned(extended_data_b) - unsigned(extended_data_a));
                sign_bit <= '1';
            end if;
        end if;
    end process;
    
    data_out <= temp_res;
    sign_out <= sign_bit;
            

end behavioural;