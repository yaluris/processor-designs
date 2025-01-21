LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY IFSTAGE_TB IS
END IFSTAGE_TB;
 
ARCHITECTURE behavior OF IFSTAGE_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IFSTAGE
    PORT(
         PC_Immed : IN  std_logic_vector(31 downto 0);
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         Reset : IN  std_logic;
         Clk : IN  std_logic;
         PC : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
	 
    COMPONENT RAM
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
   signal PC_Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal Reset : std_logic := '0';
   signal Clk : std_logic := '0';

 	--Outputs
   signal PC : std_logic_vector(31 downto 0);
	signal inst_dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFSTAGE PORT MAP (
          PC_Immed => PC_Immed,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          Reset => Reset,
          Clk => Clk,
          PC => PC
        );
		  
   uut2: RAM PORT MAP (
           clk => Clk,
           inst_addr => PC(12 downto 2),
           inst_dout => inst_dout,
           data_we => '0',  -- Unused input
           data_addr => "00000000000",  -- Unused input
           data_din => X"00000000",  -- Unused input
           data_dout => open  -- Unused output
         );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin

	   Reset <= '1';  -- Hold reset state for 100 ns
      wait for 100 ns;  -- PC = 0
		
		PC_Immed <= "00000000000000000000000000001000";
		PC_sel <= '1';  -- Increment PC by 4 and add Immed
		PC_LdEn <= '0';  -- Disable PC writing
		Reset <= '0';
		wait for Clk_period;  -- PC = 0
		
		PC_Immed <= "00000000000000000000000000001000";
		PC_sel <= '0';  -- Only increment PC by 4
		PC_LdEn <= '1';  -- Enable PC writing
		Reset <= '0';
		wait for Clk_period;  -- PC = PC + 4 = 4
		
		PC_Immed <= "00000000000000000000000000001000";
		PC_sel <= '1';  -- Increment PC by 4 and add Immed
		PC_LdEn <= '1';  -- Enable PC writing	
		Reset <= '0';
		wait for Clk_period;  -- PC = PC + 4 + 8 = 16
		
		PC_Immed <= "11111111111111111111111111111000";
		PC_sel <= '1';  -- Increment PC by 4 and add Immed
		PC_LdEn <= '1';  -- Enable PC writing	
		Reset <= '0';
		wait for Clk_period;  -- PC = PC + 4 - 8 = 12
		
		Reset <= '1';
		wait for Clk_period;  -- PC = 0

      wait;
   end process;

END;
