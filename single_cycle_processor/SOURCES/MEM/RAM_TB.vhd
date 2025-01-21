LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RAM_TB IS
END RAM_TB;
 
ARCHITECTURE behavior OF RAM_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
   signal clk : std_logic := '0';
   signal inst_addr : std_logic_vector(10 downto 0) := (others => '0');
   signal data_we : std_logic := '0';
   signal data_addr : std_logic_vector(10 downto 0) := (others => '0');
   signal data_din : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal inst_dout : std_logic_vector(31 downto 0);
   signal data_dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RAM PORT MAP (
          clk => clk,
          inst_addr => inst_addr,
          inst_dout => inst_dout,
          data_we => data_we,
          data_addr => data_addr,
          data_din => data_din,
          data_dout => data_dout
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
	
      inst_addr <= "00000000000";  -- inst_addr = 0 (text segment starting address)
		data_we <= '0';  -- Disable Memory writing
		data_addr <= "10000000000";  -- data_addr = 1024 (data segment starting address)
		data_din <= "11111111111111111111111111111111";
		wait for clk_period;
		
		inst_addr <= "00000000000";  -- inst_addr = 0 (text segment starting address)
		data_we <= '1';  -- Enable Memory writing
		data_addr <= "10000000000";  -- data_addr = 1024 (data segment starting address)
		data_din <= "11111111111111111111111111111000";
		wait for clk_period;
		
		inst_addr <= "00000000010";  -- inst_addr = 2 (third instruction)
		data_we <= '1';  -- Enable Memory writing
		data_addr <= "10000000110";  -- data_addr = 1030
		data_din <= "00000000000000000000000000000111";
		wait for clk_period;
		
		inst_addr <= "00000001000";  -- inst_addr = 8 (instruction 9)
		data_we <= '1';  -- Enable Memory writing
		data_addr <= "11111111111";  -- data_addr = 2047
		data_din <= "00000000000000000000000000001010";
		wait for clk_period;
		
      wait;
   end process;

END;
