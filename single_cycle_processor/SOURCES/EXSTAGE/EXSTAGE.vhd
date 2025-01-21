library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EXSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero : out  STD_LOGIC;
			  ALU_cout : out  STD_LOGIC;
			  ALU_ovf : out  STD_LOGIC);
end EXSTAGE;

architecture Behavioral of EXSTAGE is
  signal MUXout : STD_LOGIC_VECTOR (31 downto 0);

  COMPONENT MUX32bit2to1
    PORT(
         Datain0 : IN  std_logic_vector(31 downto 0);
         Datain1 : IN  std_logic_vector(31 downto 0);
         Sel : IN  std_logic;
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
  END COMPONENT;

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
begin

  SelectALU_B: MUX32bit2to1 PORT MAP (
                 Datain0 => RF_B,
                 Datain1 => Immed,
                 Sel => ALU_Bin_sel,
                 Dataout => MUXout
               );

  ArithmeticLogicUnit: ALU PORT MAP (
                         A => RF_A,
                         B => MUXout,
                         Op => ALU_func,
                         Output => ALU_out,
                         Zero => ALU_zero,
                         Cout => ALU_cout,
                         Ovf => ALU_ovf
                       );

end Behavioral;
