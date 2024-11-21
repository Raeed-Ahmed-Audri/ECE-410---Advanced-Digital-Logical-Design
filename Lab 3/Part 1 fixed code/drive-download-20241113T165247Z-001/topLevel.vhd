LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY top_level IS
    PORT ( clock      : IN  STD_LOGIC;
           reset      : IN  STD_LOGIC;
           user_input : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
           output_en  : IN  STD_LOGIC;
           result     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
         );
END top_level;

ARCHITECTURE behavior OF top_level IS
    -- Internal signals for control logic and datapath I/O
    SIGNAL alu_sel    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL mux_sel_2  : STD_LOGIC := '0';
    SIGNAL mux_sel_4  : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL acc_write  : STD_LOGIC := '0';
    SIGNAL rf_write   : STD_LOGIC := '0';
    SIGNAL rf_mode    : STD_LOGIC := '0';
    SIGNAL rf_address : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";

    -- Signals to interface with the datapath
    SIGNAL dp_result  : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    -- Instantiate the datapath component
    datapath_inst : ENTITY work.datapath
        PORT MAP (
            clock      => clock,
            reset      => reset,
            user_input => user_input,
            output_en  => output_en,
            result     => dp_result
        );

    -- Assign the datapath result to the top-level output
    result <= dp_result;

    -- Control process for managing `datapath` operations
    control_process : PROCESS (clock, reset)
    BEGIN
        IF reset = '1' THEN
            -- Reset all control signals
            alu_sel    <= "0000";
            mux_sel_2  <= '0';
            mux_sel_4  <= "00";
            acc_write  <= '0';
            rf_write   <= '0';
            rf_mode    <= '0';
            rf_address <= "000";

        ELSIF rising_edge(clock) THEN
            -- Control signal logic for operating the datapath
            -- Example: Perform an addition operation
            alu_sel    <= "0101";       -- Select ALU addition
            mux_sel_2  <= '0';          -- Set 2-to-1 mux selector
            mux_sel_4  <= "01";         -- Set 4-to-1 mux selector for input to accumulator
            acc_write  <= '1';          -- Enable accumulator write
            rf_write   <= '1';          -- Enable register file write
            rf_mode    <= '0';          -- Single access mode for register file
            rf_address <= "001";        -- Select address in register file

            -- Additional control logic can be added here to drive the datapath signals
        END IF;
    END PROCESS control_process;

END behavior;
