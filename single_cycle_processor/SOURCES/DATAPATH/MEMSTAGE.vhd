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

entity MEMSTAGE is
    Port ( ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_WrEn : out  STD_LOGIC;
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0);
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0));
end MEMSTAGE;

architecture Behavioral of MEMSTAGE is

begin

  MM_WrEn <= Mem_WrEn;  -- WrEn signal to memory module

  MM_Addr <= ALU_MEM_Addr + "00000000000000000000010000000000";  -- The address sent by ALU added by 0x400 = 1024 bytes (offset)

  MM_WrData <= MEM_DataIn when ByteOp = '0' else  -- sw (32bit)
               X"000000" & MEM_DataIn(7 downto 0) when ByteOp = '1';  -- sb (8bit)
				
  MEM_DataOut <= MM_RdData when ByteOp = '0' else  -- lw (32bit)
                 X"000000" & MM_RdData(7 downto 0) when ByteOp = '1';  -- lb (8bit)

end Behavioral;
