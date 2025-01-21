library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX32bit4to1 is
    Port ( Datain0 : in  STD_LOGIC_VECTOR (31 downto 0);
           Datain1 : in  STD_LOGIC_VECTOR (31 downto 0);
           Datain2 : in  STD_LOGIC_VECTOR (31 downto 0);
           Datain3 : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end MUX32bit4to1;

architecture Behavioral of MUX32bit4to1 is

begin

  Dataout <= Datain0 when Sel = "00" else
				 Datain1 when Sel = "01" else
				 Datain2 when Sel = "10" else
             Datain3 when Sel = "11";

end Behavioral;
