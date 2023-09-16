module segment(out, out_loc, clk, sw);

input sw;
input clk;
output reg [7:0]out;
output reg [3:0]out_loc;

reg [31:0]clk_count;
reg clk_1s;
reg [3:0]state;
always@(posedge clk)
begin 
	if (clk_count < 32'd20000000)
		clk_count <= clk_count + 1'b1;
	else
	begin 
		clk_count <= 32'd0;
		clk_1s <= ~clk_1s;
	end
end

always@(posedge clk)
	out_loc <= 4'b1110;
	
always@(posedge clk_1s)
begin 
	if (sw == 1) 
	begin
		if (state < 4'd5)
			state <= state + 1'b1;
		else
			state <= 4'd0;
	end
	else
	begin 			if (state < 4'd4)
			state <= state + 1'b1;
		else
			state <= 4'd0;
	end	
end
	
always@(posedge clk_1s)
begin 
	if (sw == 1)
	begin
		case(state)
			4'd0:	out <= 8'b1001_1111; //1
			4'd1:	out <= 8'b0000_0011; //0
			4'd2:	out <= 8'b0001_1111; //7
			4'd3:	out <= 8'b0000_1101; //3
			4'd4:	out <= 8'b0010_0101; //2
			4'd5:	out <= 8'b0000_1001; //9
			default: out <= 8'b0000_0000;
		endcase
	end 
	else 
	begin 
		case(state)
			4'd0:	out <= 8'b1001_1111; //1
			4'd1:	out <= 8'b0000_0011; //0
			4'd2:	out <= 8'b0001_1111; //7
			4'd3:	out <= 8'b0000_1101; //3
			4'd4:	out <= 8'b0100_1001; //5
			default: out <= 8'b0000_0000;
		endcase	
	end
end
	
endmodule
