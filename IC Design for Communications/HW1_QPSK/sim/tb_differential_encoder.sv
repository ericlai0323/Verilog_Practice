`timescale 1ns / 1ps
`define CYCLE 125

module tb_differential_encoder;

integer tmp;
// Inputs  
reg clk_8megahz;
reg rst_n; 

// Interface to DUT
wire s2p_i, s2p_q;

wire signed[1:0] diff_remapped_i, diff_remapped_q;

// File handles 
integer infile;
integer outfile;

// Internal signal
reg binary_data;

clk_generator clk_generator(
    .clk_8megahz(clk_8megahz),
    .rst_n(rst_n),
    .clk_2megahz(clk_2megahz),
    .clk_1megahz(clk_1megahz)
);

s2p s2p (
  .binary_data(binary_data), 
  .clk_2megahz(clk_2megahz),
  .clk_1megahz(clk_1megahz),
  .rst_n(rst_n),
  .s2p_i(s2p_i),
  .s2p_q(s2p_q)
);

differential_encoder differential_encoder(
    .clk_1megahz(clk_1megahz),
    .rst_n(rst_n),
    .s2p_i(s2p_i),
    .s2p_q(s2p_q),
    .diff_remapped_i(diff_remapped_i),
    .diff_remapped_q(diff_remapped_q)
);

// 8MHz clock
always #(`CYCLE/2) clk_8megahz = ~clk_8megahz;   

initial begin
   $dumpvars();
   $dumpfile("Differential Encoder.vcd");
end


initial begin
  clk_8megahz = 1'b0;
  // Reset
  rst_n = 1'b0;
  #1000;
  rst_n = 1'b1;

  // Open files
  infile = $fopen("input_data.csv", "r"); 
  outfile = $fopen("differential_encoder_data.csv", "w");

  // Read input data from file
  
  while (!$feof(infile)) begin
    tmp = $fscanf(infile, "%d", binary_data);
    $display("Read Data: %d", binary_data);
    @(posedge clk_2megahz);
  end

  // Close files 
  $fclose(infile);

  // Finish simulation
  #10000;
  $finish;

end

// Write output to file
always @(posedge clk_1megahz) begin
  $fwrite(outfile, "%d, %d\n", diff_remapped_i, diff_remapped_q); 
end

endmodule