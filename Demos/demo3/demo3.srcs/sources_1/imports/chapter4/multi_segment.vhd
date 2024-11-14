
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity multi_segment is
    Port ( sw : in STD_LOGIC_VECTOR (5 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           clk : in STD_LOGIC;
           btnC: in STD_LOGIC  
           );
end multi_segment;

architecture Behavioral of multi_segment is

signal segments   : std_logic_vector(27 downto 0);
signal mask       : std_logic_vector(3 downto 0);

begin      
	-- display_encoder
	DUT : entity work.display_encoder(Behavioral)
	port map(
        data_in       => sw(4 downto 0),
        sign_in       => sw(5),
        segments_out  => segments,
        mask_out      => mask
        );

        -- multiple display driver
        DRV : entity work.multiple_display_driver(behavioural)
	port map(
         seg_in   => segments,
         mask_in  => mask,
         clk      => clk,
         reset    => BtnC,
         an_out   => an,
         seg_out  => seg
        );
    
end Behavioral;