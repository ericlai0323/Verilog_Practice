`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:27:04 04/18/2022 
// Design Name: 
// Module Name:    BinaryCounter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module BinaryCounter(binary_counter_out, clk, rst);

//2bit binary counter
input clk, rst;
output reg [1:0]binary_counter_out;

always@(posedge clk or negedge rst)
begin 
	if (!rst)
		binary_counter_out <= 2'd0;
	else 
		binary_counter_out <= binary_counter_out + 1'b1;
end

endmodule
