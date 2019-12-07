entity BDCa7Seg is
    Port ( A: in  bit_vector(3 downto 0);
           Seg: out bit_vector(7 downto 0));
end BDCa7Seg;

architecture Behavioral of BDCa7Seg is

type dLUT is array (0 to 15) of bit_vector(7 downto 0);

constant D: dLUT := ("11000000","11111001","10100100","10110000","10011001","10010010","10000010","11111000",
							"10000000","10010000","10001000","10000011","11000110","10100001","10000110","10001110");

signal index: integer range 0 to 15;
begin

index <= to_integer(signed(a));
Seg <= D(index);

end Behavioral;
