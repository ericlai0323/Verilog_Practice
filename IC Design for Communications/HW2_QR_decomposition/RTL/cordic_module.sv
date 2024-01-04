module cordic_combined_module (
  input wire signed [15:0] x_vector_input,
  input wire signed [15:0] y_vector_input,
  input wire signed [15:0] x_rotation_input,
  input wire signed [15:0] y_rotation_input,
  output wire signed [15:0] magnitude_vector_output,
  output wire signed [15:0] angle_vector_output,
  output wire signed [15:0] magnitude_rotation_output,
  output wire signed [15:0] angle_rotation_output
);
  // Parameters for CORDIC iterations
  parameter n = 8;   // Number of iterations
  parameter w = 16;  // Width of data

  // Internal signals for vector mode
  reg signed [w-1:0] x_vector_internal;
  reg signed [w-1:0] y_vector_internal;
  reg signed [w-1:0] z_vector_internal;

  // Internal signals for rotation mode
  reg signed [w-1:0] x_rotation_internal;
  reg signed [w-1:0] y_rotation_internal;
  reg signed [w-1:0] z_rotation_internal;

  // Constant arrays for atan values
  reg unsigned [10:0] atan_table[15:0] = 
  {
    16'b101101_1100101000,
    16'b011010_1001001101,
    16'b001110_0011111110,
    16'b000111_0011110000,
    16'b000010_1001101101,
    16'b000001_0010101100,
    16'b000000_1110100010,
    16'b000000_1001001100,
    16'b000000_0100100001,
    16'b000000_0001101110,
    16'b000000_1101110100
  };

  // Initialize internal signals using non-blocking assignments
  always @* begin
    x_vector_internal <= x_vector_input;
    y_vector_internal <= y_vector_input;
    z_vector_internal <= 0;  // Initial angle for vector mode

    x_rotation_internal <= x_rotation_input;
    y_rotation_internal <= y_rotation_input;
    z_rotation_internal <= 0;  // Initial angle for rotation mode
  end

  // CORDIC vectoring iterations
  generate
    genvar i_vector;
    for (i_vector = 0; i_vector < n; i_vector = i_vector + 1) begin : cordic_iterations_vector
      always @* begin
        if (y_vector_internal > 0) begin
          x_vector_internal <= x_vector_internal - (y_vector_internal >> i_vector);
          y_vector_internal <= y_vector_internal + (x_vector_internal >> i_vector);
          z_vector_internal <= z_vector_internal + atan_table[i_vector];
        end else begin
          x_vector_internal <= x_vector_internal + (y_vector_internal >> i_vector);
          y_vector_internal <= y_vector_internal - (x_vector_internal >> i_vector);
          z_vector_internal <= z_vector_internal - atan_table[i_vector];
        end
      end
    end
  endgenerate

  // CORDIC rotation iterations
  generate
    genvar i_rotation;
    for (i_rotation = 0; i_rotation < n; i_rotation = i_rotation + 1) begin : cordic_iterations_rotation
      always @* begin
        if (y_rotation_internal > 0) begin
          x_rotation_internal <= x_rotation_internal - (y_rotation_internal >> i_rotation);
          y_rotation_internal <= y_rotation_internal + (x_rotation_internal >> i_rotation);
          z_rotation_internal <= z_rotation_internal + atan_table[i_rotation];
        end else begin
          x_rotation_internal <= x_rotation_internal + (y_rotation_internal >> i_rotation);
          y_rotation_internal <= y_rotation_internal - (x_rotation_internal >> i_rotation);
          z_rotation_internal <= z_rotation_internal - atan_table[i_rotation];
        end
      end
    end
  endgenerate

  // Output magnitude and angle for vector mode
  assign magnitude_vector_output = $sqrt(x_vector_internal*x_vector_internal + y_vector_internal*y_vector_internal);
  assign angle_vector_output = z_vector_internal;

  // Output magnitude and angle for rotation mode
  assign magnitude_rotation_output = $sqrt(x_rotation_internal*x_rotation_internal + y_rotation_internal*y_rotation_internal);
  assign angle_rotation_output = z_rotation_internal;
endmodule
