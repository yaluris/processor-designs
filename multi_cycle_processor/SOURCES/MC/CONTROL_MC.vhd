library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL_MC is
    Port ( Clk : in  STD_LOGIC;  -- Clock and Reset
	        Rst : in  STD_LOGIC;

	        PC_sel : out  STD_LOGIC;  -- IFSTAGE
	        PC_LdEn : out  STD_LOGIC;

	        Instr : in  STD_LOGIC_VECTOR (31 downto 0);  -- DECSTAGE
			  RF_WrEn : out  STD_LOGIC;
			  RF_WrData_sel : out  STD_LOGIC;
			  RF_B_sel : out  STD_LOGIC;
			  ImmExt : out  STD_LOGIC_VECTOR (1 downto 0);
			  			    
	        ALU_Ain_sel : out  STD_LOGIC;  -- EXSTAGE
			  ALU_Bin_sel : out  STD_LOGIC_VECTOR (1 downto 0);
	        ALU_func : out  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_zero : in  STD_LOGIC;
			  	    
			  ByteOp : out  STD_LOGIC;  -- MEMSTAGE
			  Mem_WrEn : out  STD_LOGIC;
			  
			  IR_WrEn : out  STD_LOGIC;  -- REGISTERS
			  ALUOutR_WrEn : out  STD_LOGIC);
end CONTROL_MC;

architecture Behavioral of CONTROL_MC is
  signal Opcode : STD_LOGIC_VECTOR (5 downto 0);
  signal tmpALU_func : STD_LOGIC_VECTOR (3 downto 0);
  type state is (IF_state, DEC_state, MEM_Addr_state, MEM_Load_state, MEM_WriteBack_state, MEM_Store_state, Rtype_EX_state, ALU_WriteBack_state, Branch_state, Itype_EX_state);  -- States declaration
  signal current_state, next_state: state;
