module adder(
    input clk_8megahz,
    input rst_n,
    input signed [15:0] data_i,
    input signed [15:0] data_q,
    output signed [15:0] sum_data
);

    reg [15:0] sum_reg;

    always @(posedge clk_8megahz or negedge rst_n) begin
        if (!rst_n) begin
            sum_reg <= 16'b0; // Reset to zero when rst_n is low
        end else begin
            // Add data_i and data_q, store result in sum_reg
            sum_reg <= data_i + data_q;
        end
    end

    assign sum_data = sum_reg;

endmodule
