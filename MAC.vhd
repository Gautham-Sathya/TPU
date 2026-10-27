----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2026 08:04:59 PM
-- Design Name: 
-- Module Name: MAC - Behavioral
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

entity MAC is
 Port (
 clk, rst, ld, en : in std_logic;
 input_sum  : in std_logic_vector (15 downto 0);
 input_val : in std_logic_vector (7 downto 0);
 out_val: out std_logic_vector (7 downto 0);
 out_sum: out std_logic_vector (15 downto 0);
 in_weight : in std_logic_vector(7 downto 0)
  );
end MAC;

architecture Behavioral of MAC is
signal weight_reg, val_reg : signed(7 downto 0) :=(others => '0');
signal sum_reg : signed(15 downto 0) :=(others => '0');
attribute USE_DSP : string;
    attribute USE_DSP of Behavioral : architecture is "yes";
begin
out_sum<= std_logic_vector(sum_reg);
val_reg <= signed(input_val);
process(clk) begin
    if rising_edge(clk) then
        if en = '1' then
                if rst = '1' then
                   weight_reg <= (others => '0');
                    sum_reg <= (others => '0');
                 else
                         if ld = '1' then
                         weight_reg <=signed(in_weight);
                         end if;
                sum_reg<= signed(input_sum)+(weight_reg*val_reg);
                out_val <= input_val;
       end if;--else
    end if; 
    end if;--clk edge

end process;

end Behavioral;
