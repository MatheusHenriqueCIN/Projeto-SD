
// Código da Control Unit
module ControlUnit (
    input [5:0] opcode,       // Campo opcode da instrução
    output reg RegDst,         // Seleção do registrador de destino
    output reg Branch,         // Sinal de branch
    output reg MemRead,        // Leitura da memória
    output reg MemtoReg,       // Seleção do dado para escrita no registrador
    output reg [1:0] ALUOp,    // Operação da ALU
    output reg MemWrite,       // Escrita na memória
    output reg ALUSrc,         // Seleção do segundo operando da ALU
    output reg RegWrite        // Escrita no banco de registradores
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

