`timescale 1ns / 1ps
module traffic_light(light, start, clk, rst);

input clk, rst;
input start;
output [2:0]light;

wire clk_2Hz, clk_1kHz;

clk_generator clk_generator(clk_2Hz, clk_1kHz, clk, rst);
state_control state_control(light, start, clk, clk_2Hz, rst);

endmodule
