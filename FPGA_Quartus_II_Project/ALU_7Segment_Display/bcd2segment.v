module bcd2segment(
    input [3:0] num_bcd,
    output reg [6:0] num_segment
);
    always @(*) begin
        reg [3:0] temp_bcd;
        temp_bcd <= num_bcd;
        case (temp_bcd)
            4'd0: num_segment <= 7'b1000000;
            4'd1: num_segment <= 7'b1111001;
            4'd2: num_segment <= 7'b0100100;
            4'd3: num_segment <= 7'b0110000;
            4'd4: num_segment <= 7'b0011001;
            4'd5: num_segment <= 7'b0010010;
            4'd6: num_segment <= 7'b0000010;
            4'd7: num_segment <= 7'b1011000;
            4'd8: num_segment <= 7'b0000000;
            4'd9: num_segment <= 7'b0010000;
            default: num_segment <= 7'b0001110;
        endcase
    end
endmodule
