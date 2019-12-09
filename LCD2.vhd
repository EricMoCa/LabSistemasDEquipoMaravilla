library IEEE;
use IEEE.numeric_bit.ALL;
-- Uncomment the following library declaration if using -- arithmetic functions with Signed or Unsigned values --use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating -- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity Debouncer is
port (Q, clk: in bit;
Qout: out bit);
end Debouncer;
architecture Behavioral of Debouncer is signal Qb: bit;
begin
process (clk) begin
if clk'event and clk = '1' then Qb <= Q;
Qout <= Qb; end if;
end process;