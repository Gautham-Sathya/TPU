----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/10/2026 04:31:19 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
 Port ( 
 clk, btn_rst,btn_start,btn_ld, send_btn  : std_logic;
    seg : out std_logic_vector(6 downto 0);
    TXD      : in std_logic;
    CTS,dig,RTS,RXD          : out std_logic


 );
end top;

architecture Behavioral of top is
component trans is
        Port (
            clk, rst, start, wren : in std_logic;
             wren_out,started_out : out std_logic;
            wr_addr, wr_data      : in std_logic_vector(7 downto 0);
            output                : out std_logic_vector(63 downto 0)
        );
    end component;

    component clock_divider_start is
        Port(
            clk, rst, start : in std_logic;
            div             : out std_logic
        );
    end component;
    
component sseg is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
       bram,uart,load,arr : in std_logic;
        seg   : out std_logic_vector(6 downto 0)
    );
end component;
    component output_buffer is
    Port (
             clk,wren,rst, en      : in  std_logic;  
             bram_out : out std_logic;
        data_in  : in  std_logic_vector(63 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    
    );
    end component;
   component weight_rom is
Port ( 
clk: in  STD_LOGIC;
data_out: out STD_LOGIC_VECTOR(511 downto 0)
);
end component;

component receiver is
 Port ( 
 addr : out std_logic_vector(7 downto 0);
 charReady, rst,clk: in std_logic
 );
 end component;
 
component clock_div is
	port (
	   clk : in std_logic;
	   div : out std_logic);
end component;

component sender is
    port (
        clk, rst, en, btn, ready : in std_logic;
        send,send_out,done,read : out std_logic;
        char : out std_logic_vector(7 downto 0);
         char_in  : in  std_logic_vector(7 downto 0)
    );
end component;

component uart is
    port (
    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)
);
end component;

    component skew is
        Port (
            clk, rst, en : in std_logic;
            input        : in std_logic_vector(63 downto 0);
            output       : out std_logic_vector(63 downto 0)
        );
    end component;

component debounce is
        port (
            btn, clk : in  std_logic;
            dbnc : out std_logic
             );
    end component;
    component sysarray is
        Port (
            clk, rst, en, load : in std_logic;
            weights_input      : in std_logic_vector(511 downto 0);
            val_in             : in std_logic_vector(63 downto 0);
            val_out            : out std_logic_vector(63 downto 0);
            sum_out            : out std_logic_vector(127 downto 0)
        );
    end component;

    component rescaler is
        Port (
            clk, rst, en : in std_logic;
            insums       : in std_logic_vector(127 downto 0);
            outsums      : out std_logic_vector(63 downto 0)
        );
    end component;
    signal skew_input: STD_LOGIC_VECTOR(63 downto 0);
    signal sys_input,output: STD_LOGIC_VECTOR(63 downto 0);
    signal sys_out: STD_LOGIC_VECTOR(127 downto 0);
    signal sys_out2: STD_LOGIC_VECTOR(63 downto 0);
    signal weightss: STD_LOGIC_VECTOR(511 downto 0);
    signal wr_addr,charRec, char_in : STD_LOGIC_VECTOR(7 downto 0);
    signal pipeline_en, CR: STD_LOGIC;
    signal started_out,array_out,bram_out,sender_out : std_logic;
    
    signal rst,div,send,send_btnn, rdy0,start,ld,wren_out,read_s : std_logic;
signal char : std_logic_vector(7 downto 0);
    
begin

 wr0:  weight_rom Port map ( 
clk =>clk,
data_out =>weightss
);

deb0: debounce port map(
clk =>  clk,
btn => btn_rst,
dbnc => rst
);
deb1: debounce port map(
clk =>  clk,
btn => btn_start,
dbnc => start
);
deb3: debounce port map(
clk =>  clk,
btn => send_btn,
dbnc => send_btnn
);

   
ss0:  sseg     Port map (
        clk   => clk,
        rst   => rst,
       bram=> bram_out,
       uart=> send_btnn,
       load=> ld,
       arr => started_out,
        seg  => seg
    );
deb2: debounce port map(
clk =>  clk,
btn => btn_ld,
dbnc => ld
);

cd: clock_div port map(
clk =>clk,
div => div
);
snd: sender port map(
clk => clk,
en => div,
ready =>rdy0,
rst =>rst,
char => char,
send => send,
send_out => sender_out,
read => read_s,
 btn => send_btnn,
 char_in => char_in     
);
o0 : output_buffer  Port map (
        clk =>clk,
        wren => wren_out,
        rst =>rst,
        en  =>  read_s,  
        data_in => output,
        bram_out => bram_out,
        data_out=> char_in
    );
uart0: uart port map(
clk => clk,
charSend => char,
en => div,
rst => rst,
rx => TXD, --jcp2
send => send,
ready =>rdy0,
tx =>RXD, --jcp1
newChar => CR,
charRec => charRec 
);
CTS<='0';
RTS<='0';


r0: receiver port map ( 
 addr =>wr_addr,
 charReady => CR,
 rst => rst,
 clk =>clk
 );

array_out <= wren_out;
trans0 : trans
    port map(
    clk     => clk,
            rst     => rst,
            start   => start,
            wren    => CR,
            wr_addr => wr_addr,
             wren_out => wren_out,
            wr_data => charRec,
            output  => skew_input,
            started_out => started_out
    );
    div0: clock_divider_start
        port map (
            clk  => clk,
            rst  => rst,
            start=> start,
            div  => pipeline_en
        );

skew0: skew
        port map(
            clk   => clk,
            rst   => rst,
            en    => pipeline_en,  
            input => skew_input,    
            output => sys_input
        );
    sys0: sysarray
        port map (
            clk           => clk,
            rst           => rst,
            en            => pipeline_en, 
            load          => ld,
            weights_input => weightss,
            val_in        => sys_input,
            val_out       => sys_out2, 
            sum_out       => sys_out
        );
dig<='1';
    rescaler0: rescaler
        port map (
            clk     => clk,
            rst     => rst,
            en      => pipeline_en,
            insums  => sys_out,
            outsums => output
        );

end Behavioral;
