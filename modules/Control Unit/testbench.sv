// Testbench
module ControlUnit_tb;

    // Inputs
    reg [5:0] opcode;
    
    // Outputs
    wire RegDst;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire [1:0] ALUOp;
    wire MemWrite;
    wire ALUSrc;
    wire RegWrite;
    
    // Instantiate the Unit Under Test (UUT)
    ControlUnit uut (
        .opcode(opcode),
        .RegDst(RegDst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );
    
    initial begin
        $display("Iniciando teste da Control Unit...");
        $display("=================================");
        
        // Test case 1: R-type instruction
        opcode = 6'b000000;  // Tipo R
        #10;
        $display("Tempo %t: Opcode=%b (R-type) | RegDst=%b, Branch=%b, MemRead=%b, MemtoReg=%b, ALUOp=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b",
                 $time, opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
        
        // Test case 2: lw instruction
        opcode = 6'b100011;  // lw
        #10;
        $display("Tempo %t: Opcode=%b (lw)     | RegDst=%b, Branch=%b, MemRead=%b, MemtoReg=%b, ALUOp=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b",
                 $time, opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
        
        // Test case 3: sw instruction
        opcode = 6'b101011;  // sw
        #10;
        $display("Tempo %t: Opcode=%b (sw)     | RegDst=%b, Branch=%b, MemRead=%b, MemtoReg=%b, ALUOp=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b",
                 $time, opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
        
        // Test case 4: beq instruction
        opcode = 6'b000100;  // beq
        #10;
        $display("Tempo %t: Opcode=%b (beq)    | RegDst=%b, Branch=%b, MemRead=%b, MemtoReg=%b, ALUOp=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b",
                 $time, opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
        
        // Test case 5: addi instruction
        opcode = 6'b001000;  // addi
        #10;
        $display("Tempo %t: Opcode=%b (addi)   | RegDst=%b, Branch=%b, MemRead=%b, MemtoReg=%b, ALUOp=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b",
                 $time, opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
        
        // Test case 6: Invalid opcode
        opcode = 6'b111111;  // Inválido
        #10;
        $display("Tempo %t: Opcode=%b (inválido)| RegDst=%b, Branch=%b, MemRead=%b, MemtoReg=%b, ALUOp=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b",
                 $time, opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
        
        $display("=================================");
        $display("Teste da Control Unit concluído com sucesso!");
        $finish;
    end
    
endmodule
