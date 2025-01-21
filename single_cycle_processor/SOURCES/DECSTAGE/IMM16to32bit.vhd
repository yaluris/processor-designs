library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;  -- Contains shift functions

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IMM16to32bit is
    Port ( Immin : in  STD_LOGIC_VECTOR (15 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           Immout : out  STD_LOGIC_VECTOR (31 downto 0));
end IMM16to32bit;

architecture Behavioral of IMM16to32bit is

begin

  Immout <= X"0000" & Immin when Sel = "00" else  -- ZeroFill(Imm)
            STD_LOGIC_VECTOR(shift_left(unsigned(X"0000" & Immin), 16)) when Sel = "01" else  -- ZeroFill(Imm) and logical shift left by 16 bits. The function returns unsigned, so use casting to convert unsigned to STD_LOGIC_VECTOR
            (15 downto 0 => Immin(15)) & Immin when Sel = "10" else  -- SignExtend(Imm)
				STD_LOGIC_VECTOR(shift_left(unsigned((15 downto 0 => Immin(15)) & Immin), 2)) when Sel = "11";  -- SignExtend(Imm) and logical shift left by 2 bits. The function returns unsigned, so use casting to convert unsigned to STD_LOGIC_VECTOR

end Behavioral;
