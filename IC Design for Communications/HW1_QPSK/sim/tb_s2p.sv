`timescale 1ns / 1ps
`define CYCLE 125

module tb_s2p;

integer tmp;
// Inputs  
reg clk_8megahz;
reg rst_n; 

// Interface to DUT
wire s2p_i, s2p_q;

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

// DUT instance
s2p dut (
  .binary_data(binary_data), 
  .clk_2megahz(clk_2megahz),
  .clk_1megahz(clk_1megahz),
  .rst_n(rst_n),
  .s2p_i(s2p_i),
  .s2p_q(s2p_q)
);

// 8MHz clock
always #(`CYCLE/2) clk_8megahz = ~clk_8megahz;   

initial begin
   $dumpvars();
   $dumpfile("S2P.vcd");
end


initial begin
  clk_8megahz = 1'b0;
  // Reset
  rst_n = 1'b0;
  #1000;
  rst_n = 1'b1;

  // Open files
  infile = $fopen("input_data.csv", "r"); 
  outfile = $fopen("s2p_data.csv", "w");

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
  $fwrite(outfile, "%d, %d\n", s2p_i, s2p_q); 
end

endmodule