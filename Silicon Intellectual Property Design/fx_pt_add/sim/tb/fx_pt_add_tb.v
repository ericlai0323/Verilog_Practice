`timescale 1ns / 100ps

`ifndef  SN
`define  SN 2
`endif

`ifndef  WDH
`define  WDH 10
`endif

`ifndef  AIW
`define  AIW 5
`endif

`ifndef  BIW
`define  BIW 3
`endif

`ifndef  T_NUM
`define  T_NUM 10000
`endif

module fx_pt_add_tb;

parameter SGN = `SN;
parameter WIDTH   = `WDH;               // define the bit width of the two input signals
parameter A_INT_W = `AIW;
parameter B_INT_W = `BIW;


reg     [WIDTH-1:0] a_t, b_t;        // two input signals

wire    [2*WIDTH:0] sum;             // the executed result of circuit 

reg     [2*WIDTH:0] sum_gld;         // the correct result 

//for test signal

integer err_count;

integer i;
integer seed1;
integer seed2;

real a_f, b_f, sum_f;
real a_t_f, b_t_f;
reg  signed [WIDTH-1:0] a_t_s, b_t_s; 
integer a_t_i, b_t_i;
reg  a_t_sgn, b_t_sgn;
reg  [WIDTH-2:0] a_t_mag, b_t_mag;
integer a_t_mag_i, b_t_mag_i;

integer a_deno, b_deno, sum_deno;
real a_deno_f, b_deno_f;

reg sum_sgn;
reg [2*WIDTH-1:0] sum_mag;

`ifdef  FSDB
reg [50*8-1:0] fsdb_name;
`endif

//assign random input values

