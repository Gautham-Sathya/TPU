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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rescaler is
 Port (
 clk,rst,en :in std_logic; 
 insums : in std_logic_vector(127 downto 0);
 outsums : out std_logic_vector(63 downto 0)
  );
end rescaler;

architecture Behavioral of rescaler is

begin


process(clk)
    variable val: signed(15 downto 0);
        begin
        if(rising_edge(clk)) then
        if en = '1' then
           if rst = '1' then
           outsums<= (others =>'0');
           else
           
            for i in 0 to 7 loop
                val:= signed(insums((i*16)+15 downto (i*16))); -- 16 bits for each column output
                
                if val< 0 then
                    val := (others => '0'); --ReLU
                end if;
                    
                 val := shift_right(val, 4); --scale by 1/16
                 if val >255 then
                 outsums((i*8)+7 downto i*8) <= "11111111"; --cap to 8 bits (12 bits rn)
                 else
                 outsums((i*8)+7 downto i*8) <= std_logic_vector(val(7 downto 0)); --8 bits 
                 end if;
            end loop;
           end if;--rst
           end if;
        end if;--posedge
        end process;
end Behavioral;
