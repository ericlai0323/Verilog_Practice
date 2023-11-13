`timescale 1ns / 1ps
`define CYCLE 125
module qpsk_tb;

integer tmp;
string line;
// Inputs  
reg clk_8megahz;
reg rst_n; 

// Interface to DUT
wire signed [15:0] sum;   

// File handles  
integer infile;
integer outfile;

// Internal signal
reg binary_data;

// DUT instance
qpsk_top dut (
  .binary_data(binary_data), 
  .clk_8megahz(clk_8megahz),
  .rst_n(rst_n),
  .sum(sum)
);


// 8MHz clock
always begin  #(`CYCLE/2) clk_8megahz = ~clk_8megahz;  end

initial begin
   $dumpvars();
   $dumpfile("QPSK.vcd");
end


initial begin
  clk_8megahz = 1'b0;
  // Reset
  rst_n = 1'b0;
  #100;
  rst_n = 1'b1;

  // Open files
  infile = $fopen("input_data.csv", "r"); 
  outfile = $fopen("output_data.csv", "w");

  // Read input data from file
  
  while (!$feof(infile)) begin
    tmp = $fscanf(infile, "%d", binary_data);
    $display("Read Data: %d", binary_data);
     @(posedge clk_8megahz);
    //#250;
  end

  // Close files 
  $fclose(infile);
  // $fclose(outfile);

  // Finish simulation
  #1000;
  $finish;

end

// Write output to file
always @(posedge clk_8megahz or negedge rst_n) begin
  $display("CLK 8MHz: %d", clk_8megahz);
  $display("Output Sum: %d", sum);
  $fwrite(outfile, "%d\n", sum); 
end

endmodule