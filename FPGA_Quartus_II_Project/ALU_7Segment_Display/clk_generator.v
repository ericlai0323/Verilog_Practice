module clk_generator(
    input clk,
    input rst,
    output reg clk_50hz);

// 50Hz clk      
reg [31:0]clk_50hz_count;
always@(posedge clk or negedge rst)
begin 
    if (!rst)
    begin 
        clk_50hz_count <= 32'd0;
        clk_50hz <= 0;
    end
    else
    begin
        if (clk_50hz_count < 32'd40000)
            clk_50hz_count <= clk_50hz_count + 32'd1;
        else 
        begin 
            clk_50hz_count <= 32'd0;
            clk_50hz <= ~clk_50hz;
        end
    end
end

endmodule
