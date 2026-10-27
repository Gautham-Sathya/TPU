----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2026 12:22:13 AM
-- Design Name: 
-- Module Name: array - Behavioral
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

entity sysarray is
  Port (
  clk,rst,en: in std_logic;
  load : in std_logic;
  weights_input : in std_logic_vector(511 downto 0); -- 64 PU * 8bits
  val_in : in std_logic_vector(63 downto 0); -- 8 per row
 
  val_out : out std_logic_vector(63 downto 0);
  sum_out : out std_logic_vector(127 downto 0)
   );
end sysarray;

architecture Behavioral of sysarray is
type val_type is array(0 to 7, 0 to 8) of std_logic_vector(7 downto 0);
type sum_type is array(0 to 8, 0 to 7) of std_logic_vector(15 downto 0);
signal val : val_type;
signal sum : sum_type;
begin
--top and left wires
TL: for i in 0 to 7 generate
val(i,0) <= val_in( (i*8) + 7 downto i*8    ); 
sum(0,i) <= (others => '0');
end generate TL;

-- 8x8
sys: for i in 0 to 7 generate
   sys2: for j in 0 to 7 generate
    
    PU : entity work.MAC
        port map(
        clk => clk,
        en => en,
        rst => rst,
        ld => load,   
 input_sum  => sum(i,j),
 input_val => val(i,j),
 out_val => val(i, j+1),
 out_sum => sum(i+1, j),
 in_weight => weights_input(  ((i*8+j)*8)+7 downto (i*8 + j)*8)  
 ); 
    end generate sys2;
    end generate sys;
--bottom and righy wiret
BR: for i in 0 to 7 generate
val_out( (i*8)+7 downto i*8 )<=  val(i,8);
sum_out (  (i*16)+ 15 downto i*16)<= sum(8,i);
end generate BR;

end Behavioral;
