-- door_controller.vhd
-- VHDL code for the automatic door controller FSM with EMERGENCY state

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity door_controller is
    Port (
        clock         : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        motion_sensor : in  STD_LOGIC;
        force_open    : in  STD_LOGIC;
        fully_open    : in  STD_LOGIC;
        fully_closed  : in  STD_LOGIC;
        door_rgb      : out STD_LOGIC_VECTOR(2 downto 0);
        motor         : out STD_LOGIC_VECTOR(1 downto 0)
    );
end door_controller;

architecture Behavioral of door_controller is

    -- State type declaration
    type state_type is (DOOR_CLOSED, DOOR_OPENING, DOOR_OPEN, DOOR_CLOSING, EMERGENCY);
    signal current_state, next_state : state_type;

    -- Timer constants and signals for door opening/closing timeout
    constant TIMEOUT      : integer := 250_000_000; -- Adjust based on clock frequency (5 seconds)
    signal timeout_count  : integer range 0 to TIMEOUT := 0;
    signal timeout_expired: STD_LOGIC := '0';

    -- Timer constants and signals for LED flashing at 1 Hz
    constant FLASH_PERIOD : integer := 50_000_000; -- Adjust based on clock frequency (1 second period)
    signal flash_count    : integer range 0 to FLASH_PERIOD := 0;
    signal flash_toggle   : STD_LOGIC := '0';

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
    next_state_logic: process(current_state, motion_sensor, force_open, fully_open, fully_closed, timeout_expired)
    begin
        case current_state is
            when DOOR_CLOSED =>
                if force_open = '1' then
                    next_state <= DOOR_OPENING;
                elsif motion_sensor = '1' then
                    next_state <= DOOR_OPENING;
                else
                    next_state <= DOOR_CLOSED;
                end if;

            when DOOR_OPENING =>
                if timeout_expired = '1' then
                    next_state <= EMERGENCY;
                elsif fully_open = '1' then
                    next_state <= DOOR_OPEN;
                elsif force_open = '1' then
                    next_state <= DOOR_OPENING;
                else
                    next_state <= DOOR_OPENING;
                end if;

            when DOOR_OPEN =>
                if force_open = '1' then
                    next_state <= DOOR_OPEN;
                elsif motion_sensor = '0' then
                    next_state <= DOOR_CLOSING;
                else
                    next_state <= DOOR_OPEN;
                end if;

            when DOOR_CLOSING =>
                if timeout_expired = '1' then
                    next_state <= EMERGENCY;
                elsif fully_closed = '1' then
                    next_state <= DOOR_CLOSED;
                elsif force_open = '1' then
                    next_state <= DOOR_OPENING;
                elsif motion_sensor = '1' then
                    next_state <= DOOR_OPENING;
                else
                    next_state <= DOOR_CLOSING;
                end if;

            when EMERGENCY =>
                if reset = '1' then
                    next_state <= DOOR_CLOSED;
                else
                    next_state <= EMERGENCY;
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
    door_rgb_output_logic: process(current_state, flash_toggle)
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
            when EMERGENCY =>
                if flash_toggle = '1' then
                    door_rgb <= "111"; -- White (flashing)
                else
                    door_rgb <= "000"; -- Off
                end if;
            when others =>
                door_rgb <= "000"; -- Off (default)
        end case;
    end process;

    -- Timeout Timer Process: Monitors DOOR_OPENING and DOOR_CLOSING states
    timeout_timer_process: process(clock, reset)
    begin
        if reset = '1' then
            timeout_count   <= 0;
            timeout_expired <= '0';
        elsif rising_edge(clock) then
            if current_state = DOOR_OPENING or current_state = DOOR_CLOSING then
                if timeout_count < TIMEOUT then
                    timeout_count   <= timeout_count + 1;
                    timeout_expired <= '0';
                else
                    timeout_expired <= '1';
                end if;
            else
                timeout_count   <= 0;
                timeout_expired <= '0';
            end if;
        end if;
    end process;

    -- Flashing LED Timer Process: Creates a 1 Hz toggle signal for the EMERGENCY state
    flash_timer_process: process(clock, reset)
    begin
        if reset = '1' then
            flash_count  <= 0;
            flash_toggle <= '0';
        elsif rising_edge(clock) then
            if current_state = EMERGENCY then
                if flash_count < FLASH_PERIOD / 2 then
                    flash_count <= flash_count + 1;
                else
                    flash_count  <= 0;
                    flash_toggle <= not flash_toggle;
                end if;
            else
                flash_count  <= 0;
                flash_toggle <= '0';
            end if;
        end if;
    end process;

end Behavioral;




