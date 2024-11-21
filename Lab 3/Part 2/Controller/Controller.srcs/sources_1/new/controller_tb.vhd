LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY controller_tb IS
END controller_tb;

ARCHITECTURE behavior OF controller_tb IS
    -- Signals for the UUT (Unit Under Test)
    SIGNAL clock          : STD_LOGIC := '0';
    SIGNAL reset          : STD_LOGIC := '0';
    SIGNAL enter          : STD_LOGIC := '0';
    SIGNAL zero_flag      : STD_LOGIC := '0';
    SIGNAL sign_flag      : STD_LOGIC := '0';
    SIGNAL of_flag        : STD_LOGIC := '0';
    SIGNAL immediate_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mux_sel        : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL acc_mux_sel    : STD_LOGIC;
    SIGNAL alu_mux_sel    : STD_LOGIC;
    SIGNAL acc0_write     : STD_LOGIC;
    SIGNAL acc1_write     : STD_LOGIC;
    SIGNAL rf_address     : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL rf_write       : STD_LOGIC;
    SIGNAL rf_mode        : STD_LOGIC;
    SIGNAL alu_sel        : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL shift_amt      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL output_en      : STD_LOGIC;
    SIGNAL PC_out         : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL OPCODE_output  : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL done           : STD_LOGIC;

    -- Clock period constant
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    UUT: ENTITY work.controller
        PORT MAP (
            clock          => clock,
            reset          => reset,
            enter          => enter,
            zero_flag      => zero_flag,
            sign_flag      => sign_flag,
            of_flag        => of_flag,
            immediate_data => immediate_data,
            mux_sel        => mux_sel,
            acc_mux_sel    => acc_mux_sel,
            alu_mux_sel    => alu_mux_sel,
            acc0_write     => acc0_write,
            acc1_write     => acc1_write,
            rf_address     => rf_address,
            rf_write       => rf_write,
            rf_mode        => rf_mode,
            alu_sel        => alu_sel,
            shift_amt      => shift_amt,
            output_en      => output_en,
            PC_out         => PC_out,
            OPCODE_output  => OPCODE_output,
            done           => done
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
        -- Initialize signals
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';
        WAIT FOR clk_period;

        -- Test FETCH state
        enter <= '1'; -- Enter fetch mode
        WAIT FOR clk_period;
        ASSERT (PC_out = "00001") REPORT "FETCH state failed" SEVERITY ERROR;

        -- Test LDI state
        immediate_data <= x"DEAD"; -- Test LDI instruction
        WAIT FOR clk_period;
        ASSERT (acc0_write = '1' AND acc_mux_sel = '0') 
            REPORT "LDI instruction failed" SEVERITY ERROR;

        -- Test STA state
        immediate_data <= x"BEEF";
        rf_write <= '1'; -- Test STA instruction
        WAIT FOR clk_period;
        ASSERT (rf_address = "000") 
            REPORT "STA instruction failed" SEVERITY ERROR;

        -- Test AND state
        alu_sel <= "1001"; -- Set ALU to AND mode
        WAIT FOR clk_period;
        ASSERT (acc0_write = '1') 
            REPORT "AND instruction failed" SEVERITY ERROR;

        -- Test OUT state
        output_en <= '1'; -- Enable output
        WAIT FOR clk_period;
        ASSERT (output_en = '1') 
            REPORT "OUT instruction failed" SEVERITY ERROR;

        -- Test NOT state
        alu_sel <= "1011"; -- Set ALU to NOT mode
        WAIT FOR clk_period;
        ASSERT (acc0_write = '1') 
            REPORT "NOT instruction failed" SEVERITY ERROR;

        -- Test XCHG state
        rf_address <= "001"; -- Test XCHG instruction
        WAIT FOR clk_period;
        ASSERT (rf_write = '1' AND acc0_write = '1') 
            REPORT "XCHG instruction failed" SEVERITY ERROR;

        -- End simulation
        WAIT;
    END PROCESS;

END behavior;

