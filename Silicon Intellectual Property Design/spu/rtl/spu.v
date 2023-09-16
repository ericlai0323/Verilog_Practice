module spu(
input  clk,
input  rst,

input  start,                  // to start the processor
output stop,                   // to show that the processor is stopped

//control signals for instruction memory (im)
input   [15:0] im_r_data,      // 16-bit read data of im
output  [7:0]  im_addr,        // 8-bit data address of im
output  im_rd,                 // read enable of im

//control signals for data memory (dm)
output  [7:0] dm_addr,         // 8-bit data address of dm
output  dm_rd,                 // read enable of dm
output  dm_wr,                 // write enable of dm

// output  [7:0] rf_w_data,


//data for data memory (dm)
input  [15:0] dm_r_data,       // 16-bit read data
output [15:0] dm_w_data        // 16-bit write data
);

//control signal for mux
wire [1:0] rf_s;

wire [7:0] rf_w_data;

//control signals for register file (rf)
wire [3:0] rf_w_addr;   // 4-bit write address 
wire rf_w_wr;           // write enable
 
wire [3:0] rf_rp_addr;  // 4-bit p-port read address 
wire rf_rp_rd;          // p-port read enable

wire [3:0] rf_rq_addr;  // 4-bit q-port read address 
wire rf_rq_rd;          // q-port read enable

//control signal for ALU
wire [1:0] alu_s;

spu_ctrl c1(.clk(clk),
            .rst(rst),
         
            .start(start),            // to start the processor
            .stop(stop),              // to show that the processor is stopped

            //control signals for instruction memory (im)
            .im_r_data(im_r_data),    // 16-bit read data of im
            .im_addr(im_addr),        // 8-bit data address of im
            .im_rd(im_rd),            // read enable of im

            //control signals for data memory (dm)
            .dm_addr(dm_addr),        // 8-bit data address of dm
            .dm_rd(dm_rd),            // read enable of dm
            .dm_wr(dm_wr),            // write enable of dm

            //
            .rf_w_data(rf_w_data),    // for LOADC

            //control signal for mux
            .rf_s(rf_s),

            //control signals for register file (rf)
            .rf_w_addr(rf_w_addr),    // 4-bit write address 
            .rf_w_wr(rf_w_wr),        // write enable
 
            .rf_rp_addr(rf_rp_addr),  // 4-bit p-port read address 
            .rf_rp_rd(rf_rp_rd),      // p-port read enable

            .rf_rq_addr(rf_rq_addr),  // 4-bit q-port read address 
            .rf_rq_rd(rf_rq_rd),      // q-port read enable

            //control signal for ALU
            .alu_s(alu_s),

            .rf_rp_zero(rf_rp_zero)
);

spu_datapath d1(.clk(clk),
                .rst(rst),

                //control signal for mux
                .rf_s(rf_s),

                //control signals for register file (rf)
                .rf_w_addr(rf_w_addr),      // 4-bit write address 
                .rf_w_wr(rf_w_wr),          // write enable

                .rf_rp_addr(rf_rp_addr),    // 4-bit p-port read address 
                .rf_rp_rd(rf_rp_rd),        // p-port read enable

                .rf_rq_addr(rf_rq_addr),    // 4-bit q-port read address 
                .rf_rq_rd(rf_rq_rd),        // q-port read enable
                
                //
                .rf_w_data(rf_w_data),    // for LOADC    
                
                //control signal for ALU
                .alu_s(alu_s),

                //data for data memory (dm)
                .dm_r_data(dm_r_data),      // 16-bit read data
                .dm_w_data(dm_w_data),       // 16-bit write data

                .rf_rp_zero(rf_rp_zero)
);

endmodule
