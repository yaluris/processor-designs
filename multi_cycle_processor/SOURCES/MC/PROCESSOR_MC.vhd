library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROCESSOR_MC is
    Port ( Clk : in  STD_LOGIC;
	        Rst : in  STD_LOGIC;
			  PC : out  STD_LOGIC_VECTOR (31 downto 0);
			  Instr : in  STD_LOGIC_VECTOR (31 downto 0);
			  MM_WrEn : out  STD_LOGIC;
			  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
			  MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0));
end PROCESSOR_MC;

architecture Behavioral of PROCESSOR_MC is
  signal tmpPC_sel : STD_LOGIC;
  signal tmpPC_LdEn : STD_LOGIC;
  signal tmpRF_WrEn : STD_LOGIC;
  signal tmpRF_WrData_sel : STD_LOGIC;
  signal tmpRF_B_sel : STD_LOGIC;
  signal tmpImmExt : STD_LOGIC_VECTOR (1 downto 0);
  signal tmpALU_Ain_sel : STD_LOGIC;
  signal tmpALU_Bin_sel : STD_LOGIC_VECTOR (1 downto 0);
  signal tmpALU_func : STD_LOGIC_VECTOR (3 downto 0);
  signal tmpALU_zero : STD_LOGIC;
  signal tmpByteOp : STD_LOGIC;
  signal tmpMem_WrEn : STD_LOGIC;
  signal tmpIR_WrEn : STD_LOGIC;
  signal tmpIR_out : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpALUOutR_WrEn : STD_LOGIC;

  COMPONENT DATAPATH_MC
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
			ALU_Ain_sel : IN  std_logic;
         ALU_Bin_sel : IN  std_logic_vector(1 downto 0);
         ALU_func : IN  std_logic_vector(3 downto 0);
         ALU_zero : OUT  std_logic;
         ALU_cout : OUT  std_logic;
         ALU_ovf : OUT  std_logic;
         ByteOp : IN  std_logic;
         Mem_WrEn : IN  std_logic;
         MM_WrEn : OUT  std_logic;
         MM_Addr : OUT  std_logic_vector(31 downto 0);
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0);
			IR_WrEn : IN  std_logic;
			IR_out : OUT  std_logic_vector(31 downto 0);
			ALUOutR_WrEn : IN  std_logic
        );
  END COMPONENT;

  COMPONENT CONTROL_MC
    PORT(
         Clk : IN  std_logic;
         Rst : IN  std_logic;
			PC_sel : OUT  std_logic;
         PC_LdEn : OUT  std_logic;
         Instr : IN  std_logic_vector(31 downto 0);
         RF_WrEn : OUT  std_logic;
         RF_WrData_sel : OUT  std_logic;
         RF_B_sel : OUT  std_logic;
         ImmExt : OUT  std_logic_vector(1 downto 0);
			ALU_Ain_sel : OUT  std_logic;
         ALU_Bin_sel : OUT  std_logic_vector(1 downto 0);
         ALU_func : OUT  std_logic_vector(3 downto 0);
         ALU_zero : IN  std_logic;
         ByteOp : OUT  std_logic;
         Mem_WrEn : OUT  std_logic;
			IR_WrEn : OUT  std_logic;
			ALUOutR_WrEn : OUT  std_logic
        );
  END COMPONENT;
begin

  DatapathMultiCycleUnit: DATAPATH_MC PORT MAP (
                  Clk => Clk,
                  Rst => Rst,
                  PC_sel => tmpPC_sel,
                  PC_LdEn => tmpPC_LdEn,
                  PC => PC,
                  Instr => Instr,
                  RF_WrEn => tmpRF_WrEn,
                  RF_WrData_sel => tmpRF_WrData_sel,
                  RF_B_sel => tmpRF_B_sel,
                  ImmExt => tmpImmExt,
						ALU_Ain_sel => tmpALU_Ain_sel,
                  ALU_Bin_sel => tmpALU_Bin_sel,
                  ALU_func => tmpALU_func,
                  ALU_zero => tmpALU_zero,
                  ALU_cout => open,
                  ALU_ovf => open,
                  ByteOp => tmpByteOp,
                  Mem_WrEn => tmpMem_WrEn,
                  MM_WrEn => MM_WrEn,
                  MM_Addr => MM_Addr,
                  MM_WrData => MM_WrData,
                  MM_RdData => MM_RdData,
						IR_WrEn => tmpIR_WrEn,
						IR_out => tmpIR_out,
						ALUOutR_WrEn => tmpALUOutR_WrEn
                );

  ControlMultiCycleUnit: CONTROL_MC PORT MAP (
                 Clk => Clk,
                 Rst => Rst,
                 PC_sel => tmpPC_sel,
                 PC_LdEn => tmpPC_LdEn,
                 Instr => tmpIR_out,
                 RF_WrEn => tmpRF_WrEn,
                 RF_WrData_sel => tmpRF_WrData_sel,
                 RF_B_sel => tmpRF_B_sel,
                 ImmExt => tmpImmExt,
					  ALU_Ain_sel => tmpALU_Ain_sel,
                 ALU_Bin_sel => tmpALU_Bin_sel,
                 ALU_func => tmpALU_func,
                 ALU_zero => tmpALU_zero,
                 ByteOp => tmpByteOp,
                 Mem_WrEn => tmpMem_WrEn,
					  IR_WrEn => tmpIR_WrEn,
					  ALUOutR_WrEn => tmpALUOutR_WrEn
               );

end Behavioral;
