----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:44:26 10/09/2019 
-- Design Name: 
-- Module Name:    FullAdder - Behavioral 
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
use IEEE.numeric_bit.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FullAdder is
	port (X, Y, Cin : in bit; Cout, Sum : out bit);
end FullAdder;

architecture Equations of FullAdder is 
begin 
	Sum <= X xor Y xor Cin after 10 ns;
	Cout <= (X and Y) or (X and Cin) or (Y and Cin) after 10 ns;
end Equations;

entity Adder4 is
    port ( A, B: in  bit_vector (3 downto 0); Ci : in  bit; S : out  bit_vector (3 downto 0); Co: out  bit);
end Adder4;

architecture Structure of Adder4 is
component FullAdder
	port (X, Y, Cin: in bit; Cout, Sum: out bit);
end component;
signal C: bit_vector (3 downto 1);

begin
	FA0: FullAdder port map (A(0), B(0), Ci, C(1), S(0));
	FA1: FullAdder port map (A(1), B(1), C(1), C(2), S(1));
	FA2: FullAdder port map (A(2), B(2), C(2), C(3), S(2));
	FA3: FullAdder port map (A(3), B(3), C(3), Co, S(3));
	
	
end Structure;

