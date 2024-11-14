library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcdtoseg is
    port ( 
      data_in : in STD_LOGIC_VECTOR ( 3 downto 0 );
      segments_out : out STD_LOGIC_VECTOR ( 6 downto 0 )
    );
end bcdtoseg;

architecture waarheidstabel of bcdtoseg is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------

-- add code here

begin

process(data_in)
    begin
        case data_in is
        when "0000" => segments_out <= "0111111";
        when "0001" => segments_out <= "0110000";
        when "0010" => segments_out <= "1011011";
        when "0011" => segments_out <= "1111001";
        when "0100" => segments_out <= "1110100";
        when "0101" => segments_out <= "1101101";
        when "0110" => segments_out <= "1101111";
        when "0111" => segments_out <= "0111000";
        when "1000" => segments_out <= "1111111";
        when "1001" => segments_out <= "1111101";
        when "1111" => segments_out <= "1000000";
        when others => segments_out <= "-------";
        
        end case;
    end process;


end waarheidstabel;
