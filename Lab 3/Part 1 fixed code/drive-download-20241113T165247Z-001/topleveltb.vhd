LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top_level_tb IS
END top_level_tb;

ARCHITECTURE behavior OF top_level_tb IS
    -- Signals for the UUT (Unit Under Test)
    SIGNAL clock      : STD_LOGIC := '0';
    SIGNAL reset      : STD_LOGIC := '0';
    SIGNAL user_input : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output_en  : STD_LOGIC := '0';
    SIGNAL result     : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period constant
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    UUT: ENTITY work.top_level
        PORT MAP (
            clock      => clock,
            reset      => reset,
            user_input => user_input,
            output_en  => output_en,
            result     => result
        );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        clock <= '0';
        WAIT FOR clk_period / 2;
        clock <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Apply reset to initialize the system
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';

        -- Simulate user input and output enable
        user_input <= x"0003";       -- Input data
        output_en <= '1';            -- Enable output
        WAIT FOR clk_period * 2;

        -- Apply new input
        user_input <= x"0005";
        WAIT FOR clk_period * 2;

        -- Disable output
        output_en <= '0';
        WAIT FOR clk_period;

        WAIT;
    END PROCESS;

END behavior;
