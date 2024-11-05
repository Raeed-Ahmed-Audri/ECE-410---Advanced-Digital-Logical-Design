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
        force_open    : in  STD_LOGIC;
        door_rgb      : out STD_LOGIC_VECTOR(2 downto 0);
        motor         : out STD_LOGIC_VECTOR(1 downto 0)
    );
end door_controller;

architecture Behavioral of door_controller is

    -- State type declaration
    type state_type is (DOOR_CLOSED, DOOR_OPENING, DOOR_OPEN, DOOR_CLOSING, EMERGENCY);
    signal current_state, next_state : state_type;

    -- Timer constants and signals
    constant OPEN_DELAY  : integer := 625_000_000; -- 625_000_000
    constant EMERGENCY_DELAY  : integer := 625_000_000;
    signal timer_count   : integer range 0 to OPEN_DELAY := 0;
    signal emergency_count   : integer range 0 to EMERGENCY_DELAY := 0;
    signal timer_expired : STD_LOGIC := '0';
    signal emergency_expired : STD_LOGIC := '0';
    signal flash_count   : integer range 0 to 125_000_000;--125_000_000;
    signal flash_expired : STD_LOGIC := '0';
    
    signal strobe        : STD_LOGIC := '0';

begin

    -- State Register Process: Updates the current state on each clock edge
    state_register: process(clock, reset, force_open)
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
                if force_open = '1' then
					next_state <= DOOR_OPENING;  -- Force door open
				elsif motion_sensor = '1' then
					next_state <= DOOR_OPENING;  -- Normal operation
				else
					next_state <= DOOR_CLOSED;
				end if;

            when DOOR_OPENING =>
				if fully_open = '1' and emergency_expired = '0' then
					next_state <= DOOR_OPEN;
				elsif emergency_expired = '1' then
					next_state <= EMERGENCY;
				else
					next_state <= DOOR_OPENING;
				end if;

            when DOOR_OPEN =>              
                if force_open = '1' then
					next_state <= DOOR_OPEN;  -- Stay in DOOR_OPEN if force_open is active
				elsif timer_expired = '1' and motion_sensor = '0' then
					next_state <= DOOR_CLOSING;  -- Close door normally
				else
					next_state <= DOOR_OPEN;
				end if;

            when DOOR_CLOSING =>
                if force_open = '1' then
					next_state <= DOOR_OPENING;  -- Reopen the door if force_open is activated
				elsif fully_closed = '1' then
					next_state <= DOOR_CLOSED;
				elsif motion_sensor = '1' then
					next_state <= DOOR_OPENING;
				elsif emergency_expired = '1' then
					next_state <= EMERGENCY;
				else
					next_state <= DOOR_CLOSING;
				end if;
            
			when EMERGENCY =>
                next_state <= EMERGENCY;
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
            when EMERGENCY =>
                motor <= "00";
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
            when EMERGENCY => 
                --door_rgb <= "111";
                --strobe <= strobe xor flash_expired;
                door_rgb(2) <= strobe;
            when others =>
                door_rgb <= "000"; -- Off (default)
        end case;
    end process;

    ---****ORIGINAL TIMER PROCESS***
    -- timer_process: process(clock, reset)
    -- begin
    --     if reset = '1' then
    --         timer_count <= 0;
    --         timer_expired <= '0';
    --     elsif rising_edge(clock) then
    --         if current_state = DOOR_OPEN then
    --             if timer_count < OPEN_DELAY then
    --                 timer_count <= timer_count + 1;
    --                 timer_expired <= '0';  -- Keep timer_expired '0' until the timer finishes
    --             else
    --                 timer_expired <= '1';  -- Timer is expired after OPEN_DELAY
    --             end if;
    --         elsif (current_state = DOOR_OPENING) or (current_state = DOOR_CLOSING) then
    --             if timer_count < OPEN_DELAY then
    --                 timer_count <= timer_count + 1;
    --                 timer_expired <= '0';  -- Keep timer_expired '0' until the timer finishes
    --             else
    --                 timer_expired <= '1';  -- Timer is expired after OPEN_DELAY
    --             end if;
    --         else
    --             timer_count <= 0;
    --             timer_expired <= '0';      -- Reset the timer when not in the DOOR_OPEN state
    --         end if;
    --     end if;
    -- end process;


    --New Timer Process so that timer is reset or ignored during the force open state  The timer counts up during the DOOR_OPENING and 
    --DOOR_CLOSING states. Once the timer_expired = '1', the FSM transitions to EMERGENCY. Since the timer_expired signal is not 
    --reset appropriately when force_open is used, this could cause the FSM to keep transitioning to EMERGENCY.
	openTimer_process: process(clock, reset, force_open, motion_sensor)
	begin
		if reset = '1' then
			timer_count <= 0;
			timer_expired <= '0';
		elsif rising_edge(clock) then
			if force_open = '1' or motion_sensor = '1' then
				timer_count <= 0;          -- Reset the timer when force_open is active
				timer_expired <= '0';       -- Keep timer_expired at '0' during force_open
				emergency_count <= 0;          -- Reset the timer when force_open is active
				emergency_expired <= '0'; 
			elsif timer_expired = '1' or emergency_expired = '1' then
				timer_count <= 0;          -- Reset the timer when force_open is active
				timer_expired <= '0';
				emergency_count <= 0;          -- Reset the timer when force_open is active
				emergency_expired <= '0';  					  			 
			else
				if current_state = DOOR_OPEN then
					if timer_count < OPEN_DELAY then
						timer_count <= timer_count + 1;
						timer_expired <= '0';  -- Timer is still counting
					else
						timer_expired <= '1';  -- Timer expired after OPEN_DELAY
						timer_count <= 0;
					end if;
				elsif ((current_state = DOOR_OPENING) or (current_state = DOOR_CLOSING)) then
					if emergency_count < EMERGENCY_DELAY then
						emergency_count <= emergency_count + 1;
						emergency_expired <= '0';  -- Timer is still counting
					else
						emergency_expired <= '1';  -- Timer expired after OPEN_DELAY
						emergency_count <= 0;
					end if;
				else
					timer_count <= 0;
					emergency_count <= 0;
				end if;
			end if;
		end if;
	end process;

    --Strobe signal should toggle in the here, not when the state changes
    red_flash: process(clock, reset)
    begin 
        if reset = '1' then
            flash_count <= 0;
            flash_expired <= '0';
            strobe <= '0'; --Initilize the strobe signal LA
        elsif rising_edge(clock) then        
            if (current_state = EMERGENCY) then
                if flash_count < 62_500_000 then
                    flash_count <= flash_count + 1;
                    flash_expired <= '0';  -- Keep timer_expired '0' until the timer finishes
                else
                    flash_count <= 0;       -- Reset the flash counter
                    flash_expired <= '1';  -- Timer is expired after OPEN_DELAY
                    strobe <= not strobe;   -- Update the strobe to flash at 1 Hz LA
                end if;
            else --LA
                flash_count <= 0;           -- Reset the flash counter if not in EMERGENCY
                strobe <= '0';              -- Ensure strobe is off when not in EMERGENCY
            end if;
        end if;       
    end process;
    
end Behavioral;




