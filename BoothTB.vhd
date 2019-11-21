--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:19:41 11/06/2019
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/Proyects/BoothMultiplier/BoothTB.vhd
-- Project Name:  BoothMultiplier
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Booth
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- bit_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.numeric_bit.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY BoothTB IS
END BoothTB;
 
ARCHITECTURE behavior OF BoothTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Booth
    PORT(
         A : IN  bit_vector(3 downto 0);
         B : IN  bit_vector(3 downto 0);
         S : OUT  bit_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal As : bit_vector(3 downto 0) := (others => '0');
   signal Bs : bit_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Ss : bit_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Booth PORT MAP (
          As,
          Bs,
          Ss
        );

--   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 50 ns;	
		As <= "0100";
		Bs <= "0000";
		wait for 50 ns;
		As <= "0010";
		Bs <= "0110";
		wait for 50 ns;
		As <= "0101";
		Bs <= "0010";
		wait for 50 ns;
		As <= "0011";
		Bs <= "0100";
		wait for 50 ns;
		As <= "0100";
		Bs <= "0100";
		wait for 50 ns;
		As <= "1111";
		Bs <= "1111";
      wait;
   end process;
end;
