library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DECODER is
    Port ( Datain : in  STD_LOGIC_VECTOR (4 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end DECODER;

architecture Behavioral of DECODER is
  signal tmpDataout : STD_LOGIC_VECTOR (31 downto 0);
begin

  tmpDataout <= "00000000000000000000000000000001" when Datain = "00000" else
                "00000000000000000000000000000010" when Datain = "00001" else
					 "00000000000000000000000000000100" when Datain = "00010" else
					 "00000000000000000000000000001000" when Datain = "00011" else
					 "00000000000000000000000000010000" when Datain = "00100" else
					 "00000000000000000000000000100000" when Datain = "00101" else
					 "00000000000000000000000001000000" when Datain = "00110" else
					 "00000000000000000000000010000000" when Datain = "00111" else
					 "00000000000000000000000100000000" when Datain = "01000" else
					 "00000000000000000000001000000000" when Datain = "01001" else
					 "00000000000000000000010000000000" when Datain = "01010" else
					 "00000000000000000000100000000000" when Datain = "01011" else
					 "00000000000000000001000000000000" when Datain = "01100" else
					 "00000000000000000010000000000000" when Datain = "01101" else
					 "00000000000000000100000000000000" when Datain = "01110" else
					 "00000000000000001000000000000000" when Datain = "01111" else
					 "00000000000000010000000000000000" when Datain = "10000" else
					 "00000000000000100000000000000000" when Datain = "10001" else
					 "00000000000001000000000000000000" when Datain = "10010" else
					 "00000000000010000000000000000000" when Datain = "10011" else
					 "00000000000100000000000000000000" when Datain = "10100" else
					 "00000000001000000000000000000000" when Datain = "10101" else
					 "00000000010000000000000000000000" when Datain = "10110" else
					 "00000000100000000000000000000000" when Datain = "10111" else
					 "00000001000000000000000000000000" when Datain = "11000" else
					 "00000010000000000000000000000000" when Datain = "11001" else
					 "00000100000000000000000000000000" when Datain = "11010" else
					 "00001000000000000000000000000000" when Datain = "11011" else
					 "00010000000000000000000000000000" when Datain = "11100" else
					 "00100000000000000000000000000000" when Datain = "11101" else
					 "01000000000000000000000000000000" when Datain = "11110" else
					 "10000000000000000000000000000000" when Datain = "11111";

  Dataout <= tmpDataout after 10ns;

end Behavioral;
