module qpsk_top(
    input binary_data,
    input rst_n,
    input clk_8megahz,
    output signed[15:0] sum
);
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


// Module
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


endmodule