library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity bintobcd is
port(
		data_in : in STD_LOGIC_VECTOR(4 downto 0);
		bcd1 : out STD_LOGIC_VECTOR(3 downto 0);
        bcd2 : out STD_LOGIC_VECTOR(3 downto 0)
    );
end bintobcd;

architecture behavioural of bintobcd is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------
signal temp : unsigned(4 downto 0);
-- add code here

begin
    process(data_in)
    begin
        temp <= unsigned(data_in);
        if (data_in < "01001") then
            bcd1 <= "0000"; -- BCD eenheden
            bcd2 <= data_in(3 downto 0); -- BCD tientallen
        -- Bereken BCD
        else
            bcd1 <= "0001";  
            bcd1 <= std_logic_vector(temp - 10);
        end if;
    end process;

end behavioural;