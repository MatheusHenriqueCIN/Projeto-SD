
module tb_DataMemory;

    // Sinais
    reg clk;
    reg mem_read;
    reg mem_write;
    reg [31:0] addr;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Instância do módulo
    DataMemory uut (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock: alterna a cada 5 unidades de tempo (período de 10)
    initial clk = 0;
    always #5 clk = ~clk;

    // Processo de teste
    initial begin
        // Inicialização
        mem_read = 0;
        mem_write = 0;
        addr = 0;
        write_data = 0;

        // Espera 1 ciclo
        @(posedge clk);

        // ---------------------------
        // Escrita 1: endereço 4
        // ---------------------------
        addr = 32'h00000004;
        write_data = 32'hABCD1234;
        mem_write = 1;
        @(posedge clk);
        mem_write = 0;

        // ---------------------------
        // Leitura 1: endereço 4
        // ---------------------------
        addr = 32'h00000004;
        mem_read = 1;
        @(posedge clk);
        $display("Read data (addr 4): %h", read_data);
        mem_read = 0;

        // ---------------------------
        // Escrita 2: endereço 8
        // ---------------------------
        addr = 32'h00000008;
        write_data = 32'h55555555;
        mem_write = 1;
        @(posedge clk);
        mem_write = 0;

        // ---------------------------
        // Leitura 2: endereço 8
        // ---------------------------
        addr = 32'h00000008;
        mem_read = 1;
        @(posedge clk);
        $display("Read data (addr 8): %h", read_data);
        mem_read = 0;

        // Finaliza simulação
        @(posedge clk);
        $finish;
    end

endmodule
