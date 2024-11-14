library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.std_logic_unsigned.all;

entity multiple_display_driver is
port(
    seg_in       : in  STD_LOGIC_VECTOR(27 downto 0);
    mask_in      : in  STD_LOGIC_VECTOR(3 downto 0);
    clk          : in  STD_LOGIC;
    reset        : in  STD_LOGIC;
    an_out       : out STD_LOGIC_VECTOR(3 downto 0);
    seg_out      : out STD_LOGIC_VECTOR(6 downto 0)
);
end multiple_display_driver;

architecture behavioural of multiple_display_driver is
    signal data_selector : std_logic_vector(15 downto 0);
    signal data_internal : std_logic_vector(6 downto 0);
    signal internal_display_mask : std_logic_vector(3 downto 0);
    signal internal_display_selector: std_logic_vector(3 downto 0);
begin

-- make sure none of the signals is active during reset
process(reset, mask_in)
begin
    if (reset = '1') then
        internal_display_mask <= "0000";
    else
        internal_display_mask <= mask_in;
    end if;
end process;

-- the display mask indicates which displays should be active with a 1
-- however: the anode signal needs to be 0 to be active, so we need to 
--   invert the mask

-- this process makes sure we do not switch displays every cycle, since that 
-- would be too fast with a clock of 100 MHz.
selector: process(clk, reset)
begin
    if (reset = '1') then
        data_selector <= "0000000000000000";
    elsif rising_edge(clk) then    
        if (data_selector="1111111111111111") then
            data_selector <= "0000000000000000";
        else
            data_selector <= data_selector + "0000000000000001";
        end if;
    end if; 
end process;

sw_multiplexer: process(data_selector(15 downto 14), seg_in) 
begin
    case data_selector(15 downto 14) is
        when "00" => 
            data_internal <= seg_in(6 downto 0);
            internal_display_selector <= "0001";
        when "01" => 
            data_internal <= seg_in(13 downto 7);
            internal_display_selector <= "0010";
        when "10" => 
            data_internal <= seg_in(20 downto 14);
            internal_display_selector <= "0100";
        when "11" => 
            data_internal <= seg_in(27 downto 21);
            internal_display_selector <= "1000";
        when others =>
            data_internal <= "-------";
            internal_display_selector <= "----";
    end case;
end process;

an_out <= not(internal_display_mask and internal_display_selector);
seg_out <= not(data_internal);

end behavioural;