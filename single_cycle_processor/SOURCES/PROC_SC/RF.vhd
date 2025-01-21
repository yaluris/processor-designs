library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.arrayin_type.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RF is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           Rst : in  STD_LOGIC);
end RF;

architecture Behavioral of RF is
  signal DECODERout : STD_LOGIC_VECTOR (31 downto 0);
  signal MUXin : arrayin;
  signal REGWE : STD_LOGIC_VECTOR (31 downto 0);
  
  COMPONENT DECODER
    PORT(
         Datain : IN  std_logic_vector(4 downto 0);
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
  
  COMPONENT MUX
    PORT(
         Datain : IN  arrayin;
         Sel : IN  std_logic_vector(4 downto 0);
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
  END COMPONENT;
begin

  Decoder5to32: DECODER PORT MAP (
                  Datain => Awr,
                  Dataout => DECODERout
                );
				 
  Register0: REG PORT MAP (
               CLK => Clk,
               RST => Rst,
               Datain => X"00000000",
               WE => '1',
               Dataout => MUXin(0)
             );

  Register1to31: for I in 1 to 31 generate
                   REGWE(I) <= WrEn AND DECODERout(I) after 2ns;
                   RegisterI: REG PORT MAP (
                                CLK => Clk,
                                RST => Rst,
                                Datain => Din,
                                WE => REGWE(I),
                                Dataout => MUXin(I)
                              );
                 end generate Register1to31;
				 
  MUX1: MUX PORT MAP (
          Datain => MUXin,
          Sel => Ard1,
          Dataout => Dout1
        );

  MUX2: MUX PORT MAP (
          Datain => MUXin,
          Sel => Ard2,
          Dataout => Dout2
        );
	 
end Behavioral;
