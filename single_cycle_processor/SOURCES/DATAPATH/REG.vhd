library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity REG is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           Datain : in  STD_LOGIC_VECTOR (31 downto 0);
           WE : in  STD_LOGIC;
           Dataout : out  STD_LOGIC_VECTOR (31 downto 0));
end REG;

architecture Behavioral of REG is
  signal tmpDataout : STD_LOGIC_VECTOR (31 downto 0);
begin

  process (CLK)
  begin
  
    if rising_edge(CLK) then  -- Wait for the Clk pulse
	   if RST = '1' then
	     tmpDataout <= X"00000000";
	   elsif WE = '1' then
	     tmpDataout <= Datain;
	   end if;
	 end if;
    
  end process;
  
  Dataout <= tmpDataout after 10ns;

end Behavioral;
