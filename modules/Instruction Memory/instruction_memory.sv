module instruction_memory (
    input wire [31:0] address,
    output reg [31:0] instruction
);
    reg [31:0] mem [0:63];
    initial begin
        mem[0] = 32'h2001000A;  // addi $1, $0, 10
        mem[1] = 32'h20020014;  // addi $2, $0, 20
        mem[2] = 32'h20030032;  // addi $3, $0, 50
        mem[3] = 32'hAC010000;  // sw $1, 0($0)
        mem[4] = 32'h00220820;  // add $1, $1, $2
        mem[5] = 32'h10230002;  // beq $1, $3, 2
        mem[6] = 32'h1000FFFD;  // beq $0, $0, -3
        mem[7] = 32'h00000000;  // nop
    end
    always @(address) begin
        instruction = mem[address >> 2];
    end
endmodule
