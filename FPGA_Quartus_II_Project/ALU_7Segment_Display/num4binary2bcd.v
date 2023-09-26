module num4binary2bcd (
    input [7:0] result,
    output reg [3:0] BCD[3:0]
);

reg [23:0] shift;
reg [3:0] i; // Use a 4-bit register for the loop counter

always @(*) begin
    // Initialize the shift register and i
    shift = 24'b0;
    i = 4'd0; // Initialize the loop counter

    // Perform BCD conversion in a loop
    for (i = 0; i < 8; i = i + 1) begin
        // BCD correction if necessary
        if (shift[19:16] >= 5) shift[19:16] = shift[19:16] + 4'b0011;
        if (shift[15:12] >= 5) shift[15:12] = shift[15:12] + 4'b0011;
        if (shift[11:8] >= 5) shift[11:8] = shift[11:8] + 4'b0011;
        if (shift[23:20] >= 5) shift[23:20] = shift[23:20] + 4'b0011;

        // Shift left by 1 bit
        shift = {shift[22:0], 1'b0};
    end

    // Assign BCD values to the 2D array
    BCD[3] = shift[23:20];
    BCD[2] = shift[19:16];
    BCD[1] = shift[15:12];
    BCD[0] = shift[11:8];
end

endmodule
