module clk_generator(clk_50HZ, clk, rst);

input clk, rst;
output reg clk_50HZ;

// 50HZ clk      
reg [31:0]clk_50HZ_count;
always@(posedge clk or negedge rst)
begin 
    if (!rst)
    begin 
        clk_50HZ_count <= 32'd0;
        clk_50HZ <= 0;
    end
    else
    begin
        if (clk_50HZ_count < 32'd40000)
            clk_50HZ_count <= clk_50HZ_count + 32'd1;
        else 
        begin 
            clk_50HZ_count <= 32'd0;
            clk_50HZ <= ~clk_50HZ;
        end
    end
end

endmodule
