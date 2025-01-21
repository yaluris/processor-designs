library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DATAPATH_MC is
    Port ( Clk : in  STD_LOGIC;  -- Clock and Reset
	        Rst : in  STD_LOGIC;
			  
			  PC_sel : in  STD_LOGIC;  -- IFSTAGE
			  PC_LdEn : in  STD_LOGIC;
			  PC : out  STD_LOGIC_VECTOR (31 downto 0);
			  
			  Instr : in  STD_LOGIC_VECTOR (31 downto 0);  -- DECSTAGE
			  RF_WrEn : in  STD_LOGIC;
			  RF_WrData_sel : in  STD_LOGIC;
			  RF_B_sel : in  STD_LOGIC;
			  ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
			  
			  ALU_Ain_sel : in  STD_LOGIC;  -- EXSTAGE
			  ALU_Bin_sel : in  STD_LOGIC_VECTOR (1 downto 0);
			  ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_zero : out  STD_LOGIC;
			  ALU_cout : out  STD_LOGIC;
			  ALU_ovf : out  STD_LOGIC;
			  
			  ByteOp : in  STD_LOGIC;  -- MEMSTAGE
			  Mem_WrEn : in  STD_LOGIC;
			  MM_WrEn : out  STD_LOGIC;
			  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
			  MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
			  MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0);
			  
			  IR_WrEn : in  STD_LOGIC;  -- REGISTERS
			  IR_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  ALUOutR_WrEn : in  STD_LOGIC);
end DATAPATH_MC;

architecture Behavioral of DATAPATH_MC is
  signal tmpImmed : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpALU_out : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpMEM_out : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpRF_A : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpRF_B : STD_LOGIC_VECTOR (31 downto 0);
  signal MDR_out : STD_LOGIC_VECTOR (31 downto 0);
  signal A_out : STD_LOGIC_VECTOR (31 downto 0);
  signal B_out : STD_LOGIC_VECTOR (31 downto 0);
  signal ALUOutR_out : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpPC : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpIR_out : STD_LOGIC_VECTOR (31 downto 0);

  COMPONENT IFSTAGE
    PORT(
         IncrementedPC : IN  std_logic_vector(31 downto 0);
			Branch_Addr : IN  std_logic_vector(31 downto 0);
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         Reset : IN  std_logic;
         Clk : IN  std_logic;
         PC : OUT  std_logic_vector(31 downto 0)
        );
  END COMPONENT;
 
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
	 
  COMPONENT EXSTAGE
    PORT(
			PC : IN  std_logic_vector(31 downto 0);
         RF_A : IN  std_logic_vector(31 downto 0);
         RF_B : IN  std_logic_vector(31 downto 0);
         Immed : IN  std_logic_vector(31 downto 0);
         ALU_Ain_sel : IN  std_logic;
			ALU_Bin_sel : IN  std_logic_vector(1 downto 0);
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_out : OUT  std_logic_vector(31 downto 0);
         ALU_zero : OUT  std_logic;
         ALU_cout : OUT  std_logic;
         ALU_ovf : OUT  std_logic
        );
  END COMPONENT;
	 
  COMPONENT MEMSTAGE
    PORT(
         ByteOp : IN  std_logic;
         Mem_WrEn : IN  std_logic;
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         MEM_DataIn : IN  std_logic_vector(31 downto 0);
         MEM_DataOut : OUT  std_logic_vector(31 downto 0);
         MM_WrEn : OUT  std_logic;
         MM_Addr : OUT  std_logic_vector(31 downto 0);
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0)
        );
  END COMPONENT;
  
  COMPONENT REG
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         Datain : IN  std_logic_vector(31 downto 0);
         WE : IN  std_logic;
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
  END COMPONENT;
begin

  InstructionFetch: IFSTAGE PORT MAP (
                      IncrementedPC => tmpALU_out,
							 Branch_Addr => ALUOutR_out,
                      PC_sel => PC_sel,
                      PC_LdEn => PC_LdEn,
                      Reset => Rst,
                      Clk => Clk,
                      PC => tmpPC
                    );

  InstructionDecoding: DECSTAGE PORT MAP (
                         Instr => tmpIR_out,
                         RF_WrEn => RF_WrEn,
                         ALU_out => ALUOutR_out,
                         MEM_out => MDR_out,
                         RF_WrData_sel => RF_WrData_sel,
                         RF_B_sel => RF_B_sel,
                         ImmExt => ImmExt,
                         Clk => Clk,
                         Rst => Rst,
                         Immed => tmpImmed,
                         RF_A => tmpRF_A,
                         RF_B => tmpRF_B
                       );

  Execution: EXSTAGE PORT MAP (
					PC => tmpPC,
               RF_A => A_out,
               RF_B => B_out,
               Immed => tmpImmed,
					ALU_Ain_sel => ALU_Ain_sel,
               ALU_Bin_sel => ALU_Bin_sel,
               ALU_func => ALU_func,
               ALU_out => tmpALU_out,
               ALU_zero => ALU_zero,
               ALU_cout => ALU_cout,
               ALU_ovf => ALU_ovf
             );

  Memory: MEMSTAGE PORT MAP (
            ByteOp => ByteOp,
            Mem_WrEn => Mem_WrEn,
            ALU_MEM_Addr => ALUOutR_out,
            MEM_DataIn => B_out,
            MEM_DataOut => tmpMEM_out,
            MM_WrEn => MM_WrEn,
            MM_Addr => MM_Addr,
            MM_WrData => MM_WrData,
            MM_RdData => MM_RdData
          );
			 
  InstructionRegister: REG PORT MAP (
                         CLK => Clk,
                         RST => Rst,
                         Datain => Instr,
                         WE => IR_WrEn,
                         Dataout => tmpIR_out
                       );
							  
  MemoryDataRegister: REG PORT MAP (
                        CLK => Clk,
                        RST => Rst,
                        Datain => tmpMEM_out,
                        WE => '1',
                        Dataout => MDR_out
                      );
							  
  RegisterA: REG PORT MAP (
               CLK => Clk,
               RST => Rst,
               Datain => tmpRF_A,
               WE => '1',
               Dataout => A_out
             );
							  
  RegisterB: REG PORT MAP (
               CLK => Clk,
               RST => Rst,
               Datain => tmpRF_B,
               WE => '1',
               Dataout => B_out
             );
				 
  ALUOutRegister: REG PORT MAP (
                    CLK => Clk,
                    RST => Rst,
                    Datain => tmpALU_out,
                    WE => ALUOutR_WrEn,
                    Dataout => ALUOutR_out
                  );
						
  PC <= tmpPC;
  IR_out <= tmpIR_out;

end Behavioral;
