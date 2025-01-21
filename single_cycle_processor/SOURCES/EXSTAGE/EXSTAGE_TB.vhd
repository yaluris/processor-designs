LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY EXSTAGE_TB IS
END EXSTAGE_TB;
 
ARCHITECTURE behavior OF EXSTAGE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EXSTAGE
    PORT(
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         Immed : IN  std_logic_vector(31 downto 0);
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_out : OUT  std_logic_vector(31 downto 0);
         ALU_zero : OUT  std_logic;
         ALU_cout : OUT  std_logic;
         ALU_ovf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal RF_A : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_B : std_logic_vector(31 downto 0) := (others => '0');
   signal Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_Bin_sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal ALU_out : std_logic_vector(31 downto 0);
   signal ALU_zero : std_logic;
   signal ALU_cout : std_logic;
   signal ALU_ovf : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   -- constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EXSTAGE PORT MAP (
          RF_A => RF_A,
          RF_B => RF_B,
          Immed => Immed,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          ALU_out => ALU_out,
          ALU_zero => ALU_zero,
          ALU_cout => ALU_cout,
          ALU_ovf => ALU_ovf
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
	
	  RF_A <= "10100000000000000000000000000000";
	  RF_B <= "10100000000000000000000000000000";
	  Immed <= "01100000000000000000000000000000";
	  ALU_Bin_sel <= '0';  -- Select RF_B as ALU B input
	  ALU_func <= "0000";  -- Addition
	  wait for 50 ns;  -- Cout = 1, Ovf = 1
	  
	  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
	  wait for 50 ns;  -- Zero = 1
	  
	  RF_A <= "01110000000000000000000000000000";
	  RF_B <= "10100000000000000000000000000000";
	  Immed <= "01110000000000000000000000000000";
	  ALU_Bin_sel <= '0';  -- Select RF_B as ALU B input
	  ALU_func <= "0001";  -- Subtraction
	  wait for 50 ns;  -- Cout = 0, Ovf = 1
	  
	  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
	  wait for 50 ns;  -- Zero = 1
	  
	  RF_A <= "01001001100101100000001011010010";
	  RF_B <= "00000000000000000000000000000000";
	  Immed <= "00111010110111100110100010110001";
	  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
	  ALU_func <= "0010";  -- AND
	  wait for 50 ns;
	  
	  ALU_func <= "0011";  -- OR
	  wait for 50 ns;
	  
	  ALU_func <= "0100";  -- NOT
	  wait for 50 ns;
	  
	  ALU_func <= "0101";  -- NAND
	  wait for 50 ns;
	  
	  ALU_func <= "0110";  -- NOR
	  wait for 50 ns;
	  
	  ALU_func <= "1000";  -- Arithmetic shift right by 1 bit
	  wait for 50 ns;
	  
	  ALU_func <= "1001";  -- Logical shift right by 1 bit
	  wait for 50 ns;
	  
	  ALU_func <= "1010";  -- Logical shift left by 1 bit
	  wait for 50 ns;
	  
	  ALU_func <= "1100";  -- Rotate left by 1 bit
	  wait for 50 ns;
	  
	  ALU_func <= "1101";  -- Rotate right by 1 bit
	  wait for 50 ns;
	  
     wait;
   end process;

END;
