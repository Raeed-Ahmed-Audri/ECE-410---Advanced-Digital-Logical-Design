-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1
-- Date: 2024-09-25
-- Test bench for the Encryption System

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Encryption_System_tb is
end Encryption_System_tb;

architecture Behavioral of Encryption_System_tb is

    -- Component Declaration for Encryption_System
    component Encryption_System
        Port (
            ASCII_DATA : in  STD_LOGIC_VECTOR(7 downto 0);  -- Input: 8-bit ASCII data
            KEY        : in  STD_LOGIC_VECTOR(7 downto 0);  -- Input: 8-bit encryption key
            OUTPUT     : out STD_LOGIC_VECTOR(7 downto 0);  -- Output: 8-bit encrypted/decrypted data
            RED        : out STD_LOGIC;                     -- Output: Red LED (invalid character indicator)
            GREEN      : out STD_LOGIC                      -- Output: Green LED (valid character indicator)
        );
    end component;

    -- Signals for connecting to UUT (Unit Under Test)
    signal ASCII_DATA : STD_LOGIC_VECTOR(7 downto 0);
    signal KEY        : STD_LOGIC_VECTOR(7 downto 0);
    signal OUTPUT     : STD_LOGIC_VECTOR(7 downto 0);
    signal RED        : STD_LOGIC;
    signal GREEN      : STD_LOGIC;

begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: entity work.Encryption_System
        Port map (
            ASCII_DATA => ASCII_DATA,
            KEY        => KEY,
            OUTPUT     => OUTPUT,
            RED        => RED,
            GREEN      => GREEN
        );

    -- Stimulus process for testing different cases
    process
    begin
        -- Test case 1: Valid uppercase letter 'A' with key
        ASCII_DATA <= "01000001";  -- ASCII for 'A'
        KEY <= "11010011";         -- Example key with MSB as shift direction, and LSBs as shift amount
        wait for 20 ns;

        -- Test case 2: Valid uppercase letter 'Z' with key
        ASCII_DATA <= "01011010";  -- ASCII for 'Z'
        KEY <= "01100101";         -- Different key
        wait for 20 ns;

        -- Test case 3: Invalid character '@'
        ASCII_DATA <= "01000000";  -- ASCII for '@'
        KEY <= "10101100";         -- Another key
        wait for 20 ns;

        -- Test case 4: Valid uppercase letter 'M' with key
        ASCII_DATA <= "01001101";  -- ASCII for 'M'
        KEY <= "11100011";         -- Another key
        wait for 20 ns;

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

