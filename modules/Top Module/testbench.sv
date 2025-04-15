`timescale 1ns / 1ps

module tb_MIPS_SingleCycle;
    reg clk = 0;
    reg reset = 0;
    integer cycle_count = 0;
    reg [31:0] last_t0_value;

    // Instanciação do DUT (Device Under Test)
    MIPS_SingleCycle dut (
        .clk(clk),
        .reset(reset)
    );

    // Gera clock (período de 10 unidades de tempo)
    always #5 clk = ~clk;

    // Contador de ciclos de clock
    always @(posedge clk) begin
        if (!reset) begin
            cycle_count <= cycle_count + 1;
        end
    end

    // Monitora mudanças no registrador $t0
    always @(posedge clk) begin
        if (!reset) begin
            if (dut.RF.rf[8] !== last_t0_value) begin
                $display("Clock %0d: $t0 mudou de 0x%h (%0d) para 0x%h (%0d)", 
                        cycle_count,
                        last_t0_value, last_t0_value,
                        dut.RF.rf[8], dut.RF.rf[8]);
                last_t0_value <= dut.RF.rf[8];
            end
        end
    end

    initial begin
        $dumpfile("mips.vcd");
        $dumpvars(0, dut);

        $display("Iniciando Testbench...");
        $display("Monitorando mudanças no registrador $t0 (registrador 8)");
        $display("======================================================");
        
        // Inicializa o último valor conhecido
        last_t0_value = dut.RF.rf[8];
        
        // Aplica reset
        reset = 1;
        #10;
        reset = 0;

        // Executa por tempo suficiente para completar o programa
        #500;
        
        $display("======================================================");
        $display("Estado final dos registradores:");
        $display("$s0 (r16) = %0d (0x%h)", dut.RF.rf[16], dut.RF.rf[16]);
        $display("$t0 (r8) = %0d (0x%h)", dut.RF.rf[8], dut.RF.rf[8]);
        $display("$s1 (r17) = %0d (0x%h)", dut.RF.rf[17], dut.RF.rf[17]);
        $display("Total de ciclos de clock: %0d", cycle_count);
        $display("Fim da simulação.");
        $finish;
    end
endmodule
