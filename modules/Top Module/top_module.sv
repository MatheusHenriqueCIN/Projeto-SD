
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

module ProgramCounter (
	input wire clk,          	// Clock
	input wire reset,        	// Reset síncrono
	input wire enable,       	// Habilita a atualização do PC
	input wire [31:0] pc_next,   // Próximo valor do PC
	output reg [31:0] pc     	// Valor atual do PC
);

	always @(posedge clk) begin
    	if (reset) begin
        	pc <= 32'b0;     	// Reseta o PC para 0
    	end else if (enable) begin
        	pc <= pc_next;   	// Atualiza o PC com o próximo valor
    	end
	end

endmodule

module pcadder4 (input logic [31:0] pc,
output logic [31:0] y);
 
assign y = pc + 4;
 
endmodule

module instruction_memory (
	input [31:0] address,
	output reg [31:0] instruction
);

	reg [31:0] mem [0:63];
	
	initial begin
    	// Manualmente inserindo o conteúdo do program.bin:
  	mem[0] = 32'b00100000000100000000000000000100;
  	mem[1] = 32'b00100000000010000000000000000001;
  	mem[2] = 32'b00100000000100010000000000000000;
  	mem[3] = 32'b00010010000010000000000000001010;
  	mem[4] = 32'b00100000000010000000000000000010;
  	mem[5] = 32'b00100000000100010000000000001000;
  	mem[6] = 32'b00010010000010000000000000000111;
  	mem[7] = 32'b00100000000010000000000000000011;
  	mem[8] = 32'b00100000000100010000000000001111;  
  	mem[9] = 32'b00010010000010000000000000000100;  
  	mem[10] = 32'b00100000000010000000000000000100;
  	mem[11] = 32'b00100000000100010000000000010110;
  	mem[12] = 32'b00010010000010000000000000000001;  
  	mem[13] = 32'b00100000000100010000000000011100;

	end

	always @(*) begin
    	instruction = mem[address >> 2];
	end
endmodule

module regfile (input logic clk,
input logic we3,
input logic [4:0] ra1, ra2, wa3,
input logic [31:0] wd3,
output logic [31:0] rd1, rd2);

logic [31:0] rf[31:0];

always_ff @(posedge clk)
if (we3) rf[wa3] <= wd3;
 
assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
 
endmodule

module SignExtend (
	input wire [15:0] in,    	// Imediato de 16 bits
	output wire [31:0] out   	// Valor estendido para 32 bits
);

	assign out = {{16{in[15]}}, in};  // Estende o bit de sinal (bit 15) para os 16 bits superiores

endmodule

module shiftleft (input logic [31:0] a,
output logic [31:0] y);
 
assign y = a << 2;
 
endmodule

// Código da Control Unit
module ControlUnit (
	input [5:0] opcode,   	// Campo opcode da instrução
	output reg RegDst,     	// Seleção do registrador de destino
	output reg Branch,     	// Sinal de branch
	output reg MemRead,    	// Leitura da memória
	output reg MemtoReg,   	// Seleção do dado para escrita no registrador
	output reg [1:0] ALUOp,	// Operação da ALU
	output reg MemWrite,   	// Escrita na memória
	output reg ALUSrc,     	// Seleção do segundo operando da ALU
	output reg RegWrite    	// Escrita no banco de registradores
);

