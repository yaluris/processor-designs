library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- For adding and subtracting STD_LOGIC_VECTOR using the + and - operators

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity INCREMENTOR is
    Port ( Datain : in  STD_LOGIC_VECTOR (31 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end INCREMENTOR;

architecture Behavioral of INCREMENTOR is

begin

  Dataout <= Datain + "00000000000000000000000000000100";  -- PC + 4 (next word)

end Behavioral;
