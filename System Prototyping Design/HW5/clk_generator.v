`timescale 1ns / 1ps
module clk_generator(clk_2Hz, clk_1kHz, clk, rst);

input clk, rst;
output reg clk_2Hz, clk_1kHz;

reg [31:0]clk_2Hz_count, clk_1kHz_count;

//2Hz
always@(posedge clk or negedge rst)
begin 
    if (!rst)
    begin
        clk_2Hz_count <= 32'd0;
        clk_2Hz <= 0;
    end
    else
    begin
        if (clk_2Hz_count < 32'd20000000)
            clk_2Hz_count <= clk_2Hz_count + 32'd1;
        else
        begin
            clk_2Hz_count <= 32'd0;
            clk_2Hz <= ~clk_2Hz;
        end
    end
end

//1kHz
always@(posedge clk or negedge rst)
begin 
    if (!rst)
    begin
        clk_1kHz_count <= 32'd0;
        clk_1kHz <= 0;
    end
    else
    begin
        if (clk_1kHz_count < 32'd20000000)
            clk_1kHz_count <= clk_1kHz_count + 32'd1;
        else
        begin
            clk_1kHz_count <= 32'd0;
            clk_1kHz <= ~clk_1kHz;
        end
    end
end

endmodule


