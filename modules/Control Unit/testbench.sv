


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
        // Inicializa as entradas
        opcode = 0;
        
        // Monitoramento dos sinais
        $monitor("Tempo %t: opcode=%b | RegDst=%b, Branch=%b, MemRead=%b, MemtoReg=%b, ALUOp=%b, MemWrite=%b, ALUSrc=%b, RegWrite=%b",
                 $time, opcode, RegDst, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
        
        // Test case 1: R-type instruction
        #10 opcode = 6'b000000;  // Tipo R
        #10;
        
        // Test case 2: lw instruction
        #10 opcode = 6'b100011;  // lw
        #10;
        
        // Test case 3: sw instruction
        #10 opcode = 6'b101011;  // sw
        #10;
        
        // Test case 4: beq instruction
        #10 opcode = 6'b000100;  // beq
        #10;
        
        // Test case 5: addi instruction
        #10 opcode = 6'b001000;  // addi
        #10;
        
        // Test case 6: Invalid opcode
        #10 opcode = 6'b111111;  // Inválido
        #10;
        
        $display("Testes concluídos!");
        $finish;
    end
    
endmodule

