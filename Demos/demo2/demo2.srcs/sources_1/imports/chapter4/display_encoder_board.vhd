library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity display_encoder_board is
    Port ( sw : in STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0) 
           );
end display_encoder_board;

architecture Behavioral of display_encoder_board is

signal segments   : std_logic_vector(27 downto 0);
signal mask       : std_logic_vector(3 downto 0);

begin      
	-- least significant digit
	DUT : entity work.display_encoder(Behavioral)
	port map(
        data_in       => sw(4 downto 0),
        sign_in       => sw(5),
        segments_out  => segments,
        mask_out      => mask
        );

    process(sw(7 downto 6), mask, segments)
    begin
        case sw(7 downto 6) is
            when "00" => 
                seg <= not(segments(27 downto 21));
                an <= not(mask and "1000");
            when "01" => 
                seg <= not(segments(20 downto 14));
                an <= not(mask and "0100");
            when "10" => 
                seg <= not(segments(13 downto 7));
                an <= not(mask and "0010");
            when "11" => 
                seg <= not(segments(6 downto 0));
                an <= not(mask and "0001");
            when others =>
                seg <= "-------";
                an <= "----";
        end case;
    end process;
end Behavioral;