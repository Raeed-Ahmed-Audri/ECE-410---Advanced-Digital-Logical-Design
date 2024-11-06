----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Antonio Andara Lara, Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/28/2024 01:01:24 PM
-- Module Name: register_file_tb
-- Description: CPU LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-----------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY register_file_tb IS
END register_file_tb;

ARCHITECTURE behavior OF register_file_tb IS
    -- Signals for the UUT
    SIGNAL clock      : STD_LOGIC := '0';
    SIGNAL rf_write   : STD_LOGIC := '0';
    SIGNAL rf_mode    : STD_LOGIC := '0'; -- Corrected signal name from 'mode' to 'rf_mode'
    SIGNAL rf_address : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rf0_in     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rf1_in     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL rf0_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rf1_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT clk_period : TIME := 10 ns; -- Adjusted clock period for clarity
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: ENTITY work.register_file
        PORT MAP (
            clock      => clock,
            rf_write   => rf_write,
            rf_mode    => rf_mode,
            rf_address => rf_address,
            rf0_in     => rf0_in,
            rf1_in     => rf1_in,
            rf0_out    => rf0_out,
            rf1_out    => rf1_out
        );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        clock <= '0';
        WAIT FOR clk_period / 2;
        clock <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stim_process : PROCESS
    BEGIN
        -- Initialize inputs
        rf_write   <= '0';                -- Ensure write is disabled initially
        rf_mode    <= '0';                -- Single access mode
        rf_address <= "000";              -- Address 0
        rf0_in     <= X"0001";            -- Input value for rf0_in
        rf1_in     <= X"0002";            -- Input value for rf1_in

        WAIT FOR clk_period;              -- Wait for one clock cycle

        -- Test single access mode write
        rf_write <= '1';                  -- Enable write
        WAIT FOR clk_period;

        rf_write <= '0';                  -- Disable write
        WAIT FOR clk_period;              -- Wait for outputs to update

        -- Check outputs
        ASSERT (rf0_out = X"0001") REPORT "Error: rf0_out should be X\"0001\" in single access mode" SEVERITY ERROR;
        ASSERT (rf1_out = X"0000") REPORT "Error: rf1_out should be X\"0000\" in single access mode" SEVERITY ERROR;

        -- Test double access mode write
        rf_mode    <= '1';                -- Switch to double access mode
        rf_address <= "001";              -- Address 1
        rf0_in     <= X"0003";            -- Input value for rf0_in
        rf1_in     <= X"0004";            -- Input value for rf1_in

        rf_write   <= '1';                -- Enable write
        WAIT FOR clk_period;

        rf_write <= '0';                  -- Disable write
        WAIT FOR clk_period;              -- Wait for outputs to update

        -- Check outputs after writing in double access mode
        ASSERT (rf0_out = X"0003") REPORT "Error: rf0_out should be X\"0003\" in double access mode" SEVERITY ERROR;
        ASSERT (rf1_out = X"0004") REPORT "Error: rf1_out should be X\"0004\" in double access mode" SEVERITY ERROR;

        -- Read back values in single access mode
        rf_mode    <= '0';                -- Switch to single access mode
        rf_address <= "001";              -- Address 1
        WAIT FOR clk_period;

        ASSERT (rf0_out = X"0003") REPORT "Error: rf0_out should be X\"0003\" when reading from register 1" SEVERITY ERROR;

        rf_address <= "101";              -- Address 5 (1 XOR 4)
        WAIT FOR clk_period;

        ASSERT (rf0_out = X"0004") REPORT "Error: rf0_out should be X\"0004\" when reading from register 5" SEVERITY ERROR;

        -- Additional test case in double access mode
        rf_mode    <= '1';                -- Double access mode
        rf_address <= "010";              -- Address 2
        rf0_in     <= X"AAAA";            -- Input value for rf0_in
        rf1_in     <= X"5555";            -- Input value for rf1_in

        rf_write   <= '1';                -- Enable write
        WAIT FOR clk_period;

        rf_write <= '0';                  -- Disable write
        WAIT FOR clk_period;              -- Wait for outputs to update

        -- Check outputs after writing
        ASSERT (rf0_out = X"AAAA") REPORT "Error: rf0_out should be X\"AAAA\" in double access mode" SEVERITY ERROR;
        ASSERT (rf1_out = X"5555") REPORT "Error: rf1_out should be X\"5555\" in double access mode" SEVERITY ERROR;

        -- Read back values
        rf_mode    <= '0';                -- Single access mode
        rf_address <= "010";              -- Address 2
        WAIT FOR clk_period;

        ASSERT (rf0_out = X"AAAA") REPORT "Error: rf0_out should be X\"AAAA\" when reading from register 2" SEVERITY ERROR;

        rf_address <= "110";              -- Address 6 (2 XOR 4)
        WAIT FOR clk_period;

        ASSERT (rf0_out = X"5555") REPORT "Error: rf0_out should be X\"5555\" when reading from register 6" SEVERITY ERROR;

        -- End of test
        WAIT;
    END PROCESS;
END behavior;
