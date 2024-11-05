library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- For numeric operations

entity count_generator_fsm is
    Port (
        clk       : in STD_LOGIC;
        reset     : in STD_LOGIC;
        sel       : in STD_LOGIC;  -- Mode select (0: up-counter, 1: custom sequence)
        en        : in STD_LOGIC;  -- Enable signal
        count_out : out STD_LOGIC_VECTOR(3 downto 0)  -- 4-bit output
    );
end count_generator_fsm;

architecture Behavioral of count_generator_fsm is
    -- State definitions for custom sequence
    type state_type is (
        S0, S1, S2, S3, S4, S5, S6, S7,
        S8, S9, S10, S11, S12, S13, S14, S15
    );  -- 16 states for the custom sequence

    signal state, next_state : state_type;
    signal count             : STD_LOGIC_VECTOR(3 downto 0);
    signal up_counter        : UNSIGNED(3 downto 0);  -- 4-bit up-counter
begin
    -- State transition process for custom sequence
    process (clk, reset)
    begin
        if reset = '1' then
            state <= S0;  -- Reset to initial state
        elsif rising_edge(clk) then
            if en = '1' then
                state <= next_state;  -- Custom sequence state transition
            end if;
        end if;
    end process;

    -- Next state and output logic
    process (state)
    begin
        case state is
            when S0 =>
                count <= "0000";
                if sel = '1' then
                    next_state <= S14;
                else
                    next_state <= S1;
                end if;
            when S1 =>
                count <= "0001";
                if sel = '1' then
                    next_state <= S6;
                else
                    next_state <= S2;
                end if;
            when S2 =>
                count <= "0010";
                if sel = '1' then
                    next_state <= S15;
                else
                    next_state <= S3;
                end if;
            when S3 =>
                count <= "0011";
                if sel = '1' then
                    next_state <= S13;
                else
                    next_state <= S4;
                end if;
            when S4 =>
                count <= "0100";
                if sel = '1' then
                    next_state <= S3;
                else
                    next_state <= S5;
                end if;
            when S5 =>
                count <= "0101";
                if sel = '1' then
                    next_state <= S11;
                else
                    next_state <= S6;
                end if;
            when S6 =>
                count <= "0110";
                if sel = '1' then
                    next_state <= S8;
                else
                    next_state <= S7;
                end if;
            when S7 =>
                count <= "0111";
                if sel = '1' then
                    next_state <= S10;
                else
                    next_state <= S8;
                end if;
            when S8 =>
                count <= "1000";
                if sel = '1' then
                    next_state <= S5;
                else
                    next_state <= S9;
                end if;
            when S9 =>
                count <= "1001";
                if sel = '1' then
                    next_state <= S2;
                else
                    next_state <= S10;
                end if;
            when S10 =>
                count <= "1010";
                if sel = '1' then
                    next_state <= S4;
                else
                    next_state <= S11;
                end if;
            when S11 =>
                count <= "1011";
                if sel = '1' then
                    next_state <= S12;
                else
                    next_state <= S12;
                end if;
            when S12 =>
                count <= "1100";
                if sel = '1' then
                    next_state <= S7;
                else
                    next_state <= S13;
                end if;
            when S13 =>
                count <= "1101";
                if sel = '1' then
                    next_state <= S0;
                else
                    next_state <= S14;
                end if;
            when S14 =>
                count <= "1110";
                if sel = '1' then
                    next_state <= S9;
                else
                    next_state <= S15;
                end if;
            when S15 =>
                count <= "1111";
                if sel = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;
            when others =>
                count <= "0000";
                next_state <= S0;
        end case;

    end process;

    -- Assign the current count to the output
    count_out <= count;
end Behavioral;



