module calculator(seg_sel, seg_out, input_current_state, keyin, keyout, sel, clk, rst);

input clk, rst;
input [1:0]sel;
input [3:0]keyout;
output [2:0]keyin;
output [3:0]seg_sel;
output [7:0]seg_out;

output [3:0] input_current_state;
wire sure;
wire clk_50HZ;
wire [3:0]temp, a, b;
wire [7:0]total;
wire [3:0]BCD_ONE, BCD_TWO, BCD_THREE, BCD_FOUR;
wire [1:0]binary_counter_out;
wire [3:0]mux_out;

clk_generator       CG(clk_50HZ, clk, rst);
keypad              key(temp, sure, keyin, keyout, clk_50HZ, rst);
Temp2TwoInput       tempab(a, b, start_alu, input_current_state, temp, sure, clk_50HZ, rst);
ALU                 cal(total, start_alu, a, b, sel);
Binary2BCD          BchangeBCD(total, BCD_ONE, BCD_TWO, BCD_THREE, BCD_FOUR);
BinaryCounter       TwoBitBinaryCounter(binary_counter_out, clk_50HZ, rst);
Four2OneMux         FourBitFour2One_Mux(mux_out, binary_counter_out, BCD_ONE, BCD_TWO, BCD_THREE, BCD_FOUR);
Two2FourDecoder TwoToFourDec(seg_sel, binary_counter_out);
BCD2Segment         BCDToSevenSegment(seg_out, mux_out);

endmodule
