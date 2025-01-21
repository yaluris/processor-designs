LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY PROCESSOR_MC_TB IS
END PROCESSOR_MC_TB;
 
ARCHITECTURE behavior OF PROCESSOR_MC_TB IS
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PROCESSOR_MC
    PORT(
         Clk : IN  std_logic;
         Rst : IN  std_logic;
			PC : OUT  std_logic_vector(31 downto 0);
			Instr : IN  std_logic_vector(31 downto 0);
			MM_WrEn : OUT  std_logic;
         MM_Addr : OUT  std_logic_vector(31 downto 0);
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0)
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
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';
	
	--Outputs
   signal PC : std_logic_vector(31 downto 0);
	signal inst_dout : std_logic_vector(31 downto 0);
	signal MM_WrEn : std_logic;
	signal MM_Addr : std_logic_vector(31 downto 0);
	signal MM_WrData : std_logic_vector(31 downto 0);
	signal data_dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PROCESSOR_MC PORT MAP (
          Clk => Clk,
          Rst => Rst,
			 PC => PC,
			 Instr => inst_dout,
			 MM_WrEn => MM_WrEn,
			 MM_Addr => MM_Addr,
			 MM_WrData => MM_WrData,
			 MM_RdData => data_dout
        );
		  
   uut2: RAM PORT MAP (
           clk => Clk,
           inst_addr => PC(12 downto 2),  -- Convert address from 32bit to 11bit (ignore the 2 least significant bits because they refer to the bytes within the word). When PC increases by 4, RAM address increases by 1
           inst_dout => inst_dout,
           data_we => MM_WrEn,
           data_addr => MM_Addr(10 downto 0),
           data_din => MM_WrData,
           data_dout => data_dout
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
   	
      Rst <= '1';  -- Hold reset state for 300 ns
      wait for Clk_period*3;
		
		Rst <= '0';

      wait;
   end process;

END;
