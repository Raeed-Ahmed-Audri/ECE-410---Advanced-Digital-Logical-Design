----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description: CPU LAB 3 - ECE 410 (2023)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
--*********************************************************************************
-- A total of fifteen operations can be performed using 4 select lines of this ALU.
-- The select line codes have been given to you in the lab manual.
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;  -- Added to support arithmetic operations

ENTITY alu16 IS
    PORT ( 
        A         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        B         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
        shift_amt : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        alu_sel   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);  -- Corrected width to 4 bits
        alu_out   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END alu16;

ARCHITECTURE Dataflow OF alu16 IS
BEGIN
    PROCESS (A, B, shift_amt, alu_sel)
    BEGIN
        CASE alu_sel IS
            WHEN "0000" =>  -- Corrected alu_sel codes to 4 bits
                alu_out <= A;  -- Pass A
            WHEN "0001" =>
                alu_out <= B;  -- Pass B
            WHEN "0010" =>
                alu_out <= STD_LOGIC_VECTOR(shift_left(unsigned(A), to_integer(unsigned(shift_amt))));  -- Logical shift left
            WHEN "0011" =>
                alu_out <= STD_LOGIC_VECTOR(shift_right(unsigned(A), to_integer(unsigned(shift_amt))));  -- Logical shift right
            WHEN "0100" =>
                alu_out <= STD_LOGIC_VECTOR(unsigned(A) + unsigned(B));  -- Addition
            WHEN "0101" =>
                alu_out <= STD_LOGIC_VECTOR(unsigned(A) - unsigned(B));  -- Subtraction
            WHEN "0110" =>
                alu_out <= A AND B;  -- Bitwise AND
            WHEN "0111" =>
                alu_out <= A OR B;  -- Bitwise OR
            WHEN "1000" =>
                alu_out <= A XOR B;  -- Bitwise XOR
            WHEN "1001" =>
                alu_out <= NOT A;  -- Bitwise NOT A
            WHEN "1010" =>
                alu_out <= NOT (A AND B);  -- Bitwise NAND
            WHEN "1011" =>
                alu_out <= NOT (A OR B);  -- Bitwise NOR
            WHEN "1100" =>
                alu_out <= NOT (A XOR B);  -- Bitwise XNOR
            WHEN "1101" =>
                alu_out <= STD_LOGIC_VECTOR(resize(unsigned(A) * unsigned(B), 16));  -- Multiplication (lower 16 bits)
            WHEN "1110" =>
                -- Comparison (A == B)
                IF A = B THEN
                    alu_out <= (OTHERS => '1');
                ELSE
                    alu_out <= (OTHERS => '0');
                END IF;
            WHEN "1111" =>
                alu_out <= (OTHERS => '0');  -- Set to zero
            WHEN OTHERS =>
                alu_out <= (OTHERS => '1');
        END CASE;
    END PROCESS;
END Dataflow;