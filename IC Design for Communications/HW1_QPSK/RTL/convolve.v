module convolve (
  input clk_8megahz,
  input rst_n,
  input signed [13:0] filtered_data,
  input signed [4:0] lo_wave_data,
  output signed [15:0] convolve_data
);

// 16-bit register to store convolution result
reg signed [15:0] conv_reg; 

always @(posedge clk_8megahz or negedge rst_n) begin
  if (!rst_n) 
    conv_reg <= 0;
  else
    // Multiply inputs and truncate to 16 bits
    // conv_reg <= $signed(filtered_data) * $signed(lo_wave_data)[15:0];
    conv_reg <= filtered_data * lo_wave_data;
end 

// Assign register to output
assign convolve_data = conv_reg;

endmodule