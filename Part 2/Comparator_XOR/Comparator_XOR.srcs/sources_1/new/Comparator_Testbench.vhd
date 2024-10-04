-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1
-- Date: 2024-09-24
-- Testbench for Comparator, XOR Encryption, and XOR Decryption system

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Testbench_System is
end Testbench_System;

architecture Behavioral of Testbench_System is

    -- Signals to hold inputs and outputs
    signal ASCII_DATA    : STD_LOGIC_VECTOR(7 downto 0);
    signal OUTPUT_DATA   : STD_LOGIC_VECTOR(7 downto 0);
    signal RED           : STD_LOGIC;
    signal GREEN         : STD_LOGIC;
    signal ENCRYPTED_DATA: STD_LOGIC_VECTOR(7 downto 0);
    signal DECRYPTED_DATA: STD_LOGIC_VECTOR(7 downto 0);
    signal KEY           : STD_LOGIC_VECTOR(7 downto 0) := "10110011";  -- Example key

begin

    -- Instantiate the Comparator Block
    Comparator_inst: entity work.Comparator_Block
        port map (
            ASCII_DATA => ASCII_DATA,
            OUTPUT     => OUTPUT_DATA,
            RED        => RED,
            GREEN      => GREEN
        );

    -- Instantiate the XOR Encryption Block
    Encryption_inst: entity work.XOR_Encryption
        port map (
            DATA     => OUTPUT_DATA,
            KEY      => KEY,
            OUT_DATA => ENCRYPTED_DATA
        );

    -- Instantiate the XOR Decryption Block
    Decryption_inst: entity work.XOR_Decryption
        port map (
            ENCRYPTED_DATA => ENCRYPTED_DATA,
            KEY            => KEY,
            DECRYPTED_DATA => DECRYPTED_DATA
        );

    -- Test process
    process
    begin
        -- Test case 1: Valid uppercase letter 'A' (ASCII 65 -> 01000001)
        ASCII_DATA <= "01000001";  -- ASCII 'A'
        wait for 10 ns;

        -- Test case 2: Valid uppercase letter 'Z' (ASCII 90 -> 01011010)
        ASCII_DATA <= "01011010";  -- ASCII 'Z'
        wait for 10 ns;

        -- Test case 3: Invalid character '@' (ASCII 64 -> 01000000)
        ASCII_DATA <= "01000000";  -- ASCII '@'
        wait for 10 ns;

        -- Test case 4: Valid uppercase letter 'M' (ASCII 77 -> 01001101)
        ASCII_DATA <= "01001101";  -- ASCII 'M'
        wait for 10 ns;

        -- Test case 5: Invalid lowercase letter 'a' (ASCII 97 -> 01100001)
        ASCII_DATA <= "01100001";  -- ASCII 'a'
        wait for 10 ns;

        -- Test case 6: Invalid non-character value (ASCII 30 -> 00011110)
        ASCII_DATA <= "00011110";  -- ASCII non-character
        wait for 10 ns;

        -- Test case 7: Valid uppercase letter 'B' (ASCII 66 -> 01000010)
        ASCII_DATA <= "01000010";  -- ASCII 'B'
        wait for 10 ns;
-- Is there anyway to switch case by case on the simulations?
        
        wait;
    end process;

end Behavioral;
