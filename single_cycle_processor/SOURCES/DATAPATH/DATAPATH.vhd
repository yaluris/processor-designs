library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DATAPATH is
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
			  
			  ALU_Bin_sel : in  STD_LOGIC;  -- EXSTAGE
			  ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_zero : out  STD_LOGIC;
			  ALU_cout : out  STD_LOGIC;
			  ALU_ovf : out  STD_LOGIC;
			  
			  ByteOp : in  STD_LOGIC;  -- MEMSTAGE
			  Mem_WrEn : in  STD_LOGIC;
			  MM_WrEn : out  STD_LOGIC;
			  MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
			  MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
			  MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0));
end DATAPATH;

architecture Behavioral of DATAPATH is
  signal tmpImmed : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpALU_out : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpMEM_out : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpRF_A : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpRF_B : STD_LOGIC_VECTOR (31 downto 0);

  COMPONENT IFSTAGE
    PORT(
         PC_Immed : IN  std_logic_vector(31 downto 0);
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
begin

  InstructionFetch: IFSTAGE PORT MAP (
                      PC_Immed => tmpImmed,
                      PC_sel => PC_sel,
                      PC_LdEn => PC_LdEn,
                      Reset => Rst,
                      Clk => Clk,
                      PC => PC
                    );

  InstructionDecoding: DECSTAGE PORT MAP (
                         Instr => Instr,
                         RF_WrEn => RF_WrEn,
                         ALU_out => tmpALU_out,
                         MEM_out => tmpMEM_out,
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
               RF_A => tmpRF_A,
               RF_B => tmpRF_B,
               Immed => tmpImmed,
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
            ALU_MEM_Addr => tmpALU_out,
            MEM_DataIn => tmpRF_B,
            MEM_DataOut => tmpMEM_out,
            MM_WrEn => MM_WrEn,
            MM_Addr => MM_Addr,
            MM_WrData => MM_WrData,
            MM_RdData => MM_RdData
          );

end Behavioral;
