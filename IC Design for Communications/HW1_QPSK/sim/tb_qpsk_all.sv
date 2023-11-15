`timescale 1ns / 1ps
`define CYCLE 125

module tb_qpsk_all;

integer tmp;
// Inputs  
reg clk_8megahz;
reg rst_n; 
// Clock
wire clk_2megahz;
wire clk_1megahz;

// Serial to Parallel Converter
wire s2p_i;
wire s2p_q;

// Differatial Encoder and Remapping
wire signed[1:0] diff_remapped_i, diff_remapped_q;

// Upsampling 
wire signed[1:0] usp_i, usp_q;

// Pulse Shaping Filter
wire signed[13:0] filtered_i, filtered_q;

// Local Oscillator
wire signed[4:0] lo_cos_wave_data, lo_nsin_wave_data;

// Multiplier Data
wire signed[15:0] multiplier_data_i, multiplier_data_q;

// Sum Output
wire signed[15:0] sum;

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

upsampling upsampling_i(
    .clk_8megahz(clk_8megahz),
    .rst_n(rst_n),
    .diff_remapped_data(diff_remapped_i),
    .usp_data(usp_i)
);

upsampling upsampling_q(
    .clk_8megahz(clk_8megahz),
    .rst_n(rst_n),
    .diff_remapped_data(diff_remapped_q),
    .usp_data(usp_q)
);


pulseshapingfilter fir_i(
    .clk_8megahz(clk_8megahz),
    .rst_n(rst_n),
    .usp_data(usp_i),
    .filtered_data(filtered_i)
);

pulseshapingfilter fir_q(
    .clk_8megahz(clk_8megahz),
    .rst_n(rst_n),
    .usp_data(usp_q),
    .filtered_data(filtered_q)
);

cos_wave_generator cos_wave_generator(
    .clk_1megahz(clk_1megahz),
    .rst_n(rst_n),
    .cos_out(lo_cos_wave_data)
);

nsin_wave_generator nsin_wave_generator(
    .clk_1megahz(clk_1megahz),
    .rst_n(rst_n),
    .nsin_out(lo_nsin_wave_data)
);

multiplier multiplier_i(
    .clk_8megahz(clk_8megahz),
    .rst_n(rst_n),
    .filtered_data(filtered_i),
    .lo_wave_data(lo_cos_wave_data),
    .multiplier_data(multiplier_data_i)
);

multiplier multiplier_q(
    .clk_8megahz(clk_8megahz),
    .rst_n(rst_n),
    .filtered_data(filtered_q),
    .lo_wave_data(lo_nsin_wave_data),
    .multiplier_data(multiplier_data_q)
);

adder adder(
    .clk_8megahz(clk_8megahz),
    .rst_n(rst_n),
    .data_i(multiplier_data_i),
    .data_q(multiplier_data_q),
    .sum_data(sum)
);
// 8MHz clock
always #(`CYCLE/2) clk_8megahz = ~clk_8megahz;   

initial begin
   $dumpvars();
   $dumpfile("AllData.vcd");
end


initial begin
  clk_8megahz = 1'b0;
  // Reset
  rst_n = 1'b0;
  #20000;
  rst_n = 1'b1;

  // Open files
  infile = $fopen("input_data.csv", "r"); 
  outfile = $fopen("all_output_data.csv", "w");

  // Title
  $fwrite(outfile, "s2p_i, s2p_q, diff_remapped_i, diff_remapped_q, usp_i, usp_q, filtered_i, filtered_q, lo_cos_wave_data, lo_nsin_wave_data, multiplier_data_i, multiplier_data_q, sum");

  // Read input data from file
  
  while (!$feof(infile)) begin
    tmp = $fscanf(infile, "%d", binary_data);
    $display("Read Data: %d", binary_data);
    @(posedge clk_2megahz);
  end

  // Close files 
  $fclose(infile);

  // Finish simulation
  #10;
  $finish;

end

// Write output to file
always @(posedge clk_8megahz or negedge rst_n) begin
  if(!rst_n)
  $fwrite(outfile, "RST");
  else
  $fwrite(outfile, "%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", s2p_i, s2p_q, diff_remapped_i, diff_remapped_q, usp_i, usp_q, filtered_i, filtered_q, lo_cos_wave_data, lo_nsin_wave_data, multiplier_data_i, multiplier_data_q, sum); 
end

endmodule