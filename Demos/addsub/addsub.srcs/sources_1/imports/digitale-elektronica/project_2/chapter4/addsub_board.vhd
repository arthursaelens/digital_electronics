library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addsub_board is
    Port ( sw : in STD_LOGIC_VECTOR (8 downto 0);
           led : out STD_LOGIC_VECTOR (5 downto 0)
         );
end addsub_board;

architecture behavioural of addsub_board is

begin

	-- least significant digit
	DUT : entity work.addsub(behavioural)
	generic map ( N => 4)
	port map(
        data_a => sw(7 downto 4),
        data_b => sw(3 downto 0),
        operation => sw(8),
        data_out => led(4 downto 0),
        sign_out => led(5)
        );

end behavioural;
