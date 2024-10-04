---- Name: Raeed Ahmed Audri Ben Jose
---- Lab: ECE410 Lab 1
---- Date: 2024-09-24
---- Testbench for Barrel Shifter

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--entity Barrel_Shifter_TB is
--end Barrel_Shifter_TB;

--architecture Behavioral of Barrel_Shifter_TB is

--    -- Component declaration for the Barrel Shifter
--    component Barrel_Shifter
--        Port (
--            DATA         : in  STD_LOGIC_VECTOR(7 downto 0);
--            DIRECTION    : in  STD_LOGIC;
--            AMOUNT       : in  STD_LOGIC_VECTOR (2 downto 0);
--            SHIFTED_DATA : out STD_LOGIC_VECTOR(7 downto 0)
--        );
--    end component;

--    -- Test signals
--    signal DATA         : STD_LOGIC_VECTOR(7 downto 0);
--    signal DIRECTION    : STD_LOGIC;
--    signal AMOUNT       : STD_LOGIC_VECTOR(2 downto 0);
--    signal SHIFTED_DATA : STD_LOGIC_VECTOR(7 downto 0);

--begin

--    -- Instantiate the Barrel Shifter
--    UUT: Barrel_Shifter
--        port map (
--            DATA         => DATA,
--            DIRECTION    => DIRECTION,
--            AMOUNT       => AMOUNT,
--            SHIFTED_DATA => SHIFTED_DATA
--        );

--    -- Test process
--    process
--    begin
--        -- Test case 1: Shift left by 0
--        DATA <= "10101011";  -- Example 8-bit data
--        DIRECTION <= '0';    -- Left shift
--        AMOUNT <= "000";     -- Shift by 0
--        wait for 10 ns;
        
----        -- Test case 2: Shift left by 1
----        AMOUNT <= "001";     -- Shift by 1
----        wait for 10 ns;

----        -- Test case 3: Shift left by 2
----        AMOUNT <= "010";     -- Shift by 2
----        wait for 10 ns;

----        -- Test case 4: Shift left by 3
----        AMOUNT <= "011";     -- Shift by 3
----        wait for 10 ns;

----        -- Test case 5: Shift left by 4
----        AMOUNT <= "100";     -- Shift by 4
----        wait for 10 ns;

----        -- Test case 6: Shift left by 5
----        AMOUNT <= "101";     -- Shift by 5
----        wait for 10 ns;

----        -- Test case 7: Shift left by 6
----        AMOUNT <= "110";     -- Shift by 6
----        wait for 10 ns;

----        -- Test case 8: Shift left by 7
----        AMOUNT <= "111";     -- Shift by 7
----        wait for 10 ns;

----        -- Test case 9: Shift right by 0
----        DIRECTION <= '1';    -- Right shift
----        AMOUNT <= "000";     -- Shift by 0
----        wait for 10 ns;

----        -- Test case 10: Shift right by 1
----        AMOUNT <= "001";     -- Shift by 1
----        wait for 10 ns;

----        -- Test case 11: Shift right by 2
----        AMOUNT <= "010";     -- Shift by 2
----        wait for 10 ns;

----        -- Test case 12: Shift right by 3
----        AMOUNT <= "011";     -- Shift by 3
----        wait for 10 ns;

----        -- Test case 13: Shift right by 4
----        AMOUNT <= "100";     -- Shift by 4
----        wait for 10 ns;

----        -- Test case 14: Shift right by 5
----        AMOUNT <= "101";     -- Shift by 5
----        wait for 10 ns;

----        -- Test case 15: Shift right by 6
----        AMOUNT <= "110";     -- Shift by 6
----        wait for 10 ns;

----        -- Test case 16: Shift right by 7
----        AMOUNT <= "111";     -- Shift by 7
----        wait for 10 ns;

--        -- End simulation
--        wait;
--    end process;

--end Behavioral;
