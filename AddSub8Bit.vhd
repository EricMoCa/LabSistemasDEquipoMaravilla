-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FullAdder is
	port (X, Y, Cin : in bit; Cout, Sum: out bit);
end FullAdder;

architecture Equations of FullAdder is 
begin
	Sum <= X xor Y xor Cin;
	Cout <= (X and Y) or (X and Cin) or (Y and Cin);
end Equations;

entity SubAdd8 is
    port ( A, B: in  bit_vector (7 downto 0); 
	 Signo : in  bit; 
	 S : out  bit_vector (7 downto 0); 
	 Co: out  bit;
	 OFlow: out bit);
end SubAdd8;

architecture Structure of SubAdd8 is

component FullAdder
	port (X, Y, Cin: in bit; Cout, Sum: out bit);
end component;

signal Bn: bit_vector(7 downto 0);
signal C: bit_vector (7 downto 1);
signal CoInner: bit;
	
	begin
	Bn(0) <= B(0) XOR Signo;
	Bn(1) <= B(1) XOR Signo;
	Bn(2) <= B(2) XOR Signo;
	Bn(3) <= B(3) XOR Signo;
	Bn(4) <= B(4) XOR Signo;
	Bn(5) <= B(5) XOR Signo;
	Bn(6) <= B(6) XOR Signo;
	Bn(7) <= B(7) XOR Signo;

	
	FA0: FullAdder port map (A(0), Bn(0), Signo, C(1), S(0));
	FA1: FullAdder port map (A(1), Bn(1), C(1), C(2), S(1));
	FA2: FullAdder port map (A(2), Bn(2), C(2), C(3), S(2));
	FA3: FullAdder port map (A(3), Bn(3), C(3), C(4), S(3));
	FA4: FullAdder port map (A(4), Bn(4), C(4), C(5), S(4));
	FA5: FullAdder port map (A(5), Bn(5), C(5), C(6), S(5));
	FA6: FullAdder port map (A(6), Bn(6), C(6), C(7), S(6));
	FA7: FullAdder port map (A(7), Bn(7), C(7), CoInner, S(7));
	
	Co <= CoInner;
	OFlow <= CoInner XOR C(7);
	
end Structure;



