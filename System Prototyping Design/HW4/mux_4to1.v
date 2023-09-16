module Four2OneMux(mux_out, binary_counter_out, BCD_ONE, BCD_TWO, BCD_THREE, BCD_FOUR);

//4bit 4to1mux
output reg [3:0]mux_out;
input [1:0]binary_counter_out;
input [3:0]BCD_ONE, BCD_TWO, BCD_THREE, BCD_FOUR;

//assign mux_out = binary_counter_out[1]?(binary_counter_out[0]? BCD_ONE:BCD_TWO):(binary_counter_out[0]?BCD_THREE:BCD_FOUR);

always@(binary_counter_out or BCD_ONE or BCD_TWO or BCD_THREE or BCD_FOUR)
begin 
    case(binary_counter_out)
        2'd0: mux_out = BCD_FOUR;
        2'd1: mux_out = BCD_THREE;
        2'd2:   mux_out = BCD_TWO;
        2'd3:   mux_out = BCD_ONE;
    endcase
end
endmodule
