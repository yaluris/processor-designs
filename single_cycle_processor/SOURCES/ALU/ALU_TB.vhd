LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU_TB IS
END ALU_TB;
 
ARCHITECTURE behavior OF ALU_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(3 downto 0);
         Output : OUT  std_logic_vector(31 downto 0);
         Zero : OUT  std_logic;
         Cout : OUT  std_logic;
         Ovf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal Output : std_logic_vector(31 downto 0);
   signal Zero : std_logic;
   signal Cout : std_logic;
   signal Ovf : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
    
   -- constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          A => A,
          B => B,
          Op => Op,
          Output => Output,
          Zero => Zero,
          Cout => Cout,
          Ovf => Ovf
        );

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;


   -- Stimulus process
   stim_proc: process
   begin
	  
	  A <= "00000000000000000000000000000011";  -- Addition (3 + 7 = 10)
	  B <= "00000000000000000000000000000111";
	  Op <= "0000";
	  wait for 50 ns;
	  A <= "01110000000000000000000000000000";  -- Addition (2 positive Two's Complement numbers are added and the result has the opposite sign)
	  B <= "01110000000000000000000000000000";  -- Cout = 0, Ovf = 1
	  wait for 50 ns;
	  A <= "10100000000000000000000000000000";  -- Addition (2 negative Two's Complement numbers are added and the result has the opposite sign)
	  B <= "10100000000000000000000000000000";  -- Cout = 1, Ovf = 1
	  wait for 50 ns;
	  A <= "01110000000000000000000000000000";  -- Addition (adding operands with different signs)
	  B <= "10100000000000000000000000000000";  -- Ovf = 0
	  wait for 50 ns;	  
	  A <= "01100000000000000000000000000000";  -- Addition (adding operands with different signs)
	  B <= "10010000000000000000000000000000";  -- Ovf = 0
	  wait for 50 ns;
	  A <= "01110000000000000000000000000000";  -- Addition (adding opposite numbers)
	  B <= "10010000000000000000000000000000";  -- Zero = 1
	  wait for 50 ns;
	  
	  A <= "00000000000000000000000000000011";  -- Subtraction (3 - 7 = -4)
	  B <= "00000000000000000000000000000111";
	  Op <= "0001";
	  wait for 50 ns;
	  A <= "00000000000000000000000000000011";  -- Subtraction (3 - (-7) = 10)
	  B <= "11111111111111111111111111111001";
	  wait for 50 ns;
	  A <= "01110000000000000000000000000000";  -- Subtraction (2 Two's Complement numbers with opposite signs are subtracted and the result has the same sign as the subtrahend)
	  B <= "10100000000000000000000000000000";  -- Cout = 0, Ovf = 1
	  wait for 50 ns;
	  A <= "00000000000000000000000000000111";  -- Subtraction (subtracting the same number)
	  B <= "00000000000000000000000000000111";  -- Zero = 1
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- AND
	  B <= "00111010110111100110100010110001";
	  Op <= "0010";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- OR
	  B <= "00111010110111100110100010110001";
	  Op <= "0011";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- NOT
	  Op <= "0100";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- NAND
	  B <= "00111010110111100110100010110001";
	  Op <= "0101";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- NOR
	  B <= "00111010110111100110100010110001";
	  Op <= "0110";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- Arithmetic shift right by 1 bit
	  Op <= "1000";
	  wait for 50 ns;
	  A <= "10111010110111100110100010110001";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- Logical shift right by 1 bit
	  Op <= "1001";
	  wait for 50 ns;
	  A <= "10111010110111100110100010110001";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- Logical shift left by 1 bit
	  Op <= "1010";
	  wait for 50 ns;
	  A <= "10111010110111100110100010110001";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- Rotate left by 1 bit
	  Op <= "1100";
	  wait for 50 ns;
	  A <= "10111010110111100110100010110001";
	  wait for 50 ns;
	  
	  A <= "01001001100101100000001011010010";  -- Rotate right by 1 bit
	  Op <= "1101";
	  wait for 50 ns;
	  A <= "10111010110111100110100010110001";
	  wait for 50 ns;
	
     wait;
   end process;

END;
