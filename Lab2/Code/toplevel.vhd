-- door_controller_top.vhd
-- Top-level architecture for the automatic door controller system

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity door_controller_top is
    Port (
        clock         : in  STD_LOGIC;
        motion_sensor : in  STD_LOGIC;
        fully_open    : in  STD_LOGIC;
        fully_closed  : in  STD_LOGIC;
        door_rgb      : out STD_LOGIC_VECTOR(2 downto 0);
        motor         : out STD_LOGIC_VECTOR(1 downto 0)
    );
end door_controller_top;

architecture Behavioral of door_controller_top is

    -- Signal declarations
    signal reset       : STD_LOGIC;
    signal clock_div   : STD_LOGIC;

    -- Component declaration for door_controller (FSM)
    component door_controller
        Port (
            clock         : in  STD_LOGIC;
            reset         : in  STD_LOGIC;
            motion_sensor : in  STD_LOGIC;
            fully_open    : in  STD_LOGIC;
            fully_closed  : in  STD_LOGIC;
            door_rgb      : out STD_LOGIC_VECTOR(2 downto 0);
            motor         : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

    -- Component declaration for clock divider
    component clock_divider
        Port (
            clk_in  : in  STD_LOGIC;
            clk_out : out STD_LOGIC
        );
    end component;

begin
    -- Instantiate the clock divider
    clk_div_inst: clock_divider
        Port Map (
            clk_in  => clock,
            clk_out => clock_div
        );

    -- Instantiate the door controller FSM
    door_ctrl_inst: door_controller
        Port Map (
            clock         => clock_div,
            reset         => reset,
            motion_sensor => motion_sensor,
            fully_open    => fully_open,
            fully_closed  => fully_closed,
            door_rgb      => door_rgb,
            motor         => motor
        );

    -- Reset logic (can be driven by an external button or internal signal)
    process(clock)
    begin
        if rising_edge(clock) then
            reset <= '0';
        end if;
    end process;

end Behavioral;