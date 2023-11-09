module local_oscillator_cos(
    input clk_8megahz,
    input rst_n,
    input wire signed [13:0] filtered_data,
    output reg signed [13:0] lo_cos_data
);

// output = cos(2*pi*filtered_data/8)

endmodule

