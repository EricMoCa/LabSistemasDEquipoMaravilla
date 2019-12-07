library IEEE;
use IEEE.numeric_bit.all;
entity BinToBCD is
    Port ( Bin : in  bit_vector (11 downto 0);
           Unid : out  bit_vector (3 downto 0);
           Dec : out  bit_vector (3 downto 0);
           Cen : out  bit_vector (3 downto 0);
           Mil : out  bit_vector (3 downto 0)
          );
end BinToBCD;
architecture Behavior of BinToBCD is
begin
bcd1: process(Bin)
  variable temp : UNSIGNED(11 downto 0);
  variable bcd : UNSIGNED(15 downto 0) := (others => '0');  
  begin
    bcd := (others => '0');
    temp(11 downto 0) := unsigned(Bin);
    for i in 0 to 11 loop
      if bcd(3 downto 0) > 4 then 
        bcd(3 downto 0) := bcd(3 downto 0) + 3;
      end if;
      if bcd(7 downto 4) > 4 then 
        bcd(7 downto 4) := bcd(7 downto 4) + 3;
      end if;
      if bcd(11 downto 8) > 4 then  
        bcd(11 downto 8) := bcd(11 downto 8) + 3;
      end if;
      bcd := bcd(14 downto 0) & temp(11);
      temp := temp(10 downto 0) & '0';
    end loop;
    Unid <= bit_vector(bcd(3 downto 0));
    Dec <= bit_vector(bcd(7 downto 4));
    Cen <= bit_vector(bcd(11 downto 8));
    Mil <= bit_vector(bcd(15 downto 12));
  end process bcd1;            
end Behavior;
