----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2026 11:31:26 PM
-- Design Name: 
-- Module Name: sseg - Behavioral
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

entity sseg is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
       bram,uart,load,arr : in std_logic;
        seg   : out std_logic_vector(6 downto 0)
    );
end sseg;

architecture Behavioral of sseg is

    constant o : std_logic_vector(6 downto 0) := "0111111"; -- o
    constant b     : std_logic_vector(6 downto 0) := "0111111"; -- b
    constant u     : std_logic_vector(6 downto 0) := "0111110"; -- u
    constant L     : std_logic_vector(6 downto 0) := "0111000"; -- l
    constant a     : std_logic_vector(6 downto 0) := "1101101"; -- s

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                seg <= O;
            else
                if uart = '1' then seg <=u;
                elsif load = '1' then seg <=L;
                elsif arr = '1' then seg <=a;
                elsif bram = '1' then seg <=b;
                else  seg <=o;
                end if;
            end if;
        end if;
    end process;

end Behavioral;