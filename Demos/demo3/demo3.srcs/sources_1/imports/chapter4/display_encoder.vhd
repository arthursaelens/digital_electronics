library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_encoder is
    Port ( data_in : in STD_LOGIC_VECTOR (4 downto 0);
           sign_in : in STD_LOGIC;
           segments_out : out STD_LOGIC_VECTOR (27 downto 0);
           mask_out : out STD_LOGIC_VECTOR (3 downto 0) 
           );
end display_encoder;

architecture Behavioral of display_encoder is

---------------------------------------
-- Do NOT edit file above this line! --
---------------------------------------

    -- Signalen voor BCD output
    signal bcd1, bcd2 : STD_LOGIC_VECTOR(3 downto 0); -- BCD for tens and ones
    signal segments_bcd1, segments_bcd2 : STD_LOGIC_VECTOR(6 downto 0); -- 7-segment outputs for BCD digits
    signal segments_sign : STD_LOGIC_VECTOR(6 downto 0);  -- 7-segment output for sign

    signal sign_bcd : STD_LOGIC_VECTOR(3 downto 0); -- Teken omzetten naar BCD
    signal double_digits : std_logic;

begin      
    -- instantie van bin to bcd
    bintobcd_instance: entity work.bintobcd
    port map(
        data_in => data_in,
        bcd1 => bcd1,
        bcd2 => bcd2
    );
    
    --instantie van bcd to seg voor eenheden
    bcdtoseg_instance1: entity work.bcdtoseg
    port map(
        data_in => bcd2,            -- BCD-invoer voor eenheden
        segments_out => segments_bcd2 -- 7-segment output voor eenheden, juiste positie in segmentenvector
    );
    
    -- Instantie van bcdtoseg voor de tientallen (bcd1)
    bcdtoseg_instance2: entity work.bcdtoseg
    port map(
        data_in => bcd1,            -- BCD-invoer voor tientallen
        segments_out => segments_bcd1 -- 7-segment output voor tientallen
    );
    
    process (sign_in)
    begin
        if sign_in = '1' then
            sign_bcd <= "1111";  -- BCD voor het minteken "-"
        else
            sign_bcd <= "0000";  -- Geen teken
        end if;
    end process;
    
    -- Instantie van bcdtoseg voor het teken (sign_in)
    bcdtoseg_sign_instance: entity work.bcdtoseg
    port map(
        data_in      => sign_bcd,
        segments_out => segments_sign            -- 7-segment output voor teken
    );
    

    -- Berekening van de mask-out bits
    mask_out(3) <= '1'; --altijd aan
    mask_out(0) <= sign_in;
    
    process (data_in)
    begin
        if data_in > "01001" then
            double_digits <= '1';
        else
            double_digits <= '0';
        end if;
    end process;
    
    mask_out(2) <= double_digits;
    mask_out(1) <= '0';
    
    
    -- Combineer alle segment outputs voor 4 displays (27-bits output)
    process (segments_bcd2, segments_bcd1, segments_sign)
    begin
        segments_out <= segments_bcd2 & segments_bcd1 & "-------" & segments_sign;
    end process;

end Behavioral;
