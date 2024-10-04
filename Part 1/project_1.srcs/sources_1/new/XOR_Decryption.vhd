-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1

-- Date: 2024-09-24

-- XOR Decryption

-- Library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Include numeric_std for logical operations on vectors

-- Entity declaration for the XOR decryption block
entity XOR_Decryption is
    Port (
        ENCRYPTED_DATA : in  STD_LOGIC_VECTOR (7 downto 0);  -- Encrypted 8-bit data input
        KEY            : in  STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit encryption key
        DECRYPTED_DATA : out STD_LOGIC_VECTOR (7 downto 0)   -- 8-bit decrypted output
    );
end XOR_Decryption;

-- Architecture declaration for the XOR decryption block
architecture Behavioral of XOR_Decryption is
begin
    -- Convert ENCRYPTED_DATA and KEY to UNSIGNED for the XOR operation, then convert the result back to STD_LOGIC_VECTOR
    DECRYPTED_DATA <= std_logic_vector(unsigned(ENCRYPTED_DATA) XOR unsigned(KEY));
end Behavioral;
