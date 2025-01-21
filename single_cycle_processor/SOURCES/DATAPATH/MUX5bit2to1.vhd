library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX5bit2to1 is
    Port ( Datain0 : in  STD_LOGIC_VECTOR (4 downto 0);
           Datain1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Sel : in  STD_LOGIC;
           Dataout : out  STD_LOGIC_VECTOR (4 downto 0));
end MUX5bit2to1;

architecture Behavioral of MUX5bit2to1 is

begin

  Dataout <= Datain0 when Sel = '0' else
             Datain1 when Sel = '1';

end Behavioral;
