-- door_controller_tb.vhd
-- Testbench for the automatic door controller FSM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity door_controller_tb is
end door_controller_tb;

architecture Behavioral of door_controller_tb is

    -- Component Declaration of the Unit Under Test (UUT)
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

    -- Signals to connect to UUT
    signal clock_tb         : STD_LOGIC := '0';
    signal reset_tb         : STD_LOGIC := '0';
    signal motion_sensor_tb : STD_LOGIC := '0';
    signal fully_open_tb    : STD_LOGIC := '0';
    signal fully_closed_tb  : STD_LOGIC := '1'; -- Assume door starts closed
    signal force_open_tb    : STD_LOGIC := '0';
    signal door_rgb_tb      : STD_LOGIC_VECTOR(2 downto 0);
    signal motor_tb         : STD_LOGIC_VECTOR(1 downto 0);

    -- Simulation time constants
    constant CLK_PERIOD : time := 20 ns; -- Clock period (adjust as needed)

begin

    -- Instantiate the UUT
    uut: door_controller
        Port Map (
            clock         => clock_tb,
            reset         => reset_tb,
            motion_sensor => motion_sensor_tb,
            fully_open    => fully_open_tb,
            fully_closed  => fully_closed_tb,
            force_open    => force_open_tb,
            door_rgb      => door_rgb_tb,
            motor         => motor_tb
        );

    -- Clock Generation
    clock_process: process
    begin
        while True loop
            clock_tb <= '0';
            wait for CLK_PERIOD / 2;
            clock_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus Process
    stimulus_process: process
    begin
        -- Initial Reset
        reset_tb <= '1';
        wait for CLK_PERIOD * 2;
        reset_tb <= '0';
        wait for CLK_PERIOD * 2;

        -- Test Case 1: Motion detected, door should start opening
        motion_sensor_tb <= '1';
        fully_closed_tb <= '0';
        wait for CLK_PERIOD * 2;
        assert motor_tb = "01" report "Test Case 1 Failed: Motor should be opening" severity error;

        -- Simulate door reaching fully open position
        fully_open_tb <= '1';
        wait for CLK_PERIOD;
--        fully_open_tb <= '0';
--        wait for CLK_PERIOD;
        assert door_rgb_tb = "010" report "Test Case 1 Failed: Door should be open (Green)" severity error;

        -- Keep motion sensor active for a while
        wait for CLK_PERIOD * 5;

        -- Motion sensor deasserted, timer should start
        motion_sensor_tb <= '0';
        wait for CLK_PERIOD * 2;

        -- Wait for timer to expire (simulate a shorter delay for testing)


        -- Door should start closing
        assert motor_tb = "10" report "Test Case 1 Failed: Motor should be closing" severity error;
    
        wait for CLK_PERIOD * 6;
        --fully_closed_tb <= '1';
        
        -- assert door_rgb_tb = "100" report "Test Case 1 Failed: Motor should be closed" severity error;
        -- end of sanity test
        
        
--        -- test emergency state
--        motion_sensor_tb <= '1';
--        wait for CLK_PERIOD * 2;
--        assert motor_tb = "01" report "Test Case 1 Failed: Motor should be opening" severity error;        
        
--        wait for CLK_PERIOD * 11;
        
--        assert door_rgb_tb = "011" report "Stuck Opening to Emergency Test Failed" severity error;
        
--        wait for CLK_PERIOD * 5;
--        reset_tb <= '1';
--        wait for CLK_PERIOD * 2;
--        reset_tb <= '0';
        

        

        wait;
    end process;

end Behavioral;


