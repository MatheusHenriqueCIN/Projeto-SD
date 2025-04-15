`timescale 1ns / 1ps

module DataMemory (
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input wire [31:0] addr,
    input wire [31:0] write_data,
    output reg [31:0] read_data
);

    // Memória com 1024 posições de 32 bits (4 KB)
    reg [31:0] memory [0:1023];
    
    // Inicialização da memória (todas posições para zero)
    integer i;
    initial begin
        for (i = 0; i < 1024; i = i + 1)
            memory[i] = 32'b0;
    end

    // Leitura combinacional
    always @(*) begin
        if (mem_read) begin
            if (addr[31:12] == 20'b0) begin  // Verifica se endereço está dentro dos limites
                read_data = memory[addr[11:2]];
                $display("[MEM READ] Addr: %h : Data: %h", addr, read_data);
            end else begin
                read_data = 32'hxxxxxxxx;
                $display("[MEM READ ERROR] Endereço %h fora dos limites!", addr);
            end
        end else begin
            read_data = 32'b0;
        end
    end

    // Escrita sincronizada
    always @(posedge clk) begin
        if (mem_write) begin
            if (addr[31:12] == 20'b0) begin  // Verifica se endereço está dentro dos limites
                memory[addr[11:2]] <= write_data;
                $display("[MEM WRITE] Addr: %h : Data: %h", addr, write_data);
            end else begin
                $display("[MEM WRITE ERROR] Endereço %h fora dos limites!", addr);
            end
        end
    end

endmodule
