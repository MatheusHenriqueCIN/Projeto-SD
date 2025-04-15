module tb_MIPS_SingleCycle;
	reg clk = 0;
	reg reset = 0;

	// Instanciação do DUT (Device Under Test)
	MIPS_SingleCycle dut (
    	.clk(clk),
    	.reset(reset)
	);

	// Gera clock (10 unidades de tempo)
	always #5 clk = ~clk;

	initial begin
    	$dumpfile("mips.vcd");
    	$dumpvars(0, dut);

    	$display("Iniciando Testbench...");
    	reset = 1;
    	#10;
    	reset = 0;

    	// Espera um pouco e mostra registradores
    	#200;
    	$display("=== Estado dos Registradores ===");
      	$display("t0 = %d", dut.RF.rf[8]);
      	$display("s0 = %d", dut.RF.rf[16]);
      	$display("s1 = %d", dut.RF.rf[17]);

    	$display("Fim da simulação.");
    	$finish;
end
 
endmodule
