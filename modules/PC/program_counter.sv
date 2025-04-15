module ProgramCounter (
    input logic clk,           // Clock
    input logic reset,        // Reset síncrono
    input logic enable,       // Habilita a atualização do PC
    input logic [31:0] pc_next, // Próximo valor do PC
    output logic [31:0] pc     // Valor atual do PC
);

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= 32'b0;      // Reseta o PC para 0
        end else if (enable) begin
            pc <= pc_next;    // Atualiza o PC com o próximo valor
        end // else: pc mantém o valor anterior (implícito)
    end

endmodule
