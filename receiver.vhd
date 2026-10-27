----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2026 07:05:50 PM
-- Design Name: 
-- Module Name: receiver - Behavioral
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
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receiver is
 Port ( 
 addr : out std_logic_vector(7 downto 0);
 charReady, rst,clk: in std_logic
 );
end receiver;
architecture Behavioral of receiver is
signal bram_addr : unsigned(7 downto 0) := (others => '0');
begin
addr <= std_logic_vector(bram_addr);
process(clk) begin
    if rising_edge(clk) then
        if rst = '1' then
            bram_addr <= (others =>'1');
        elsif charReady = '1' then
            if bram_addr = 255 then
                bram_addr<= (others => '1');
            else
            bram_addr <= bram_addr+1;
            end if;
        end if;
        end if;
        end process;


end Behavioral;
