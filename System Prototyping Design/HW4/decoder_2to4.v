module Two2FourDecoder(seg_sel, binary_counter_out);

//2to4 decoder
input [1:0]binary_counter_out;
output reg [3:0]seg_sel;

always@(binary_counter_out)
begin
    case(binary_counter_out)
        2'd0:   seg_sel = 4'b1110;
        2'd1: seg_sel = 4'b1101;
        2'd2:   seg_sel = 4'b1011;
        2'd3: seg_sel = 4'b0111;
        //default: seg_sel <= 4'd1;
    endcase
end

endmodule
