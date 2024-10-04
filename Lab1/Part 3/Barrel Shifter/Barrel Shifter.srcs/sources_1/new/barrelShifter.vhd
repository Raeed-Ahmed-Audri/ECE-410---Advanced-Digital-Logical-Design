-- Name: Raeed Ahmed Audri Ben Jose
-- Lab: ECE410 Lab 1
-- Date: 2024-09-24
-- Barrel Shifter (Bit Rotator) for 8-bit vector

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Barrel_Shifter is
    Port (
        DATA         : in  STD_LOGIC_VECTOR (7 downto 0);  -- 8-bit input data
        DIRECTION    : in  STD_LOGIC;                      -- 1-bit direction control (0 for left, 1 for right)
        AMOUNT       : in  STD_LOGIC_VECTOR (2 downto 0);  -- 3-bit shift amount
        SHIFTED_DATA : out STD_LOGIC_VECTOR (7 downto 0)   -- 8-bit rotated output data
    );
end Barrel_Shifter;

architecture Behavioral of Barrel_Shifter is
begin
    process (DATA, DIRECTION, AMOUNT)
    begin
        if DIRECTION = '0' then  -- Rotate left
            case AMOUNT is
                when "000" =>
                    SHIFTED_DATA <= DATA;  -- No rotation
                when "001" =>
                    SHIFTED_DATA <= DATA(6 downto 0) & DATA(7);  -- Rotate left by 1
                when "010" =>
                    SHIFTED_DATA <= DATA(5 downto 0) & DATA(7 downto 6);  -- Rotate left by 2
                when "011" =>
                    SHIFTED_DATA <= DATA(4 downto 0) & DATA(7 downto 5);  -- Rotate left by 3
                when "100" =>
                    SHIFTED_DATA <= DATA(3 downto 0) & DATA(7 downto 4);  -- Rotate left by 4
                when "101" =>
                    SHIFTED_DATA <= DATA(2 downto 0) & DATA(7 downto 3);  -- Rotate left by 5
                when "110" =>
                    SHIFTED_DATA <= DATA(1 downto 0) & DATA(7 downto 2);  -- Rotate left by 6
                when "111" =>
                    SHIFTED_DATA <= DATA(0) & DATA(7 downto 1);  -- Rotate left by 7
                when others =>
                    SHIFTED_DATA <= DATA;  -- Default case
            end case;
        else  -- Rotate right
            case AMOUNT is
                when "000" =>
                    SHIFTED_DATA <= DATA;  -- No rotation
                when "001" =>
                    SHIFTED_DATA <= DATA(0) & DATA(7 downto 1);  -- Rotate right by 1
                when "010" =>
                    SHIFTED_DATA <= DATA(1 downto 0) & DATA(7 downto 2);  -- Rotate right by 2
                when "011" =>
                    SHIFTED_DATA <= DATA(2 downto 0) & DATA(7 downto 3);  -- Rotate right by 3
                when "100" =>
                    SHIFTED_DATA <= DATA(3 downto 0) & DATA(7 downto 4);  -- Rotate right by 4
                when "101" =>
                    SHIFTED_DATA <= DATA(4 downto 0) & DATA(7 downto 5);  -- Rotate right by 5
                when "110" =>
                    SHIFTED_DATA <= DATA(5 downto 0) & DATA(7 downto 6);  -- Rotate right by 6
                when "111" =>
                    SHIFTED_DATA <= DATA(6 downto 0) & DATA(7);  -- Rotate right by 7
                when others =>
                    SHIFTED_DATA <= DATA;  -- Default case
            end case;
        end if;
    end process;

end Behavioral;



