-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1

-- Date: 2024-09-25

-- XOR Encryption


-- Library declaration
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Include numeric_std for logical operations on vectors

-- Entity declaration for the XOR encryption block
entity XOR_Encryption is
    Port (
        DATA   : in  STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit data input
        KEY    : in  STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit encryption key
        OUT_DATA : out STD_LOGIC_VECTOR (7 downto 0) -- 8-bit encrypted output
    );
end XOR_Encryption;

-- Architecture declaration for the XOR encryption block
architecture Behavioral of XOR_Encryption is
begin
    -- Convert DATA and KEY to UNSIGNED for the XOR operation, then convert the result back to STD_LOGIC_VECTOR
    OUT_DATA <= std_logic_vector(unsigned(DATA) XOR unsigned(KEY));
end Behavioral;
