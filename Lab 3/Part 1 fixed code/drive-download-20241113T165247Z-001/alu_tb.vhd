----------------------------------------------------------------------------------
-- Filename : alu.vhdl
-- Author : Antonio Alejandro Andara Lara
-- Date : 31-Oct-2023
-- Design Name: alu_tb
-- Project Name: ECE 410 lab 3 2023
-- Description : testbench for the ALU of the simple CPU design
-- Revision 1.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
-- Copyright : University of Alberta, 2023
-- License : CC0 1.0 Universal
----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu_tb IS
END alu_tb;

ARCHITECTURE sim OF alu_tb IS
    SIGNAL alu_sel   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL A         : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL B         : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL shift_amt : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL alu_out   : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    uut : ENTITY WORK.alu16(Dataflow)
        PORT MAP( alu_sel   => alu_sel,
                  A         => A,
                  B         => B,
                  shift_amt => shift_amt,
                  alu_out   => alu_out
                );

    stim_proc : PROCESS
    BEGIN
        -- Test ALU operations

        -- Pass A
        alu_sel <= "0001";
        A <= x"0064";  -- 100 in decimal
        WAIT FOR 20 ns;

        -- Pass B
        alu_sel <= "0010";
        B <= x"0033";  -- 51 in decimal
        WAIT FOR 20 ns;

        -- Logical shift left
        alu_sel <= "0011";
        A <= x"000F";  -- 15 in decimal
        shift_amt <= "0010"; -- Shift by 2
        WAIT FOR 20 ns;

        -- Logical shift right
        alu_sel <= "0100";
        shift_amt <= "0001"; -- Shift by 1
        WAIT FOR 20 ns;

        -- Addition A + B
        alu_sel <= "0101";
        A <= x"000A";  -- 10 in decimal
        B <= x"0005";  -- 5 in decimal
        WAIT FOR 20 ns;

        -- Subtraction A - B
        alu_sel <= "0110";
        A <= x"0010";  -- 16 in decimal
        B <= x"0008";  -- 8 in decimal
        WAIT FOR 20 ns;

        -- Increment A
        alu_sel <= "0111";
        A <= x"000A";  -- 10 in decimal
        WAIT FOR 20 ns;

        -- Decrement A
        alu_sel <= "1000";
        WAIT FOR 20 ns;

        -- AND operation
        alu_sel <= "1001";
        A <= x"00FF";
        B <= x"0F0F";
        WAIT FOR 20 ns;

        -- OR operation
        alu_sel <= "1010";
        WAIT FOR 20 ns;

        -- NOT A
        alu_sel <= "1011";
        WAIT FOR 20 ns;

        -- NOT B
        alu_sel <= "1100";
        WAIT FOR 20 ns;

        -- Set alu_out to 1
        alu_sel <= "1101";
        WAIT FOR 20 ns;

        -- Set alu_out to 0
        alu_sel <= "1110";
        WAIT FOR 20 ns;

        -- Set alu_out to all 1s
        alu_sel <= "1111";
        WAIT FOR 20 ns;

        WAIT; -- End the simulation
    END PROCESS stim_proc;

END sim;
