-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1
-- Date: 2024-09-25

-- Block to convert uppercase ASCII characters to lowercase
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Uppercase_To_Lowercase is
    Port (
        ASCII_DATA   : in  STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit input ASCII character
        LOWERCASE_DATA : out  STD_LOGIC_VECTOR (7 downto 0)  -- 8-bit output ASCII lowercase character
    );
end Uppercase_To_Lowercase;

architecture Behavioral of Uppercase_To_Lowercase is
begin
    process(ASCII_DATA)
    begin
        -- Check if the character is an uppercase letter (ASCII 65 to 90)
        if (ASCII_DATA >= x"41" and ASCII_DATA <= x"5A") then
            -- Convert to lowercase by adding 32
            LOWERCASE_DATA <= ASCII_DATA + 32;
        else
            -- If not uppercase, pass it through unchanged
            LOWERCASE_DATA <= ASCII_DATA;
        end if;
    end process;
end Behavioral;
