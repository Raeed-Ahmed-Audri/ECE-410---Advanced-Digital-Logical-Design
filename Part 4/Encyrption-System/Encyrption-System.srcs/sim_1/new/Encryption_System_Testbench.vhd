-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1
-- Date: 2024-09-25
-- Testbench for Encryption_System

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Encryption_System_tb is
end Encryption_System_tb;

architecture Behavioral of Encryption_System_tb is

    -- Signals to drive the inputs and observe the outputs
    signal ASCII_DATA : STD_LOGIC_VECTOR(7 downto 0);
    signal KEY        : STD_LOGIC_VECTOR(7 downto 0);
    signal OUTPUT     : STD_LOGIC_VECTOR(7 downto 0);
    signal RED        : STD_LOGIC;
    signal GREEN      : STD_LOGIC;

    -- Clock signal for driving the simulation
    signal clk : STD_LOGIC := '0';

    -- Instantiate the Unit Under Test (UUT)
    component Encryption_System
        Port (
            ASCII_DATA : in  STD_LOGIC_VECTOR(7 downto 0);
            KEY        : in  STD_LOGIC_VECTOR(7 downto 0);
            OUTPUT     : out STD_LOGIC_VECTOR(7 downto 0);
            RED        : out STD_LOGIC;
            GREEN      : out STD_LOGIC
        );
    end component;

begin
    -- Clock process definition (optional, only needed if there is sequential logic involved)
    clk_process : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Instantiate the Encryption_System (UUT)
    uut: Encryption_System
        Port map (
            ASCII_DATA => ASCII_DATA,
            KEY        => KEY,
            OUTPUT     => OUTPUT,
            RED        => RED,
            GREEN      => GREEN
        );

    -- Test cases
    stimulus_process: process
    begin
        -- Test case 1: Valid uppercase character 'A' with key '00001010'
        ASCII_DATA <= "01000001";  -- ASCII for 'A'
        KEY <= "00001010";         -- Sample key
        wait for 20 ns;

        -- Test case 2: Valid uppercase character 'Z' with key '11010101'
        ASCII_DATA <= "01011010";  -- ASCII for 'Z'
        KEY <= "11010101";         -- Sample key
        wait for 20 ns;

--        -- Test case 3: Invalid character '@' with key '01100110'
--        ASCII_DATA <= "01000000";  -- ASCII for '@'
--        KEY <= "01100110";         -- Sample key
--        wait for 20 ns;

--        -- Test case 4: Valid uppercase character 'M' with key '11110000'
--        ASCII_DATA <= "01001101";  -- ASCII for 'M'
--        KEY <= "11110000";         -- Sample key
--        wait for 20 ns;

--        -- Test case 5: Lowercase 'a' (invalid)
--        ASCII_DATA <= "01100001";  -- ASCII for 'a'
--        KEY <= "10110010";         -- Another key
--        wait for 20 ns;

--        -- Test case 6: Random non-character value
--        ASCII_DATA <= "00011110";  -- Non-character ASCII value
--        KEY <= "11011101";         -- Another key
--        wait for 20 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
