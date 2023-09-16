module mux_8to1(
    out,
	 in0,
	 in1,
	 in2,
	 in3,
	 in4,
	 in5,
	 in6,
	 in7,
	 sel);
output out;
input in0, in1, in2, in3, in4, in5, in6, in7;
input [2:0] sel;
wire w1,w2;

mux_4to1 mux1(w1,in0,in1,in2,in3,sel[1:0]);
mux_4to1 mux2(w2,in4,in5,in6,in7,sel[1:0]);
mux_2to1 mux3(out,w1,w2,sel[2]);
endmodule