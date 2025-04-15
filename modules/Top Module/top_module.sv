
module MIPS_SingleCycle (
	input wire clk,
	input wire reset
);

	// Sinais de interconexão
	wire [31:0] pc_current, pc_next, pc_plus4, pc_branch;
	wire [31:0] instruction;
	wire [4:0] rs, rt, rd;
	wire [31:0] reg_data1, reg_data2, alu_srcB, alu_result;
	wire [31:0] imm_ext, shifted_imm, mem_read_data;
	wire [3:0] alu_control;
	wire [31:0] write_back_data;
	wire branch_taken;
	wire zero_flag;

	// Sinais de controle
	wire RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	wire [1:0] ALUOp;

	// Program Counter
	ProgramCounter PC (
    	.clk(clk),
    	.reset(reset),
    	.enable(1'b1),  // PC sempre atualizado em 1 ciclo
    	.pc_next(pc_next),
    	.pc(pc_current)
	);

	// PC + 4
	pcadder4 AdderPC4 (
    	.pc(pc_current),
    	.y(pc_plus4)
	);

	// Memória de Instrução
	instruction_memory IMEM (
    	.address(pc_current),
    	.instruction(instruction)
	);

	// Decode fields
	assign rs = instruction[25:21];
	assign rt = instruction[20:16];
	assign rd = instruction[15:11];

	// Unidade de Controle
	ControlUnit CU (
    	.opcode(instruction[31:26]),
    	.RegDst(RegDst),
    	.Branch(Branch),
    	.MemRead(MemRead),
    	.MemtoReg(MemtoReg),
    	.ALUOp(ALUOp),
    	.MemWrite(MemWrite),
    	.ALUSrc(ALUSrc),
    	.RegWrite(RegWrite)
	);

	// wire precisa estar declarado ANTES do uso!
wire [4:0] mux_reg_dst;

// Banco de Registradores
regfile RF (
	.clk(clk),
	.we3(RegWrite),
	.ra1(rs),
	.ra2(rt),
	.wa3(mux_reg_dst),
	.wd3(write_back_data),
	.rd1(reg_data1),
	.rd2(reg_data2)
);

// Mux para seleção do registrador destino
mux2 #(5) MuxRegDst (
	.d0(rt),
	.d1(rd),
	.s(RegDst),
	.y(mux_reg_dst)
);


	// Extensor de Sinal
	SignExtend SE (
    	.in(instruction[15:0]),
    	.out(imm_ext)
	);

	// Mux para segundo operando da ALU
	mux2 #(32) MuxALUSrc (
    	.d0(reg_data2),
    	.d1(imm_ext),
    	.s(ALUSrc),
    	.y(alu_srcB)
	);

	// Unidade de Seleção de Operação da ALU
	OperationSelector ALUOpSelector (
    	.Mode(ALUOp),
    	.InstructionFunct(instruction[5:0]),
    	.OpCode(alu_control)
	);

	// Unidade Lógica e Aritmética
	ArithmeticLogicUnit ALU (
    	.InputA(reg_data1),
    	.InputB(alu_srcB),
    	.Operation(alu_control),
    	.Result(alu_result),
    	.IsZero(zero_flag)
	);

	// Memória de Dados
	DataMemory DMEM (
    	.clk(clk),
    	.mem_read(MemRead),
    	.mem_write(MemWrite),
    	.addr(alu_result),
    	.write_data(reg_data2),
    	.read_data(mem_read_data)
	);

	// Mux para seleção do dado que será escrito no registrador
	mux2 #(32) MuxMemToReg (
    	.d0(alu_result),
    	.d1(mem_read_data),
    	.s(MemtoReg),
    	.y(write_back_data)
	);

	// Deslocamento do imediato << 2
	shiftleft SL2 (
    	.a(imm_ext),
    	.y(shifted_imm)
	);

	// Soma PC + deslocamento (PC Branch)
	PCBranch BranchAdder (
    	.pc_plus_4(pc_plus4),
    	.imm_ext(imm_ext),
    	.pc_branch_out(pc_branch)
	);

	// Verificação de Branch
	assign branch_taken = Branch & zero_flag;

	// Seleção do próximo valor do PC
	mux2 #(32) MuxPCSrc (
    	.d0(pc_plus4),
    	.d1(pc_branch),
    	.s(branch_taken),
    	.y(pc_next)
	);

endmodule
