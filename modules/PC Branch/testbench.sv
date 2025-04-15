`timescale 1ns / 1ps

module PCBranch_tb;

    // Parâmetros
    parameter CLK_PERIOD = 10;  // Período do clock em ns

    // Sinais de entrada
    reg [31:0] pc_plus_4;
    reg [31:0] imm_ext;
    
    // Sinais de saída
    wire [31:0] pc_branch_out;
    
    // Instância do módulo testado
    PCBranch uut (
        .pc_plus_4(pc_plus_4),
        .imm_ext(imm_ext),
        .pc_branch_out(pc_branch_out)
    );
    
    // Inicialização
    initial begin
        $display("Iniciando teste do PC Branch...");
        $display("=================================");
        $display("");
        
        // Teste 1: Branch pequeno positivo
        pc_plus_4 = 32'h0000_1004;
        imm_ext = 32'h0000_0001;  // +1 (depois do shift será +4)
        #CLK_PERIOD;
        $display("Teste 1 - PC+4: 0x%h, Imm: 0x%h -> PCBranch: 0x%h (Esperado: 0x00001008)", 
                 pc_plus_4, imm_ext, pc_branch_out);
        
        // Teste 2: Branch grande positivo
        pc_plus_4 = 32'h0000_2008;
        imm_ext = 32'h0000_0100;  // +256 (depois do shift será +1024)
        #CLK_PERIOD;
        $display("Teste 2 - PC+4: 0x%h, Imm: 0x%h -> PCBranch: 0x%h (Esperado: 0x00002408)", 
                 pc_plus_4, imm_ext, pc_branch_out);
        
        // Teste 3: Branch negativo (backward)
        pc_plus_4 = 32'h0000_300C;
        imm_ext = 32'hFFFF_FFFC;  // -4 (depois do shift será -16)
        #CLK_PERIOD;
      $display("Teste 3 - PC+4: 0x%h, Imm: 0x%h -> PCBranch: 0x%h (Esperado: 0x00002ffc)", 
                 pc_plus_4, imm_ext, pc_branch_out);
        
        // Teste 4: Branch zero (próxima instrução)
        pc_plus_4 = 32'h0000_4010;
        imm_ext = 32'h0000_0000;  // 0
        #CLK_PERIOD;
        $display("Teste 4 - PC+4: 0x%h, Imm: 0x%h -> PCBranch: 0x%h (Esperado: 0x00004010)", 
                 pc_plus_4, imm_ext, pc_branch_out);
        
        // Teste 5: Valor máximo positivo
        pc_plus_4 = 32'h7FFF_FFFC;
        imm_ext = 32'h3FFF_FFFF;  // Valor grande positivo
        #CLK_PERIOD;
      $display("Teste 5 - PC+4: 0x%h, Imm: 0x%h -> PCBranch: 0x%h (Esperado: 0x7ffffff8)", 
                 pc_plus_4, imm_ext, pc_branch_out);
        
        $display("");
        $display("=================================");
        $display("Teste do PC Branch concluído com sucesso!");
        $finish;
    end

endmodule
