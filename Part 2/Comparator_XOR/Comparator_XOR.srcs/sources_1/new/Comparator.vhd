-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1

-- Date: 2024-09-25

-- Comparator Block for ASCII uppercase validation
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Comparator_Block is
    Port (
        ASCII_DATA : in  STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit ASCII input
        OUTPUT     : out STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit valid/invalid output
        RED        : out STD_LOGIC;                      -- Red LED signal
        GREEN      : out STD_LOGIC                       -- Green LED signal
    );
end Comparator_Block;

architecture Behavioral of Comparator_Block is
    signal valid_char : STD_LOGIC;
begin
    -- MSB Check (should be "010")
    process(ASCII_DATA)
    begin
        if (ASCII_DATA(7 downto 5) = "010") then
            -- LSB Check (Valid range for uppercase letters)
            -- This part should be derived from the 5-variable truth table.
            case ASCII_DATA(4 downto 0) is
                when "00001" | "00010" | "00011" | "00100" | "00101" | "00110" |
                     "00111" | "01000" | "01001" | "01010" | "01011" | "01100" |
                     "01101" | "01110" | "01111" | "10000" | "10001" | "10010" |
                     "10011" | "10100" | "10101" | "10110" | "10111" | "11000" |
                     "11001" | "11010" =>
                     valid_char <= '1'; -- Valid uppercase letter
                when others =>
                     valid_char <= '0'; -- Invalid character
            end case;
        else
            valid_char <= '0'; -- MSB check failed, invalid character
        end if;
    end process;

    -- Set output and LED signals based on the validity of the character
    OUTPUT <= (others => '0') when valid_char = '0' else ASCII_DATA;
    GREEN <= '1' when valid_char = '1' else '0';
    RED <= '1' when valid_char = '0' else '0';

end Behavioral;
