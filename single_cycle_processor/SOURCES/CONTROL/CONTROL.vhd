library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL is
    Port ( PC_sel : out  STD_LOGIC;  -- IFSTAGE
	        PC_LdEn : out  STD_LOGIC;

	        Instr : in  STD_LOGIC_VECTOR (31 downto 0);  -- DECSTAGE
			  RF_WrEn : out  STD_LOGIC;
			  RF_WrData_sel : out  STD_LOGIC;
			  RF_B_sel : out  STD_LOGIC;
			  ImmExt : out  STD_LOGIC_VECTOR (1 downto 0);
			  			    
	        ALU_Bin_sel : out  STD_LOGIC;  -- EXSTAGE
	        ALU_func : out  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_zero : in  STD_LOGIC;
			  	    
			  ByteOp : out  STD_LOGIC;  -- MEMSTAGE
			  Mem_WrEn : out  STD_LOGIC);
end CONTROL;

architecture Behavioral of CONTROL is
  signal Opcode : STD_LOGIC_VECTOR (5 downto 0);
  signal tmpALU_func : STD_LOGIC_VECTOR (3 downto 0);
begin

  Opcode <= Instr(31 downto 26);
  tmpALU_func <= Instr(3 downto 0);  -- The 4 least significant bits of Instr are enough for the ALU_func

  process (Opcode, tmpALU_func, ALU_zero)  -- The sensitivity list contains those signals which affect the execution of the process
  begin
  
    case Opcode is
      when "100000" =>  -- Árithmetic and logic operations between 2 registers. RF[rd] <- RF[rs] (ALU operation) RF[rt]
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instructions)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		  RF_B_sel <= '0';  -- Select RF[rt] = Instr(15 downto 11) as second read register
		  ImmExt <= "00";  -- ZeroFill(Imm) but don't care
		  ALU_Bin_sel <= '0';  -- Select RF_B as ALU B input (no immediate)
		  ALU_func <= tmpALU_func;  -- Select ALU operation
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "111000" =>  -- li. RF[rd] <- SignExtend(Imm)
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "10";  -- SignExtend(Imm)
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0011";  -- OR bitmask (RF[rs] = RF[r0])
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		  
		when "111001" =>  -- lui. RF[rd] <- ZeroFill(Imm)<<16
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "01";  -- ZeroFill(Imm) and logical shift left by 16 bits
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0011";  -- OR bitmask (RF[rs] = RF[r0])
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing

		  
		when "110000" =>  -- addi. RF[rd] <- RF[rs] + SignExtend(Imm)
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "10";  -- SignExtend(Imm)
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0000";  -- Add
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "110010" =>  -- nandi. RF[rd] <- RF[rs] NAND ZeroFill(Imm)
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "00";  -- ZeroFill(Imm)
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0101";  -- NAND
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "110011" =>  -- ori. RF[rd] <- RF[rs] OR ZeroFill(Imm)
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "00";  -- ZeroFill(Imm)
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0011";  -- OR
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "111111" =>  -- b. PC <- PC + 4 + SignExtend(Imm)<<2
		  PC_sel <= '1';  -- Increment PC by 4 and add Immed
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '0';  -- Disable RF writing
		  RF_WrData_sel <= '-';  -- Don't care
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register but don't care
		  ImmExt <= "11";  -- SignExtend(Imm) and logical shift left by 2 bits
		  ALU_Bin_sel <= '0';  -- Select RF_B as ALU B input but don't care
		  ALU_func <= "----";  -- Don't care
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "000000" =>  -- beq
		  PC_sel <= ALU_zero;  -- if (RF[rs] = RF[rd]) then (PC <- PC + 4 + SignExtend(Imm)<<2) else (PC <- PC + 4)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '0';  -- Disable RF writing
		  RF_WrData_sel <= '-';  -- Don't care
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "11";  -- SignExtend(Imm) and logical shift left by 2 bits
		  ALU_Bin_sel <= '0';  -- Select RF_B as ALU B input
		  ALU_func <= "0001";  -- Subtract (RF[rs] - RF[rd])
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "000001" =>  -- bne
		  PC_sel <= NOT ALU_zero;  -- if (RF[rs] /= RF[rd]) then (PC <- PC + 4 + SignExtend(Imm)<<2) else (PC <- PC + 4)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '0';  -- Disable RF writing
		  RF_WrData_sel <= '-';  -- Don't care
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "11";  -- SignExtend(Imm) and logical shift left by 2 bits
		  ALU_Bin_sel <= '0';  -- Select RF_B as ALU B input
		  ALU_func <= "0001";  -- Subtract (RF[rs] - RF[rd])
		  ByteOp <= '-';  -- Don't care
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "000011" =>  -- lb. RF[rd] <- X"000000" & MM[RF[rs] + SignExtend(Imm) + 0x400](7 downto 0)
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '1';  -- Select MEM_out as RF Din
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "10";  -- SignExtend(Imm)
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0000";  -- Add (ALU_MEM_Addr <- RF[rs] + SignExtend(Imm))
		  ByteOp <= '1';  -- Byte
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "000111" =>  -- sb. MM[RF[rs] + SignExtend(Imm) + 0x400] <- X"000000" & RF[rd](7 downto 0)
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '0';  -- Disable RF writing
		  RF_WrData_sel <= '-';  -- Don't care
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "10";  -- SignExtend(Imm)
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0000";  -- Add (ALU_MEM_Addr <- RF[rs] + SignExtend(Imm))
		  ByteOp <= '1';  -- Byte
		  Mem_WrEn <= '1';  -- Enable Memory writing
		  
		when "001111" =>  -- lw. RF[rd] <- MM[RF[rs] + SignExtend(Imm) + 0x400]
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '1';  -- Select MEM_out as RF Din
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "10";  -- SignExtend(Imm)
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0000";  -- Add (ALU_MEM_Addr <- RF[rs] + SignExtend(Imm))
		  ByteOp <= '0';  -- Word
		  Mem_WrEn <= '0';  -- Disable Memory writing
		  
		when "011111" =>  -- sw. MM[RF[rs] + SignExtend(Imm) + 0x400] <- RF[rd]
		  PC_sel <= '0';  -- Only increment PC by 4 (no branching instruction)
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '0';  -- Disable RF writing
		  RF_WrData_sel <= '-';  -- Don't care
		  RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		  ImmExt <= "10";  -- SignExtend(Imm)
		  ALU_Bin_sel <= '1';  -- Select Immed as ALU B input
		  ALU_func <= "0000";  -- Add (ALU_MEM_Addr <- RF[rs] + SignExtend(Imm))
		  ByteOp <= '0';  -- Word
		  Mem_WrEn <= '1';  -- Enable Memory writing
		  
		when others =>
	     null;
    end case;
    
  end process;

end Behavioral;
