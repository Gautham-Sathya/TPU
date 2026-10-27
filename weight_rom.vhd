----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2026 05:09:50 PM
-- Design Name: 
-- Module Name: weight_rom - Behavioral
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity weight_rom is
Port ( 
clk: in  STD_LOGIC;
data_out: out STD_LOGIC_VECTOR(511 downto 0)
);
end weight_rom;

architecture Behavioral of weight_rom is
type matrix is array(0 to 7, 0 to 7) of integer range 0 to 255;
constant sample : matrix := (
        (15, 15, 15, 15, 15, 15, 15, 15),
        (15, 15, 15, 15, 15, 15, 15, 15),
        (15, 15, 15, 15, 15, 15, 15, 15),
        (15, 15, 15, 15, 15, 15, 15, 15),
        (1, 15, 15, 15, 15, 15, 15, 15),
        (0, 15, 15, 15, 15, 15, 15, 15),
        (0, 15, 15, 15, 15, 15, 15, 15),
        (1, 15, 15, 15, 15, 15, 15, 15)
    );

begin
process(clk)
begin
    if rising_edge(clk) then
        for i in 0 to 7 loop
            for j in 0 to 7 loop
                data_out(((i*8+j)*8)+7 downto (i*8+j)*8) <=std_logic_vector(to_unsigned(sample(i,j), 8)); 
            end loop;
        end loop;
    end if;
end process;

end Behavioral;
