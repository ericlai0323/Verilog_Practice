`timescale 1ns / 1ps

module qpsk_tb;

integer tmp;
integer i;

// Inputs  
reg clk_8megahz;
reg rst_n; 

reg [299:0] binary_data_array = {1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0,  
                                  1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
                                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0,
                                  1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0,
                                  1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
                                  1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0,
                                  1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0,
                                  1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1,
                                  1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
                                  1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
                                  1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0,
                                  1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0,
                                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0,
                                  1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0,
                                  1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1,
                                  1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
                                  1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0,
                                  1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0,
                                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1,
                                  1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0,
                                  1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1,
                                  1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
                                  1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0,
                                  1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0,
                                  1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0,
                                  1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
                                  1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
                                  1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1,
                                  1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1,
                                  1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};

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
always #125 clk_8megahz = ~clk_8megahz;   

initial begin
   $dumpvars();
   $dumpfile("QPSK.vcd");
end


initial begin

  // Reset
  rst_n = 1'b0;
  #1000;
  rst_n = 1'b1;

  // Open files
  // infile = $fopen("input_data.csv", "r"); 
  outfile = $fopen("output_data.csv", "w");

  for (i=0; i<300; i=i+1) begin
    binary_data = binary_data_array[i]; 
    @(posedge clk_8mhz);
  end
  // Read input data from file
  
  // while (!$feof(infile)) begin
  //   tmp = $fscanf(infile, "%b", binary_data);
  //   @(posedge clk_8megahz);
  // end


  // Close files 
  // $fclose(infile);
  $fclose(outfile);

  // Finish simulation
  #1000;
  $finish;

end

// Write output to file
always @(posedge clk_8megahz) begin
  $fwrite(outfile, "%d\n", sum); 
end

endmodule