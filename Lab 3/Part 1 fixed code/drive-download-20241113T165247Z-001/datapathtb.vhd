LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY datapath_tb IS
END datapath_tb;

ARCHITECTURE behavior OF datapath_tb IS
    -- Signals for the UUT (Unit Under Test)
    SIGNAL clock      : STD_LOGIC := '0';
    SIGNAL reset      : STD_LOGIC := '0';
    SIGNAL user_input : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL output_en  : STD_LOGIC := '0';
    SIGNAL result     : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    -- Additional control signals for the UUT
    SIGNAL alu_sel    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL alu_mux_sel   : STD_LOGIC := '0';                       -- 2-to-1 MUX selector
    SIGNAL acc_mux_sel   : STD_LOGIC := '0';                       -- 2-to-1 MUX selector
    SIGNAL mux_sel_4  : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL acc0_write  : STD_LOGIC := '0';
    SIGNAL acc1_write  : STD_LOGIC := '0';
    SIGNAL rf_write   : STD_LOGIC := '0';
    SIGNAL rf_mode    : STD_LOGIC := '0';
    SIGNAL rf_address : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    
    Signal test_rf_out : STD_LOGIC_VECTOR(15 DOWNTO 0);    
    Signal test_acc0_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    -- Clock period constant
    CONSTANT clk_period : TIME := 10 ns;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    UUT: ENTITY work.datapath
        PORT MAP (
            clock      => clock,
            reset      => reset,
            user_input => user_input,
            output_en  => output_en,
            result     => result,
            alu_sel    => alu_sel,
            mux_sel_4  => mux_sel_4,
            acc0_write  => acc0_write,
            acc1_write  => acc1_write,
            rf_write   => rf_write,
            rf_mode    => rf_mode,
            rf_address => rf_address,
            acc_mux_sel => acc_mux_sel,
            alu_mux_sel => alu_mux_sel,      
            test_rf_out=> test_rf_out,
            test_acc0_out => test_acc0_out
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

        -- Test different ALU operations by changing alu_sel and providing inputs


        -- Load values into register file and test ALU addition
        acc0_write <= '1';         -- Enable write to accumulator   
        user_input <= x"0003";
        mux_sel_4 <= "11";  
        WAIT FOR clk_period;
        acc0_write <= '0';     
        
        rf_write <= '1';          -- Enable write to register file
        rf_address <= "000";      -- Write to address 0
        WAIT FOR clk_period;  
          
        rf_write <= '0';
        
        
        
        user_input <= x"0005";
        acc0_write <= '1';
        WAIT FOR clk_period;
        acc0_write <= '0';
        
        -- Test ALU addition
        alu_sel <= "0101";        -- ALU addition operation
        alu_mux_sel <= '1';         -- Select register outputs


        mux_sel_4 <= "00";
        acc0_write <= '1';
        WAIT FOR clk_period;
        acc0_write <= '0';
        

        output_en <= '1';         -- Enable output
        
        
        WAIT FOR clk_period;
        
        
        
        -- Check the ALU result in acc0_out
        ASSERT (result = x"0008") 
        REPORT "ALU addition failed" SEVERITY ERROR;
    
        output_en <= '0';         -- Enable output







        -- Test shifting operation in ALU
        alu_sel <= "0011";        -- ALU shift left
        WAIT FOR clk_period;
        ASSERT (result = x"0010")
        REPORT "ALU shift left failed" SEVERITY ERROR;

        -- Test register file read in single mode
        rf_mode <= '0';           -- Single access mode
        rf_address <= "000";      -- Address 0 read
        WAIT FOR clk_period;
        ASSERT (result = x"0003") 
        REPORT "Register read failed for single access" SEVERITY ERROR;

        -- Test accumulator functionality
        acc0_write <= '1';          -- Enable write to accumulator
        user_input <= x"0002";     -- Load accumulator input
        WAIT FOR clk_period;
        
        -- Verify accumulator operation
        ASSERT (result = x"0010") 
        REPORT "Accumulator write failed" SEVERITY ERROR;

        -- Test MUX selection
        mux_sel_4 <= "10";        -- Switch mux selection to acc0_out
        WAIT FOR clk_period;
        ASSERT (result = x"0002")
        REPORT "MUX selection failed" SEVERITY ERROR;

        -- Test tri-state buffer
        output_en <= '1';         -- Enable output
        WAIT FOR clk_period;
        ASSERT (result /= "ZZZZZZZZZZZZZZZZ") 
        REPORT "Tri-state buffer enable failed" SEVERITY ERROR;

        output_en <= '0';         -- Disable output
        WAIT FOR clk_period;
        ASSERT (result = "ZZZZZZZZZZZZZZZZ") 
        REPORT "Tri-state buffer disable failed" SEVERITY ERROR;

        WAIT;
    END PROCESS;

END behavior;
