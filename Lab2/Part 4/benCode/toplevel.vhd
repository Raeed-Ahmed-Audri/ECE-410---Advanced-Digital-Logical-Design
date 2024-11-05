library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port (
        -- Inputs
        clock        : in  STD_LOGIC;  -- Connect to Zybo board clock (e.g., 100 MHz)
        reset        : in  STD_LOGIC;  -- Reset signal (optional: map to a button on the Zybo board)
        motion_sensor: in  STD_LOGIC;  -- GPIO input from AD2 mapped to V15
        fully_open   : in  STD_LOGIC;  -- GPIO input from AD2 mapped to T11
        fully_closed : in  STD_LOGIC;  -- GPIO input from AD2 mapped to W15
        force_open    : in  STD_LOGIC;

        -- Outputs
        door_rgb     : out STD_LOGIC_VECTOR(2 downto 0); -- 3-bit RGB LED (V16, F17, M17)
        motor        : out STD_LOGIC_VECTOR(1 downto 0)  -- Motor control (M14, M15)
    );
end top_level;

architecture Structural of top_level is

    -- Signals for internal connections
    signal internal_clock      : STD_LOGIC;
    signal internal_reset      : STD_LOGIC;
    signal internal_motion_sensor : STD_LOGIC;
    signal internal_fully_open : STD_LOGIC;
    signal internal_fully_closed : STD_LOGIC;
    signal internal_force_open   : STD_LOGIC;
    signal internal_door_rgb   : STD_LOGIC_VECTOR(2 downto 0);
    signal internal_motor      : STD_LOGIC_VECTOR(1 downto 0);

begin

    -- Instantiate the door controller FSM
    door_fsm: entity work.door_controller
        Port map (
            clock        => internal_clock,        -- Connect to internal clock
            reset        => internal_reset,        -- Connect to reset
            motion_sensor => internal_motion_sensor, -- Motion sensor input
            fully_open   => internal_fully_open,   -- Limit switch for fully open
            fully_closed => internal_fully_closed, -- Limit switch for fully closed
            door_rgb     => internal_door_rgb,     -- RGB LED output
            motor        => internal_motor,         -- Motor control output
            force_open   => internal_force_open
        );

    -- Assign inputs to the internal signals (directly from pins)
    internal_clock      <= clock;
    internal_reset      <= reset;
    internal_motion_sensor <= motion_sensor;
    internal_fully_open <= fully_open;
    internal_fully_closed <= fully_closed;
    internal_force_open   <= force_open;

    -- Assign outputs to the actual Zybo board pins
    door_rgb <= internal_door_rgb;  -- Map RGB LED output to Zybo pins
    motor    <= internal_motor;     -- Map motor output to Zybo pins

end Structural;