always @(opcode) begin
	case (opcode)
    	// Instruções do tipo R (add, sub, and, or, slt, etc.)
    	6'b000000: begin
        	RegDst = 1'b1;
        	ALUSrc = 1'b0;
        	MemtoReg = 1'b0;
        	RegWrite = 1'b1;
        	MemRead = 1'b0;
        	MemWrite = 1'b0;
        	Branch = 1'b0;
        	ALUOp = 2'b10;
    	end
   	 
    	// lw
    	6'b100011: begin
        	RegDst = 1'b0;
        	ALUSrc = 1'b1;
        	MemtoReg = 1'b1;
        	RegWrite = 1'b1;
        	MemRead = 1'b1;
        	MemWrite = 1'b0;
        	Branch = 1'b0;
        	ALUOp = 2'b00;
    	end
   	 
    	// sw
    	6'b101011: begin
        	ALUSrc = 1'b1;
        	RegWrite = 1'b0;
        	MemRead = 1'b0;
        	MemWrite = 1'b1;
        	Branch = 1'b0;
        	ALUOp = 2'b00;
    	end
   	 
    	// beq
    	6'b000100: begin
        	ALUSrc = 1'b0;
        	RegWrite = 1'b0;
        	MemRead = 1'b0;
        	MemWrite = 1'b0;
        	Branch = 1'b1;
        	ALUOp = 2'b01;
    	end
   	 
    	// Instruções imediatas (addi, ori, etc.)
    	6'b001000: begin  // addi
		
        	RegDst = 1'b0;
        	ALUSrc = 1'b1;
        	MemtoReg = 1'b0;
        	RegWrite = 1'b1;
        	MemRead = 1'b0;
        	MemWrite = 1'b0;
        	Branch = 1'b0;
        	ALUOp = 2'b00;
    	end
   	 
    	// Default
    	default: begin
        	RegDst = 1'b0;
        	ALUSrc = 1'b0;
        	MemtoReg = 1'b0;
        	RegWrite = 1'b0;
        	MemRead = 1'b0;
        	MemWrite = 1'b0;
        	Branch = 1'b0;
        	ALUOp = 2'b00;
    	end
	endcase
end

endmodule

module mux2 #(parameter WIDTH = 8)
(input logic [WIDTH-1:0] d0, d1,
input logic s,
output logic [WIDTH-1:0] y);
 
assign y = s ? d1 : d0;
 
endmodule

module ArithmeticLogicUnit (
	input [31:0] InputA,
	input [31:0] InputB,
	input [3:0] Operation,
	output reg [31:0] Result,
	output reg IsZero
);
	always @(*) begin
    	Result = 32'b0; // Default value
    	if (Operation == 4'b0010)
        	Result = InputA + InputB;
    	else if (Operation == 4'b0110)
        	Result = InputA - InputB;
    	else if (Operation == 4'b0000)
        	Result = InputA & InputB;
    	else if (Operation == 4'b0001)
        	Result = InputA | InputB;
    	else if (Operation == 4'b0111)
        	Result = (InputA < InputB) ? 32'b1 : 32'b0;

    	IsZero = (Result == 32'b0);
	end
endmodule

module OperationSelector (
	input wire [1:0] Mode,
	input wire [5:0] InstructionFunct,
	output reg [3:0] OpCode
);
	always @(*) begin
    	OpCode = 4'b1111; // Default invalid operation
    	case (Mode)
        	2'b00: OpCode = 4'b0010; // Add
        	2'b01: OpCode = 4'b0110; // Subtract
        	2'b10: begin
            	if (InstructionFunct == 6'b100000)
                	OpCode = 4'b0010; // Add
            	else if (InstructionFunct == 6'b100010)
                	OpCode = 4'b0110; // Subtract
            	else if (InstructionFunct == 6'b100100)
                	OpCode = 4'b0000; // AND
            	else if (InstructionFunct == 6'b100101)
                	OpCode = 4'b0001; // OR
            	else if (InstructionFunct == 6'b101010)
                	OpCode = 4'b0111; // SLT
        	end
        	default: OpCode = 4'b1111;
    	endcase
	end
endmodule

module DataMemory (
	input wire clk,                 	// Clock
	input wire mem_read,           	// Sinal de leitura
	input wire mem_write,          	// Sinal de escrita
	input wire [31:0] addr,        	// Endereço de acesso (word-aligned)
	input wire [31:0] write_data,  	// Dado a ser escrito
	output reg [31:0] read_data    	// Dado lido
);

	// Memória com 1024 posições de 32 bits (4 KB de memória)
	reg [31:0] memory [0:63];

	// Leitura (combinacional)
	always @(*) begin
    	if (mem_read)
        	read_data = memory[addr[11:2]];  // word-aligned
    	else
        	read_data = 32'b0;
	end

	// Escrita (sincronizada ao clock)
	always @(posedge clk) begin
    	if (mem_write)
        	memory[addr[11:2]] <= write_data;  // word-aligned
	end

endmodule

module PCBranch (
	input wire [31:0] pc_plus_4,    	// PC + 4
	input wire [31:0] imm_ext,      	// Imediato estendido (sign extend)
	output wire [31:0] pc_branch_out	// Endereço alvo do branch
);

	assign pc_branch_out = pc_plus_4 + (imm_ext << 2);  // Desloca e soma

endmodule
