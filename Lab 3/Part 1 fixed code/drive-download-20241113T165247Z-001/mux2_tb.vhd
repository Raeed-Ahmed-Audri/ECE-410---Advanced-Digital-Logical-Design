LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux2_tb IS
END mux2_tb;

ARCHITECTURE sim OF mux2_tb IS

    SIGNAL in0     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL in1     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mux_sel : STD_LOGIC := '0';
    SIGNAL mux_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : ENTITY work.mux2(Dataflow)
        PORT MAP(
            in0     => in0,
            in1     => in1,
            mux_sel => mux_sel,
            mux_out => mux_out           
        );

    stimulus : PROCESS
    BEGIN
        -- Setup test data
        in0 <= "1010101010101010";  -- 16-bit value for in0
        in1 <= "1100110011001100";  -- 16-bit value for in1

        -- Test selecting in0
        mux_sel <= '0';
        WAIT FOR 20 ns;

        -- Assertion to check if output matches in0
        ASSERT (mux_out = in0)
        REPORT "Mismatch for mux_sel = 0!"
            SEVERITY ERROR;
            
        -- Test selecting in1
        mux_sel <= '1';
        WAIT FOR 20 ns;

        -- Assertion to check if output matches in1
        ASSERT (mux_out = in1)
        REPORT "Mismatch for mux_sel = 1!"
            SEVERITY ERROR;

        -- End the test
        WAIT;
    END PROCESS stimulus;

END sim;
