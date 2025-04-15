`timescale 1ns / 1ps

module instruction_memory_tb;

    // Inputs
    reg [31:0] address;

    // Outputs
    wire [31:0] instruction;

    // Instantiate the Unit Under Test (UUT)
    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin
        $display("Iniciando teste do Instruction Memory...");
        $display("=================================");
        
        // Test case 1: Primeira instrução (addi $s0, $0, 4)
        address = 32'h00000000;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $s0, $0, 4)", address, instruction);
        
        // Test case 2: Segunda instrução (addi $t0, $0, 1)
        address = 32'h00000004;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $t0, $0, 1)", address, instruction);
        
        // Test case 3: Terceira instrução (addi $s1, $0, $0)
        address = 32'h00000008;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $s1, $0, $0)", address, instruction);
        
        // Test case 4: Instrução de branch (beq $s0, $t0, done)
        address = 32'h0000000C;
        #10;
        $display("Endereço: %h | Instrução: %b (beq $s0, $t0, done)", address, instruction);
        
        // Test case 5: Quinta instrução (addi $t0, $0, 2)
        address = 32'h00000010;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $t0, $0, 2)", address, instruction);
        
        // Test case 6: Sexta instrução (addi $s1, $0, 8)
        address = 32'h00000014;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $s1, $0, 8)", address, instruction);
        
        // Test case 7: Sétima instrução (beq $s0, $t0, done)
        address = 32'h00000018;
        #10;
        $display("Endereço: %h | Instrução: %b (beq $s0, $t0, done)", address, instruction);
        
        // Test case 8: Oitava instrução (addi $t0, $0, 3)
        address = 32'h0000001C;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $t0, $0, 3)", address, instruction);
        
        // Test case 9: Nona instrução (addi $s1, $0, 15)
        address = 32'h00000020;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $s1, $0, 15)", address, instruction);
        
        // Test case 10: Décima instrução (beq $s0, $t0, done)
        address = 32'h00000024;
        #10;
        $display("Endereço: %h | Instrução: %b (beq $s0, $t0, done)", address, instruction);
        
        // Test case 11: Décima primeira instrução (addi $t0, $0, 4)
        address = 32'h00000028;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $t0, $0, 4)", address, instruction);
        
        // Test case 12: Décima segunda instrução (addi $s1, $0, 22)
        address = 32'h0000002C;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $s1, $0, 22)", address, instruction);
        
        // Test case 13: Décima terceira instrução (beq $s0, $t0, done)
        address = 32'h00000030;
        #10;
        $display("Endereço: %h | Instrução: %b (beq $s0, $t0, done)", address, instruction);
        
        // Test case 14: Décima quarta instrução (addi $s1, $0, 28)
        address = 32'h00000034;
        #10;
        $display("Endereço: %h | Instrução: %b (addi $s1, $0, 28)", address, instruction);
        
        $display("=================================");
        $display("Teste concluído com sucesso!");
        $finish;
    end

endmodule
