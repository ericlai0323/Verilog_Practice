module top(
		input clk_50megahz,
		input [3:0]sw_a, // sw[17:14]
		input [3:0]sw_b, // sw[13:10]
		input [1:0]sw_mode, // sw[1:0]
		input flag_n,
		input rst_n,
		output reg [3:0]sw_a_led,
		output reg [3:0]sw_b_led,
		output reg [1:0]sw_mode_led,
		output reg key_flag_n,
		output reg key_rst_n,
		output reg [6:0]segment_a[1:0],
		output reg [6:0]segment_b[1:0],
		output reg [6:0]segment_result[3:0]);

		wire clk_50hz;
		wire [7:0]alu_result;
		wire [3:0]temp_a;
		wire [3:0]temp_b;
		wire [7:0]temp_result;

		wire [3:0]bcd_a[1:0];
		wire [3:0]bcd_b[1:0];
		wire [3:0]bcd_result[3:0];

		assign sw_a_led = sw_a;
		assign sw_b_led = sw_b;
		assign sw_mode_led = sw_mode;
		assign key_flag_n = flag_n;
		assign key_rst_n = rst_n;


		clk_generator clk_generator_0(clk_50megahz, rst_n, clk_50hz);
		temp_reg temp_reg_0(clk_50hz, rst_n, sw_a, sw_b, alu_result, temp_a, temp_b, temp_result);
		alu alu_0(clk_50hz, rst_n, flag_n, sw_a, sw_b, sw_mode, alu_result);
		num2binary2bcd num2binary2bcd_a(temp_a, bcd_a);
		num2binary2bcd num2binary2bcd_b(temp_b, bcd_b);
		num4binary2bcd num4binary2bcd_result(temp_result, bcd_result);

		bcd2segment bcd2segment_a_0(bcd_a[0], segment_a[0]);
		bcd2segment bcd2segment_a_1(bcd_a[1], segment_a[1]);
		
		bcd2segment bcd2segment_b_0(bcd_b[0], segment_b[0]);
		bcd2segment bcd2segment_b_1(bcd_b[1], segment_b[1]);

		bcd2segment bcd2segment_result_0(bcd_result[0], segment_result[0]);
		bcd2segment bcd2segment_result_1(bcd_result[1], segment_result[1]);
		bcd2segment bcd2segment_result_2(bcd_result[2], segment_result[2]);
		bcd2segment bcd2segment_result_3(bcd_result[3], segment_result[3]);

		

		
endmodule