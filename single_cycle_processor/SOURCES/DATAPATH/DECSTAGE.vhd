library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end DECSTAGE;

architecture Behavioral of DECSTAGE is
  signal MUX32bitout : STD_LOGIC_VECTOR (31 downto 0);
  signal MUX5bitout : STD_LOGIC_VECTOR (4 downto 0);

  COMPONENT MUX32bit2to1
    PORT(
         Datain0 : IN  std_logic_vector(31 downto 0);
         Datain1 : IN  std_logic_vector(31 downto 0);
         Sel : IN  std_logic;
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
  END COMPONENT;

  COMPONENT MUX5bit2to1
    PORT(
         Datain0 : IN  std_logic_vector(4 downto 0);
         Datain1 : IN  std_logic_vector(4 downto 0);
         Sel : IN  std_logic;
         Dataout : OUT  std_logic_vector(4 downto 0)
        );
  END COMPONENT;

  COMPONENT RF
    PORT(
         Ard1 : IN  std_logic_vector(4 downto 0);
         Ard2 : IN  std_logic_vector(4 downto 0);
         Awr : IN  std_logic_vector(4 downto 0);
         Dout1 : OUT  std_logic_vector(31 downto 0);
         Dout2 : OUT  std_logic_vector(31 downto 0);
         Din : IN  std_logic_vector(31 downto 0);
         WrEn : IN  std_logic;
         Clk : IN  std_logic;
         Rst : IN  std_logic
        );
  END COMPONENT;

  COMPONENT IMM16to32bit
    PORT(
         Immin : IN  std_logic_vector(15 downto 0);
         Sel : IN  std_logic_vector(1 downto 0);
         Immout : OUT  std_logic_vector(31 downto 0)
        );
  END COMPONENT;
begin

  SelectRF_Din: MUX32bit2to1 PORT MAP (
                  Datain0 => ALU_out,
                  Datain1 => MEM_out,
                  Sel => RF_WrData_sel,
                  Dataout => MUX32bitout
                );

  SelectReadRegister2: MUX5bit2to1 PORT MAP (
                         Datain0 => Instr(15 downto 11),
                         Datain1 => Instr(20 downto 16),
                         Sel => RF_B_sel,
                         Dataout => MUX5bitout
                       );

  RegisterFile: RF PORT MAP (
                  Ard1 => Instr(25 downto 21),
                  Ard2 => MUX5bitout,
                  Awr => Instr(20 downto 16),
                  Dout1 => RF_A,
                  Dout2 => RF_B,
                  Din => MUX32bitout,
                  WrEn => RF_WrEn,
                  Clk => Clk,
                  Rst => Rst
                );
					 
  ConvertImmediateto32bit: IMM16to32bit PORT MAP (
                             Immin => Instr(15 downto 0),
                             Sel => ImmExt,
                             Immout => Immed
                           );

end Behavioral;
