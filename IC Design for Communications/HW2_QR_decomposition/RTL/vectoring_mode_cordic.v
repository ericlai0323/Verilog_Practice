module vectoring_mode_cordic(
    input clk,
    input rstn,
    input signed [11:0] x_value,
    input signed [11:0] y_value,
    output reg signed [11:0] x_out,
    output reg signed [11:0] y_out,
    input [6:0] angle
);

// Constants
parameter iteration = 8;
parameter factor = 10'b10_0110_1101; // factor = 0.6073 * 2^10 = 621.8752 fixed-point -> 621 -> 9-bit

// Internal signals
reg signed [11:0] x_temp, y_temp;
reg signed [20:0] angle_temp; // Increase the precision for intermediate angle
reg unsigned [3:0] i; // Loop variable 

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Reset values
        x_temp <= 0;
        y_temp <= 0;
        angle_temp <= 0;
        x_out <= 0;
        y_out <= 0;
        i <= 0;
        factor <= 1 << 10; // Equivalent to 1 in fixed point
    end else begin
        // Assign input values
        x_temp <= x_value;
        y_temp <= y_value;
        angle_temp <= 0;
        factor <= 1 << 10; // Reset factor for each operation

        // CORDIC iteration loop
        for (i = 0; i < iteration; i = i + 1) begin
            case (y_temp < 0)
                1'b0: begin
                    x_temp <= x_temp - (y_temp >>> i);
                    y_temp <= y_temp + (x_temp >>> i);
                    angle_temp <= angle_temp - (atan_table[i] >>> 10);
                end
                1'b1: begin
                    x_temp <= x_temp + (y_temp >>> i);
                    y_temp <= y_temp - (x_temp >>> i);
                    angle_temp <= angle_temp + (atan_table[i] >>> 10);
                end
            endcase
        end

        // Output values
        x_out <= (x_temp * factor) >>> 10; // Adjusting for fixed point
        y_out <= (y_temp * factor) >>> 10;
    end
end

endmodule
