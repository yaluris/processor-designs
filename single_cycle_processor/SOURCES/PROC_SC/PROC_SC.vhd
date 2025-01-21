library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROC_SC is
    Port ( Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC);
end PROC_SC;

architecture Behavioral of PROC_SC is
  signal tmpPC_sel : STD_LOGIC;
  signal tmpPC_LdEn : STD_LOGIC;
  signal tmpPC : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpInstr : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpRF_WrEn : STD_LOGIC;
  signal tmpRF_WrData_sel : STD_LOGIC;
  signal tmpRF_B_sel : STD_LOGIC;
  signal tmpImmExt : STD_LOGIC_VECTOR (1 downto 0); 
  signal tmpALU_Bin_sel : STD_LOGIC;
  signal tmpALU_func : STD_LOGIC_VECTOR (3 downto 0);
  signal tmpALU_zero : STD_LOGIC;
  signal tmpByteOp : STD_LOGIC;
  signal tmpMem_WrEn : STD_LOGIC;
  signal tmpMM_WrEn : STD_LOGIC;
  signal tmpMM_Addr : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpMM_WrData : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpMM_RdData : STD_LOGIC_VECTOR (31 downto 0);

  COMPONENT RAM
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
begin

  RAMUnit: RAM PORT MAP (
             clk => Clk,
             inst_addr => tmpPC(12 downto 2),  -- Convert address from 32bit to 11bit (ignore the 2 least significant bits because they refer to the bytes within the word). When PC increases by 4, RAM address increases by 1
             inst_dout => tmpInstr,
             data_we => tmpMM_WrEn,
             data_addr => tmpMM_Addr(10 downto 0),
             data_din => tmpMM_WrData,
             data_dout => tmpMM_RdData
           );

  DatapathUnit: DATAPATH PORT MAP (
                  Clk => Clk,
                  Rst => Rst,
                  PC_sel => tmpPC_sel,
                  PC_LdEn => tmpPC_LdEn,
                  PC => tmpPC,
                  Instr => tmpInstr,
                  RF_WrEn => tmpRF_WrEn,
                  RF_WrData_sel => tmpRF_WrData_sel,
                  RF_B_sel => tmpRF_B_sel,
                  ImmExt => tmpImmExt,
                  ALU_Bin_sel => tmpALU_Bin_sel,
                  ALU_func => tmpALU_func,
                  ALU_zero => tmpALU_zero,
                  ALU_cout => open,
                  ALU_ovf => open,
                  ByteOp => tmpByteOp,
                  Mem_WrEn => tmpMem_WrEn,
                  MM_WrEn => tmpMM_WrEn,
                  MM_Addr => tmpMM_Addr,
                  MM_WrData => tmpMM_WrData,
                  MM_RdData => tmpMM_RdData
                );

  ControlUnit: CONTROL PORT MAP (
                 PC_sel => tmpPC_sel,
                 PC_LdEn => tmpPC_LdEn,
                 Instr => tmpInstr,
                 RF_WrEn => tmpRF_WrEn,
                 RF_WrData_sel => tmpRF_WrData_sel,
                 RF_B_sel => tmpRF_B_sel,
                 ImmExt => tmpImmExt,
                 ALU_Bin_sel => tmpALU_Bin_sel,
                 ALU_func => tmpALU_func,
                 ALU_zero => tmpALU_zero,
                 ByteOp => tmpByteOp,
                 Mem_WrEn => tmpMem_WrEn
               );

end Behavioral;
