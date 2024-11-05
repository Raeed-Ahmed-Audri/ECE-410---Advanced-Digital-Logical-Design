----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/10/2024 09:14:56 PM
-- Design Name: 
-- Module Name: LFSR - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LFSR is
  Generic ( LFSR_WIDTH : integer := 4);
  Port ( 
    reset                   : in STD_LOGIC;
    clk                     : in STD_LOGIC;
    data_out, custom_out    : buffer STD_LOGIC_VECTOR (LFSR_WIDTH - 1 downto 0) := (others => '1')
  );

end LFSR;
    

    
architecture Behavioral of LFSR is
    
begin

    
    process(clk, reset)
    begin
        if (reset = '1') then 
            data_out <= (others => '1');
            custom_out <= (others => '1');
            
        elsif (clk'event and clk = '1') then
            -- GENERIC IMPLEMENTATION
--            data_out(LFSR_WIDTH - 1) <= data_out(0); -- deals with looping LSB to MSB
--            for i in LFSR_WIDTH - 2 downto 0 loop    -- deals with all the other bit shifts
--                data_out(i) <= data_out(i + 1);
--            end loop;
            -- END OF BLOCK
            
            data_out(7) <= data_out(0);
            data_out(6) <= data_out(7) xor data_out(1) ;
            data_out(5) <= data_out(6);
            data_out(4) <= data_out(5);
            data_out(3) <= data_out(4);
            data_out(2) <= data_out(3) xor data_out(1) ;
            data_out(1) <= data_out(2) xor data_out(1) ;
            data_out(0) <= data_out(1);
            
            custom_out(7) <= custom_out(0);
            custom_out(6) <= custom_out(7) xor custom_out(1) ;
            custom_out(5) <= custom_out(6);
            custom_out(4) <= custom_out(5);
            custom_out(3) <= custom_out(4);
            custom_out(2) <= custom_out(3);
            custom_out(1) <= custom_out(2);
            custom_out(0) <= custom_out(1);
            
        end if;
    end process;
    
end Behavioral;





