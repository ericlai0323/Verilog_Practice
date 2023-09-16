module GreenMan(row, col, clk, rst);

output [7:0]row, col;
input clk, rst;

wire clk_1kHz, mode_clk;
wire [7:0]map1, map2, map3, map4, map5, map6, map7, map8;
wire [2:0]pattern;
wire [1:0]mode;

clk_generator clk_generator(clk_1kHz, mode, pattern, clk, rst);
map                 map(mode, pattern, map1, map2, map3, map4, map5, map6, map7, map8);
led_matrix      led_matrix(map1, map2, map3, map4, map5, map6, map7, map8,
                                    row, col, clk_1kHz, rst);
                        
endmodule
