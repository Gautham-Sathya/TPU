library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity clock_divider_start is
port(
clk, rst, start : in std_logic;
div : out std_logic
);
end clock_divider_start;

architecture behav of clock_divider_start is 
signal count : unsigned(2 downto 0) := (others => '0');
signal first : std_logic :='1';
begin

process(clk)
begin
    if rising_edge(clk) Then
        if rst = '1' then
            count <=(others => '0');
            first <='1';
            div <='0' ;
        elsif start = '1' and first = '1' then -- first div is 5 cycles for bram 4cycle +  idle     
            first <='0';
            count <=(others => '0');
            div <='0';
        else
                if first = '0' then
                    if count = 3 then 
                    div <='1';
                    count<= "000";
                    else 
                    div <='0';
                    count<= count + 1;
                    end if;
                end if;
        end if;
                
    end if;--posedge
end process;--process

end behav;

