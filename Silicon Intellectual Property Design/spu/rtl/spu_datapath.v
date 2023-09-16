module spu_datapath(

input clk,
input rst,

//control signal for mux
input [1:0] rf_s,        // 00 = alu_out, 01 = dm_r_data, 10 = {8'b0,rf_w_data}

//control signals for register file (rf)
input  [3:0] rf_w_addr,  // 4-bit write address 
input  rf_w_wr,          // write enable

input  [3:0] rf_rp_addr, // 4-bit p-port read address 
input  rf_rp_rd,         // p-port read enable

input  [3:0] rf_rq_addr, // 4-bit q-port read address 
input  rf_rq_rd,         // q-port read enable

input  [7:0] rf_w_data,         // IR[7:0]

//control signal for ALU
input  [1:0] alu_s,

//data for data memory (dm)
input  [15:0] dm_r_data, // 16-bit read data
output [15:0] dm_w_data,  // 16-bit write data

output rf_rp_zero       // if rp_data equal zero, rf_rp_zero = 1
);

wire   [15:0] mux_out;
reg    [15:0] mux_out_temp;

//data for rf
wire   [15:0] rf_rp_data;  // 16-bit rf p-port read data
wire   [15:0] rf_rq_data;  // 16-bit rf q-port read data

reg    [15:0] alu_out;

assign mux_out = mux_out_temp;
assign dm_w_data = rf_rp_data;

assign rf_rp_zero = (~rf_rp_data) == 16'b1111111111111111; 

//register file
reg_file #(
 .DEPTH(16),
 .ADDR(4),
 .WIDTH(16))
  
rf(.rst(rst),
   .clk(clk),
   .w_en(rf_w_wr),        // write enable
   .w_addr(rf_w_addr),    // write address
   .r1_en(rf_rp_rd),      // #1-port read enable
   .r2_en(rf_rq_rd),      // #2-port read enable
   .r1_addr(rf_rp_addr),  // #1-port read address
   .r2_addr(rf_rq_addr),  // #2-port read address
   .w_data(mux_out),      // write data
   .r1_data(rf_rp_data),  // #1-port read data
   .r2_data(rf_rq_data)   // #2-port read data
);

always@(*)
begin

  case(rf_s)
  2'b00: mux_out_temp = alu_out;
  2'b01: mux_out_temp = dm_r_data;
  2'b10: mux_out_temp = {8'b0,rf_w_data};
  default: mux_out_temp = 16'b0;
  endcase

  case(alu_s)
  2'b00: alu_out = rf_rp_data;
  2'b01: alu_out = rf_rp_data + rf_rq_data;
  2'b10: alu_out = rf_rp_data - rf_rq_data;
  default: alu_out = 16'd0;
  endcase
end


endmodule























