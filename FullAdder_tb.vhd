--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:57:21 10/09/2019
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/Proyects/FullAdder/FullAdder_tb.vhd
-- Project Name:  FullAdder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FullAdder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types bit and
-- bit_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY FullAdder_tb IS
END FullAdder_tb;
 
ARCHITECTURE behavior OF FullAdder_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FullAdder
    PORT(
         X : IN  bit;
         Y : IN  bit;
         Cin : IN  bit;
         Cout : OUT  bit;
         Sum : OUT  bit
        );
    END COMPONENT;
    

   --Inputs
   signal X : bit := '0';
   signal Y : bit := '0';
   signal Cin : bit := '0';

 	--Outputs
   signal Cout : bit;
   signal Sum : bit;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FullAdder PORT MAP (
          X => X,
          Y => Y,
          Cin => Cin,
          Cout => Cout,
          Sum => Sum
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		x <= '1';
		y <= '0';
		cin<='0';
		wait for 100 ns;	
		x <= '1';
		y <= '1';
		cin<='0';
      wait for 100 ns;
		x <= '1';
		y <= '1';
		cin <= '1';
   end process;
	

END;
