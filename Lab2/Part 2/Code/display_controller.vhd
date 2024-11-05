----------------------------------------------------------------------------------
-- Filename : display_driver.vhdl
-- Author : Antonio Alejandro Andara Lara
-- Date : 02-Oct-10-2024
-- Design Name: display driver
-- Description : This file implements a design that can read two 4 bit (hex)
-- characters from a register and show it on a seven segments display
-- Additional Comments:
-- Copyright : University of Alberta, 2024
-- License : CC0 1.0 Universal
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY display_controller IS
	PORT (
		digits : IN STD_LOGIC_VECTOR (3 DOWNTO 0);  -- 4-bit count from FSM
		clock  : IN STD_LOGIC;
		segments : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)  -- To 7-segment display
--		display_select : out STD_LOGIC
	);
END display_controller;

ARCHITECTURE Behavioral OF display_controller IS

	SIGNAL digit : STD_LOGIC_VECTOR (3 DOWNTO 0);  -- 4-bit character to display

BEGIN
	-- Directly assign the digits (no need for alternating displays)
	
	digit <= digits;
--    display_select <= '0';
    
	-- 7-segment decoding logic
	WITH digit SELECT
		segments <= "1111110" WHEN "0000", --0
					"0000110" WHEN "0001", --1
					"1101101" WHEN "0010", --2
					"1001111" WHEN "0011", --3
					"0010111" WHEN "0100", --4
					"1011011" WHEN "0101", --5
					"1111011" WHEN "0110", --6
					"0001110" WHEN "0111", --7
					"1111111" WHEN "1000", --8
					"1011111" WHEN "1001", --9
					"0111111" WHEN "1010", --A
					"1110011" WHEN "1011", --B
					"1111000" WHEN "1100", --C
					"1100111" WHEN "1101", --D
					"1111001" WHEN "1110", --E
					"0111001" WHEN "1111", --F
					"0000000" WHEN OTHERS;  -- Default case
END Behavioral;
