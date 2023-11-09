module local_oscillator_nsin(
  input clk_8megahz,
  input rst_n,
  input wire signed [13:0] filtered_data,
  output reg signed [13:0] lo_nsin_data  
);

// 14-bit truncated constants
localparam SIN_MAX = 14'h2000;
// localparam SIN_SCALE = 14'h4000; 

reg [31:0] phase_accum;

always @(posedge clk_8megahz) begin
  if(!rst_n)
    phase_accum <= 0;
  else  
    phase_accum <= phase_accum + filtered_data;
end

wire [13:0] sin_out;

assign sin_out = SIN_MAX - $signed(phase_accum[31:18]);

always @(posedge clk_8megahz) begin
  if(!rst_n)
    lo_nsin_data <= 0;
  else
    lo_nsin_data <= -sin_out; // Negate to get negative sine
end

endmodule