begin

  Opcode <= Instr(31 downto 26);
  tmpALU_func <= Instr(3 downto 0);  -- The 4 least significant bits of Instr are enough for the ALU_func

  MealyFSM: process (current_state, Opcode, tmpALU_func, ALU_zero)  -- The sensitivity list contains those signals which affect the execution of the process
  begin

    case current_state is
		when IF_state =>
		  PC_sel <= '0';  -- Only increment PC by 4
		  PC_LdEn <= '1';  -- Enable PC writing
		  RF_WrEn <= '0';
		  RF_WrData_sel <= '-';
		  RF_B_sel <= '-';
		  ImmExt <= "--";
		  ALU_Ain_sel <= '0';  -- Select PC as ALU A input
		  ALU_Bin_sel <= "01";  -- Select 4 as ALU B input
		  ALU_func <= "0000";  -- Addition
		  ByteOp <= '-';
		  Mem_WrEn <= '0';
		  IR_WrEn <= '1';  -- Enable IR writing
		  ALUOutR_WrEn <= '0';
		  next_state <= DEC_state;
		  
		when DEC_state =>
		  PC_LdEn <= '0';  -- Disable PC writing
		  ImmExt <= "11";  -- SignExtend(Imm) and logical shift left by 2 bits
		  ALU_Ain_sel <= '0';  -- Select PC as ALU A input
		  ALU_Bin_sel <= "10";  -- Select Immed as ALU B input
		  ALU_func <= "0000";  -- Addition (probable branch address)
		  IR_WrEn <= '0';  -- Disable IR writing
		  ALUOutR_WrEn <= '1';  -- Enable ALUOutR writing
		  if (Opcode = "000011" OR Opcode = "000111" OR Opcode = "001111" OR Opcode = "011111") then  -- lb, sb, lw, sw
		    RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		    next_state <= MEM_Addr_state;
		  elsif (Opcode = "100000") then  -- R-type
		    RF_B_sel <= '0';  -- Select RF[rt] = Instr(15 downto 11) as second read register
		    next_state <= Rtype_EX_state;
		  elsif (Opcode = "111111" OR Opcode = "000000" OR Opcode = "000001") then  -- b, beq, bne
		    RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		    next_state <= Branch_state;
		  elsif (Opcode = "111000" OR Opcode = "111001" OR Opcode = "110000" OR Opcode = "110010" OR Opcode = "110011") then  -- li, lui, addi, nandi, ori
		    RF_B_sel <= '1';  -- Select RF[rd] = Instr(20 downto 16) as second read register
		    next_state <= Itype_EX_state;
		  end if;
		  
		when MEM_Addr_state =>
		  ImmExt <= "10";  -- SignExtend(Imm)
		  ALU_Ain_sel <= '1';  -- Select RF_A as ALU A input
		  ALU_Bin_sel <= "10";  -- Select Immed as ALU B input
		  ALU_func <= "0000";  -- Add (ALU_MEM_Addr <- RF[rs] + SignExtend(Imm))
		  if (Opcode = "000011" OR Opcode = "001111") then  -- lb, lw
		    next_state <= MEM_Load_state;
		  elsif (Opcode = "000111" OR Opcode = "011111") then  -- sb, sw
		    next_state <= MEM_Store_state;
		  end if;
		  
		when MEM_Load_state =>
		  if (Opcode = "000011") then  -- lb. RF[rd] <- X"000000" & MM[RF[rs] + SignExtend(Imm) + 0x400](7 downto 0)
		    ByteOp <= '1';  -- Byte
		  elsif (Opcode = "001111") then  -- lw. RF[rd] <- MM[RF[rs] + SignExtend(Imm) + 0x400]
		    ByteOp <= '0';  -- Word
		  end if;
		  next_state <= MEM_WriteBack_state;
		  
		when MEM_WriteBack_state =>
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '1';  -- Select MEM_out as RF Din
		  next_state <= IF_state;
		  
		when MEM_Store_state =>
		  if (Opcode = "000111") then  -- sb. MM[RF[rs] + SignExtend(Imm) + 0x400] <- X"000000" & RF[rd](7 downto 0)
		    ByteOp <= '1';  -- Byte
		  elsif (Opcode = "011111") then  -- sw. MM[RF[rs] + SignExtend(Imm) + 0x400] <- RF[rd]
		    ByteOp <= '0';  -- Word
		  end if;
		  Mem_WrEn <= '1';  -- Enable Memory writing
		  next_state <= IF_state;
		  
		when Rtype_EX_state =>
		  ALU_Ain_sel <= '1';  -- Select RF_A as ALU A input
		  ALU_Bin_sel <= "00";  -- Select RF_B as ALU B input
		  ALU_func <= tmpALU_func;  -- Select ALU operation
		  next_state <= ALU_WriteBack_state;
		  
		when ALU_WriteBack_state =>
		  RF_WrEn <= '1';  -- Enable RF writing
		  RF_WrData_sel <= '0';  -- Select ALU_out as RF Din
		  next_state <= IF_state;
		  
		when Branch_state =>
		  PC_sel <= '1';  -- Select the branch address as PC Datain (PC will be incremented by 4 in the next state)
		  if (Opcode = "111111" OR (Opcode = "000000" AND ALU_zero = '1') OR (Opcode = "000001" AND ALU_zero = '0')) then
		    PC_LdEn <= '1';  -- Enable PC writing
		  else
		    PC_LdEn <= '0';  -- Disable PC writing
		  end if;
		  ALU_Ain_sel <= '1';  -- Select RF_A as ALU A input
		  ALU_Bin_sel <= "00";  -- Select RF_B as ALU B input
		  ALU_func <= "0001";  -- Subtract (RF[rs] - RF[rd])
		  ALUOutR_WrEn <= '0';  -- Disable ALUOutR writing so the branch address (calculated in DEC_state) doesn't get overwritten by the subtraction result
		  next_state <= IF_state;
		  
		when Itype_EX_state =>
		  if (Opcode = "111000") then  -- li. RF[rd] <- SignExtend(Imm)
		    ImmExt <= "10";  -- SignExtend(Imm)
		    ALU_func <= "0011";  -- OR bitmask (RF[rs] = RF[r0])
		  elsif (Opcode = "111001") then  -- lui. RF[rd] <- ZeroFill(Imm)<<16
		    ImmExt <= "01";  -- ZeroFill(Imm) and logical shift left by 16 bits
		    ALU_func <= "0011";  -- OR bitmask (RF[rs] = RF[r0])
		  elsif (Opcode = "110000") then  -- addi. RF[rd] <- RF[rs] + SignExtend(Imm)
		    ImmExt <= "10";  -- SignExtend(Imm)
		    ALU_func <= "0000";  -- Add
		  elsif (Opcode = "110010") then  -- nandi. RF[rd] <- RF[rs] NAND ZeroFill(Imm)
		    ImmExt <= "00";  -- ZeroFill(Imm)
		    ALU_func <= "0101";  -- NAND
		  elsif (Opcode = "110011") then  -- ori. RF[rd] <- RF[rs] OR ZeroFill(Imm)
		    ImmExt <= "00";  -- ZeroFill(Imm)
		    ALU_func <= "0011";  -- OR
		  end if;
		  ALU_Ain_sel <= '1';  -- Select RF_A as ALU A input
		  ALU_Bin_sel <= "10";  -- Select Immed as ALU B input
	     next_state <= ALU_WriteBack_state; 	  
    end case;
    
  end process;

  process (Clk, Rst)
  begin
  
    if rising_edge(Clk) then  -- Wait for the Clk pulse
	   if Rst = '1' then
	     current_state <= IF_state;  -- PC resets too
	   else
	     current_state <= next_state;
	   end if;
	 end if;
    
  end process;

end Behavioral;
