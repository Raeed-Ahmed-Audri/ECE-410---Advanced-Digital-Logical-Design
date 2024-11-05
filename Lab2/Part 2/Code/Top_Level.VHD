library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Top-level entity
entity top_level_fsm is
    Port (
        -- Inputs
        clk      : in  STD_LOGIC;            -- Clock signal
        reset    : in  STD_LOGIC;            -- Reset input (push button)
        en       : in  STD_LOGIC;            -- Enable signal (switch)
        sel      : in  STD_LOGIC;            -- Select signal (switch: 0 for up-counter, 1 for custom sequence)

        -- Outputs to 7-segment display
        segments : out STD_LOGIC_VECTOR(6 downto 0)  -- 7-segment display output (A-G)
    );
end top_level_fsm;

architecture Behavioral of top_level_fsm is

    -- Signals for interconnection between FSM and display controller
    signal count_out : STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit output from FSM to the display controller

    -- Signal for the clock divider (2 Hz clock)
    signal slow_clk : STD_LOGIC := '0';
    constant limit  : INTEGER := 62_500_000;  

    -- Signal for clock divider
    signal count : INTEGER range 0 to limit := 0;

begin

    -- Clock divider process (divide the system clock to 2 Hz)
    clk_divider : process (clk)
    begin
        if rising_edge(clk) then
            if count < limit then
                count <= count + 1;
            else
                count <= 0;
                slow_clk <= not slow_clk;  -- Toggle the clock
            end if;
        end if;
    end process;

    -- Instantiate the FSM (count generator)
    fsm_inst : entity work.count_generator_fsm
        port map (
            clk       => slow_clk,    -- Use the divided clock for slower counting
            reset     => reset,       -- Reset input
            sel       => sel,         -- Select signal for mode (0 for up-counter, 1 for custom sequence)
            en        => en,          -- Enable signal
            count_out => count_out    -- 4-bit output from FSM
        );

    -- Instantiate the display controller
    display_inst : entity work.display_controller
        port map (
            digits   => count_out,    -- 4-bit count from FSM
            clock    => clk,          -- Original system clock for display controller
            segments => segments      -- 7-segment display output (A-G)
        );

end Behavioral;
