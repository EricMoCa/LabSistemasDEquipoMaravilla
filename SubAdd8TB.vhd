--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:47:49 10/16/2019
-- Design Name:   
-- Module Name:   C:/Xilinx/14.7/Proyects/BIT8ADDERSUBTRACTOR/SubAdd8TB.vhd
-- Project Name:  BIT8ADDERSUBTRACTOR
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SubAdd8
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
LIBRARY ieee;
USE ieee.numeric_bit.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SubAdd8TB IS
END SubAdd8TB;
 
ARCHITECTURE behavior OF SubAdd8TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SubAdd8
    PORT(
         A : IN  bit_vector(7 downto 0);
         B : IN  bit_vector(7 downto 0);
         Signo : IN  bit;
         S : OUT  bit_vector(7 downto 0);
         Co : OUT  bit
        );
    END COMPONENT;
    

   --Inputs
   signal A : bit_vector(7 downto 0) := (others => '0');
   signal B : bit_vector(7 downto 0) := (others => '0');
   signal Signo : bit := '0';

 	--Outputs
   signal S : bit_vector(7 downto 0);
   signal Co : bit;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SubAdd8 PORT MAP (
          A => A,
          B => B,
          Signo => Signo,
          S => S,
          Co => Co
        );

   -- Clock process definitions
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 50 ns;	
		A <= "00000001";
		B <= "00000001";
		Signo <= '0';
		wait for 50 ns;	
		A <= "00000100";
		B <= "00000001";
		Signo <= '1';
		wait for 50 ns;	
		A <= "00001000";
		B <= "00000011";
		Signo <= '1';
      wait;
   end process;

END;
