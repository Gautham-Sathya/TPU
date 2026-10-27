library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity output_buffer is
    Port (
        clk,wren,rst, en      : in  std_logic;  
        data_in  : in  std_logic_vector(63 downto 0);
        data_out : out std_logic_vector(7 downto 0);
        bram_out : out std_logic
        
    );
end output_buffer;

architecture Behavioral of output_buffer is
    type bram_t is array (0 to 224) of std_logic_vector(7 downto 0);
    signal bram0 : bram_t := (others => (others => '0'));
    signal bram1 : bram_t := (others => (others => '0'));
    signal bram2 : bram_t := (others => (others => '0'));
    signal bram3 : bram_t := (others => (others => '0'));
    signal bram4 : bram_t := (others => (others => '0'));
    signal bram5 : bram_t := (others => (others => '0'));
    signal bram6 : bram_t := (others => (others => '0'));
    signal bram7 : bram_t := (others => (others => '0'));
    attribute ram_style : string;
    attribute ram_style of bram0 : signal is "block";
    attribute ram_style of bram1 : signal is "block";
    attribute ram_style of bram2 : signal is "block";
    attribute ram_style of bram3 : signal is "block";
    attribute ram_style of bram4 : signal is "block";
    attribute ram_style of bram5 : signal is "block";
    attribute ram_style of bram6 : signal is "block";
    attribute ram_style of bram7 : signal is "block";
    
signal  rd_addr, wr_addr  :  unsigned(7 downto 0):= (others => '0') ;
signal counter : integer := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1'then
             rd_addr <= (others => '0') ;
             bram_out <= '0';
            else
            if en = '1' then
                    if rd_addr < 225 then
                        data_out <= bram0(to_integer(rd_addr));
                        rd_addr  <= rd_addr + 1;
                    else
                        bram_out <= '1'; 
                    end if;
            end if;--en
            
            
            if wren = '1'  then
                bram0(to_integer(wr_addr)) <= data_in( 7 downto  0);
                bram1(to_integer(wr_addr)) <= data_in(15 downto  8);
                bram2(to_integer(wr_addr)) <= data_in(23 downto 16);
                bram3(to_integer(wr_addr)) <= data_in(31 downto 24);
                bram4(to_integer(wr_addr)) <= data_in(39 downto 32);
                bram5(to_integer(wr_addr)) <= data_in(47 downto 40);
                bram6(to_integer(wr_addr)) <= data_in(55 downto 48);
                bram7(to_integer(wr_addr)) <= data_in(63 downto 56);
                wr_addr<= wr_addr +1;
                end if;
            end if;
         end if;
    end process;

    

end Behavioral;