-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1
-- Date: 2024-09-25
-- Top-level design for the encryption-decryption system with uppercase to lowercase conversion

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Encryption_System is
    Port (
        ASCII_DATA : in  STD_LOGIC_VECTOR (7 downto 0);  -- Input: 8-bit ASCII data
        KEY        : in  STD_LOGIC_VECTOR (7 downto 0);  -- Input: 8-bit encryption key
        OUTPUT     : out STD_LOGIC_VECTOR (7 downto 0);  -- Output: 8-bit encrypted/decrypted data
        led6_r        : out STD_LOGIC;                      -- Output: Red LED (invalid character indicator)
        led6_g      : out STD_LOGIC                       -- Output: Green LED (valid character indicator)
    );
end Encryption_System;

architecture Behavioral of Encryption_System is

    -- Internal signals
    signal VALID_DATA      : STD_LOGIC_VECTOR(7 downto 0); -- Output from comparator block
    signal SHIFTED_DATA    : STD_LOGIC_VECTOR(7 downto 0); -- Data after first barrel shifting
    signal ENCRYPTED_DATA  : STD_LOGIC_VECTOR(7 downto 0); -- Data after XOR encryption
    signal DECRYPTED_DATA  : STD_LOGIC_VECTOR(7 downto 0); -- Data after XOR decryption
    signal FINAL_DATA      : STD_LOGIC_VECTOR(7 downto 0); -- Data after reverse barrel shifting
    signal LOWERCASE_DATA  : STD_LOGIC_VECTOR(7 downto 0); -- Data after conversion to lowercase

    -- Signals for barrel shifter control
    signal SHIFT_DIRECTION : STD_LOGIC;                    -- Direction for barrel shift (0 = left, 1 = right)
    signal SHIFT_AMOUNT    : STD_LOGIC_VECTOR(2 downto 0); -- 3-bit shift amount derived from LSBs of the key

    -- Intermediate signal for reverse shift direction
    signal REVERSE_SHIFT_DIRECTION : STD_LOGIC;

begin

    -- Comparator Block: Ensure that only valid uppercase ASCII letters are passed through
    COMP: entity work.Comparator_Block
        Port map (
            ASCII_DATA => ASCII_DATA,
            OUTPUT     => VALID_DATA,
            RED        => led6_r,
            GREEN      => led6_g
        );

    -- Extract the shift direction and amount from the key
    SHIFT_DIRECTION <= KEY(7);           -- MSB of the key controls the direction
    SHIFT_AMOUNT    <= KEY(2 downto 0);  -- LSBs of the key control the shift amount

    -- Barrel Shifter: Shift the valid data based on the key
    SHIFT: entity work.Barrel_Shifter
        Port map (
            DATA         => VALID_DATA,       -- Input is valid data from comparator
            DIRECTION    => SHIFT_DIRECTION,  -- Shift direction based on key
            AMOUNT       => SHIFT_AMOUNT,     -- Shift amount based on key
            SHIFTED_DATA => SHIFTED_DATA      -- Output shifted data
        );

    -- XOR Encryption Block: Perform XOR operation on shifted data with the key
    ENCRYPT: entity work.XOR_Encryption
        Port map (
            DATA     => SHIFTED_DATA,  -- Input is the shifted data
            KEY      => KEY,           -- Use the same key for encryption
            OUT_DATA => ENCRYPTED_DATA -- Output is the encrypted data
        );

    -- XOR Decryption Block: Decrypt the encrypted data by XORing again with the key
    DECRYPT: entity work.XOR_Decryption
        Port map (
            ENCRYPTED_DATA => ENCRYPTED_DATA, -- Input is the encrypted data
            KEY            => KEY,            -- Use the same key for decryption
            DECRYPTED_DATA => DECRYPTED_DATA  -- Output is the decrypted data
        );

    -- Reverse the shift direction for the barrel shifter after decryption
    REVERSE_SHIFT_DIRECTION <= not SHIFT_DIRECTION;

    -- Second Barrel Shifter: Reverse the shift after decryption
    REVERSE_SHIFT: entity work.Barrel_Shifter
        Port map (
            DATA         => DECRYPTED_DATA,            -- Input is the decrypted data
            DIRECTION    => REVERSE_SHIFT_DIRECTION,   -- Reversed shift direction for decryption
            AMOUNT       => SHIFT_AMOUNT,              -- Shift amount remains the same
            SHIFTED_DATA => FINAL_DATA                 -- Output is the final decrypted and shifted data
        );

    -- Uppercase to Lowercase Conversion Block
    UCASE_TO_LCASE: entity work.Uppercase_To_Lowercase
        Port map (
            ASCII_DATA     => FINAL_DATA,      -- Input is the decrypted and shifted data
            LOWERCASE_DATA => LOWERCASE_DATA  -- Output is the converted lowercase data
        );

    -- Output the final shifted and decrypted lowercase data as the final output
    OUTPUT <= LOWERCASE_DATA;

end Behavioral;


