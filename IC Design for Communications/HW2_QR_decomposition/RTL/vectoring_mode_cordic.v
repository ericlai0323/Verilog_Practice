module vectoring_mode_cordic(
    input clk,
    input rstn,
    input signed [11:0]x_value, // [11]Signed 1-bit [10:0] Data 11-bit
    input signed [11:0]y_value,
    output reg signed [11:0]x_out,
    output reg signed [11:0]y_out,
    input [6:0]angle // [6]Signed 1-bit, [5:0]Data 6-bit  +99 ~ -99
);
// iteration = 8

reg signed [11:0] x_temp, y_temp;
reg signed [20:0] angle_temp; // Increase the precision for intermediate angle
reg [3:0] i; // Loop variable
reg [11:0] factor; // factor = 0.6073 * 2^10 = 621.8752

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        x_temp <= 0;
        y_temp <= 0;
        angle_temp <= 0;
        x_out <= 0;
        y_out <= 0;
        i <= 0;
        factor <= 1 << 10; // Equivalent to 1 in fixed point
    end else begin
        x_temp <= x_value;
        y_temp <= y_value;
        angle_temp <= 0;
        factor <= 1 << 10; // Reset factor for each operation
        for (i = 0; i < 8; i = i + 1) begin
            if (y_temp != 0) begin
                if (y_temp < 0) begin
                    x_temp <= x_temp + (y_temp >>> i);
                    y_temp <= y_temp - (x_temp >>> i);
                    angle_temp <= angle_temp + (atan_table[i] >>> 10);
                end else begin
                    x_temp <= x_temp - (y_temp >>> i);
                    y_temp <= y_temp + (x_temp >>> i);
                    angle_temp <= angle_temp - (atan_table[i] >>> 10);
                end
            end
        end
        x_out <= (x_temp * factor) >>> 10; // Adjusting for fixed point
        y_out <= (y_temp * factor) >>> 10;
    end
end


endmodule