library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package arrayin_type is
  type arrayin is array (0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
end package arrayin_type;

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

entity MUX is
    Port ( Datain : in  arrayin;
           Sel : in  STD_LOGIC_VECTOR (4 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX;

architecture Behavioral of MUX is
  signal tmpDataout : STD_LOGIC_VECTOR (31 downto 0);
begin

  tmpDataout <= Datain(0) when Sel = "00000" else
                Datain(1) when Sel = "00001" else
					 Datain(2) when Sel = "00010" else
					 Datain(3) when Sel = "00011" else
					 Datain(4) when Sel = "00100" else
					 Datain(5) when Sel = "00101" else
					 Datain(6) when Sel = "00110" else
					 Datain(7) when Sel = "00111" else
					 Datain(8) when Sel = "01000" else
					 Datain(9) when Sel = "01001" else
					 Datain(10) when Sel = "01010" else
					 Datain(11) when Sel = "01011" else
					 Datain(12) when Sel = "01100" else
					 Datain(13) when Sel = "01101" else
					 Datain(14) when Sel = "01110" else
					 Datain(15) when Sel = "01111" else
					 Datain(16) when Sel = "10000" else
					 Datain(17) when Sel = "10001" else
					 Datain(18) when Sel = "10010" else
					 Datain(19) when Sel = "10011" else
					 Datain(20) when Sel = "10100" else
					 Datain(21) when Sel = "10101" else
					 Datain(22) when Sel = "10110" else
					 Datain(23) when Sel = "10111" else
					 Datain(24) when Sel = "11000" else
					 Datain(25) when Sel = "11001" else
					 Datain(26) when Sel = "11010" else
					 Datain(27) when Sel = "11011" else
					 Datain(28) when Sel = "11100" else
					 Datain(29) when Sel = "11101" else
					 Datain(30) when Sel = "11110" else
					 Datain(31) when Sel = "11111";

  Dataout <= tmpDataout after 10ns;

end Behavioral;
