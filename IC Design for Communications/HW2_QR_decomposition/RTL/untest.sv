module cordic_combined_module (
  input wire signed [15:0] x_input,
  input wire signed [15:0] y_input,
  input wire [7:0] iterations,
  input wire vector_mode,
  output wire signed [15:0] x_output,
  output wire signed [15:0] y_output,
  output wire signed [15:0] angle_output
);
  // Parameters for CORDIC iterations
  parameter W = 16;  // Width of data

  // Internal signals
  reg signed [W-1:0] x_internal;
  reg signed [W-1:0] y_internal;
  reg signed [W-1:0] angle_internal;

  // Constants for atan values
  reg signed [W-1:0] atan_values [0:7];

  // Calculate atan values
  always @* begin
    atan_values[0] = 0;
    atan_values[1] = 45;
    for (int i = 2; i < 8; i = i + 1) begin
      atan_values[i] = atan_values[i-1] / 2;
    end
  end

  // Calculate factor
  reg signed [W-1:0] factor;
  always @* begin
    factor = 1;
    if (vector_mode) begin
      for (int i = 0; i < iterations; i = i + 1) begin
        factor = factor * (1/$sqrt(1+(2**(-i))**2));
      end
    end
  end

  // CORDIC iterations
  always @* begin
    x_internal = x_input;
    y_internal = y_input;
    angle_internal = 0;

    if (vector_mode) begin
      for (int i = 0; i < iterations; i = i + 1) begin
        signed [W-1:0] t = 2**(-i);
        signed [W-1:0] sign_value = -($sign(y_internal)*$sign(x_internal));
        x_internal = x_internal - sign_value * y_internal * t;
        y_internal = y_internal + sign_value * x_internal * t;
        angle_internal = angle_internal - sign_value * atan_values[i];
      end
    end else begin
      if (angle_internal != 0) begin
        for (int i = 0; i < iterations; i = i + 1) begin
          signed [W-1:0] t = 2**(-i);
          signed [W-1:0] sign_value = $sign(angle_internal);
          x_internal = x_internal - sign_value * y_internal * t;
          y_internal = y_internal + sign_value * x_internal * t;
          angle_internal = angle_internal - sign_value * atan_values[i];
        end
      end
    end
  end

  // Output results
  assign x_output = x_internal * factor;
  assign y_output = y_internal * factor;
  assign angle_output = angle_internal;
endmodule
