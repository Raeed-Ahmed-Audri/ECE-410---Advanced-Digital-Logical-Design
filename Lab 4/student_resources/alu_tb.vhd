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

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu_tb IS
END alu_tb;

ARCHITECTURE sim OF alu_tb IS
    -- Signal Declarations
    SIGNAL alu_sel   : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";  -- Changed to 4 bits
    SIGNAL input_a   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL input_b   : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL shift_amt : STD_LOGIC_VECTOR(3 DOWNTO 0)  := "0000";  -- Changed to 4 bits
    SIGNAL alu_out   : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : ENTITY WORK.alu16(Dataflow)
        PORT MAP(
            A         => input_a,     -- Corrected port mapping
            B         => input_b,
            shift_amt => shift_amt,
            alu_sel   => alu_sel,
            alu_out   => alu_out
        );

    -- Stimulus Process
    stim_proc : PROCESS
    BEGIN
        -- Test Pass A
        alu_sel   <= "0000";
        input_a   <= X"1234";
        input_b   <= X"5678";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"1234")
            REPORT "Test Pass A failed!" SEVERITY ERROR;

        -- Test Pass B
        alu_sel   <= "0001";
        input_a   <= X"1234";
        input_b   <= X"5678";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"5678")
            REPORT "Test Pass B failed!" SEVERITY ERROR;

        -- Test Logical Shift Left
        alu_sel   <= "0010";
        input_a   <= X"0001";
        shift_amt <= "0001";  -- Shift by 1
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0002")
            REPORT "Test Logical Shift Left failed!" SEVERITY ERROR;

        -- Test Logical Shift Right
        alu_sel   <= "0011";
        input_a   <= X"0002";
        shift_amt <= "0001";  -- Shift by 1
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0001")
            REPORT "Test Logical Shift Right failed!" SEVERITY ERROR;

        -- Test Addition
        alu_sel   <= "0100";
        input_a   <= X"0003";
        input_b   <= X"0004";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0007")
            REPORT "Test Addition failed!" SEVERITY ERROR;

        -- Test Subtraction
        alu_sel   <= "0101";
        input_a   <= X"0007";
        input_b   <= X"0003";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0004")
            REPORT "Test Subtraction failed!" SEVERITY ERROR;

        -- Test Bitwise AND
        alu_sel   <= "0110";
        input_a   <= X"00FF";
        input_b   <= X"0F0F";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"000F")
            REPORT "Test Bitwise AND failed!" SEVERITY ERROR;

        -- Test Bitwise OR
        alu_sel   <= "0111";
        input_a   <= X"00F0";
        input_b   <= X"000F";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"00FF")
            REPORT "Test Bitwise OR failed!" SEVERITY ERROR;

        -- Test Bitwise XOR
        alu_sel   <= "1000";
        input_a   <= X"00FF";
        input_b   <= X"0F0F";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0FF0")
            REPORT "Test Bitwise XOR failed!" SEVERITY ERROR;

        -- Test Bitwise NOT A
        alu_sel   <= "1001";
        input_a   <= X"FFFF";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0000")
            REPORT "Test Bitwise NOT A failed!" SEVERITY ERROR;

        -- Test Bitwise NAND
        alu_sel   <= "1010";
        input_a   <= X"FFFF";
        input_b   <= X"FFFF";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0000")
            REPORT "Test Bitwise NAND failed!" SEVERITY ERROR;

        -- Test Bitwise NOR
        alu_sel   <= "1011";
        input_a   <= X"FFFF";
        input_b   <= X"0000";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0000")
            REPORT "Test Bitwise NOR failed!" SEVERITY ERROR;

        -- Test Bitwise XNOR
        alu_sel   <= "1100";
        input_a   <= X"FFFF";
        input_b   <= X"0000";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0000")
            REPORT "Test Bitwise XNOR failed!" SEVERITY ERROR;

        -- Test Multiplication (lower 16 bits)
        alu_sel   <= "1101";
        input_a   <= X"0002";
        input_b   <= X"0003";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0006")
            REPORT "Test Multiplication failed!" SEVERITY ERROR;

        -- Test Comparison (A == B)
        alu_sel   <= "1110";
        input_a   <= X"1234";
        input_b   <= X"1234";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"FFFF")
            REPORT "Test Comparison Equal failed!" SEVERITY ERROR;

        input_b   <= X"5678";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0000")
            REPORT "Test Comparison Not Equal failed!" SEVERITY ERROR;

        -- Test Set to Zero
        alu_sel   <= "1111";
        WAIT FOR 20 ns;
        ASSERT (alu_out = X"0000")
            REPORT "Test Set to Zero failed!" SEVERITY ERROR;

        WAIT;
    END PROCESS stim_proc;
END sim;
