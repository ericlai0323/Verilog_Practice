module nsin_wave_generator (
  input        clk_8megahz,
  input        rst_n, 
  
  // 5-bit combined nsine wave output
  output [4:0] nsin_out   
);

// Parameter to set nsine wave frequency  
parameter FREQ = 1_000_000;   

// Counter to generate phase   
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

// Lookup 5-bit nsine value  
reg signed [4:0] nsin;

// nsine lookup table
always @(*) begin
  case(phase)
    16'h0000: nsin = -5'b00000; // 0
    16'h0888: nsin = -5'b10001; // 45
    16'h1111: nsin = -5'b11111; // 90
    16'h1777: nsin = -5'b01001; // 135 
    16'h2222: nsin = -5'b00001; // 180
    16'h2EEE: nsin = -5'b10000; // 225
    16'h3CCC: nsin = -5'b01100; // 270
    16'h4777: nsin = -5'b00101; // 315
    default: nsin = -5'b00000;
  endcase
end

// Break down 5-bit nsine value
wire nsin_sign = nsin[4];
wire nsin_int = nsin[3];
wire [2:0] nsin_float = nsin[2:0];

// Concatenate as 5-bit output 
assign nsin_out = {nsin_sign, nsin_int, nsin_float};

endmodule