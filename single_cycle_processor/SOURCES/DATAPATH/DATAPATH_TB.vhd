LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY DATAPATH_TB IS
END DATAPATH_TB;
 
ARCHITECTURE behavior OF DATAPATH_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DATAPATH
    PORT(
         Clk : IN  std_logic;
         Rst : IN  std_logic;
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         PC : OUT  std_logic_vector(31 downto 0);
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : IN  std_logic;
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         ImmExt : IN  std_logic_vector(1 downto 0);
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_zero : OUT  std_logic;
         ALU_cout : OUT  std_logic;
         ALU_ovf : OUT  std_logic;
         ByteOp : IN  std_logic;
         Mem_WrEn : IN  std_logic;
         MM_WrEn : OUT  std_logic;
         MM_Addr : OUT  std_logic_vector(31 downto 0);
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
    COMPONENT RAM  -- Component Declaration for memory
    PORT(
         clk : IN  std_logic;
         inst_addr : IN  std_logic_vector(10 downto 0);
         inst_dout : OUT  std_logic_vector(31 downto 0);
         data_we : IN  std_logic;
         data_addr : IN  std_logic_vector(10 downto 0);
         data_din : IN  std_logic_vector(31 downto 0);
         data_dout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;


   --Inputs
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal RF_WrEn : std_logic := '0';
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ImmExt : std_logic_vector(1 downto 0) := (others => '0');
   signal ALU_Bin_sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal ByteOp : std_logic := '0';
   signal Mem_WrEn : std_logic := '0';
   signal MM_RdData : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal PC : std_logic_vector(31 downto 0);
   signal ALU_zero : std_logic;
   signal ALU_cout : std_logic;
   signal ALU_ovf : std_logic;
   signal MM_WrEn : std_logic;
   signal MM_Addr : std_logic_vector(31 downto 0);
   signal MM_WrData : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATAPATH PORT MAP (
          Clk => Clk,
          Rst => Rst,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          PC => PC,
          Instr => Instr,
          RF_WrEn => RF_WrEn,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt => ImmExt,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          ALU_zero => ALU_zero,
          ALU_cout => ALU_cout,
          ALU_ovf => ALU_ovf,
          ByteOp => ByteOp,
          Mem_WrEn => Mem_WrEn,
          MM_WrEn => MM_WrEn,
          MM_Addr => MM_Addr,
          MM_WrData => MM_WrData,
          MM_RdData => MM_RdData
        );
		  
   uut2: RAM PORT MAP (
          clk => Clk,
          inst_addr => PC(12 downto 2),
          inst_dout => Instr,
          data_we => MM_WrEn,
          data_addr => MM_Addr(10 downto 0),
          data_din => MM_WrData,
          data_dout => MM_RdData
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
		PC_sel <= '0'; 
		PC_LdEn <= '1'; 
		RF_WrEn <= '1';
		RF_WrData_sel <= '0';
		RF_B_sel <= '1';
		ImmExt <= "10";
		ALU_Bin_sel <= '1';
		ALU_func <= "0000";	
		ByteOp <= '-';
		Mem_WrEn <= '0';
		wait for Clk_period;
		
		Rst <= '0';  -- addi r5,r0,8
		PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		PC_LdEn <= '1';  -- Enable PC writing
	   RF_WrEn <= '1';  -- Enable RF writing
		RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		ImmExt <= "10";  -- SignExtend(Imm)
		ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		ALU_func <= "0000";  -- Add
		ByteOp <= '-';  -- Don't care
		Mem_WrEn <= '0';  -- Disable Memory writing
		wait for Clk_period;
		
		Rst <= '0';  -- ori r3,r0,ABCD
		PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		PC_LdEn <= '1';  -- Enable PC writing
	   RF_WrEn <= '1';  -- Enable RF writing
		RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		ImmExt <= "00";  -- ZeroFill(Imm)
		ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		ALU_func <= "0011";  -- OR
		ByteOp <= '-';  -- Don't care
		Mem_WrEn <= '0';  -- Disable Memory writing
		wait for Clk_period;
			
		Rst <= '0';  -- sw r3,4(r0)
		PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
  	   PC_LdEn <= '1';  -- Enable PC writing
	   RF_WrEn <= '0';  -- Disable RF writing
    	RF_WrData_sel <= '-';  -- Don't care
		RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
	   ImmExt <= "10";  -- SignExtend(Imm)
		ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
	   ALU_func <= "0000";  -- Add (ALU_MEM_Addr <- RF[rs] + SignExtend(Imm))
		ByteOp <= '0';  -- Word
	   Mem_WrEn <= '1';  -- Enable Memory writing 
		wait for Clk_period;

		Rst <= '0';  -- lw r10,-4(r5)
		PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
	   PC_LdEn <= '1';  -- Enable PC writing
		RF_WrEn <= '1';  -- Enable RF writing
		RF_WrData_sel <= '1';  -- Select MEM_out as RF Din
	   RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
	   ImmExt <= "10";  -- SignExtend(Imm)
		ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		ALU_func <= "0000";  -- Add (ALU_MEM_Addr <- RF[rs] + SignExtend(Imm))
		ByteOp <= '0';  -- Word
		Mem_WrEn <= '0';  -- Disable Memory writing  
		wait for Clk_period;
		
		Rst <= '0';  -- lb r16,4(r0)
		PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		PC_LdEn <= '1';  -- Enable PC writing
		RF_WrEn <= '1';  -- Enable RF writing
		RF_WrData_sel <= '1';  -- Select MEM_out as RF Din
		RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		ImmExt <= "10";  -- SignExtend(Imm)
		ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		ALU_func <= "0000";  -- Add (ALU_MEM_Addr <- RF[rs] + SignExtend(Imm))
		ByteOp <= '1';  -- Byte
		Mem_WrEn <= '0';  -- Disable Memory writing
		wait for Clk_period;

		
		Rst <= '0';  -- nand r4,r10,r16
		PC_sel <= '0';  -- Only increment PC by 4 (no branching instructions)
		PC_LdEn <= '1';  -- Enable PC writing
		RF_WrEn <= '1';  -- Enable RF writing
		RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		RF_B_sel <= '0';  -- Select RF[rt] = Instr(15 downto 11) as second read register
		ImmExt <= "00";  -- ZeroFill(Imm) but don't care
		ALU_Bin_sel <= '0';  -- Select RF_B as ALU B input (no immediate)
		ALU_func <= "0101";  -- NAND
		ByteOp <= '-';  -- Don't care
		Mem_WrEn <= '0';  -- Disable Memory writing
		wait for Clk_period;

      wait;
   end process;

END;
