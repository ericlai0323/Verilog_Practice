module ripple(
    q,
	 clk,
	 reset);

output [3:0]q;
input clk,reset;

reg [31:0]clk_count;
reg clk_1s;

initial clk_1s = 1'b0;

always@(posedge clk or negedge reset)
begin
	if (!reset)
	begin
		clk_count <= 32'd0;
		clk_1s <= 1'b0;
	end
	else
	begin
		if (clk_count <= 32'd20000000)
			clk_count <= clk_count + 1'b1;
		else
		begin 	
			clk_count <= 32'd0;
			clk_1s <= ~clk_1s;
		end
	end
	
end	

T_FF tff0(
    q[0],
	clk_1s,
	 reset);
	 
T_FF tff1(
    q[1],
	 q[0],
	 reset);

T_FF tff2(
    q[2],
	 q[1],
	 reset);

T_FF tff3(
    q[3],
	 q[2],
	 reset);

endmodule
