module cos_wave_generator (
  input        clk_8megahz,
  input        rst_n, 
  
  // 5-bit combined cosine output
  output [4:0] cos_out   
);

// Set frequency to 1 MHz
parameter FREQ = 1_000_000;    

// Phase counter
reg [31:0] count;
wire [15:0] phase;

// Increment counter 
always @(posedge clk_8megahz) begin
  if(!rst_n)
    count <= 0;
  else if(count == (50_000_000 / FREQ) - 1)  
    count <= 0;
  else  
    count <= count + 1;
end

// Assign lower 16 bits as phase 
assign phase = count[15:0];

// Lookup 5-bit cosine value
reg signed [4:0] cos;

// Cosine lookup table
always @(*) begin
  case(phase)
    16'h0000: cos = 5'b11111; // 90
    16'h0888: cos = 5'b01001; // 45
    16'h1111: cos = 5'b00000; // 0
    16'h1777: cos = 5'b10100; // 315
    16'h2222: cos = 5'b10000; // 270
    16'h2EEE: cos = 5'b01100; // 225
    16'h3CCC: cos = 5'b00101; // 180
    16'h4777: cos = 5'b10001; // 135
    default: cos = 5'b00000;
  endcase
end

// Break out sign, integer, fractional bits from cosine 
wire cos_sign = cos[4];
wire cos_int = cos[3];
wire [2:0] cos_frac = cos[2:0];

// Concat to 5-bit cos_out
assign cos_out = {cos_sign, cos_int, cos_frac};

endmodule