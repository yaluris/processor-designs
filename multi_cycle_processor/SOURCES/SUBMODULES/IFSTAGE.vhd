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
    Port ( IncrementedPC : in  STD_LOGIC_VECTOR (31 downto 0);  -- MC
			  Branch_Addr : in  STD_LOGIC_VECTOR (31 downto 0);  -- MC
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is
  signal MUXout : STD_LOGIC_VECTOR (31 downto 0);

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
		  
  SelectNextPCValue: MUX32bit2to1 PORT MAP (  -- MC
                       Datain0 => IncrementedPC,
                       Datain1 => Branch_Addr,
                       Sel => PC_sel,
                       Dataout => MUXout
                     );
		  
  ProgramCounter: REG PORT MAP (
                    CLK => Clk,
                    RST => Reset,
                    Datain => MUXout,
                    WE => PC_LdEn,
                    Dataout => PC
                  );

end Behavioral;
