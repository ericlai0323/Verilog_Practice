module led_matrix(map1, map2, map3, map4, map5, map6, map7, map8,
                        row, col, clk_1kHz, rst);
                        
input clk_1kHz, rst;
input [7:0]map1, map2, map3, map4, map5, map6, map7, map8;
output reg [7:0]row, col;

always@(posedge clk_1kHz or negedge rst)
begin
    if (!rst)
        col <= 8'b1111_1110;
    else
        col <= {col[6:0], col[7]};
end

always@(col or map1 or map2 or map3 or map4 or map5 or map6 or map7 or map8)
begin
    case(1'b0)
        col[0]: row <= ~map1;
        col[1]: row <= ~map2;
        col[2]: row <= ~map3;
        col[3]: row <= ~map4;
        col[4]: row <= ~map5;
        col[5]: row <= ~map6;
        col[6]: row <= ~map7;
        col[7]: row <= ~map8;
    endcase
end
    

endmodule
