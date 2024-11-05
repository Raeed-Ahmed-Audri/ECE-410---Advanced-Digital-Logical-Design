----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2024 02:00:07 PM
-- Design Name: 
-- Module Name: LSFR_Top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level is
    Port (
        reset       : in  STD_LOGIC;
        sysclk      : in  STD_LOGIC;
        --lfsr_out    : out STD_LOGIC_VECTOR(7 downto 0);  -- Output from LFSR to Constraint file
        segments : out STD_LOGIC_VECTOR(6 downto 0);  -- Output to 7-segment display
        display_select : out STD_LOGIC                    -- Controls which 7-segment display is active
    );
end top_level;

architecture Behavioral of top_level is
    -- Clock divider signal to slow down system clock to 2 Hz
    CONSTANT limit : INTEGER := 62_500_000;

    SIGNAL count        : INTEGER RANGE 1 TO limit:= 1; -- set the counter range
    SIGNAL clock_div: STD_LOGIC := '0';

    -- Signals for LFSR
    signal lfsr_data     : STD_LOGIC_VECTOR(7 downto 0) := (others => '1');
    signal lfsr_custom   : STD_LOGIC_VECTOR(7 downto 0) := (others => '1');
    signal digits        : STD_LOGIC_VECTOR(7 downto 0) := (others => '1');

    -- Component declaration for LFSR
    component LFSR
        Generic ( LFSR_WIDTH : integer := 8 );
        Port (
            reset       : in  STD_LOGIC;
            clk         : in  STD_LOGIC;
            data_out    : buffer STD_LOGIC_VECTOR (LFSR_WIDTH - 1 downto 0);
            custom_out  : buffer STD_LOGIC_VECTOR (LFSR_WIDTH - 1 downto 0)
        );
    end component;

    -- Component declaration for 7-segment display driver (your display_controller)
    component display_controller
        Port (
            digits        : in STD_LOGIC_VECTOR(7 downto 0);  -- Input digits (2 hex)
            clock         : in STD_LOGIC;
            display_select: out STD_LOGIC;                    -- Control for the 7-segment display selection
            segments      : out STD_LOGIC_VECTOR(6 downto 0)  -- Segments for 7-segment display
        );
    end component;

begin

    -- Clock divider process to generate 2 Hz clock
	clock_divider: PROCESS (sysclk)
    BEGIN
        IF rising_edge(sysclk) THEN
            IF count < limit THEN
                count <= count + 1;
            ELSE
                count        <= 1;
                clock_div <= NOT clock_div;
            END IF;
        END IF;
    END PROCESS;

    -- Instantiate the LFSR
    lfsr_instance : LFSR
        generic map (
            LFSR_WIDTH => 8
        )
        port map (
            reset      => reset,
            clk        => clock_div, --Signal clk_2hz
            data_out   => lfsr_data,
            custom_out => lfsr_custom
        );

    digits <= lfsr_custom(3 downto 0) & lfsr_custom(7 downto 4);

    -- Instantiate the 7-segment display driver (using your display_controller)
    display_controller_instance : display_controller
        port map (
            digits        => digits,  -- Connect LFSR output to the display driver
            clock         => sysclk,    -- Use the 2 Hz clock for display refresh
            display_select => display_select, --Change in Constraint File
            segments      => segments  -- Output to the 7-segment display Change in Constraint file
        );

    -- Assign the LFSR output to top-level output


end Behavioral;