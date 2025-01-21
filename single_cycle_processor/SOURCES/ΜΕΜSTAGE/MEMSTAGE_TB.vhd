LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY MEMSTAGE_TB IS
END MEMSTAGE_TB;
 
ARCHITECTURE behavior OF MEMSTAGE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEMSTAGE
    PORT(
         ByteOp : IN  std_logic;
         Mem_WrEn : IN  std_logic;
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         MEM_DataIn : IN  std_logic_vector(31 downto 0);
         MEM_DataOut : OUT  std_logic_vector(31 downto 0);
         MM_WrEn : OUT  std_logic;
         MM_Addr : OUT  std_logic_vector(31 downto 0);
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
    COMPONENT RAM  -- Component Declaration for memory
    PORT(
         clk : IN  std_logic;
         inst_addr : IN  std_logic_vector(10 downto 0);
         inst_dout : OUT  std_logic_vector(31 downto 0);
         data_we : IN  std_logic;
         data_addr : IN  std_logic_vector(10 downto 0);
         data_din : IN  std_logic_vector(31 downto 0);
         data_dout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;


   --Inputs
	signal clk : std_logic := '0';
   signal ByteOp : std_logic := '0';
   signal Mem_WrEn : std_logic := '0';
   signal ALU_MEM_Addr : std_logic_vector(31 downto 0) := (others => '0');
   signal MEM_DataIn : std_logic_vector(31 downto 0) := (others => '0');
   signal MM_RdData : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal MEM_DataOut : std_logic_vector(31 downto 0);
   signal MM_WrEn : std_logic;
   signal MM_Addr : std_logic_vector(31 downto 0);
   signal MM_WrData : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 100 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEMSTAGE PORT MAP (
          ByteOp => ByteOp,
          Mem_WrEn => Mem_WrEn,
          ALU_MEM_Addr => ALU_MEM_Addr,
          MEM_DataIn => MEM_DataIn,
          MEM_DataOut => MEM_DataOut,
          MM_WrEn => MM_WrEn,
          MM_Addr => MM_Addr,
          MM_WrData => MM_WrData,
          MM_RdData => MM_RdData
        );
		  
   uut2: RAM PORT MAP (
          clk => clk,
          inst_addr => "00000000000",
          inst_dout => open,
          data_we => MM_WrEn,
          data_addr => MM_Addr(10 downto 0),
          data_din => MM_WrData,
          data_dout => MM_RdData
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin

      ByteOp <= '0';  -- sw (check MM_WrEn, MM_Addr and MM_WrData)
		Mem_WrEn <= '0';  -- Disable Memory writing
		ALU_MEM_Addr <= X"00000000";  -- The address sent by ALU
		MEM_DataIn <= "11111111111111111111111111111010";  -- MEM_DataIn = -6
      wait for Clk_period;
		
		ByteOp <= '0';  -- sw (check MM_WrEn, MM_Addr and MM_WrData)
		Mem_WrEn <= '1';  -- Enable Memory writing
		ALU_MEM_Addr <= X"00000000";  -- The address sent by ALU
		MEM_DataIn <= "11111111111111111111111111111010";  -- MEM_DataIn = -6
      wait for Clk_period;
		
		ByteOp <= '0';  -- sw (check MM_WrEn, MM_Addr and MM_WrData)
		Mem_WrEn <= '1';  -- Enable Memory writing
		ALU_MEM_Addr <= X"00000001";  -- The address sent by ALU
		MEM_DataIn <= "00000000000000000000000000000011";  -- MEM_DataIn = 3
      wait for Clk_period;
		
		ByteOp <= '0';  -- lw (check MEM_DataOut)
		Mem_WrEn <= '0';  -- Disable Memory writing
		ALU_MEM_Addr <= X"00000000";  -- The address sent by ALU
		MEM_DataIn <= "00000000000000000000000000000000";
      wait for Clk_period;  -- MEM_DataOut = 11111111111111111111111111111010 = -6
		
		ByteOp <= '1';  -- lb (check MEM_DataOut)
		Mem_WrEn <= '0';  -- Disable Memory writing
		ALU_MEM_Addr <= X"00000000";  -- The address sent by ALU
		MEM_DataIn <= "00000000000000000000000000000000";
      wait for Clk_period;  -- MEM_DataOut = 00000000000000000000000011111010 = 250
		
		ByteOp <= '1';  -- sb (check MM_WrEn, MM_Addr and MM_WrData)
		Mem_WrEn <= '1';  -- Enable Memory writing
		ALU_MEM_Addr <= X"00000002";  -- The address sent by ALU
		MEM_DataIn <= "00000000000000000000000000000100";  -- MEM_DataIn = 4
      wait for Clk_period;	

      wait;
   end process;

END;
