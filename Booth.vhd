----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:31:44 10/23/2019 
-- Design Name: 
-- Module Name:    Booth - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.numeric_Bit.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Booth is
    Port ( A : in  bit_vector(3 downto 0);
           B : in  bit_vector(3 downto 0);
           S : out bit_vector(7 downto 0));
end Booth;

entity FA is
 Port ( A : in bit;
    B : in bit;
    Cin : in bit;
    S : out bit;
    Cout : out bit);
end FA;

architecture gate_level of FA is

begin

 S <= A XOR B XOR Cin ;
 Cout <= (A AND B) OR (Cin AND A) OR (Cin AND B) ;

end gate_level;

entity Add4bit is
Port ( A : in bit_VECTOR (3 downto 0);
B : in bit_VECTOR (3 downto 0);
Cin : in bit;
S : out bit_VECTOR (3 downto 0);
Cout : out bit);
end Add4bit;

architecture Behavioral of Add4bit is

-- Full Adder VHDL Code Component Decalaration
component FA
Port (  A : in bit;
    B : in bit;
    Cin : in bit;
    S : out bit;
    Cout : out bit);
end component;

-- Intermediate Carry declaration
signal c1,c2,c3: bit;

begin

-- Port Mapping Full Adder 4 times
FA1: FA port map( A(0), B(0), Cin, S(0), c1);
FA2: FA port map( A(1), B(1), c1, S(1), c2);
FA3: FA port map( A(2), B(2), c2, S(2), c3);
FA4: FA port map( A(3), B(3), c3, S(3), Cout);

end Behavioral;


architecture architectural of Booth is

component Add4bit
port	(	A, B: in bit_vector(3 downto 0);
			Cin: in bit; 
			S: out bit_vector(3 downto 0);
			Cout: out bit);
end component;

component FA
Port (  A : in bit;
    B : in bit;
    Cin : in bit;
    S : out bit;
    Cout : out bit);
end component;

signal F: bit_vector(2 downto 0);
signal ArrA0: bit_vector(3 downto 0);
signal ArrA1: bit_vector(3 downto 0);
signal ArrA2: bit_vector(3 downto 0);
signal ArrB0: bit_vector(3 downto 0);
signal ArrB1: bit_vector(3 downto 0);
signal ArrB2: bit_vector(3 downto 0);
signal ArrC0: bit_vector(3 downto 0);
signal ArrC1: bit_vector(3 downto 0);
signal ArrC2: bit_vector(3 downto 0);
signal inutil: bit;

begin

ArrA0 <= '1' & (A(3) NAND B(0)) & (A(2) AND B(0)) & (A(1) AND B(0));
ArrB0 <= (A(3) NAND B(1)) & (A(2) AND B(1)) & (A(1) AND B(1)) & (A(0) AND B(1));

ArrA1 <= F(0) & ArrC0(3) & ArrC0(2) & ArrC0(1);
ArrB1 <= (A(3) NAND B(2)) & (A(2) AND B(2)) & (A(1) AND B(2)) & (A(0) AND B(2));

ArrA2 <= F(1) & ArrC1(3) & ArrC1(2) & ArrC1(1);
ArrB2 <= (A(3) AND B(3)) & (A(2) NAND B(3)) & (A(1) NAND B(3)) & (A(0) NAND B(3));

	FA4BIT1:	Add4bit port map (ArrA0, ArrB0,'0', ArrC0, F(0));
	FA4BIT2:	Add4bit port map (ArrA1, ArrB1,'0', ArrC1, F(1));
	FA4BIT3:	Add4bit port map (ArrA2, ArrB2,'0', ArrC2, F(2));
	HA: 		FA port map (F(2), '1', '0', S(7),  inutil);
	
S(0) <= A(0) AND B(0);
S(1) <= ArrC0(0);
S(2) <= ArrC1(0);
S(3) <= ArrC2(0);
S(4) <= ArrC2(1);
S(5) <= ArrC2(2);
S(6) <= ArrC2(3);

end architectural;

