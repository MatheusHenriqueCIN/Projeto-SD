module SignExtend (
	input wire [15:0] in,    	// Imediato de 16 bits
	output wire [31:0] out   	// Valor estendido para 32 bits
);

	assign out = {{16{in[15]}}, in};  // Estende o bit de sinal (bit 15) para os 16 bits superiores

endmodule

