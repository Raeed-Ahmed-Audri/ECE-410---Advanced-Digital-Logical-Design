-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1

-- Date: 2024-09-24

-- Testbench for XOR Encryption/Decryption System
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XOR_Testbench is
end XOR_Testbench;

architecture Behavioral of XOR_Testbench is
    -- Signals to hold inputs and outputs
    signal DATA : STD_LOGIC_VECTOR(7 downto 0);
    signal KEY  : STD_LOGIC_VECTOR(7 downto 0);
    signal ENCRYPTED_DATA : STD_LOGIC_VECTOR(7 downto 0);
    signal DECRYPTED_DATA : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    -- Instantiate the encryption block
    U1: entity work.XOR_Encryption
        port map (
            DATA => DATA,
            KEY => KEY,
            OUT_DATA => ENCRYPTED_DATA
        );

    -- Instantiate the decryption block
    U2: entity work.XOR_Decryption
        port map (
            ENCRYPTED_DATA => ENCRYPTED_DATA,
            KEY => KEY,
            DECRYPTED_DATA => DECRYPTED_DATA
        );

    -- Test process
    process
    begin
        -- Test case 1
        DATA <= "00000000";  -- All zeros
        KEY  <= "00001101";  -- 3 '1's in the key
        wait for 10 ns;
        
        -- Test case 2
        DATA <= "11111111";  -- All ones
        KEY  <= "11110011";  -- 4 '1's in the key
        wait for 10 ns;

        -- Test case 3
        DATA <= "10101010";  -- Alternating 1's and 0's
        KEY  <= "01100110";  -- Random key
        wait for 10 ns;

        -- Test case 4
        DATA <= "01010101";  -- Alternating 0's and 1's
        KEY  <= "10011001";  -- Random key
        wait for 10 ns;

        -- Test case 5
        DATA <= "11110000";  -- Leading ones
        KEY  <= "00111100";  -- Random key
        wait for 10 ns;

        -- Test case 6
        DATA <= "00001111";  -- Trailing ones
        KEY  <= "11100011";  -- Random key
        wait for 10 ns;

        -- Test case 7
        DATA <= "00110011";  -- Double pattern
        KEY  <= "10101010";  -- Random key
        wait for 10 ns;

        -- Test case 8
        DATA <= "11001100";  -- Complement of previous
        KEY  <= "01010101";  -- Random key
        wait for 10 ns;

        -- Test case 9
        DATA <= "10000000";  -- Only the MSB set
        KEY  <= "11000011";  -- Random key
        wait for 10 ns;

        -- Test case 10
        DATA <= "00000001";  -- Only the LSB set
        KEY  <= "11110000";  -- Random key
        wait for 10 ns;

        -- Test case 11
        DATA <= "01111111";  -- All bits but MSB set
        KEY  <= "10101001";  -- Random key
        wait for 10 ns;

        -- Test case 12
        DATA <= "11101100";  -- Random data
        KEY  <= "00001111";  -- Random key
        wait for 10 ns;

        -- Test case 13
        DATA <= "01011010";  -- Random data
        KEY  <= "01111010";  -- Random key
        wait for 10 ns;

        -- Test case 14
        DATA <= "11010111";  -- Random data
        KEY  <= "10111100";  -- Random key
        wait for 10 ns;

        -- Test case 15
        DATA <= "10011011";  -- Random data
        KEY  <= "00110101";  -- Random key
        wait for 10 ns;

        -- Test case 16
        DATA <= "11111100";  -- Random data
        KEY  <= "11011001";  -- Random key
        wait for 10 ns;

        -- Test case 17
        DATA <= "10110011";  -- Random data
        KEY  <= "01100011";  -- Random key
        wait for 10 ns;

        -- Test case 18
        DATA <= "01010100";  -- Random data
        KEY  <= "00111111";  -- Random key
        wait for 10 ns;

        -- Test case 19
        DATA <= "00100101";  -- Random data
        KEY  <= "11010101";  -- Random key
        wait for 10 ns;

        -- Test case 20
        DATA <= "11011011";  -- Random data
        KEY  <= "10110011";  -- Random key
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
