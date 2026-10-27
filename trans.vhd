----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2026 07:59:07 PM
-- Design Name: 
-- Module Name: trans - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity trans is
Port (
    clk, rst, start, wren : in std_logic;
  wren_out,started_out : out std_logic;
    wr_addr, wr_data : in std_logic_vector(7 downto 0);
    output : out std_logic_vector(63 downto 0)
 );
end trans;

architecture Behavioral of trans is
type bram_t is array (0 to 255) of std_logic_vector(7 downto 0);
signal bram : bram_t := (others =>(others =>'0'));
attribute ram_style : string;
attribute ram_style of bram : signal is "block";
signal rd_addr : unsigned(7 downto 0) := (others => '0');
signal rd_data : std_logic_vector(7 downto 0);

type state_t is (IDLE, FETCH0, FETCH1, FETCH2, FETCH3, FETCH4);
signal state : state_t :=IDLE;
signal addr_count : unsigned(7 downto 0) := (others => '0');
signal p0,p1,p2,p3 : std_logic_vector(7 downto 0); 

signal wren_count : unsigned(5 downto 0) := (others => '0');
signal started : std_logic := '0';

begin
started_out<=started;
process(clk) begin
if(rising_edge(clk)) then


    if rst = '1' then
     started <= '0';
     wren_out<= '0';
    elsif started = '0' then
        if start = '1' and started = '0' then
         started <= '1';
        end if;
     elsif started = '1' and wren_count < 45 then
        wren_count <= wren_count +1;
     else
        wren_out <='1';
        end if;
    end if;

end process;

process(clk) begin
if(rising_edge(clk)) then
    if wren = '1' then
        bram(TO_INTEGER(unsigned(wr_addr))) <= wr_data;
    end if;
    rd_data <=bram(TO_INTEGER(rd_addr));
end if;
end process;





process(clk) begin
    if rising_edge(clk) then
        if rst = '1' then
     
        state <= IDLE;
        addr_count<= (others=> '0');
        rd_addr      <= (others => '0');
                output       <= (others => '0');
                p0 <= (others => '0');
                p1 <= (others => '0');
                p2 <= (others => '0');
                p3 <= (others => '0');
            else
                case state is

                    when IDLE =>
                        if start = '1' then
                            addr_count <= (others => '0');
                            rd_addr     <= (others => '0');  
                            state        <= FETCH0;
                        end if;

                    when FETCH0 => --data hasnt arrived yet
                    
                       
                        rd_addr  <= addr_count + 1;         
                        state    <= FETCH1;

                    when FETCH1 =>-- p0 arrives ram is finding +1
                     
                        p0       <= rd_data;
                        rd_addr  <= addr_count +16;        
                        state    <= FETCH2;

                    when FETCH2 => --p1 arrives finding +16
                    
                        p1       <= rd_data;
                        rd_addr  <= addr_count + 17;        
                        state    <= FETCH3;

                    when FETCH3 => --p2arrives finfing +17 
                     
                        p2       <= rd_data;
                        state <=FETCH4 ;
                   
                    when FETCH4 =>
                    
                        output( 7 downto  0) <= p0;
                        output(15 downto  8) <= p1;
                        output(23 downto 16) <= p2;
                        output(31 downto 24) <= rd_data; 
                        output(63 downto 32) <= (others => '0');

                      
                        if addr_count >= 238 then        
                            state <= IDLE;
                        elsif addr_count(3 downto 0) = "1110" then
                            addr_count<= addr_count+2;
                            rd_addr      <= addr_count + 2; 
                            state        <= FETCH0;
                        else
                            addr_count <= addr_count + 1;
                            rd_addr      <= addr_count + 1; 
                            state        <= FETCH0;
                        end if;
                end case;
            end if;
    end if;
end process;




end Behavioral;
