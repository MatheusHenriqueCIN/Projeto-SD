
`timescale 1ns / 1ps
module tb_instruction_memory;
    reg [31:0] address;
    wire [31:0] instruction;

    // Instantiate the module
    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    // Test stimulus
    initial begin
        // Print header
        $display("Iniciando teste do Instruction Memory...");
        $display("=================================");

        // Monitor address and instruction changes
        $monitor("address = %08h -> instruction = %08h", address, instruction);

        // Test 1: address = 0, expect instruction = 2001000A
        address = 32'h00000000;
        #10;

        // Test 2: address = 4, expect instruction = 20020014
        address = 32'h00000004;
        #10;

        // Test 3: address = 8, expect instruction = 20030032
        address = 32'h00000008;
        #10;

        // Test 4: address = 16, expect instruction = 00220820
        address = 32'h00000010;
        #10;

        // Print footer
        $display("=================================");
        $display("Teste do Instruction Memory concluído com sucesso!");

        $finish;
    end
endmodule
