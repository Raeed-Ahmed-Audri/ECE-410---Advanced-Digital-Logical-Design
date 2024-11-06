----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Antonio Andara Lara, Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: DATAPATH FOR THE CPU
-- Module Name: cpu - structural(datapath)
-- Description: CPU_PART 1 OF LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Antonio Andara (October 28, 2024)
-- Additional Comments:
--*********************************************************************************
-- datapath top level module that maps all the components used inside of it
-----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;
USE ieee.numeric_std.ALL;

ENTITY datapath IS
    PORT ();
END datapath;

ARCHITECTURE Structural OF datapath IS
    ---------------------------------------------------------------------------
    SIGNAL alu0_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu1_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL acc0_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL acc1_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rf0_in      : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rf1_in      : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rf0_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rf1_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mux_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu_mux_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL acc_mux_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL user_input  : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ouput_en    : STD_LOGIC;
    SIGNAL clock_div   : STD_LOGIC;
    ---------------------------------------------------------------------------
BEGIN
    -- Instantiate all components here
    mux4 :

    acc_mux :

    alu_mux :

    accumulator0 :

    accumulator1 :

    register_file :

    alu0 :

    alu1 :

    tri_state_buffer :

    -- logic for flags

END Structural;
