-- Testbench for door_controller.vhd with EMERGENCY state and force_open input

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity door_controller_tb is
end door_controller_tb;

architecture Behavioral of door_controller_tb is

    -- Signals to connect to the DUT (Device Under Test)
    signal clock         : std_logic := '0';
    signal reset         : std_logic := '0';
    signal motion_sensor : std_logic := '0';
    signal fully_open    : std_logic := '0';
    signal fully_closed  : std_logic := '0';
    signal force_open    : std_logic := '0';
    signal door_rgb      : std_logic_vector(2 downto 0);
    signal motor         : std_logic_vector(1 downto 0);

    -- Clock period constant (adjust based on your FPGA clock)
    constant clock_period : time := 10 ns;

    -- Instantiate the DUT (Device Under Test)
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

begin
    -- Instantiate the DUT
    UUT: door_controller
        Port map (
            clock         => clock,
            reset         => reset,
            motion_sensor => motion_sensor,
            fully_open    => fully_open,
            fully_closed  => fully_closed,
            force_open    => force_open,
            door_rgb      => door_rgb,
            motor         => motor
        );

    -- Clock Generation Process
    clock_process: process
    begin
        while true loop
            clock <= '0';
            wait for clock_period / 2;
            clock <= '1';
            wait for clock_period / 2;
        end loop;
    end process;

    -- Stimulus Process (Test scenarios)
    stimulus_process: process
    begin
        -- Reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Test 1: Normal operation (door opens and closes normally)
        motion_sensor <= '1';  -- Motion detected, door should open
        wait for 50 ns;
        fully_open <= '1';     -- Door fully opens
        wait for 50 ns;
        fully_open <= '0';     -- Simulate door staying open
        wait for 50 ns;
        fully_closed <= '1';   -- Door fully closes
        wait for 50 ns;
        fully_closed <= '0';

        -- Test 2: Door stuck in DOOR_OPENING (EMERGENCY after 5 seconds)
        motion_sensor <= '1';  -- Motion detected, door should open
        wait for 50 ns;
        motion_sensor <= '0';  -- No more motion detected
        -- Wait for door to get stuck in DOOR_OPENING (longer than 5 seconds)
        wait for 6 sec;
        assert (motor = "00") report "Error: EMERGENCY state not entered!" severity error;

        -- Test 3: Reset the system from EMERGENCY state
        reset <= '1';          -- Reset the system
        wait for 20 ns;
        reset <= '0';
        wait for 50 ns;

        -- Test 4: Test force_open input (manual override)
        force_open <= '1';     -- Force door to open
        wait for 50 ns;
        fully_open <= '1';     -- Door fully opens
        force_open <= '0';     -- Disable force_open
        wait for 50 ns;
        fully_open <= '0';

        -- Test 5: Door stuck in DOOR_CLOSING (EMERGENCY after 5 seconds)
        fully_open <= '1';     -- Start with door fully open
        motion_sensor <= '0';  -- No motion
        wait for 50 ns;
        fully_open <= '0';
        fully_closed <= '0';   -- Door starts closing
        wait for 6 sec;        -- Wait for the door to get stuck in DOOR_CLOSING
        assert (motor = "00") report "Error: EMERGENCY state not entered from DOOR_CLOSING!" severity error;

        -- End of testbench
        wait;
    end process;

end Behavioral;






