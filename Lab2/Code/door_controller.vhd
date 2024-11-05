-- door_controller.vhd
-- VHDL code for the automatic door controller FSM

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
        door_rgb      : out STD_LOGIC_VECTOR(2 downto 0);
        motor         : out STD_LOGIC_VECTOR(1 downto 0)
    );
end door_controller;

architecture Behavioral of door_controller is

    -- State type declaration
    type state_type is (DOOR_CLOSED, DOOR_OPENING, DOOR_OPEN, DOOR_CLOSING);
    signal current_state, next_state : state_type;

    -- Timer constants and signals
    constant OPEN_DELAY  : integer := 10000000; -- Adjust as needed
    signal timer_count   : integer range 0 to OPEN_DELAY := 0;
    signal timer_expired : STD_LOGIC := '0';

begin

    -- State Register Process: Updates the current state on each clock edge
    state_register: process(clock, reset)
    begin
        if reset = '1' then
            current_state <= DOOR_CLOSED;
        elsif rising_edge(clock) then
            current_state <= next_state;
        end if;
    end process;

    -- Next State Logic: Determines the next state based on inputs and current state
    next_state_logic: process(current_state, motion_sensor, fully_open, fully_closed, timer_expired)
    begin
        case current_state is
            when DOOR_CLOSED =>
                if motion_sensor = '1' then
                    next_state <= DOOR_OPENING;
                else
                    next_state <= DOOR_CLOSED;
                end if;

            when DOOR_OPENING =>
                if fully_open = '1' then
                    next_state <= DOOR_OPEN;
                else
                    next_state <= DOOR_OPENING;
                end if;

            when DOOR_OPEN =>
                if timer_expired = '1' and motion_sensor = '0' then
                    next_state <= DOOR_CLOSING;
                else
                    next_state <= DOOR_OPEN;
                end if;

            when DOOR_CLOSING =>
                if fully_closed = '1' then
                    next_state <= DOOR_CLOSED;
                elsif motion_sensor = '1' then
                    next_state <= DOOR_OPENING;
                else
                    next_state <= DOOR_CLOSING;
                end if;

            when others =>
                next_state <= DOOR_CLOSED;
        end case;
    end process;

    -- Output Logic for Motor Control
    motor_output_logic: process(current_state)
    begin
        case current_state is
            when DOOR_OPENING =>
                motor <= "01"; -- Door opening
            when DOOR_CLOSING =>
                motor <= "10"; -- Door closing
            when others =>
                motor <= "00"; -- Motor off
        end case;
    end process;

    -- Output Logic for RGB LED Control
    door_rgb_output_logic: process(current_state)
    begin
        case current_state is
            when DOOR_CLOSED =>
                door_rgb <= "100"; -- Red
            when DOOR_OPENING =>
                door_rgb <= "001"; -- Blue
            when DOOR_OPEN =>
                door_rgb <= "010"; -- Green
            when DOOR_CLOSING =>
                door_rgb <= "110"; -- Yellow
            when others =>
                door_rgb <= "000"; -- Off (default)
        end case;
    end process;

    -- Timer Process: Manages the delay in the DOOR_OPEN state
    timer_process: process(clock, reset)
    begin
        if reset = '1' then
            timer_count <= 0;
            timer_expired <= '0';
        elsif rising_edge(clock) then
            if current_state = DOOR_OPEN then
                if timer_count < OPEN_DELAY then
                    timer_count <= timer_count + 1;
                else
                    timer_expired <= '1';
                end if;
            else
                timer_count <= 0;
                timer_expired <= '0';
            end if;
        end if;
    end process;

end Behavioral;




