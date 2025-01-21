LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY REG_TB IS
END REG_TB;
 
ARCHITECTURE behavior OF REG_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT REG
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         Datain : IN  std_logic_vector(31 downto 0);
         WE : IN  std_logic;
         Dataout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal Datain : std_logic_vector(31 downto 0) := (others => '0');
   signal WE : std_logic := '0';

 	--Outputs
   signal Dataout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: REG PORT MAP (
          CLK => CLK,
          RST => RST,
          Datain => Datain,
          WE => WE,
          Dataout => Dataout
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
	
     RST <= '1';  -- Hold reset state for 100 ns
	  WE <= '0';
	  wait for CLK_period;
	  
	  RST <= '0';
	  WE <= '1';
	  Datain <= "00000000000000000000000000000001";
	  wait for CLK_period;
	  
	  RST <= '1';
	  WE <= '0';
	  wait for CLK_period;
	  
	  RST <= '0';
	  Datain <= "00000000000000000000000000000111";
	  wait for CLK_period;
	  
	  WE <= '1';
	  wait for CLK_period;
	  
	  Datain <= "11111111111111111111111111111001";
	  wait for CLK_period;
	  
	  RST <= '1';
	  wait for CLK_period;
	  
     wait;
   end process;

END;
