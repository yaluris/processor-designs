library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- For adding STD_LOGIC_VECTOR using the + operator

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ADDERIMM is
    Port ( Datain : in  STD_LOGIC_VECTOR (31 downto 0);
           Imm : in  STD_LOGIC_VECTOR (31 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end ADDERIMM;

architecture Behavioral of ADDERIMM is

begin

  Dataout <= Datain + Imm;  -- (PC + 4) + PC_Immed

end Behavioral;
