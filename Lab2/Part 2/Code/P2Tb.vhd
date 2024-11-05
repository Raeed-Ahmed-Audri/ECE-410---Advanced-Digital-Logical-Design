library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_count_generator_fsm is
end tb_count_generator_fsm;

architecture Behavioral of tb_count_generator_fsm is
    -- Signal declarations for inputs and outputs
    signal clk        : STD_LOGIC := '0';
    signal reset      : STD_LOGIC := '0';
    signal sel        : STD_LOGIC := '0';  -- Mode select (0: up-counter, 1: custom sequence)
    signal en         : STD_LOGIC := '1';  -- Enable signal
    signal count_out  : STD_LOGIC_VECTOR(3 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

    -- Component declaration for the FSM
    component count_generator_fsm
        Port (
            clk       : in STD_LOGIC;
            reset     : in STD_LOGIC;
            sel       : in STD_LOGIC;
            en        : in STD_LOGIC;
            count_out : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

begin
    -- Instantiate the FSM
    uut: count_generator_fsm
        port map (
            clk       => clk,
            reset     => reset,
            sel       => sel,
            en        => en,
            count_out => count_out
        );

    -- Clock generation process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Testbench stimulus process
    stimulus: process
    begin
        -- Initial reset
        reset <= '1';
        wait for 2 ns;  -- Hold reset for a short period
        reset <= '0';

        -- Test 1: Up-counter mode (sel = 0), count up to 15, and return to 0000
        sel <= '1';  -- Up-counter mode
        wait for 200 ns;  -- Let the up-counter run from 0000 to 1111 (16 cycles)
        
        -- Reset to start custom sequence test
--        reset <= '1';
--        wait for 2 ns;
--        reset <= '0';

        -- Test 2: Custom sequence mode (sel = 1), follow the custom sequence
        sel <= '0';  -- Switch to custom sequence mode
        wait for 200 ns;  -- Let the FSM run through the custom sequence
        

        
        -- Finish simulation
        wait;
    end process;

end Behavioral;



