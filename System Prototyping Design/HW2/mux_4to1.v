module mux_4to1(
    out,
	 in0,
	 in1,
	 in2,
	 in3,
	 sel);
output out;
input in0, in1, in2, in3;
input [1:0] sel;

wire w1,w2;

mux_2to1 mux1(w1,in0,in1,sel[0]);
mux_2to1 mux2(w2,in2,in3,sel[0]);
mux_2to1 mux3(out,w1,w2,sel[1]);

endmodule
