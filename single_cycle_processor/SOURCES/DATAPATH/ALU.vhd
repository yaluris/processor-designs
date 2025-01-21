library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- For adding and subtracting STD_LOGIC_VECTOR using the + and - operators

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;  -- Contains shift and rotate functions

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           Output : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
  signal sum : STD_LOGIC_VECTOR (32 downto 0);
  signal difference : STD_LOGIC_VECTOR (32 downto 0);
  signal tmpOutput : STD_LOGIC_VECTOR (31 downto 0);
  signal tmpZero : STD_LOGIC;
  signal tmpCout : STD_LOGIC;
  signal tmpOvf : STD_LOGIC;
begin

  sum <= (A(31) & A) + (B(31) & B) when Op = "0000";
  
  difference <= (A(31) & A) - (B(31) & B) when Op = "0001";
  
  tmpOutput <= sum(31 downto 0) when Op = "0000" else
               difference(31 downto 0) when Op = "0001" else
					A AND B when Op = "0010" else
					A OR B when Op = "0011" else
					NOT A when Op = "0100" else
					A NAND B when Op = "0101" else
					A NOR B when Op = "0110" else
					STD_LOGIC_VECTOR(shift_right(signed(A), 1)) when Op = "1000" else  -- Arithmetic shift right by 1 bit. The function returns signed, so use casting to convert signed to STD_LOGIC_VECTOR
					STD_LOGIC_VECTOR(shift_right(unsigned(A), 1)) when Op = "1001" else  -- Logical shift right by 1 bit. The function returns unsigned, so use casting to convert unsigned to STD_LOGIC_VECTOR
					STD_LOGIC_VECTOR(shift_left(unsigned(A), 1)) when Op = "1010" else  -- Logical shift left by 1 bit. The function returns unsigned, so use casting to convert unsigned to STD_LOGIC_VECTOR
					STD_LOGIC_VECTOR(rotate_left(unsigned(A), 1)) when Op = "1100" else  -- Rotate left by 1 bit. The function returns unsigned, so use casting to convert unsigned to STD_LOGIC_VECTOR
					STD_LOGIC_VECTOR(rotate_right(unsigned(A), 1)) when Op = "1101";  -- Rotate right by 1 bit. The function returns unsigned, so use casting to convert unsigned to STD_LOGIC_VECTOR

  tmpZero <= '1' when tmpOutput = X"00000000" else
             '0';

  tmpCout <= sum(32) when Op = "0000" else
             difference(32) when Op = "0001" else
				 '0';

  tmpOvf <= '1' when (Op = "0000") AND (A(31) = B(31)) AND (tmpOutput(31) /= A(31)) else  -- If 2 Two's Complement numbers are added, and they both have the same sign (both positive or both negative), then overflow occurs if and only if the result has the opposite sign. Overflow never occurs when adding operands with different signs
            '1' when (Op = "0001") AND (A(31) /= B(31)) AND (tmpOutput(31) = B(31)) else  -- If 2 Two's Complement numbers are subtracted, and their signs are different, then overflow occurs if and only if the result has the same sign as the subtrahend
		      '0';  -- There is no overflow

  Output <= tmpOutput after 10ns;
  Zero <= tmpZero after 10ns;
  Cout <= tmpCout after 10ns;
  Ovf <= tmpOvf after 10ns;

end Behavioral;
