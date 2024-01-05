module vectoring_mode_cordic_pipeline(
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

// Pipeline registers
reg signed [11:0] x_temp[0:iteration-1], y_temp[0:iteration-1];
reg signed [20:0] angle_temp[0:iteration-1]; // Increase the precision for intermediate angle
reg unsigned [3:0] i[0:iteration-1]; // Loop variable 

// Pipeline control signals
reg [2:0] pipeline_stage = 3'b000;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        // Reset values
        x_out <= 0;
        y_out <= 0;
        pipeline_stage <= 3'b000;
    end else begin
        // Stage 0: Input stage
        if (pipeline_stage == 3'b000) begin
            // Assign input values
            x_temp[0] <= x_value;
            y_temp[0] <= y_value;
            angle_temp[0] <= 0;
            i[0] <= 0;
        end

        // Stage 1: CORDIC iteration loop
        if (pipeline_stage >= 3'b001 && pipeline_stage < iteration + 3'b001) begin
            i[pipeline_stage-3'b001] <= pipeline_stage - 3'b001;
            case (y_temp[pipeline_stage-3'b001] < 0)
                1'b0: begin
                    x_temp[pipeline_stage-3'b001] <= x_temp[pipeline_stage-4'd1] - (y_temp[pipeline_stage-4'd1] >>> i[pipeline_stage-4'd1]);
                    y_temp[pipeline_stage-3'b001] <= y_temp[pipeline_stage-4'd1] + (x_temp[pipeline_stage-4'd1] >>> i[pipeline_stage-4'd1]);
                    angle_temp[pipeline_stage-3'b001] <= angle_temp[pipeline_stage-4'd1] - (atan_table[i[pipeline_stage-4'd1]] >>> 10);
                end
                1'b1: begin
                    x_temp[pipeline_stage-3'b001] <= x_temp[pipeline_stage-4'd1] + (y_temp[pipeline_stage-4'd1] >>> i[pipeline_stage-4'd1]);
                    y_temp[pipeline_stage-3'b001] <= y_temp[pipeline_stage-4'd1] - (x_temp[pipeline_stage-4'd1] >>> i[pipeline_stage-4'd1]);
                    angle_temp[pipeline_stage-3'b001] <= angle_temp[pipeline_stage-4'd1] + (atan_table[i[pipeline_stage-4'd1]] >>> 10);
                end
            endcase
        end

        // Stage 2: Output stage
        if (pipeline_stage == iteration + 3'b001) begin
            // Output values
            x_out <= (x_temp[iteration-1] * factor) >>> 10; // Adjusting for fixed point
            y_out <= (y_temp[iteration-1] * factor) >>> 10;
        end

        // Pipeline control
        if (pipeline_stage < iteration + 3'b010)
            pipeline_stage <= pipeline_stage + 1;
        else
            pipeline_stage <= 3'b000;
    end
end

endmodule
