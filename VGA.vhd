library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity VGA is
port(Clk50_in : in std_logic;         
       Red       : out std_logic;         
       Green     : out std_logic;
       Blue     : out std_logic;
       HOut   : out std_logic;         
       VOut   : out std_logic);      
end VGA;
 
architecture Behavioral of VGA is
signal Clk25 : std_logic;
signal Horizontal : std_logic_vector (9 downto 0);
signal Vertical : std_logic_vector (9 downto 0);
constant hPixels: std_logic_vector(9 downto 0) := "1100100000";
Begin
 

Process (Clk50_in)
Begin
	if Clk50_in'event and Clk50_in = '1' then
	if (Clk25 = '0') then              
 
	Clk25 <= '1';
	else
	Clk25 <= '0';
	end if;
	end if;
end Process;

Process (Clk25)
Begin
	if Clk25'event and Clk25 = '1' then
	
	if Horizontal >= "0010010011" and Horizontal <= "0011100101" and Vertical >= "0000000001" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0011100110" and Horizontal <= "0100110111" and Vertical >= "0000000001" and Vertical <= "0001100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0011100110" and Horizontal <= "0100110111" and Vertical >= "0011010101" and Vertical <= "0100100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0011100110" and Horizontal <= "0100110111" and Vertical >= "0110010011" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0100111000" and Horizontal <= "0110001001" and Vertical >= "0000000001" and Vertical <= "0001100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0100111000" and Horizontal <= "0110001001" and Vertical >= "0011010101" and Vertical <= "0100100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0100111000" and Horizontal <= "0110001001" and Vertical >= "0110010011" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0110001010" and Horizontal <= "0110110010" and Vertical >= "0000000001" and Vertical <= "0001100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0110001010" and Horizontal <= "0110110010" and Vertical >= "0011010101" and Vertical <= "0100100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0110001010" and Horizontal <= "0110110010" and Vertical >= "0110010011" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "0110110011" and Horizontal <= "0111011011" and Vertical >= "0000000001" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';	
	Green <= '0';
	elsif Horizontal >= "0111011100" and Horizontal <= "1000000100" and Vertical >= "0000000001" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';	
	Green <= '0';
	elsif Horizontal >= "1000000101" and Horizontal <= "1000101101" and Vertical >= "0000000001" and Vertical <= "0001100100" then
	Red <= '1';
	Blue <= '0';	
	Green <= '0';
	elsif Horizontal >= "1000000101" and Horizontal <= "1000101101" and Vertical >= "0011010101" and Vertical <= "0100100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "1000000101" and Horizontal <= "1000101101" and Vertical >= "0110010011" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "1000101110" and Horizontal <= "1001111111" and Vertical >= "0000000001" and Vertical <= "0001100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "1000101110" and Horizontal <= "1001111111" and Vertical >= "0011010101" and Vertical <= "0100100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "1000101110" and Horizontal <= "1001111111" and Vertical >= "0110010011" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "1010000000" and Horizontal <= "1011010000" and Vertical >= "0000000001" and Vertical <= "0001100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "1010000000" and Horizontal <= "1011010000" and Vertical >= "0011010101" and Vertical <= "0100100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "1010000000" and Horizontal <= "1011010000" and Vertical >= "0110010011" and Vertical <= "0111100100" then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	elsif Horizontal >= "1011010001" and Horizontal <= "1100100000" and Vertical >= "0000000001" and Vertical <= "0111100100" 
	then
	Red <= '1';
	Blue <= '0';
	Green <= '0';
	else 
	Red <= '0';
	Blue <= '1';
	Green <= '1';
	end if;
	if (Horizontal > "0000000000") and (Horizontal < "0001100001") then
	HOut <= '0';
	else
	HOut <= '1';
	end if;

	if (Vertical > "0000000000") and (Vertical < "0000000011")then
	VOut <= '0';
	else
	VOut <= '1';
	end if;

	Horizontal <= Horizontal + "0000000001" ;

	if (Horizontal= "1100100000") then    
	Vertical <= Vertical + "0000000001";       
	Horizontal <= "0000000000";
	end if;
	if (Vertical= "1000001001") then                 
	Vertical <= "0000000000";
	end if;
	end if;
	
	end process;
end Behavioral;


