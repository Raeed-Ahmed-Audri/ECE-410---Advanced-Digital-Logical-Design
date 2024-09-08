LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;  -- To handle integer operations

ENTITY clock_divider IS
   PORT (
      clock_in  : IN  STD_LOGIC;
      clock_out : OUT STD_LOGIC
   );
END clock_divider;

ARCHITECTURE Behavioral OF clock_divider IS
   SIGNAL clock_div : STD_LOGIC := '0';  -- Signal for divided clock
   SIGNAL counter : INTEGER := 0;        -- Clock cycle counter
   CONSTANT limit : INTEGER := 25000; -- Adjust this limit for the desired division ratio
BEGIN
   -- Process for clock division
   PROCESS (clock_in)
   BEGIN
      IF rising_edge(clock_in) THEN
         IF counter = limit THEN
            counter <= 0;
            clock_div <= NOT clock_div;  -- Toggle the clock output
         ELSE
            counter <= counter + 1;  -- Increment the clock cycle counter
         END IF;
      END IF;
   END PROCESS;

   -- Output the divided clock
   clock_out <= clock_div;

END Behavioral;
