module BCD2Segment(seg_out, mux_out);

parameter SEGMENT_ZERO  = 8'b0000_0011,
             SEGMENT_ONE    = 8'b1001_1111,
             SEGMENT_TWO    = 8'b0010_0101,
             SEGMENT_THREE = 8'b0000_1101,
             SEGMENT_FOUR   = 8'b1001_1001,
             SEGMENT_FIVE  = 8'b0100_1001,
             SEGMENT_SIX    = 8'b0100_0001,
             SEGMENT_SEVEN = 8'b0001_1011,
             SEGMENT_EIGHT = 8'b0000_0001,
             SEGMENT_NINE   = 8'b0000_1001;
             
//BCD to seven segment 
input [3:0]mux_out;
output reg [7:0]seg_out;

always@(mux_out)
begin
    case(mux_out)
        4'd0:   seg_out = SEGMENT_ZERO;
        4'd1:   seg_out = SEGMENT_ONE;
        4'd2:   seg_out = SEGMENT_TWO;
        4'd3:   seg_out = SEGMENT_THREE;
        4'd4:   seg_out = SEGMENT_FOUR;
        4'd5:   seg_out = SEGMENT_FIVE;
        4'd6:   seg_out = SEGMENT_SIX;
        4'd7:   seg_out = SEGMENT_SEVEN;
        4'd8:   seg_out = SEGMENT_EIGHT;
        4'd9:   seg_out = SEGMENT_NINE;
        //default: seg_out <= SEGMENT_ZERO;
    endcase
end

endmodule
