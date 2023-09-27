module top_tb;
    reg clk, flag_n, rst_n;
    reg [3:0] sw_a;
    reg [3:0] sw_b;
    reg [1:0] sw_mode;
    reg [3:0] bcd_a[1:0];
    reg [3:0] bcd_b[1:0];
    reg [3:0] bcd_result[3:0];

    // Assuming top_bcd module is defined correctly
    top_bcd top_bcd_0(
        .clk(clk),
        .flag_n(flag_n),
        .rst_n(rst_n),
        .sw_a(sw_a),
        .sw_b(sw_b),
        .sw_mode(sw_mode),
        .bcd_a(bcd_a),
        .bcd_b(bcd_b),
        .bcd_result(bcd_result)
    );

    initial begin
        sw_a = 4'b0000;
        sw_b = 4'b0000;
        sw_mode = 2'b00;
        flag_n = 1'b1;
		  
		  bcd_a = {{4'd0},{4'd0}};
		  bcd_b = {{4'd0},{4'd0}};
		  bcd_result = {{4'd0},{4'd0},{4'd0},{4'd0}};

        #10;
        sw_a = 4'b0001;
        sw_b = 4'b0010;
        sw_mode = 2'b00;
        flag_n = 1'b0;

        #15;
        sw_a = 4'b0011;
        sw_b = 4'b0100;
        sw_mode = 2'b00;
        flag_n = 1'b1;

        #20;
        sw_a = 4'b1001;
        sw_b = 4'b1010;
        sw_mode = 2'b00;
        flag_n = 1'b0;
    end
endmodule