initial
begin
  
  seed1=1;
  seed2=2;
  
  err_count=0;

  a_t=$random(seed1);
  b_t=$random(seed2); 

  for(i=0; i<`T_NUM; i=i+1)
     begin
       case(i)
       0: begin
            a_t={WIDTH{1'b1}};
            b_t={WIDTH{1'b1}};
          end
       1: begin
            a_t={1'b0,{(WIDTH-1){1'b1}}};
            b_t={1'b0,{(WIDTH-1){1'b1}}};
          end
       2: begin
            a_t={1'b0,{(WIDTH-1){1'b1}}};
            b_t={1'b1,{(WIDTH-1){1'b1}}};
          end
       3: begin
            a_t={1'b1,{(WIDTH-1){1'b1}}};
            b_t={1'b0,{(WIDTH-1){1'b1}}};
          end
       4: begin
            a_t={1'b1,{(WIDTH-1){1'b0}}};
            b_t={1'b0,{(WIDTH-1){1'b0}}};
          end
       5: begin
            a_t={1'b1,{(WIDTH-1){1'b0}}};
            b_t={1'b1,{(WIDTH-1){1'b0}}};
          end
       6: begin
            a_t={1'b0,{(WIDTH-1){1'b0}}};
            b_t={1'b0,{(WIDTH-1){1'b0}}};
          end
       7: begin
            a_t={1'b0,{(WIDTH-1){1'b0}}};
            b_t={1'b1,{(WIDTH-1){1'b0}}};
          end
       8: begin
            a_t=$random(seed1);
            a_t={1'b1,a_t[WIDTH-2:0]};
            b_t={1'b0,a_t[WIDTH-2:0]};
          end
       9: begin
            a_t=$random(seed1);
            a_t={1'b0,a_t[WIDTH-2:0]};
            b_t={1'b1,a_t[WIDTH-2:0]};
          end
      10: begin
            a_t=$random(seed1);
            a_t={1'b1,a_t[WIDTH-2:0]};
            b_t={1'b1,a_t[WIDTH-2:0]};
          end
      11: begin
            a_t=$random(seed1);
            a_t={1'b0,a_t[WIDTH-2:0]};
            b_t={1'b0,a_t[WIDTH-2:0]};
          end
      12: begin
            a_t=$random(seed1);
            b_t=a_t;
          end
       default:begin
                 a_t=$random(seed1);
                 b_t=$random(seed2);
	       end
       endcase
	
       a_t_s = a_t;  // unsigned to signed
       b_t_s = b_t;  // unsigned to signed	
		
       a_t_i = a_t;  // unsigned to integer(signed)
       b_t_i = b_t;  // unsigned to integer(signed)
			
       a_t_sgn = a_t[WIDTH-1]; // sign of a_t
       b_t_sgn = b_t[WIDTH-1]; // sign of b_t		
			
       a_t_mag = a_t[WIDTH-2:0]; // mag of a_t
       b_t_mag = b_t[WIDTH-2:0]; // mag of b_t
			
       a_t_mag_i = a_t_mag; // unsigned mag to integer(signed)
       b_t_mag_i = b_t_mag; // unsigned mag to integer(signed)
			
       a_deno=1<<(WIDTH-A_INT_W); // denominator of a for fixed point(integer)
       b_deno=1<<(WIDTH-B_INT_W); // denominator of b for fixed point(integer)
       sum_deno=1<<(WIDTH); // denominator of sum for fixed point(integer)
			
       a_deno_f = a_deno; // integer to real
       b_deno_f = b_deno; // integer to real
			
       case(SGN)
         0: begin
              a_t_f = a_t_i; // integer to real
              b_t_f = b_t_i; // integer to real
              a_f = a_t_f/a_deno_f;
              b_f = b_t_f/b_deno_f;
              sum_f = a_f+b_f;
              sum_f = sum_f*sum_deno;
              sum_gld = sum_f; // real to integer
            end

         1: begin
              a_t_f = a_t_s; //signed to real
              b_t_f = b_t_s; //signed to real
              a_f = a_t_f/a_deno_f;
              b_f = b_t_f/b_deno_f;
              sum_f = a_f+b_f;
              sum_f = sum_f*sum_deno;
              sum_gld = sum_f; // real to integer
            end

         default: begin
		     a_t_f = a_t_sgn ? -a_t_mag_i:a_t_mag_i; //signed to real
		     b_t_f = b_t_sgn ? -b_t_mag_i:b_t_mag_i; //signed to real
		     a_f = a_t_f/a_deno_f;
	             b_f = b_t_f/b_deno_f;
		     sum_f = a_f+b_f;
                     sum_f = sum_f*sum_deno;
		     
                     if(sum_f>=0.0)
			begin
			  sum_sgn = 1'b0;
			  sum_mag = sum_f; // real to integer
		          sum_gld = {sum_sgn,sum_mag};
			end 
                     else
			begin 
                          sum_sgn = 1'b1;
			  sum_mag = -sum_f; // real to integer
			  sum_gld = {sum_sgn,sum_mag};
			end						   
		  end
         endcase
			
       #10 			
       if (sum!==sum_gld)
            begin
              err_count=err_count+1;
	      $display ($time, " An error occurred !");
              $display ($time, " a_t=%d b_t=%d sum_tb=%d sum=%d\n", 
                                 a_t, b_t, sum_gld, sum);				   
            end
			
     end
		
  $display(" ");
  $display("-------------------------------------------------------\n");
  $display("--------------------- S U M M A R Y -------------------\n");
  $display("SGN=%3d, WIDTH=%3d, A_INT_W=%3d, B_INT_W=%3d\n", 
            SGN, WIDTH, A_INT_W, B_INT_W);
  if(err_count==0)
       $display("Congratulations! The results are all PASSED!!\n");
  else
       $display("FAIL!!!  There are %d errors! \n", err_count);
	  
  $display("-------------------------------------------------------\n");
		
  //#10 $stop; 
  #10 $finish;       

end

`ifdef  FSDB
initial
begin
  $sformat(fsdb_name,"fx_pt_add_tb_%1d_%02d_%02d_%02d.fsdb", 
                     SGN, WIDTH, A_INT_W, B_INT_W);   // something like sprintf in C
  $fsdbDumpfile(fsdb_name);  //your waveform file for nWave
  $fsdbDumpvars;
end
`endif

fx_pt_add #(.SGN(SGN),
            .WIDTH(WIDTH),
            .A_INT_W(A_INT_W),
            .B_INT_W(B_INT_W)) 
            inst1(.a(a_t), 
                  .b(b_t), 
                  .sum(sum));


endmodule

