`timescale 1ns / 1ps

module ProgramCounter_tb;
    // Sinais do testbench
    logic clk;
    logic reset;
    logic enable;
    logic [31:0] pc_next;
    logic [31:0] pc;

    // Instancia o módulo ProgramCounter
    ProgramCounter uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .pc_next(pc_next),
        .pc(pc)
    );

    // Geração do clock (período de 10ns)
    always #5 clk = ~clk;

    // Sequência de teste
    initial begin
        $display("Iniciando teste do ProgramCounter...");
        $display("=================================");

        // Inicialização
        clk = 0; reset = 0; enable = 0; pc_next = 0;
        #10;

        // Teste 1: Reset síncrono
        reset = 1;
        #10; // Espera borda de clock
        reset = 0;
        $display("PC = %h -> Reset -> PC = %h", pc, pc);

        // Teste 2: Atualizar PC com enable = 1
        enable = 1;
        pc_next = 32'h00000004;
        #10; // Espera borda de clock
        $display("PC = %h -> PC_next = %h -> PC = %h", pc, pc_next, pc);

        // Teste 3: Atualizar PC novamente
        pc_next = 32'h00000008;
        #10; // Espera borda de clock
        $display("PC = %h -> PC_next = %h -> PC = %h", pc, pc_next, pc);

        // Teste 4: Manter PC com enable = 0
        enable = 0;
        pc_next = 32'h00000000;
        #10; // Espera borda de clock
        $display("PC = %h -> PC_next = %h (enable=0) -> PC = %h", pc, pc_next, pc);

        // Teste 5: Reset novamente
        reset = 1;
        #10; // Espera borda de clock
        reset = 0;
        $display("PC = %h -> Reset -> PC = %h", pc, pc);

        // Finalização
        $display("=================================");
        $display("Teste do ProgramCounter concluído com sucesso!");
        #20;
        $stop;
    end

endmodule
