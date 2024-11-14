

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity button_test_board is
port(
    clk : in std_logic;
    sw  : in std_logic_vector(1 downto 0);
    btnC : in std_logic;
    btnU : in std_logic;
    seg  : out std_logic_vector(6 downto 0);
    an   : out std_logic_vector(3 downto 0)
);
end button_test_board;

architecture Behavioral of button_test_board is

signal btn_pressed : std_logic;
signal en_up, en_dwn :  std_logic;
signal current_val : std_logic_vector(3 downto 0);
signal segments : std_logic_vector(6 downto 0);

begin

   BUTTON : entity work.button_pressed(behavioural)
	port map(
          clk          => clk,
          reset        => btnC, 
          button_in    => btnU,
          button_out   => btn_pressed
        );
        
    en_up <= (btn_pressed and sw(0));    
    en_dwn <= (btn_pressed and sw(1));    
        
    BCDCOUNTER : entity work.bcd_counter(behavioural) -- volgens mij sticky counter
    port map(
          clk       => clk,
          reset     => btnC,
          cnt_up    => en_up,
          cnt_dwn   => en_dwn,
          data_out  => current_val
    );
        
    -- least significant digit
	DECODER : entity work.bcdtoseg(waarheidstabel)
	port map(
        data_in => current_val,  
        segments_out => segments		
        );


 
    seg <= not(segments);
    an <= "0111";
        
end Behavioral;
