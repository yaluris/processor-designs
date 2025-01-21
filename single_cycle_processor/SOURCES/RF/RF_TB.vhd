LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RF_TB IS
END RF_TB;
 
ARCHITECTURE behavior OF RF_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RF
    PORT(
         Ard1 : IN  std_logic_vector(4 downto 0);
         Ard2 : IN  std_logic_vector(4 downto 0);
         Awr : IN  std_logic_vector(4 downto 0);
         Dout1 : OUT  std_logic_vector(31 downto 0);
         Dout2 : OUT  std_logic_vector(31 downto 0);
         Din : IN  std_logic_vector(31 downto 0);
         WrEn : IN  std_logic;
         Clk : IN  std_logic;
         Rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Ard1 : std_logic_vector(4 downto 0) := (others => '0');
   signal Ard2 : std_logic_vector(4 downto 0) := (others => '0');
   signal Awr : std_logic_vector(4 downto 0) := (others => '0');
   signal Din : std_logic_vector(31 downto 0) := (others => '0');
   signal WrEn : std_logic := '0';
   signal Clk : std_logic := '0';
   signal Rst : std_logic := '0';

 	--Outputs
   signal Dout1 : std_logic_vector(31 downto 0);
   signal Dout2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RF PORT MAP (
          Ard1 => Ard1,
          Ard2 => Ard2,
          Awr => Awr,
          Dout1 => Dout1,
          Dout2 => Dout2,
          Din => Din,
          WrEn => WrEn,
          Clk => Clk,
          Rst => Rst
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
	
	   Rst <= '1';  -- Hold reset state for 100 ns
      wait for 100 ns;
		
	   Ard1 <= "00001";  -- Select first read register (1)
		Ard2 <= "00011";  -- Select second read register (3)
		Awr <= "00011";  -- Select write register (3)
		Din <= "11111111111111111111111111111000";  -- Din = -8
		WrEn <= '0';  -- Disable REG writing
		Rst <= '0';
		wait for Clk_period;  -- Dout1 = 0, Dout2 = 0
		
		WrEn <= '1';  -- Enable REG writing
		wait for Clk_period;  -- Dout1 = 0, Dout2 = -8
		
		Ard1 <= "00011";  -- Select first read register (3)
		Ard2 <= "00000";  -- Select second read register (0)
		Awr <= "00000";  -- Select write register (0)
		Din <= "00000000000000000000000000001000";  -- Din = 8
		WrEn <= '1';  -- Enable REG writing
		Rst <= '0';
		wait for Clk_period;  -- Dout1 = -8, Dout2 = 0
		
		Ard1 <= "00000";  -- Select first read register (0)
		Ard2 <= "11111";  -- Select second read register (31)
		Awr <= "11111";  -- Select write register (31)
		Din <= "11111111111111111111111111111010";  -- Din = -6
		WrEn <= '1';  -- Enable REG writing
		Rst <= '0';
		wait for Clk_period;  -- Dout1 = 0, Dout2 = -6
		
		Ard1 <= "00011";  -- Select first read register (3)
		Ard2 <= "11111";  -- Select second read register (31)
		Awr <= "11111";  -- Select write register (31)
		Din <= "00000000000000000000000000001010";  -- Din = 10
		WrEn <= '1';  -- Enable REG writing
		Rst <= '0';
		wait for Clk_period;  -- Dout1 = -8, Dout2 = 10
		
		Rst <= '1';
      wait for Clk_period;

     wait;
   end process;

END;
