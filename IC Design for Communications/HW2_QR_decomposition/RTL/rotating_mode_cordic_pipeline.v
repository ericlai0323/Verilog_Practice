module rotating_mode_cordic_pipeline(
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

// Pipeline registers
reg signed [11:0] x_temp[0:iteration-1], y_temp[0:iteration-1];
reg signed [6:0] angle_temp[0:iteration-1];
reg signed [11:0] x_out_temp[0:iteration-1], y_out_temp[0:iteration-1];
reg [2:0] pipeline_stage = 3'b000;

// atan_table instance
atan_table atan_inst (
    .index(angle_temp[iteration-1]),
    .atan_value(angle_temp[iteration-1])
);

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Reset pipeline registers
        x_temp <= 0;
        y_temp <= 0;
        angle_temp <= 0;
        x_out_temp <= 0;
        y_out_temp <= 0;
        pipeline_stage <= 3'b000;
    end else begin
        // Stage 0: Input stage
        if (pipeline_stage == 3'b000) begin
            // Assign input values
            x_temp[0] <= x_value;
            y_temp[0] <= y_value;
            angle_temp[0] <= angle;
        end

        // Stage 1: CORDIC iteration loop
        if (pipeline_stage >= 3'b001 && pipeline_stage < iteration + 3'b001) begin
            int i = pipeline_stage - 3'b001;
            int sign_value = (angle_temp[i] < 0) ? -1 : 1;
            x_temp[i+1] <= x_temp[i] - sign_value * y_temp[i] * (2 ** -i);
            y_temp[i+1] <= y_temp[i] + sign_value * x_temp[i] * (2 ** -i);
            angle_temp[i+1] <= angle_temp[i] - sign_value * atan_temp[i];
        end

        // Stage 2: Output stage
        if (pipeline_stage == iteration + 3'b001) begin
            // Output values
            x_out_temp[iteration-1] <= x_temp[iteration-1] * factor;
            y_out_temp[iteration-1] <= y_temp[iteration-1] * factor;
        end

        // Pipeline control
        if (pipeline_stage < iteration + 3'b010)
            pipeline_stage <= pipeline_stage + 1;
        else
            pipeline_stage <= 3'b000;
    end
end

// Output values
assign x_out = x_out_temp[iteration-1];
assign y_out = y_out_temp[iteration-1];

endmodule
