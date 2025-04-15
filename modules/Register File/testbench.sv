`timescale 1ns / 1ps

module regfile_tb;
    // Testbench Signals
    logic clk;
    logic we3;
    logic [4:0] ra1, ra2, wa3;
    logic [31:0] wd3;
    logic [31:0] rd1, rd2;

    // Instantiate Register File
    regfile uut (
        .clk(clk),
        .we3(we3),
        .ra1(ra1),
        .ra2(ra2),
        .wa3(wa3),
        .wd3(wd3),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock Generation
    always #5 clk = ~clk;  // Clock com período de 10ns

    // Test Sequence
    initial begin
        $display("Iniciando teste do Register File...");
        $display("=================================");
        
        // Inicialização
        clk = 0; we3 = 0; ra1 = 0; ra2 = 0; wa3 = 0; wd3 = 0;
        #10;

        // Teste 1: Escrever em R5 e ler R5
        write_reg(5, 32'hA5A5A5A5);
        read_reg(5, 0);
        $display("R[5] = %h, R[0] = %h", rd1, rd2);

        // Teste 2: Escrever em R10 e ler R10
        write_reg(10, 32'h12345678);
        read_reg(10, 0);
        $display("R[10] = %h, R[0] = %h", rd1, rd2);

        // Teste 3: Tentar escrever em R0 e ler R0
        write_reg(0, 32'hFFFFFFFF);
        read_reg(0, 5);
        $display("R[0] = %h, R[5] = %h", rd1, rd2);

        // Teste 4: Escrever e ler em outro registrador (R15)
        write_reg(15, 32'h5555AAAA);
        read_reg(15, 10);
        $display("R[15] = %h, R[10] = %h", rd1, rd2);

        // Finalização
        $display("=================================");
        $display("Teste do Register File concluído com sucesso!");
        #20;
        $stop;
    end

    // Task para Escrever em um Registrador
    task write_reg(input [4:0] regnum, input [31:0] value);
        begin
            we3 = 1;
            wa3 = regnum;
            wd3 = value;
            #10; // Espera a borda do clock
            we3 = 0; // Desabilita escrita
            #10;
        end
    endtask

    // Task para Ler Registradores
    task read_reg(input [4:0] regA, input [4:0] regB);
        begin
            ra1 = regA;
            ra2 = regB;
            #10; // Espera a propagação da lógica combinacional
        end
    endtask

endmodule
