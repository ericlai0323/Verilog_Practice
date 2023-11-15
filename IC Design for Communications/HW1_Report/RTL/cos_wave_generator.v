module cos_wave_generator (
  input        clk_1megahz,
  input        rst_n, 
  
  // 5-bit combined cosine output
  output wire signed [4:0] cos_out   
);

// counter
reg [2:0] count; 

// Increment counter
always @(posedge clk_1megahz or negedge rst_n) begin
  if(!rst_n)
    count <= 3'b0;
  else   
    count <= count + 1; 
end

reg [4:0] cos; 

// Cosine lookup table  
always @(*) begin
  case(count)
    3'd0: cos = 5'b00001; // 1.000
    3'd1: cos = 5'b01001; // 0.707        
    3'd2: cos = 5'b00000; // 0.000
    3'd3: cos = 5'b10001; // -0.707
    3'd4: cos = 5'b10000; // -1.000
    3'd5: cos = 5'b10100; // -0.707 
    3'd6: cos = 5'b00000; // 0.000
    3'd7: cos = 5'b01100; // 0.707
    default: cos = 5'b00000;
  endcase
end

assign cos_out = cos;

endmodule