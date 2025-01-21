LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CONTROL_TB IS
END CONTROL_TB;
 
ARCHITECTURE behavior OF CONTROL_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CONTROL
    PORT(
         PC_sel : OUT  std_logic;
         PC_LdEn : OUT  std_logic;
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : OUT  std_logic;
         RF_WrData_sel : OUT  std_logic;
         RF_B_sel : OUT  std_logic;
         ImmExt : OUT  std_logic_vector(1 downto 0);
         ALU_Bin_sel : OUT  std_logic;
         ALU_func : OUT  std_logic_vector(3 downto 0);
         ALU_zero : IN  std_logic;
         ByteOp : OUT  std_logic;
         Mem_WrEn : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_zero : std_logic := '0';

 	--Outputs
   signal PC_sel : std_logic;
   signal PC_LdEn : std_logic;
   signal RF_WrEn : std_logic;
   signal RF_WrData_sel : std_logic;
   signal RF_B_sel : std_logic;
   signal ImmExt : std_logic_vector(1 downto 0);
   signal ALU_Bin_sel : std_logic;
   signal ALU_func : std_logic_vector(3 downto 0);
   signal ByteOp : std_logic;
   signal Mem_WrEn : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name

   -- constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CONTROL PORT MAP (
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          Instr => Instr,
          RF_WrEn => RF_WrEn,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          ALU_zero => ALU_zero,
          ByteOp => ByteOp,
          Mem_WrEn => Mem_WrEn
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
	
	   Instr <= "10000000001000100001100000110000";  -- add r2,r1,r3
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000110001";  -- sub r2,r1,r3
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000110010";  -- and r2,r1,r3
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000110011";  -- or r2,r1,r3
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000110100";  -- not r2,r1
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000110101";  -- nand r2,r1,r3
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000110110";  -- nor r2,r1,r3
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000111000";  -- sra r2,r1
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000111001";  -- srl r2,r1
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000111010";  -- sll r2,r1
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000111100";  -- rol r2,r1
      wait for 50 ns;
		
		Instr <= "10000000001000100001100000111101";  -- ror r2,r1
      wait for 50 ns;
		
		Instr <= "11100000000000100000000000000011";  -- li r2,3
      wait for 50 ns;
		
		Instr <= "11100100000000100000000000000011";  -- lui r2,3
      wait for 50 ns;
		
		Instr <= "11000000000000100000000000000011";  -- addi r2,r1,3
      wait for 50 ns;
		
		Instr <= "11001000000000100000000000000011";  -- nandi r2,r1,3
      wait for 50 ns;
		
		Instr <= "11001100000000100000000000000011";  -- ori r2,r1,3
      wait for 50 ns;
		
		Instr <= "11111100000000100000000000001010";  -- b 10
      wait for 50 ns;
		
		Instr <= "00000000010000100000000000001010";  -- beq r2,r2,10
      wait for 50 ns;
		
		Instr <= "00000100010000100000000000001010";  -- bne r2,r2,10
      wait for 50 ns;
		
		Instr <= "00001100001000100000000000000011";  -- lb r2,3(r1)
      wait for 50 ns;
		
		Instr <= "00011100001000100000000000001010";  -- sb r2,10(r1)
      wait for 50 ns;
		
		Instr <= "00111100001000100000000000000011";  -- lw r2,3(r1)
      wait for 50 ns;
		
		Instr <= "01111100001000100000000000001010";  -- sw r2,10(r1)
      wait for 50 ns;

      wait;
   end process;

END;
