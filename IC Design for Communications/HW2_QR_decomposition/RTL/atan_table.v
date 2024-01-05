module atan_table(
    input [3:0] index,
    output reg signed [11:0] atan_value
);

always @* begin
    case (index)
        4'b0000: atan_value = 12'b0000_0000_0000; // atan(1/2^0) = 0
        4'b0001: atan_value = 12'b0010_1010_1101; // atan(1/2^1) = 45 degrees
        4'b0010: atan_value = 12'b0100_1101_0010; // atan(1/2^2) = 26.565 degrees
        4'b0011: atan_value = 12'b0110_0010_1100; // atan(1/2^3) = 14.036 degrees
        4'b0100: atan_value = 12'b0111_0100_1111; // atan(1/2^4) = 7.125 degrees
        4'b0101: atan_value = 12'b1000_0000_0000; // atan(1/2^5) = 3.576 degrees
        4'b0110: atan_value = 12'b1001_0011_0010; // atan(1/2^6) = 1.789 degrees
        4'b0111: atan_value = 12'b1010_0001_1001; // atan(1/2^7) = 0.895 degrees
        4'b1000: atan_value = 12'b1010_1111_1111; // atan(1/2^8) = 0.447 degrees
        // Add more values as needed
        default: atan_value = 12'b0000_0000_0000; // Default value for safety
    endcase
end

endmodule
