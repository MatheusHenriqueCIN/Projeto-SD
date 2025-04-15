`timescale 1ns / 1ps

module tb_DataMemory;
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [31:0] addr;
    reg [31:0] write_data;
    wire [31:0] read_data;

    DataMemory uut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("\nIniciando teste da DataMemory...");
        $display("=================================");
        
        // Inicialização
        mem_read = 0;
        mem_write = 0;
        addr = 0;
        write_data = 0;
        #10;
        
        // Teste 1: Escrita e leitura válida
        addr = 32'h00000004;
        write_data = 32'hABCD1234;
        mem_write = 1;
        #10;
        mem_write = 0;
        mem_read = 1;
        #10;
        if (read_data !== 32'hABCD1234)
            $error("Erro na leitura! Esperado: ABCD1234 | Recebido: %h", read_data);
        mem_read = 0;
        
        // Teste 2: Escrita e leitura no limite
        addr = 32'h00000FFC;
        write_data = 32'hFFFFFFFF;
        mem_write = 1;
        #10;
        mem_write = 0;
        mem_read = 1;
        #10;
        if (read_data !== 32'hFFFFFFFF)
            $error("Erro no endereço limite! Esperado: FFFFFFFF | Recebido: %h", read_data);
        mem_read = 0;
        
        // Teste 3: Leitura inativa
        addr = 32'h00000004;
        mem_read = 0;
        #10;
        if (read_data !== 32'h00000000)
            $error("Erro na leitura inativa! Saída deveria ser zero, recebido: %h", read_data);
            
        // Teste 4: Endereço inválido
        addr = 32'h00001000;
        mem_read = 1;
        #10;
        if (read_data !== 32'hxxxxxxxx)
            $error("Erro no endereço inválido! Esperado: xxxxxxxx | Recebido: %h", read_data);
        mem_read = 0;
        
        $display("=================================");
        $display("Teste da DataMemory concluído!");
        $finish;
    end
endmodule
