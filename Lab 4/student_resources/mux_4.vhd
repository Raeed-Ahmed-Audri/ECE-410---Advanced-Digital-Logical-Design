----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description: CPU LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Shyama Gandhi (Nov 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
--*********************************************************************************
--THIS IS A 4x1 MUX that selects between the four inputs as shown in the lab manual.
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux2_tb IS
END mux2_tb;

ARCHITECTURE sim OF mux2_tb IS
    -- Signal Declarations
    SIGNAL mux_sel : STD_LOGIC                      := '0';
    SIGNAL in0     : STD_LOGIC_VECTOR(15 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL in1     : STD_LOGIC_VECTOR(15 DOWNTO 0)  := (OTHERS => '0');
    SIGNAL mux_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : ENTITY WORK.mux2(Dataflow)
        PORT MAP(
            mux_sel => mux_sel,
            in0     => in0,
            in1     => in1,
            mux_out => mux_out
        );

    -- Stimulus Process
    stim_proc : PROCESS
    BEGIN
        -- Test Case 1: mux_sel = '0', expect mux_out = in0
        mux_sel <= '0';
        in0     <= X"1234";
        in1     <= X"5678";
        WAIT FOR 20 ns;
        ASSERT (mux_out = X"1234")
            REPORT "Test Case 1 Failed: mux_out should be in0 when mux_sel = '0'" SEVERITY ERROR;

        -- Test Case 2: mux_sel = '1', expect mux_out = in1
        mux_sel <= '1';
        WAIT FOR 20 ns;
        ASSERT (mux_out = X"5678")
            REPORT "Test Case 2 Failed: mux_out should be in1 when mux_sel = '1'" SEVERITY ERROR;

        -- Test Case 3: mux_sel = 'X', expect mux_out = all zeros
        mux_sel <= 'X';
        WAIT FOR 20 ns;
        ASSERT (mux_out = (OTHERS => '0'))
            REPORT "Test Case 3 Failed: mux_out should be zeros when mux_sel is undefined" SEVERITY ERROR;

        -- Test Case 4: Change inputs while mux_sel = '1'
        in1     <= X"9ABC";
        WAIT FOR 20 ns;
        ASSERT (mux_out = X"9ABC")
            REPORT "Test Case 4 Failed: mux_out should reflect updated in1 when mux_sel = '1'" SEVERITY ERROR;

        -- Test Case 5: Change mux_sel back to '0', expect mux_out = in0
        mux_sel <= '0';
        WAIT FOR 20 ns;
        ASSERT (mux_out = X"1234")
            REPORT "Test Case 5 Failed: mux_out should be in0 when mux_sel = '0'" SEVERITY ERROR;

        -- End of test
        WAIT;
    END PROCESS stim_proc;
END sim;
