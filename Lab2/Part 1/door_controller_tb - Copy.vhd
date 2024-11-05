-- door_controller_tb.vhd
-- Testbench for the door controller FSM with force_open and emergency states

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity door_controller_tb is
end door_controller_tb;

architecture Behavioral of door_controller_tb is

    -- Component declaration of the unit under test (UUT)
    component door_controller
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
    end component;

    -- Signals for the UUT
    signal clock        : STD_LOGIC := '0';
    signal reset        : STD_LOGIC := '0';
    signal motion_sensor: STD_LOGIC := '0';
    signal fully_open   : STD_LOGIC := '0';
    signal fully_closed : STD_LOGIC := '0';
    signal force_open   : STD_LOGIC := '0';
    signal door_rgb     : STD_LOGIC_VECTOR(2 downto 0);
    signal motor        : STD_LOGIC_VECTOR(1 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate the UUT
    uut: door_controller
        Port map (
            clock        => clock,
            reset        => reset,
            motion_sensor=> motion_sensor,
            fully_open   => fully_open,
            fully_closed => fully_closed,
            force_open   => force_open,
            door_rgb     => door_rgb,
            motor        => motor
        );

    -- Clock process to simulate clock signal
    clock_process: process
    begin
        while true loop
            clock <= '0';
            wait for CLK_PERIOD/2;
            clock <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Test process to apply stimulus to the UUT
    stimulus_process: process
    begin
        -- Test Case 1: Force open from DOOR_CLOSED
        wait for 20 ns;
        fully_closed <= '1';
        wait for 20 ns;
        force_open <= '1';  -- Force open
        wait for 40 ns;
        force_open <= '0';  -- Release force open
        wait for 40 ns;

        -- Test Case 2: Force open from DOOR_OPENING
        reset <= '1'; wait for 20 ns; reset <= '0'; -- Reset to start fresh
        motion_sensor <= '1';  -- Start opening door
        wait for 20 ns;
        force_open <= '1';  -- Force open during opening
        wait for 40 ns;
        force_open <= '0';  -- Release force open
        wait for 40 ns;

        -- Test Case 3: Force open from DOOR_OPEN
        reset <= '1'; wait for 20 ns; reset <= '0'; -- Reset to start fresh
        fully_open <= '1';
        wait for 20 ns;
        force_open <= '1';  -- Force open while door is open
        wait for 40 ns;
        force_open <= '0';  -- Release force open
        wait for 40 ns;

        -- Test Case 4: Force open from DOOR_CLOSING
        reset <= '1'; wait for 20 ns; reset <= '0'; -- Reset to start fresh
        fully_open <= '1';  -- Door starts open
        wait for 20 ns;
        motion_sensor <= '0'; -- Timer expires to start closing
        wait for 20 ns;
        fully_open <= '0'; -- Now closing
        wait for 20 ns;
        force_open <= '1';  -- Force open during closing
        wait for 40 ns;
        force_open <= '0';  -- Release force open
        wait for 40 ns;

        -- Test Case 5: Force open with Reset
        reset <= '1';  -- Assert reset during force open
        wait for 20 ns;
        force_open <= '1';  -- Force open should stop once reset is triggered
        wait for 40 ns;
        reset <= '0';  -- Deassert reset
        wait for 40 ns;
        force_open <= '0';
        wait for 40 ns;

        -- Test Case 6: Emergency state and LED flashing
        reset <= '1'; wait for 20 ns; reset <= '0'; -- Reset to start fresh
        fully_open <= '0';  -- Ensure door starts closed
        wait for 20 ns;
        motion_sensor <= '1';  -- Start opening the door
        wait for 100 ns; -- Wait longer to simulate timer expiry (for EMERGENCY state)
        -- At this point, the door should be in EMERGENCY
        -- LED should be flashing (check door_rgb signal)
        wait for 200 ns; -- Observe the LED flashing (strobe toggling)

        wait;
    end process;

end Behavioral;



