module rotating_mode_cordic(
    input clk,
    input rstn,
    input signed [11:0] x_value,
    input signed [11:0] y_value,
    input signed [6:0] angle,
    output reg signed [11:0] x_out,
    output reg signed [11:0] y_out
);

// Constants
parameter iteration = 8;
parameter factor = 10'b10_0110_1101; // 0.6073 * 2^10 = 621.8752

reg signed [11:0] x_temp, y_temp;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Reset logic here if needed
        x_temp <= 12'b0;
        y_temp <= 12'b0;
        x_out <= 12'b0;
        y_out <= 12'b0;
    end else begin
        // Rotate if angle is not zero
        if (angle != 0) begin
            for (int i = 0; i < iteration; i = i + 1) begin
                int sign_value = (angle < 0) ? -1 : 1;
                x_temp <= x_value - sign_value * y_value * (2 ** -i);
                y_temp <= y_value + sign_value * x_value * (2 ** -i);
                angle <= angle - sign_value * $atanh(2 ** -i);
                x_value <= x_temp;
                y_value <= y_temp;
            end
        end

        // Output values
        x_out <= x_value * factor;
        y_out <= y_value * factor;
    end
end

endmodule
