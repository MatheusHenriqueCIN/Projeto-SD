
module DataMemory (
    input wire clk,                 // Clock
    input wire mem_read,           // Sinal de leitura
    input wire mem_write,          // Sinal de escrita
    input wire [31:0] addr,        // Endereço de acesso (word-aligned)
    input wire [31:0] write_data,  // Dado a ser escrito
    output reg [31:0] read_data    // Dado lido
);

    // Memória com 1024 posições de 32 bits (4 KB de memória)
    reg [31:0] memory [0:1023];

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
