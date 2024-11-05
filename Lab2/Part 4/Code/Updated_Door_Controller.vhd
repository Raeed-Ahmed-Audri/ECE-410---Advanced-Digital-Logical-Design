-- door_controller.vhd
-- VHDL code for the upgraded automatic door controller FSM with EMERGENCY state

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity door_controller is
    Port (
        clock         : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        motion_sensor : in  STD_LOGIC;
        fully_open    : in  STD_LOGIC;
        fully_closed  : in  STD_LOGIC;
        force_open    : in  STD_LOGIC;   -- New force_open input
        door_rgb      : out STD_LOGIC_VECTOR(2 downto 0);
        motor         : out STD_LOGIC_VECTOR(1 downto 0)
    );
end door_controller;

architecture Behavioral of door_controller is

    -- State type declaration
    type state_type is (DOOR_CLOSED, DOOR_OPENING, DOOR_OPEN, DOOR_CLOSING, EMERGENCY);
    signal current_state, next_state : state_type;

    -- Timer constants and signals
    constant MAX_OPEN_CLOSE_TIME : integer := 50000000; -- Adjust based on clock frequency for 5 seconds
    signal timer_count           : integer range 0 to MAX_OPEN_CLOSE_TIME := 0;
    signal emergency_flag        : STD_LOGIC := '0';

    -- Signal for 1 Hz flashing
    signal led_toggle : STD_LOGIC := '0';

begin

    -- State Register Process: Updates the current state on each clock edge
    state_register: process(clock, reset)
    begin
        if reset = '1' then
            current_state <= DOOR_CLOSED;  -- Reset to initial state
        elsif rising_edge(clock) then
            current_state <= next_state;   -- Update state
        end if;
    end process;

    -- Next State Logic: Determines the next state based on inputs and current state
    next_state_logic: process(current_state, motion_sensor, fully_open, fully_closed, force_open, timer_count)
    begin
        case current_state is
            -- DOOR_CLOSED State
            when DOOR_CLOSED =>
                if force_open = '1' then
                    next_state <= DOOR_OPENING;  -- Manual override
                elsif motion_sensor = '1' then
                    next_state <= DOOR_OPENING;  -- Normal opening
                else
                    next_state <= DOOR_CLOSED;
                end if;

            -- DOOR_OPENING State
            when DOOR_OPENING =>
                if force_open = '1' then
                    next_state <= DOOR_OPENING;  -- Keep opening
                elsif fully_open = '1' then
                    next_state <= DOOR_OPEN;     -- Fully opened
                elsif timer_count >= MAX_OPEN_CLOSE_TIME then
                    next_state <= EMERGENCY;     -- Time exceeded, go to EMERGENCY
                else
                    next_state <= DOOR_OPENING;
                end if;

            -- DOOR_OPEN State
            when DOOR_OPEN =>
                if timer_count >= MAX_OPEN_CLOSE_TIME and motion_sensor = '0' then
                    next_state <= DOOR_CLOSING;  -- Close after time delay and no motion
                else
                    next_state <= DOOR_OPEN;
                end if;

            -- DOOR_CLOSING State
            when DOOR_CLOSING =>
                if force_open = '1' then
                    next_state <= DOOR_OPENING;  -- Manual override to reopen
                elsif fully_closed = '1' then
                    next_state <= DOOR_CLOSED;   -- Fully closed
                elsif timer_count >= MAX_OPEN_CLOSE_TIME then
                    next_state <= EMERGENCY;     -- Time exceeded, go to EMERGENCY
                else
                    next_state <= DOOR_CLOSING;
                end if;

            -- EMERGENCY State
            when EMERGENCY =>
                if reset = '1' then
                    next_state <= DOOR_CLOSED;   -- Reset brings back to initial state
                else
                    next_state <= EMERGENCY;     -- Stay in EMERGENCY until reset
                end if;

            when others =>
                next_state <= DOOR_CLOSED;  -- Default to closed state
        end case;
    end process;

    -- Timer Process: Manages the timing for transitions to EMERGENCY
    timer_process: process(clock, reset)
    begin
        if reset = '1' then
            timer_count <= 0;               -- Reset timer
        elsif rising_edge(clock) then
            if current_state = DOOR_OPENING or current_state = DOOR_CLOSING then
                if timer_count < MAX_OPEN_CLOSE_TIME then
                    timer_count <= timer_count + 1;
                end if;
            else
                timer_count <= 0;  -- Reset timer when not in OPENING or CLOSING state
            end if;
        end if;
    end process;

    -- Output Logic for Motor Control
    motor_output_logic: process(current_state)
    begin
        case current_state is
            when DOOR_OPENING =>
                motor <= "01"; -- Motor opening
            when DOOR_CLOSING =>
                motor <= "10"; -- Motor closing
            when others =>
                motor <= "00"; -- Motor off in other states (including EMERGENCY)
        end case;
    end process;

    -- Output Logic for RGB LED Control (including 1 Hz flashing in EMERGENCY)
    door_rgb_output_logic: process(clock)
    begin
        if rising_edge(clock) then
            case current_state is
                when DOOR_CLOSED =>
                    door_rgb <= "100"; -- Red
                when DOOR_OPENING =>
                    door_rgb <= "001"; -- Blue
                when DOOR_OPEN =>
                    door_rgb <= "010"; -- Green
                when DOOR_CLOSING =>
                    door_rgb <= "110"; -- Yellow
                when EMERGENCY =>
                    if timer_count mod (MAX_OPEN_CLOSE_TIME / 5) = 0 then -- Flash at 1 Hz
                        led_toggle <= not led_toggle;
                    end if;
                    if led_toggle = '1' then
                        door_rgb <= "111"; -- LED on
                    else
                        door_rgb <= "000"; -- LED off
                    end if;
                when others =>
                    door_rgb <= "000"; -- Off (default)
            end case;
        end if;
    end process;

end Behavioral;




