module num2binary2bcd (
    input [3:0] num,
    output reg [3:0] BCD[1:0]
);

reg [3:0] temp_num;
integer i;

always @(*) begin
    // Initialize BCD values to 0
    BCD[1] = 4'b0000;
    BCD[0] = 4'b0000;

    // Perform BCD conversion
    temp_num = num;

    for (i = 0; i < 4; i = i + 1) begin
        if (temp_num >= 4'b0101) begin
            temp_num = temp_num + 4'b0011;
        end

        BCD[1][i] = temp_num[3];
        BCD[0][i] = temp_num[2:0];

        temp_num = temp_num << 1;
    end
end

endmodule
