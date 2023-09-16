`timescale 1ns/10ps

module spu_ctrl(

input   clk,
input   rst,

input   start,                 // to start the processor
output  reg stop,              // to show that the processor is stopped

//control signals for instruction memory (im)
input   [15:0] im_r_data,      // 16-bit read data of im
output  [7:0]  im_addr,        // 8-bit data address of im
output  reg im_rd,             // read enable of im

//control signals for data memory (dm)
output  [7:0] dm_addr,         // 8-bit data address of dm
output  reg dm_rd,             // read enable of dm
output  reg dm_wr,             // write enable of dm

output  [7:0] rf_w_data,

//control signal for mux
output  reg [1:0] rf_s,        // 00 mux_out = alu_out, 01 mux_out = dm_r_data, 10 mux_out = {8'b0,rf_w_data}

//control signals for register file (rf)
output  reg [3:0] rf_w_addr,   // 4-bit write address 
output  reg rf_w_wr,           // write enable
 
output  reg [3:0] rf_rp_addr,  // 4-bit p-port read address 
output  reg rf_rp_rd,          // p-port read enable

output  reg [3:0] rf_rq_addr,  // 4-bit q-port read address 
output  reg rf_rq_rd,          // q-port read enable

//control signal for ALU
output  reg [1:0] alu_s,       // 00 alu_out = rf_rp_data, 01 alu_out = rf_rp_data + rf_rq_data, 10 alu_out = rf_rp_data - rf_rq_data

input   rf_rp_zero
);

parameter [3:0]  INIT   = 4'd0, 
                 FETCH  = 4'd1,
		             DECODE = 4'd2,
		             LOAD   = 4'd3,
		             STORE  = 4'd4,
                 ADD    = 4'd5,
                 STOP   = 4'd6,
                 LOADC  = 4'd7,
                 ADDI   = 4'd8,
                 SUB    = 4'd9,
                 JMPZ   = 4'd10,
                 JMPNZ  = 4'd11,
                 JMP    = 4'd12,
                 JMPEQ  = 4'd13;

parameter [3:0]  OP_LOAD  = 4'd0,
                 OP_STORE = 4'd1,
	               OP_ADD   = 4'd2,
                 OP_LOADC = 4'd3,
                 OP_ADDI  = 4'd4,
                 OP_SUB   = 4'd5,
                 OP_JMPZ  = 4'd6,
                 OP_JMPNZ = 4'd7,
                 OP_JMP   = 4'd8,
                 OP_JMPEQ = 4'd9,
	               OP_STOP  = 4'd15;				  
					  
reg [7:0] pc;    // 8-bit program counter
reg pc_inc;
reg pc_clr;

//pc
reg pc_ld;

reg [15:0] ir;    // 16-bit instruction register
reg ir_ld;

reg [3:0] cs, ns;  // current state and next state

wire [3:0] ra, rb, rc;  // address for rf

wire [3:0] op;          // op code

assign im_addr = pc;

/*
4'[opcode],4'[Ra],4'[Rb],4'[Rc]
*/
assign op = ir[15:12];

assign ra = ir[11:8];
assign rb = ir[7:4];
assign rc = ir[3:0];

assign dm_addr = ir[7:0];
assign rf_w_data = ir[7:0];

// program counter
always@(posedge clk or posedge rst)
begin
  if(rst)
     pc <= #1 8'd0;
  else if(pc_clr)
     pc <= #1 8'd0;
  else if(pc_inc)
     pc <= #1 (pc + 8'd1);
  else if(pc_ld)
     pc <= #1 (pc + $signed(dm_addr) - 8'd1);
end

// ir
always@(posedge clk or posedge rst)
begin
  if(rst)
     ir <= #1 16'd0;
  else if(ir_ld)
     ir <= #1 im_r_data;
end

// current state register
always@(posedge clk or posedge rst)
begin
  if(rst)
     cs <= #1 INIT;
  else 
     cs <= #1 ns;
end

// next state combinational logic
always@(*)
begin
  case(cs)
  INIT:    if(start)
              ns = FETCH;
			  else
			     ns = INIT;
  
  FETCH:   ns = DECODE;
  
  DECODE:  case(op)
            OP_LOAD:  ns = LOAD;
			   OP_STORE: ns = STORE;
			   OP_ADD:   ns = ADD;
            OP_SUB:   ns = SUB;
            OP_LOADC: ns = LOADC;
            OP_ADDI:  ns = ADDI;
			   OP_STOP:  ns = STOP; 
           default:  ns = INIT;
			  endcase
			 
  LOAD:    ns = FETCH;
  
  STORE:   ns = FETCH;
  
  ADD:     ns = FETCH;

  SUB:     ns = FETCH;

  LOADC:   ns = FETCH;

  ADDI:    ns = FETCH;
  
  STOP:    ns = INIT;
  
  default: ns = INIT;
  endcase
end
  

// controller output combinational logic
always@(*)
begin
  im_rd = 1'b0;
  
  pc_clr = 1'b0;
  pc_inc = 1'b0;

  //pc
  pc_ld = 1'b0;

  
  ir_ld = 1'b0;  
  
  dm_rd = 1'b0;
  dm_wr = 1'b0;
  
  rf_s = 2'b00;
  
  rf_w_addr  = 4'd0;
  rf_w_wr = 1'b0;
  
  rf_rp_addr = 4'd0;
  rf_rp_rd = 1'b0;  
  
  rf_rq_addr = 4'd0;
  rf_rq_rd = 1'b0;  
  
  alu_s = 2'b00;
  stop = 1'b0; 

  case(cs)
  INIT:    begin
             pc_clr = 1'b1;  
           end
  
  FETCH:   begin
              im_rd  = 1'b1;
              ir_ld  = 1'b1;
              pc_inc = 1'b1;  
           end
 
  LOAD:    begin
              dm_rd = 1'b1;
              rf_s = 2'b01;
              rf_w_addr = ra;
              rf_w_wr = 1'b1;			  
           end
  
  STORE:   begin
              dm_wr = 1'b1; 
              rf_rp_addr = ra;
              rf_rp_rd = 1'b1;			  
           end
  
  ADD:     begin           
              rf_rp_addr = rb;
              rf_rp_rd = 1'b1;

              rf_rq_addr = rc;
              rf_rq_rd = 1'b1;

              rf_w_addr = ra;
              rf_w_wr = 1'b1;	
            
              alu_s = 2'b01;		  
           end

  STOP:    begin
              stop = 1'b1;  
           end
			  
// Subtract instruction : Ra = Rb - Rc
  SUB:     begin
              rf_rp_addr = rb;
              rf_rp_rd = 1'b1;

              rf_rq_addr = rc;
              rf_rq_rd = 1'b1;

              rf_w_addr = ra;
              rf_w_wr = 1'b1;
            
              rf_s = 2'b00;

              alu_s = 2'b10;
           end

// LOAD-Constant instruction : Ra = C
  LOADC:    begin
              rf_w_addr = ra;
              rf_w_wr = 1'b1;
              rf_s = 2'b10;
            end
  
  ADDI:     begin
              rf_rp_addr = rb;
              rf_rp_rd = 1'b1;

              // rf_rq_addr = rc;
              // rf_rq_rd = 1'b1;

              rf_w_addr = ra;
              rf_w_wr = 1'b1;	
            
              alu_s = 2'b01;
            end
  
  JMP:      begin
            pc_ld = 1'b1;
  end
  default: begin
              im_rd = 1'b0;
    
              pc_clr = 1'b0;
              pc_inc = 1'b0;

              pc_ld = 1'b0;
    
              ir_ld = 1'b0;  
    
              dm_rd = 1'b0;
              dm_wr = 1'b0;
  
              rf_s = 2'b00;
  
              rf_w_addr  = 4'd0;
              rf_w_wr = 1'b0;
    
              rf_rp_addr = 4'd0;
              rf_rp_rd = 1'b0;  
    
              rf_rq_addr = 4'd0;
              rf_rq_rd = 1'b0;  
    
              alu_s = 2'b00;
    
              stop = 1'b0;
			  end
  endcase
end

endmodule








