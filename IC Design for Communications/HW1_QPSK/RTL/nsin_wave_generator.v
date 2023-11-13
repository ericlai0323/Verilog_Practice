module nsin_wave_generator (
  input        clk_1megahz,
  input        rst_n, 
  
  // 5-bit combined nsine wave output
  output wire signed [4:0] nsin_out   
);

// Counter 
reg [2:0] count;

// Increment counter
always @(posedge clk_1megahz or negedge rst_n) begin
  if(!rst_n)
    count <= 3'b0;
  else   
    count <= count + 1; 
end

reg [4:0] sin; 

// nsine lookup table
always @(*) begin
  case(count)
    3'd6: sin = ~(5'b00001); // 1.000
    3'd7: sin = ~(5'b01001); // 0.707
    3'd0: sin = ~(5'b00000); // 0.000 
    3'd1: sin = ~(5'b10001); // -0.707
    3'd2: sin = ~(5'b10000); // -1.000
    3'd3: sin = ~(5'b10100); // -0.707
    3'd4: sin = ~(5'b00000); // 0.000
    3'd5: sin = ~(5'b01100); // 0.707
    default: sin = ~(5'b00000); 
  endcase
end

assign nsin_out = sin;

endmodule