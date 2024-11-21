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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY datapath IS
    PORT ( clock      : IN  STD_LOGIC;
           reset      : IN  STD_LOGIC;
           user_input : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
           output_en  : IN  STD_LOGIC;
           result     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0') ;
           alu_sel     : IN STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001"; -- Example operation 
           mux_sel_4   : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";   -- 4-to-1 MUX selector
           acc0_write   : IN STD_LOGIC := '1';   
           acc1_write   : IN STD_LOGIC := '1';                           -- Accumulator write enable
           rf_write    : IN STD_LOGIC := '1';                       -- Register file write enable
           rf_mode     : IN STD_LOGIC := '0';                       -- Register file mode
           rf_address  : IN STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";  -- Register file address
           acc_mux_sel : IN STD_LOGIC;
           alu_mux_sel : IN STD_LOGIC;
           test_rf_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
           test_acc0_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0')
          
         );
END datapath;

ARCHITECTURE Structural OF datapath IS
    ---------------------------------------------------------------------------
    -- Internal Signals
    SIGNAL alu0_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu1_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL acc0_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL acc1_out    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rf0_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL rf1_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mux_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu_mux_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL acc_mux_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
--    SIGNAL alu_sel     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001"; -- Example operation
 
--    SIGNAL mux_sel_4   : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";   -- 4-to-1 MUX selector
--    SIGNAL acc_write   : STD_LOGIC := '1';                       -- Accumulator write enable
--    SIGNAL rf_write    : STD_LOGIC := '1';                       -- Register file write enable
--    SIGNAL rf_mode     : STD_LOGIC := '0';                       -- Register file mode
--    SIGNAL rf_address  : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";  -- Register file address
    ---------------------------------------------------------------------------

    -- Component Declarations
    COMPONENT mux4
        PORT ( in0      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               in1      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               in2      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               in3      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               mux_sel  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
               mux_out  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT mux2
        PORT ( in0     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               in1     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               mux_sel : IN  STD_LOGIC;
               mux_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT accumulator
        PORT ( clock     : IN  STD_LOGIC;
               reset     : IN  STD_LOGIC;
               acc_write : IN  STD_LOGIC;
               acc_in    : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               acc_out   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT register_file
        PORT ( clock      : IN  STD_LOGIC;
               rf_write   : IN  STD_LOGIC;
               rf_mode    : IN  STD_LOGIC;
               rf_address : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
               rf0_in     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               rf1_in     : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               rf0_out    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
               rf1_out    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT alu16
        PORT ( A         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               B         : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               shift_amt : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
               alu_sel   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
               alu_out   : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
             );
    END COMPONENT;

    COMPONENT tri_state_buffer
        PORT ( output_en     : IN  STD_LOGIC;
               buffer_input  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
               buffer_output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
             );
    END COMPONENT;

BEGIN

    -- Instantiate input_mux (another 4-to-1 multiplexer for ALU input selection)
    input_mux : mux4
        PORT MAP ( in0     => alu0_out,
                   in1     => rf0_out,
                   in2     => acc0_out,     --  Incorrect, needs to be immediate_data
                   in3     => user_input,
                   mux_sel => mux_sel_4,
                   mux_out => mux_out
                 );

    -- Instantiate alu_mux (2-to-1 multiplexer for ALU source selection)
    alu_mux : mux2
        PORT MAP ( in0     => rf1_out,
                   in1     => acc0_out,
                   mux_sel => alu_mux_sel,
                   mux_out => alu_mux_out
                 );
    acc_mux : mux2
        PORT MAP ( in0     => rf0_out, --rf0out
                   in1     => acc1_out,
                   mux_sel => acc_mux_sel,
                   mux_out => acc_mux_out
                 );
          

    -- Instantiate accumulator0
    accumulator0 : accumulator
        PORT MAP ( clock     => clock,
                   reset     => reset,
                   acc_write => acc0_write,
                   acc_in    => mux_out,
                   acc_out   => acc0_out
                 );

    -- Instantiate accumulator1
    accumulator1 : accumulator
        PORT MAP ( clock     => clock,
                   reset     => reset,
                   acc_write => acc1_write,
                   acc_in    => alu_mux_out,
                   acc_out   => acc1_out
                 );

    -- Instantiate the register file
    register_file_inst : register_file
        PORT MAP ( clock      => clock,
                   rf_write   => rf_write,
                   rf_mode    => rf_mode,
                   rf_address => rf_address,
                   rf0_in     => acc0_out,
                   rf1_in     => acc1_out,
                   rf0_out    => rf0_out,
                   rf1_out    => rf1_out
                 );

    -- Instantiate ALU 0
    alu0 : alu16
        PORT MAP ( A         => rf0_out,
                   B         => alu_mux_out,
                   shift_amt => "0001",  -- Example shift amount
                   alu_sel   => alu_sel,
                   alu_out   => alu0_out
                 );

    -- Instantiate ALU 1
    alu1 : alu16
        PORT MAP ( A         => acc0_out,
                   B         => rf1_out,
                   shift_amt => "0010",  -- Example shift amount
                   alu_sel   => alu_sel,
                   alu_out   => alu1_out
                 );

    -- Instantiate tri-state buffer for output
    tri_state_buffer_inst : tri_state_buffer
        PORT MAP ( output_en     => output_en,
                   buffer_input  => acc0_out,
                   buffer_output => result
                 );

    test_rf_out <= rf0_out;
    test_acc0_out <= acc0_out;
END Structural;

