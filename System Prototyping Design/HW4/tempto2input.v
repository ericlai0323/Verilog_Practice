module Temp2TwoInput(a, b, start_alu, input_current_state, temp, sure, clk_50HZ, rst);

parameter INPUT_DEFAULT_STATE = 4'b0001;  
parameter STATE1               = 4'b0010;  
parameter STATE2                = 4'b0100;  
parameter STATE3                = 4'b1000;  
 

//keypad to input a and b

input [3:0]temp;
input sure, clk_50HZ, rst;
output reg [3:0]a, b = 4'd0;
output reg start_alu;

output reg [3:0] input_current_state;
reg [3:0] input_next_state;    
always@(posedge clk_50HZ or negedge rst)
  if (!rst)
    input_current_state <= INPUT_DEFAULT_STATE;
  else
    input_current_state <= input_next_state;
     

always@(*)
  case(input_current_state)
    INPUT_DEFAULT_STATE:                // ??????
        if(temp != 4'b1111)
            if (sure == 1'd0)
                input_next_state <= STATE1;
             else 
                input_next_state <= INPUT_DEFAULT_STATE;
        else
          input_next_state <= INPUT_DEFAULT_STATE;
    STATE1:                         // ???0? 
        if(sure == 1'd1)
          input_next_state <= STATE2;
          else
          input_next_state <= STATE1;
    STATE2:                         // ???1? 
        if(sure == 1'd0)
          input_next_state <= STATE3;
        else
          input_next_state <= STATE2;    
    STATE3:                         // ???2?
        if(sure == 1'd1)
          input_next_state <= INPUT_DEFAULT_STATE;
        else
          input_next_state <= STATE3;                   
  endcase
  
  
always@(posedge clk_50HZ or negedge rst)
    if (!rst)
    begin
        a <= 4'd0;
        b <= 4'd0;
        start_alu <= 0;
    end
    else
    begin
        case(input_next_state)
            INPUT_DEFAULT_STATE :
            begin
                start_alu <= 0;
                a <= 4'd0;
                b <= 4'd0;
            end
            STATE1 :                        // ???0?
            begin   
                a <= temp; 
            end
            STATE2 :                        // ???1?
            begin   
                b <= temp;
            end
            STATE3 :                        // ???2?
            begin 
                a <= a;
                b <= b;
                start_alu <= 1;
            end
        endcase
    end


 
endmodule
