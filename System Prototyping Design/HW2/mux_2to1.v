module mux_2to1(
    out,
	 a,
	 b,
	 control);
output out;
input a, b, control;
tri out;
wire a,b,control;

bufif0 b1(out, a, control);
bufif1 b2(out, b, control);

endmodule
