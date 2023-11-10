`timescale 1ns / 1ps

module pulseshapingfilter(
	input clk,
	input rst_n,
	input wire signed [1:0] usp_data,
	output reg signed [13:0] filtered_data
    );
	
	parameter word_width = 12;
	parameter order = 32;

	reg signed [word_width-1:0] delay_pipeline[order:0];
	
	// Define coef
	wire signed [word_width-1:0]  coef[order:0];
	assign coef[0] = 12'b111111110110;
	assign coef[1] = 12'b111111111101;
	assign coef[2] = 12'b000000001011;
	assign coef[3] = 12'b000000010000;
	assign coef[4] = 12'b000000000001;
	assign coef[5] = 12'b111111101111;
	assign coef[6] = 12'b111111110011;
	assign coef[7] = 12'b000000010010;
	assign coef[8] = 12'b000000101100;
	assign coef[9] = 12'b000000001101;
	assign coef[10] = 12'b111110110001;
	assign coef[11] = 12'b111101100001;
	assign coef[12] = 12'b111110010111;
	assign coef[13] = 12'b000010100000;
	assign coef[14] = 12'b001001000100;
	assign coef[15] = 12'b001111001101;
	assign coef[16] = 12'b010001101101;
	assign coef[17] = 12'b001111001101;
	assign coef[18] = 12'b001001000100;
	assign coef[19] = 12'b000010100000;
	assign coef[20] = 12'b111110010111;
	assign coef[21] = 12'b111101100001;
	assign coef[22] = 12'b111110110001;
	assign coef[23] = 12'b000000001101;
	assign coef[24] = 12'b000000101100;
	assign coef[25] = 12'b000000010010;
	assign coef[26] = 12'b111111110011;
	assign coef[27] = 12'b111111101111;
	assign coef[28] = 12'b000000000001;
	assign coef[29] = 12'b000000010000;
	assign coef[30] = 12'b000000001011;
	assign coef[31] = 12'b111111111101;
	assign coef[32] = 12'b111111110110;

	// define multipler
	reg signed [31:0]  product[16:0];

	// define sum buffer
	reg signed [31:0]  sum_buf;	

	// define input data buffer
	reg signed [15:0] data_in_buf;

	// data buffer
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_in_buf <= 0;
		end
		else begin
			data_in_buf <= usp_data;
		end
	end

	// delay units pipeline
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			delay_pipeline[0] <= 0 ;
			delay_pipeline[1] <= 0 ;
			delay_pipeline[2] <= 0 ;
			delay_pipeline[3] <= 0 ;
			delay_pipeline[4] <= 0 ;
			delay_pipeline[5] <= 0 ;
			delay_pipeline[6] <= 0 ;
			delay_pipeline[7] <= 0 ;
			delay_pipeline[8] <= 0 ;
			delay_pipeline[9] <= 0 ;
			delay_pipeline[10] <= 0 ;
			delay_pipeline[11] <= 0 ;
			delay_pipeline[12] <= 0 ;
			delay_pipeline[13] <= 0 ;
			delay_pipeline[14] <= 0 ;
			delay_pipeline[15] <= 0 ;
			delay_pipeline[16] <= 0 ;
		end 
		else begin
			delay_pipeline[0] <= data_in_buf ;
			delay_pipeline[1] <= delay_pipeline[0] ;
			delay_pipeline[2] <= delay_pipeline[1] ;
			delay_pipeline[3] <= delay_pipeline[2] ;
			delay_pipeline[4] <= delay_pipeline[3] ;
			delay_pipeline[5] <= delay_pipeline[4] ;
			delay_pipeline[6] <= delay_pipeline[5] ;
			delay_pipeline[7] <= delay_pipeline[6] ;
			delay_pipeline[8] <= delay_pipeline[7] ;
			delay_pipeline[9] <= delay_pipeline[8] ;
			delay_pipeline[10] <= delay_pipeline[9] ;
			delay_pipeline[11] <= delay_pipeline[10] ;
			delay_pipeline[12] <= delay_pipeline[11] ;
			delay_pipeline[13] <= delay_pipeline[12] ;
			delay_pipeline[14] <= delay_pipeline[13] ;
			delay_pipeline[15] <= delay_pipeline[14] ;
			delay_pipeline[16] <= delay_pipeline[15] ;
		end
	end

	// implement product with coef 
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			product[0] <= 0;
			product[1] <= 0;
			product[2] <= 0;
			product[3] <= 0;
			product[4] <= 0;
			product[5] <= 0;
			product[6] <= 0;
			product[7] <= 0;
			product[8] <= 0;
			product[9] <= 0;
			product[10] <= 0;
			product[11] <= 0;
			product[12] <= 0;
			product[13] <= 0;
			product[14] <= 0;
			product[15] <= 0;
			product[16] <= 0;
		end
		else begin
			product[0] <= coef[0] * delay_pipeline[0];
			product[1] <= coef[1] * delay_pipeline[1];
			product[2] <= coef[2] * delay_pipeline[2];
			product[3] <= coef[3] * delay_pipeline[3];
			product[4] <= coef[4] * delay_pipeline[4];
			product[5] <= coef[5] * delay_pipeline[5];
			product[6] <= coef[6] * delay_pipeline[6];
			product[7] <= coef[7] * delay_pipeline[7];
			product[8] <= coef[8] * delay_pipeline[8];
			product[9] <= coef[9] * delay_pipeline[9];
			product[10] <= coef[10] * delay_pipeline[10];
			product[11] <= coef[11] * delay_pipeline[11];
			product[12] <= coef[12] * delay_pipeline[12];
			product[13] <= coef[13] * delay_pipeline[13];
			product[14] <= coef[14] * delay_pipeline[14];
			product[15] <= coef[15] * delay_pipeline[15];
			product[16] <= coef[16] * delay_pipeline[16];
		end
	end

	// accumulation
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			sum_buf <= 0;
		end
		else begin
			sum_buf <= product[0] + product[1]+ product[2]+ product[3]+ product[4]
			+ product[5]+ product[6]+ product[7]+ product[8]+ product[9]+ product[10]
			+ product[11]+ product[12]+ product[13]+ product[14]+ product[15]+ product[16];
		end
	end

	always @(sum_buf) begin
		if (!rst_n) begin
			filtered_data = 0;
		end
		else begin
			filtered_data = sum_buf;
		end
	end

endmodule