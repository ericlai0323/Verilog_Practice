module D_FF(q,d,clk,reset);

output q;
input d,clk,reset;
reg q;

always@(posedge clk or negedge reset)
if(!reset)
	q<=1'b0;
else
	q<=d;
endmodule
