library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity addsub_display is
    Port ( sw : in STD_LOGIC_VECTOR (8 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           clk : in STD_LOGIC;
           btnC: in STD_LOGIC  
           );
end addsub_display;

architecture Behavioral of addsub_display is

signal addsub_result : std_logic_vector(4 downto 0);
signal addsub_sign : std_logic;
signal segments   : std_logic_vector(27 downto 0);
signal mask       : std_logic_vector(3 downto 0);

begin    

     
    DUT : entity work.addsub(behavioural)
	generic map ( N => 4)
	port map(
        data_a => sw(7 downto 4),
        data_b => sw(3 downto 0),
        operation => sw(8),
        data_out => addsub_result,
        sign_out => addsub_sign
        ); 
     
	-- display_encoder
	ENC : entity work.display_encoder(Behavioral)
	port map(
        data_in       => addsub_result,
        sign_in       => addsub_sign,
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