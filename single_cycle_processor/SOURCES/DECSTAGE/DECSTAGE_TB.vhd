LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY DECSTAGE_TB IS
END DECSTAGE_TB;
 
ARCHITECTURE behavior OF DECSTAGE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DECSTAGE
    PORT(
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : IN  std_logic;
         ALU_out : IN  std_logic_vector(31 downto 0);
         MEM_out : IN  std_logic_vector(31 downto 0);
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         ImmExt : IN  std_logic_vector(1 downto 0);
         Clk : IN  std_logic;
         Rst : IN  std_logic;
         Immed : OUT  std_logic_vector(31 downto 0);
         RF_A : OUT  std_logic_vector(31 downto 0);
         RF_B : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrEn : std_logic := '0';
   signal ALU_out : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_out : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';

 	--Outputs
   signal Immed : std_logic_vector(31 downto 0);
   signal RF_A : std_logic_vector(31 downto 0);
   signal RF_B : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DECSTAGE PORT MAP (
          Instr => Instr,
          RF_WrEn => RF_WrEn,
          ALU_out => ALU_out,
          MEM_out => MEM_out,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          Clk => Clk,
          Rst => Rst,
          Immed => Immed,
          RF_A => RF_A,
          RF_B => RF_B
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
	
      Rst <= '1';  -- Hold reset state for 100 ns
      wait for 100 ns;

      Instr <= "11000000001001000000000000001000";  -- rs = 00001 = 1, rd = 00100 = 4, rt = 00000 = 0, Imm = 0000000000001000 = 8
		RF_WrEn <= '0';  -- Disable RF writing
		ALU_out <= "00000000000000000000000000000011";  -- ALU_out = 3
		MEM_out <= "11111111111111111111111111111010";  -- MEM_out = -6
		RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		ImmExt <= "00";  -- ZeroFill(Imm)
		Rst <= '0';
		wait for Clk_period;  -- RF_A = RF[rs], RF_B = RF[rd], Immed = ZeroFill(Imm)
		
		Instr <= "11000000001001000000000000001000";  -- rs = 00001 = 1, rd = 00100 = 4, rt = 00000 = 0, Imm = 0000000000001000 = 8
		RF_WrEn <= '1';  -- Enable RF writing
		ALU_out <= "00000000000000000000000000000011";  -- ALU_out = 3
		MEM_out <= "11111111111111111111111111111010";  -- MEM_out = -6
		RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		ImmExt <= "01";  -- ZeroFill(Imm) and logical shift left by 16 bits
		Rst <= '0';
		wait for Clk_period;  -- RF_A = RF[rs], RF_B = RF[rd], Immed = ZeroFill(Imm) and logical shift left by 16 bits
		
		Instr <= "11000000001001011111111111111000";  -- rs = 00001 = 1, rd = 00101 = 5, rt = 11111 = 31, Imm = 1111111111111000 = -8
		RF_WrEn <= '1';  -- Enable RF writing
		ALU_out <= "00000000000000000000000000000011";  -- ALU_out = 3
		MEM_out <= "11111111111111111111111111111010";  -- MEM_out = -6
		RF_WrData_sel <= '1';  -- Select MEM_out as RF Din
		RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		ImmExt <= "10";  -- SignExtend(Imm)
		Rst <= '0';
		wait for Clk_period;  -- RF_A = RF[rs], RF_B = RF[rd], Immed = SignExtend(Imm)
		
		Instr <= "11000000100000010010000000000000";  -- rs = 00100 = 4, rd = 00001 = 1, rt = 00100 = 4, Imm = 0010000000000000 = 8192
		RF_WrEn <= '0';  -- Disable RF writing
		ALU_out <= "00000000000000000000000000000011";  -- ALU_out = 3
		MEM_out <= "11111111111111111111111111111010";  -- MEM_out = -6
		RF_WrData_sel <= '0';
		RF_B_sel <= '0';  -- Select RF[rt] = Instr(15 downto 11) as second read register
		ImmExt <= "11";  -- SignExtend(Imm) and logical shift left by 2 bits
		Rst <= '0';
		wait for Clk_period;  -- RF_A = RF[rs], RF_B = RF[rt], Immed = SignExtend(Imm) and logical shift left by 2 bits
		
      wait;
   end process;

END;
