library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is
  signal tmpPC : STD_LOGIC_VECTOR (31 downto 0);
  signal INCREMENTORout : STD_LOGIC_VECTOR (31 downto 0);
  signal ADDERIMMout : STD_LOGIC_VECTOR (31 downto 0);
  signal MUXout : STD_LOGIC_VECTOR (31 downto 0);

  COMPONENT INCREMENTOR
    PORT(
         Datain : IN  std_logic_vector(31 downto 0);
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
  END COMPONENT;

  COMPONENT ADDERIMM
    PORT(
         Datain : IN  std_logic_vector(31 downto 0);
         Imm : IN  std_logic_vector(31 downto 0);
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
  END COMPONENT;

  COMPONENT MUX32bit2to1
    PORT(
         Datain0 : IN  std_logic_vector(31 downto 0);
         Datain1 : IN  std_logic_vector(31 downto 0);
         Sel : IN  std_logic;
         Dataout : OUT  std_logic_vector(31 downto 0)
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
		
  IncrementPCby4: INCREMENTOR PORT MAP (
                    Datain => tmpPC,
                    Dataout => INCREMENTORout
                  );
		  
  AddImmMultipliedby4: ADDERIMM PORT MAP (  -- For branching instructions
                         Datain => INCREMENTORout,
                         Imm => PC_Immed,
                         Dataout => ADDERIMMout
                       );
		  
  SelectNextPCValue: MUX32bit2to1 PORT MAP (
                       Datain0 => INCREMENTORout,
                       Datain1 => ADDERIMMout,
                       Sel => PC_sel,
                       Dataout => MUXout
                     );
		  
  ProgramCounter: REG PORT MAP (
                    CLK => Clk,
                    RST => Reset,
                    Datain => MUXout,
                    WE => PC_LdEn,
                    Dataout => tmpPC
                  );
						
  PC <= tmpPC;

end Behavioral;
