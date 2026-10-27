----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2026 05:10:42 PM
-- Design Name: 
-- Module Name: skew - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity skew is
Port (
clk,rst,en: in std_logic;
input : in std_logic_vector(63 downto 0);
output : out std_logic_vector(63 downto 0)
 );
end skew;

architecture Behavioral of skew is
type grid_t is array (0 to 7, 0 to 7) of std_logic_vector(7 downto 0);
signal grid : grid_t := (others => (others=> (others => '0')));
begin

--assign diagonal to output
outputAssign: for i in 0 to 7 generate
    output((i*8)+7 downto i*8)<= grid(i,i);
end generate outputAssign;

process(clk) 
begin
    if rising_edge(clk) then
        if en = '1' then
        if rst = '1' then
        grid <= (others => (others=> (others => '0'))); --reset grid
        else 
            for i in 0 to 7 loop --load new input
                grid(i,0) <= input((i*8)+7 downto i*8);
            end loop;
            for i in 1 to 7 loop --shift register
             for j in 1 to 7 loop
                grid(i,j) <= grid(i,j-1);
             end loop;
            end loop;
        end if;
        end if;
    end if;
end process;
end Behavioral;
